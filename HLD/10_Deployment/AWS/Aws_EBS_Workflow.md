# AWS Block Storage (EBS) – Complete Guide

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
      mkfs -t ext4 /dev/xvdf
      mkfs = make filesystem → this command formats a block device with a filesystem.
      -t ext4 = specifies the type of filesystem. ext4 is a common Linux filesystem that supports large volumes and journaling.
      /dev/xvdf = the device you are formatting (the additional EBS volume).
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
(parent_inode, name) → dentry ?

   ├── YES (cache hit) 
   │       ↓
   │    dentry → inode
   │
   └── NO (cache miss) 
           ↓
     [3] FILESYSTEM LOOKUP
           ↓
     inode = inode->i_op->lookup()
           ↓
     ext4_lookup(parent_inode, name)
           ↓
     get inode number from directory
           ↓
     ext4_iget(inode_number)
           ↓
     inode loaded into memory
           ↓
     [4] INODE INITIALIZATION
           ↓
     inode->i_op  = ext4_inode_operations
     inode->i_fop = ext4_file_operations
           ↓
     [5] CREATE DENTRY
           ↓
     dentry->d_inode = inode
     (cached in dcache)

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

read(fd, buf, size)
   ↓
file = fdtable[fd]
   ↓
file->f_op->read_iter()
   ↓
ext4_file_read_iter()
   ↓
generic_file_read_iter()
   ↓

─────────────── KEY PART STARTS ───────────────

filemap_read()   ← PAGE CACHE LAYER
   ↓
(offset = file->f_pos)

 LOGICAL FLOW:
   file offset (bytes)
        ↓
   page index = offset / PAGE_SIZE
        ↓
   page cache lookup

(page present?) ── YES  → copy to user
        │
        NO 
        ↓

─────────────── EXT4 MAPPING ───────────────

ext4_map_blocks()
   ↓
Convert:
   file offset → logical block number

formula:
   logical_block = offset / block_size

Example:
   offset = 8192 bytes
   block_size = 4096
   → logical_block = 2

   ↓
inode → extent tree lookup
   ↓
(ext4 uses extents, not direct blocks)

extent:
   logical_block → physical_block

Example:
   logical 2 → physical block 5000

   ↓

─────────────── BLOCK LAYER MAPPING ───────────────

physical block → sector

formula:
   sector = (block * block_size) / 512

Example:
   block_size = 4096
   → 1 block = 8 sectors

   block 5000 → sector 40000

   ↓

mpage_readpages()
   ↓
submit_bio(READ)

─────────────── BLOCK I/O STACK ───────────────

bio:
   contains:
     - sector number
     - size
     - buffer

   ↓
I/O scheduler
   ↓
blk-mq
   ↓
request queue
   ↓
device driver

─────────────── AWS EBS ───────────────

virtual block device
   ↓
network virtualization
   ↓
AWS storage backend
   ↓
SSD disk

   ↓
data returned ↑ (reverse path)
   ↓
page cache updated
   ↓
copy_to_user()

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
