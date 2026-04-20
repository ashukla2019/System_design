# AWS Block Storage (EBS)

---

## 🔹 What is Block Storage?

In AWS, block storage is provided by **Amazon EBS (Elastic Block Store)**.

* Provides raw disk volumes
* Works like a virtual hard drive (SSD/HDD)
* Attached to EC2 instances
* Can be formatted, partitioned, and mounted

> EBS is **not shared storage** (single-instance attachment in most cases).
> For shared storage across multiple EC2 instances, use **Amazon EFS**.

---

## 🔹 Architecture Overview

```
EC2 Instance (Operating System)
│
▼
EBS Volume (Block Device)
│
▼
EBS Service (replicated within AZ)
│
▼
Physical Storage (Disks in Data Center)
```

---

## 🔹 Step-by-Step Usage

### 1️⃣ Create Volume

* Create EBS volume in a specific Availability Zone
* Example: 20 GB SSD (gp3)

---

### 2️⃣ Attach to EC2

```
EC2 ───── attaches ─────► EBS Volume
```

* Device names:

  * `/dev/xvda`
  * `/dev/xvdf`

---

### 3️⃣ Format & Mount

```bash
mkfs -t ext4 /dev/xvdf
mount /dev/xvdf /data
```

### Explanation

**mkfs (make filesystem):**

* Creates ext4 filesystem
* Writes:

  * Superblock (filesystem metadata)
  * Inodes (file metadata)
  * Journal (crash recovery)

**mount:**

* Attaches filesystem to directory (`/data`)
* Makes storage usable

---

## 🔹 What Creating a Filesystem Means

A new EBS volume starts as **raw block storage**.

Creating a filesystem adds structure:

* Superblock → filesystem info
* Inode table → file metadata
* Block bitmap → free/used tracking

---

## 🔹 Internal Data Flow

### 🔸 Read Flow

```
Application (read(fd, buffer, size))
   → Provides: file descriptor + byte offset
   ↓

VFS (Virtual File System)
   → Resolves file descriptor → file object
   → Uses dentry cache for path resolution
   → Forwards request to filesystem
   ↓

Filesystem (ext4)
   → Uses inode to map file metadata
   → Converts:
       File Offset (bytes)
       → Logical Block Number (LBN)
   ↓

Page Cache (RAM)
   → Checks if data is already in memory
   → If HIT → return immediately
   → If MISS → proceed to disk I/O
   ↓

Block Layer
   → Converts:
       Logical Blocks → BIO (block I/O request)
   → Merges + optimizes I/O requests
   ↓

NVMe Driver
   → Converts BIO → NVMe commands
   → Maps blocks → sector-level operations
   → Sends request to device queue
   ↓

AWS Nitro System
   → Converts NVMe request → network call
   → Forwards request over AWS internal network
   ↓

EBS Storage (AZ)
   → Reads block from distributed storage
   → Ensures replication consistency
   ↓

──────── RESPONSE PATH ────────(from here response is sent back to upper layer)

EBS → Nitro → NVMe Driver → Block Layer
   ↓
Filesystem (ext4)
   → Maps blocks → file offsets
   ↓

Page Cache (RAM)
   → Stores data for future reads
   ↓

VFS
   → Returns data to application
   ↓

Application
   → Receives final data
```

---

### 🔸 Write Flow

```
Application (write(fd, buffer, size))
   → Provides: file descriptor + data (bytes)
   ↓

VFS (Virtual File System)
   → Resolves file descriptor → file object
   → Forwards write request to filesystem
   ↓

Filesystem (ext4)
   → Uses inode + extent tree to map file layout
   → Converts:
       File Offset → Logical Block Number (LBN)
   → Determines allocation if new data is needed
   ↓

Page Cache (RAM)
   → Copies user data → kernel memory
   → Marks pages as DIRTY
   → write() returns immediately (non-durable yet)
   ↓

Writeback (Deferred I/O)
   → Triggered by:
       - kernel background threads
       - fsync() / sync()
   ↓

Filesystem (ext4 journaling phase)
   → Writes metadata to journal first
   → Ensures crash consistency
   → Prepares final block allocation
   ↓

Block Layer
   → Converts:
       Logical Blocks → BIO (block I/O requests)
   → Merges and schedules writes efficiently
   ↓

NVMe Driver
   → Converts BIO → NVMe commands
   → Maps blocks → sector-level operations
   → Submits to device queue
   ↓

AWS Nitro System
   → Virtualizes NVMe device
   → Translates I/O into AWS network requests
   → Sends to EBS backend
   ↓

EBS Storage (Availability Zone)
   → Writes data to distributed storage nodes
   → Replicates data within AZ
   → Returns acknowledgement
   ↓

──────── RESPONSE PATH ────────

EBS → Nitro → NVMe Driver → Block Layer
   ↓

Filesystem
   → Marks pages CLEAN
   ↓

Page Cache
   → Data now considered persisted in kernel view
   ↓

VFS
   → Returns success to application
   ↓

Application
   → write() completed
   → Data is durable ONLY after fsync()
```

---

## 🔹 Key Concepts

### Data Storage Internals

* Files → Inodes → Blocks
* Blocks distributed across storage in AZ
* Automatic replication within AZ

---

### Journaling (ext4)

* Metadata written before actual data
* Ensures crash consistency

---

### Page Cache

* Improves read performance
* Writes buffered before disk flush

---

## 🔹 Snapshot (Backup)

```
EBS Volume
   ↓
Snapshot Trigger (manual / scheduled)
   ↓
AWS Snapshot Service
   ↓
Block-level capture (only used blocks)
   ↓
Incremental storage (only changes after first snapshot)
   ↓
Stored in Amazon S3 (managed by AWS, not directly visible)
```

### Use Cases

* Backup
* Disaster Recovery
* Volume cloning

---

## 🔹 End-to-End Flow

```
User / Application
        ↓
EC2 (OS + Filesystem)
        ↓
EBS Volume (Block Device)
        ↓
AWS Network Layer
        ↓
EBS Storage Cluster (AZ)
        ↓
Physical Disks
```

---

## 🔹 VFS Path Lookup Example

```
open("/home/user/file.txt")

1. Start at root inode
2. Lookup "home" (cache hit)
3. Lookup "user" (cache miss → ext4 lookup)
4. Lookup "file.txt" (cache hit)

→ Final inode returned
```

---

## 🔹 Key Takeaways

* EBS = Block storage for EC2
* Must format and mount before use
* Works like a real disk
* High performance and low latency
* Data replicated within AZ
* Snapshots stored in S3
* Not designed for shared access (use EFS instead)

---
