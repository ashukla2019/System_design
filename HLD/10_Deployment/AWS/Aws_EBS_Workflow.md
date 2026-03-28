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

Application
    │
    │ open(), read(), write()
    │ → triggers system calls (user → kernel transition)

First of all open is done:
    ▼
Path Resolution (VFS)
    │
    │"/home/file.txt"
          ↓
      VFS path lookup
          ↓
      dentry found
          ↓
      dentry contains:
          inode number = 12345
          super_block → ext4
          ↓
      inode not in memory
          ↓
      VFS calls ext4_iget(sb, 12345)
          ↓
      inode loaded into memory
          ↓
       ext4 sets:
       inode->i_fop = ext4_file_operations
    ▼
struct file Creation (VFS)
    │
    │ Kernel allocates struct file
    │ Initializes:
    │   file->f_inode = inode
    │   file->f_pos   = 0
    │   file->f_op    = inode->i_fop   🔥
    │
    │ fd → struct file mapping stored
    ▼
Read/Write:

VFS Entry (read/write)
    │
    │ read(fd, ...) / write(fd, ...)
    │
    │ fd → struct file
    │
    │ VFS calls:
    │   file->f_op->read_iter()
    │   file->f_op->write_iter()
    │
    │ (filesystem-specific function)
    ▼

Filesystem Layer (ext4 — Mapping happens here 🔥)
ext4 Filesystem
    │
    │ Uses inode + offset
    │
    │ Mapping:
    │   offset → logical block
    │   inode → physical disk block
    │
    │ Example:
    │   offset 8192 → block 2
    │   inode → disk block 876
    │
    │ Handles:
    │   - journaling
    │   - metadata
    │   - block allocation
    ▼
page cache:

Page Cache (RAM)
    │
    │ WRITE:
    │   data written to memory first (dirty pages)
    │   later flushed to disk
    │
    │ READ:
    │   if data in cache → return immediately
    │   else → go to disk
    ▼

Block Layer
    │
    │ Converts:
    │   filesystem block → sectors
    │
    │ Example:
    │   block 876 → sectors 7008–7015
    │
    │ Handles:
    │   - I/O scheduling
    │   - request merging
    │   - queueing
    ▼

Block Device Driver
    │
    │ Converts request → hardware command
    │
    │ Example:
    │   READ/WRITE sectors → NVMe command
    │
    │ For EBS:
    │   appears as NVMe device (/dev/nvmeX)
    ▼

AWS Network Layer
    │
    │ NVMe request → Nitro → AWS internal network
    │
    │ EBS is NOT local disk
    │ → remote block storage in same AZ
    ▼

EBS Service(EBS volume)
    │
    │ Receives LBA (sector) request
    │
    │ Maps:
    │   LBA → physical storage nodes
    │
    │ Handles:
    │   - replication (multiple copies)
    │   - durability
    │   - snapshots (copy-on-write)
    │   - encryption
    ▼
Physical Disk
    │
    │ LBA → NAND flash / disk sectors
    │
    │ Data is persisted

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
