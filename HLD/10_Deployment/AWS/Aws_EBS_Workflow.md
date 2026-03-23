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
```
Application (syscalls: read/write)
    │
    │  The app calls read(), write(), open(), close() etc.
    │  These are **user-space → kernel-space transitions (system calls)**.
    ▼
VFS + ext4 (maps file → block)
    │
    │  VFS (Virtual File System) abstracts the filesystem.
    │  ext4 maps file paths and offsets → specific logical blocks.
    │  Handles journaling, metadata, inode management.
    ▼
Block Device Driver (queues I/O)
    │
    │  Converts filesystem block requests → device-level I/O.
    │  Manages queues, caching, and error handling.
    │  For EBS, this is usually the NVMe or virtio-blk driver.
    ▼
AWS Internal Network
    │
    │  The block request travels over the AWS AZ network to EBS.
    │  Even though the volume seems “attached”, it is **remote storage**.
    │  Network latency is minimal but exists.
    ▼
EBS Volume (replication, durability)
    │
    │  AWS service receives the request.
    │  Ensures data is replicated (usually 3 copies in AZ).
    │  Handles IOPS provisioning, snapshots, encryption if enabled.
    ▼
Physical Disks (SSD/HDD)
    │
    │  Data is finally written to persistent storage media.
    │  For reads, the process reverses back to the app.
Data travels over AWS internal network (not truly local)
```

5️⃣ Data Storage Internals
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
User/Application
        │
        ▼
EC2 Instance (OS + File System)
        │
        ▼
EBS Volume (Block Device)
        │
        ▼
AWS Network Layer



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
Directory structure: maps file names → inodes
        │
        ▼
EBS Storage Cluster (AZ)
        │
        ▼
Physical Disks
