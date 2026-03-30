# AWS Block Storage (EBS) 

## 🔹 What is Block Storage?

In AWS, block storage is provided by **Amazon EBS (Elastic Block Store)**.

- Provides raw disk volumes  
- Works like a hard drive (SSD/HDD)  
- Can be attached to EC2 instances  
- You can format, partition, and mount it  

---

## 🔹 Architecture Overview
```
EC2 Instance (OS)
│
▼
EBS Volume (Block Storage)
│
▼
EBS Service (replicated within AZ)
│
▼
Physical Storage (disks in data center)
```

---

## 🔹 Step-by-Step Working

### 1️⃣ Create Volume
Create an EBS (Elastic Block Store) volume in a specific Availability Zone.
Example: 20 GB SSD
**Steps to Create an EBS Volume**
Log in to AWS Management Console
Navigate to “Volumes”
Click “Create Volume”

Note: EBS is block storage, not traditional network-attached storage. It behaves like a virtual hard drive attached to a single EC2 instance, though it can be accessed over the network by that instance. For shared network storage, consider Amazon EFS.

---

### 2️⃣ Attach to EC2
EC2 ───── attaches ─────► EBS Volume


- Appears as:
  - `/dev/xvda`
  - `/dev/xvdf`

---

### 3️⃣ Format & Mount (Inside EC2)

```bash
mkfs -t ext4 /dev/xvdf
      Erase existing data on /dev/xvdf (if any)
      Create a fresh ext4 filesystem structure, including:
      Superblock (metadata about the filesystem)
      Inodes (file metadata structures)
      Journaling system (for crash recovery)
      Make the device ready to be mounted and used for storing files
mount /dev/xvdf /data
      mount = attaches a filesystem to a directory so you can access it.
      /dev/xvdf = the device you formatted.
      /data = the directory in your EC2 instance where you want the volume to be accessible.
Now it behaves like a local disk.

4️⃣ Read/Write Flow

USER SPACE
   ↓
open("/home/user/file.txt")
   ↓
────────────────────────────────────
KERNEL SPACE (VFS)
────────────────────────────────────

[1] PATH STRING
   "/home/user/file.txt"
   ↓
Split into components
["home", "user", "file.txt"]
   ↓

[2] DENTRY CACHE LOOKUP (for each component)
   ↓
[ PATH COMPONENT ]
(parent_inode, name)
        │
        ▼
   ┌───────────────┐
   │ dcache lookup │
   └───────────────┘
        │
 ┌──────┴───────┐
 │              │
YES            NO
 │              │
 ▼              ▼
dentry->inode   parent_inode->i_op->lookup()
  │                │
  │         ┌───────────────────────────┐
  │         │ filesystem finds inode    │
  │         │ (disk may be accessed)    │
  │         └──────────────┬────────────┘
  │                        ▼
  │              [4] INODE INITIALIZATION
  │                 inode->i_op = ext4_inode_operations
  │                 inode->i_fop = ext4_file_operations
  │                        ▼
  │              [5] CREATE DENTRY
  │                 dentry->d_inode = inode
  │                 (cached in parent + name)
  │                        ▼
  └───────────────► next time cache hit!

────────────────────────────────────
[6] OPEN() PHASE
────────────────────────────────────

struct file *file
   ↓
file->f_inode = inode
file->f_op    = inode->i_fop
file->f_pos   = 0
   ↓
file->f_op->open() → ext4_file_open()
   ↓
fdtable[fd] → file*

────────────────────────────────────
[8] READ SYSTEM CALL
────────────────────────────────────

[1] User calls read()
read(fd, buf, size)
        │
        ▼
[2] Get file object from fdtable
fd → file
        │
        ▼
[3] Call file operation
file->f_op->read_iter()
        │
        ▼
[4] Check PAGE CACHE (RAM)
filemap_read()
        │
 ┌──────┴───────┐
 │              │
YES            NO
 │              │
 ▼              ▼
[Copy to user]   [5]  Map file offset to logical block
copy_to_user()      offset = file->f_pos
                    logical_block = offset / block_size

                    ↓
[6] Filesystem mapping (EXT4)-> (logical_block → physical_block)
ext4_map_blocks()
inode → extent tree lookup
logical_block → physical_block

                    ↓
[7] Convert physical block to disk sector
sector = physical_block * (block_size / 512)

                    ↓
[8] Submit read request (submit_bio)
submit_bio(READ)

                    ↓
[9] Block layer + I/O scheduler
Linux kernel schedules request via blk-mq
physical sectors → request queue

                    ↓
[10] Virtual block device (EBS)
Disk request sent to virtual block device (EBS volume)

                    ↓
[11] Network (inside cloud)
Request traverses AWS network virtualization

                    ↓
[12] AWS storage backend (SSD)
EBS retrieves data from SSD

                    ↓
[13] Data returned to Linux kernel
Data copied into page cache (RAM)

                    ↓
[14] Copy to user buffer
copy_to_user()
        │
        ▼
[DONE] User buffer filled

────────────────────────────────────
[9] WRITE SYSTEM CALL
────────────────────────────────────

write(fd, buf, size)
   ↓
file = fdtable[fd]
   ↓
file->f_op->write_iter()
   ↓
ext4_file_write_iter()
   ↓
generic_perform_write()

─────────────── WRITE PATH ───────────────

copy data → page cache
   ↓
mark page DIRTY
   ↓
update file offset
   ↓
(return to user immediately) 

─────────────── WRITEBACK (ASYNC) ───────────────

writeback thread
   ↓
ext4_writepages()
   ↓

 SAME MAPPING HAPPENS:

offset → logical block → physical block → sector

   ↓
mpage_writepages()
   ↓
submit_bio(WRITE)
   ↓
block layer → driver → EBS → disk

────────────────────────────────────
 COMPLETE DATA TRANSFORMATION
────────────────────────────────────

USER BUFFER
   ↓
file offset (bytes)
   ↓
PAGE CACHE (4KB pages)
   ↓
EXT4:
   offset → logical block
   ↓
EXTENTS:
   logical → physical block
   ↓
BLOCK LAYER:
   block → sector (512B units)
   ↓
BIO:
   sector-based I/O
   ↓
DRIVER:
   hardware command
   ↓
EBS:
   network storage
   ↓
SSD

Two critical mapping:
File → inode → blocks        (filesystem)
LBA → physical storage       (EBS)

VFS role:
fd → struct file → f_op → ext4

struct file is bridge:

fd → file → inode → blocks

read/write = fd → file → ext4 → block → sector → EBS → disk

5️⃣ Data fd → file → inode → blocks Internals
Data is split into blocks (e.g., 4KB, 8KB)
Stored across multiple disks in the same AZ
Automatically replicated

6️⃣ Snapshot (Backup)
EBS Volume ─────► Snapshot ─────► Amazon S3

Uses:

Backup
Disaster recovery
Volume cloning

Full End-to-End Flow
User / Application
        │
        ▼
EC2 Instance (Operating System + File System)
        │
        │  OS uses VFS + filesystem (e.g., ext4) to map
        │  file names → inodes → logical blocks
        ▼
EBS Volume (Block Device)
        │
        │  Block device driver (NVMe / virtio-blk) queues I/O
        │  Sends requests over the AWS internal network
        ▼
AWS Network Layer
        │
        │  Transfers block I/O to the EBS service within the same AZ
        ▼
EBS Storage Cluster (AZ)
        │
        │  Handles replication, snapshots, encryption, and IOPS
        ▼
Physical Disks (SSD/HDD)


What “making a filesystem” means
Raw block device:
When you attach a new EBS volume (/dev/xvdf), it’s just a series of raw blocks.
The OS has no idea what these blocks mean — it’s just a chunk of storage.
mkfs creates a filesystem:
mkfs = make filesystem
-t ext4 tells Linux to use the ext4 filesystem format.
It writes metadata structures to the disk:
Superblock: info about the filesystem (size, block count, etc.)
Inode table: stores info about files (permissions, timestamps, block pointers)
Block bitmap: tracks which blocks are used/free


VFS path lookup:

open("/home/user/file.txt")

1. Start at root inode
2. Lookup "home"
   → found in dcache 
3. Lookup "user"
   → not in cache 
   → call ext4_lookup()
   → create dentry + inode 
4. Lookup "file.txt"
   → found in cache 

Final inode returned
