
# Cloud Block Storage: AWS EBS and Azure Managed Disks

---

## 🔹 What is Block Storage?

In AWS, block storage is provided by **Amazon EBS (Elastic Block Store)**.
In Microsoft Azure, block storage is provided by **Azure Managed Disks **
* Provides raw disk volumes
* Works like a virtual hard drive (SSD/HDD)
* Attached to EC2 instances/ Azure Virtual Machines (VMs)
* Can be formatted, partitioned, and mounted

---

## 🔹 Architecture Overview

```
AWS (EBS)                                      | Azure (Managed Disks)
------------------------------------------------|------------------------------------------------
EC2 Instance (Operating System)                | Azure Virtual Machine (Operating System)
│                                               | │
▼                                               | ▼
EBS Volume (Block Device)                      | Azure Managed Disk (Block Device)
│                                               | │
▼                                               | ▼
EBS Service (replicated within AZ)             | Azure Disk Service / Storage Fabric (replication + I/O routing)
│                                               | │
▼                                               | ▼
Physical Storage (Disks in Data Center)        | Physical Storage (Disks in Azure Data Centers)
```

---

## 🔹 Step-by-Step Usage

### 1️⃣ Create Volume

AWS (EBS)                                      | Azure (Managed Disk)
------------------------------------------------|------------------------------------------------
Create EBS volume in a specific AZ            | Create Managed Disk in a specific Region / Zone
Example: 20 GB SSD (gp3)                      | Example: 20 GB SSD (Standard SSD / Premium SSD)

---

### 2️⃣ Attach to EC2/VM

```
EC2 Instance ───── attaches ─────► EBS Volume  | Azure VM ───── attaches ─────► Managed Disk
```

* Device names:

| AWS                      | Azure                                                      |
| ------------------------ | ---------------------------------------------------------- |
| `/dev/xvda`, `/dev/xvdf` | `/dev/sdX` (Linux VM) or drive letters in Windows (C:, D:) |


---

### 3️⃣ Format & Mount

```bash
mkfs -t ext4 /dev/xvdf
mount /dev/xvdf /data
```

### Explanation

**mkfs (make filesystem):**

Creates filesystem structure on raw block storage:

Superblock → filesystem metadata (size, state, features)
Inode table → file metadata (permissions, size, pointers)
Block bitmap → tracks free/used blocks
Journal → crash recovery mechanism (ext4 / NTFS equivalent logging)

**mount:**

Attaches filesystem to a directory (/data)
Integrates disk into OS directory tree
Makes storage accessible to applications

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
AWS (EBS)                                              | Azure (Managed Disks)
-------------------------------------------------------|-------------------------------------------------------

Application (read(fd, buffer, size))                  | Application (read(fd, buffer, size))
   → file descriptor + byte offset                    |    → file descriptor + byte offset
   ↓                                                  |    ↓

VFS (Virtual File System)                             | VFS (Virtual File System)
   → resolves file object                             |    → resolves file object
   → dentry cache lookup                              |    → dentry cache lookup
   ↓                                                  |    ↓

Filesystem (ext4)                                    | Filesystem (NTFS / ext4 / xfs)
   → inode mapping                                    |    → inode / MFT mapping
   → File Offset → Logical Block Number               |    → File Offset → Logical Block Number
   ↓                                                  |    ↓

Page Cache (RAM)                                     | Page Cache (RAM)
   → check cached data                                |    → check cached data
   → HIT → return                                     |    → HIT → return
   → MISS → disk I/O                                  |    → MISS → disk I/O
   ↓                                                  |    ↓

Block Layer                                          | Block Layer
   → Logical Blocks → BIO                             |    → Logical Blocks → BIO
   → I/O merging + scheduling                         |    → I/O merging + scheduling
   ↓                                                  |    ↓

NVMe Driver                                          | Azure Disk Driver
   → BIO → NVMe commands                              |    → BIO → disk I/O requests
   → sector mapping                                   |    → sector mapping
   ↓                                                  |    ↓

AWS Nitro System                                     | Azure Managed Disk (Logical Abstraction)
   → NVMe → network translation                      |    → virtual disk abstraction
   → internal AWS network                            |    → forwards request to disk service
   ↓                                                  |    ↓

EBS Storage (Availability Zone)                      | Azure Disk Service (I/O Control Layer)
   → reads from distributed storage                 |    → routes read request
   → ensures replication                             |    → manages caching + QoS
   ↓                                                  |    ↓

-------------------------------------------------------|-------------------------------------------------------
────────────── RESPONSE PATH ──────────────           | ────────────── RESPONSE PATH ──────────────

EBS → Nitro → NVMe Driver → Block Layer              | Storage Fabric → Disk Service → Driver → Block Layer
   ↓                                                  |    ↓

Filesystem (ext4)                                    | Filesystem
   → blocks → file offset                            |    → blocks → file offset
   ↓                                                  |    ↓

Page Cache (RAM)                                     | Page Cache (RAM)
   → stores data                                     |    → stores data
   ↓                                                  |    ↓

VFS                                                  | VFS
   ↓                                                  |    ↓

Application receives final data                      | Application receives final data
```
VFS looks up that fd: fd 3 → struct file (kernel object)
That “file object” contains:
 Pointer to inode (actual file metadata)
 File offset (where you’re reading from)
 File operations (read/write functions)
---

### 🔸 Write Flow

```
AWS (EBS)                                              | Azure (Managed Disks)
-------------------------------------------------------|-------------------------------------------------------

Application (write(fd, buffer, size))                 | Application (write(fd, buffer, size))
   → file descriptor + data                          |    → file descriptor + data
   ↓                                                  |    ↓

VFS (Virtual File System)                             | VFS (Virtual File System)
   → resolves file object                             |    → resolves file object
   → forwards to filesystem                          |    → forwards to filesystem
   ↓                                                  |    ↓

Filesystem (ext4)                                    | Filesystem (NTFS / ext4 / xfs)
   → inode + extent tree                             |    → inode / MFT mapping
   → File Offset → Logical Block Number              |    → File Offset → Logical Block Number
   → allocates blocks if needed                      |    → allocates blocks if needed
   ↓                                                  |    ↓

Page Cache (RAM)                                     | Page Cache (RAM)
   → copies user data                               |    → copies user data
   → marks pages DIRTY                               |    → marks pages DIRTY
   → write() returns immediately                     |    → write() returns immediately
   ↓                                                  |    ↓

Writeback (Deferred I/O)                             | Writeback (Deferred I/O)
   → background flush threads                        |    → background flush threads
   → fsync()/sync() triggers                         |    → fsync()/flush triggers
   ↓                                                  |    ↓

Filesystem Journaling (ext4)                         | Filesystem Journaling (NTFS/ext4)
   → metadata written first                          |    → metadata consistency layer
   → crash recovery guarantee                        |    → crash recovery guarantee
   ↓                                                  |    ↓

Block Layer                                          | Block Layer
   → Logical Blocks → BIO                            |    → Logical Blocks → BIO
   → merges + schedules writes                      |    → merges + schedules writes
   ↓                                                  |    ↓

NVMe Driver                                          | Azure Disk Driver
   → BIO → NVMe commands                             |    → BIO → disk I/O requests
   → sector mapping                                  |    → sector mapping
   ↓                                                  |    ↓

AWS Nitro System                                     | Azure Managed Disk (Logical Abstraction)
   → NVMe → network translation                     |    → virtual disk abstraction
   → sends over AWS network                         |    → forwards to disk service
   ↓                                                  |    ↓

EBS Storage (Availability Zone)                      | Azure Disk Service (I/O Control Layer)
   → writes to distributed storage                  |    → routes write request
   → replicates within AZ                           |    → handles replication logic
   → returns ACK                                    |    → returns ACK
   ↓                                                  |    ↓

-------------------------------------------------------|-------------------------------------------------------
────────────── RESPONSE PATH ──────────────           | ────────────── RESPONSE PATH ──────────────

EBS → Nitro → NVMe Driver → Block Layer              | Storage Fabric → Disk Service → Driver → Block Layer
   ↓                                                  |    ↓

Filesystem                                           | Filesystem
   → marks pages CLEAN                              |    → marks pages CLEAN
   ↓                                                  |    ↓

Page Cache                                           | Page Cache
   → data now considered persisted                  |    → data now considered persisted
   ↓                                                  |    ↓

VFS                                                  | VFS
   ↓                                                  |    ↓

Application                                          | Application
   → write() complete                               |    → write() complete
   → durable ONLY after fsync()                     |    → durable ONLY after flush/fsync()
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
AWS (EBS Snapshot)                              | Azure (Managed Disk Snapshot)
------------------------------------------------|------------------------------------------------
EBS Volume                                     | Managed Disk
   ↓                                           |    ↓
Snapshot Trigger (manual / scheduled)          | Snapshot Trigger (manual / scheduled)
   ↓                                           |    ↓
AWS Snapshot Service                           | Azure Snapshot Service
   ↓                                           |    ↓
Block-level capture (used blocks only)         | Disk-level / incremental snapshot (used changed blocks only)
   ↓                                           |    ↓
Incremental storage (delta changes only)       | Incremental snapshot storage (delta changes only)
   ↓                                           |    ↓
Stored in Amazon S3 (backend managed)          | Stored in Azure Storage (backend managed, not directly visible)
```

### Use Cases

* Backup
* Disaster Recovery
* Volume cloning

---

## 🔹 End-to-End Flow

```
AWS (EBS)                                      | Azure (Managed Disks)
------------------------------------------------|------------------------------------------------
User / Application                             | User / Application
        ↓                                      |        ↓
EC2 (OS + Filesystem)                          | Azure Virtual Machine (OS + Filesystem)
        ↓                                      |        ↓
EBS Volume (Block Device)                      | Azure Managed Disk (Block Device)
        ↓                                      |        ↓
AWS Network Layer / Nitro System               | Azure Disk Service (I/O + control layer)
        ↓                                      |        ↓
EBS Storage Cluster (AZ)                       | Azure Storage Fabric (Distributed storage system)
        ↓                                      |        ↓
Physical Disks                                 | Physical Disks (Azure Data Centers)
```

