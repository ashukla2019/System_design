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
Application
   ↓
VFS (Virtual File System)
   ↓
Page Cache (RAM)
   ↓ (cache miss)
Filesystem (ext4)
   ↓
Block Layer
   ↓
NVMe Driver
   ↓
AWS Nitro System
   ↓
EBS Storage (AZ)
   ↓
Data returned → Cache → Application
```

---

### 🔸 Write Flow

```
Application
   ↓
VFS
   ↓
Page Cache (marked DIRTY)
   ↓
(Returns quickly to user)
   ↓
Background Flush / fsync()
   ↓
Filesystem (ext4 + journaling)
   ↓
Block Layer
   ↓
NVMe Driver
   ↓
AWS Nitro → Network
   ↓
EBS Storage (replicated in AZ)
   ↓
Acknowledgement
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
EBS Volume ─────► Snapshot ─────► Amazon S3
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
