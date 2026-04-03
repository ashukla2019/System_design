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
   │
   ▼
[1] Application requests data
   read(file, buffer)

   │
   ▼
KERNEL SPACE
────────────────────────────

[2] VFS (Virtual File System)
   → Understands "this is a file read"
   → Routes request to correct filesystem (ext4, xfs, etc.)

   │
   ▼
[3] Page Cache Check (RAM)
   → Is data already in memory?

   ┌───────────────┐
   │  Cache Hit?   │
   └──────┬────────┘
          │
     YES  │  NO
          │
          ▼
   Return data     Go to disk

                 │
                 ▼

[4] Filesystem (e.g., ext4)
   → Converts:
     File Offset → Logical Block

   │
   ▼
[5] Block Mapping
   → Logical Block → Physical Block (on disk)

   │
   ▼
[6] Sector Calculation
   → Physical Block → Disk Sector

   │
   ▼
[7] Block Layer
   → Prepares I/O request
   → Merges & schedules requests

   │
   ▼
[8] Device Driver
   → Talks to actual device (NVMe / SSD)

   │
   ▼
[9] Storage Device
   (Local Disk OR Cloud like AWS EBS)
   → Reads data from physical storage

   │
   ▼
[10] Data Returned to RAM
   → Stored in Page Cache

   │
   ▼
[11] Copy to User Buffer
   → Kernel → Application memory

   │
   ▼
USER SPACE
   → Application receives data
  
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
