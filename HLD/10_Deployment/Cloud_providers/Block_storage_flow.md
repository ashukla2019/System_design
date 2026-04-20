
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

Application                                            | Application
(read(fd, buffer, size))                               | (read(fd, buffer, size))
 → file descriptor + byte offset                       | → file descriptor + byte offset
 ↓                                                     | ↓

VFS (Virtual File System)                              | VFS (Virtual File System)
 → fd → struct file (file object resolution)           | → fd → struct file
 → pathname → dentry → inode lookup                    | → pathname → dentry → inode/MFT lookup
 ↓                                                     | ↓

Filesystem (ext4)                                      | Filesystem (NTFS / ext4 / xfs)
 → inode → file metadata                               | → inode / MFT → metadata
 → byte offset → file logical block                    | → byte offset → file logical block
 → file logical block → disk logical block (LBA)       | → file logical block → disk logical block (LBA)
 ↓                                                     | ↓

Page Cache (RAM)                                       | Page Cache (RAM)
 → check cache (by inode + offset)                     | → check cache
 → HIT → return data                                   | → HIT → return data
 → MISS → generate read request                        | → MISS → generate read request
 ↓                                                     | ↓

Block Layer                                            | Block Layer
 → logical block (LBA) → BIO                           | → logical block (LBA) → BIO
 → BIO → request (blk-mq request queue)                | → BIO → request
 → I/O merging, splitting, scheduling                  | → I/O merging, scheduling
 ↓                                                     | ↓

Device Driver Layer                                    | Device Driver Layer
(NVMe driver)                                          | (SCSI or NVMe driver)
 → request → device command                            | → request → device command
 → LBA + length → NVMe READ command                    | → LBA + length → SCSI READ / NVMe READ
 → queue submission (submission queue)                 | → queue submission
 ❗ (No physical mapping here)                          | ❗ (No physical mapping here)
 ↓                                                     | ↓

Device (Virtual Disk)                                  | Device (Virtual Disk)
(NVMe device exposed by Nitro)                         | (Virtual disk exposed by Azure fabric)
 → accepts protocol commands                           | → accepts protocol commands
 → DMA to/from memory                                  | → DMA to/from memory
 ↓                                                     | ↓

Hypervisor / Offload Layer                             | Azure Storage Fabric
→ AWS Nitro System           | → Azure host + storage fabric
 → NVMe command → network RPC                          | → protocol → internal storage RPC
 → maps virtual LBA → backend storage                  | → maps virtual LBA → backend storage
 ↓                                                     | ↓

Storage Backend                                        | Storage Backend
→ Amazon Elastic Block Store             | → Azure Managed Disks
 → LBA → physical chunk placement                      | → LBA → storage extent mapping
 → replication within AZ                               | → replication (LRS/ZRS)
 → distributed storage read                            | → distributed storage read
 ↓                                                     | ↓

---------------- RESPONSE PATH ------------------------|---------------- RESPONSE PATH ------------------------

EBS → Nitro → Device → Driver                          | Storage → Fabric → Device → Driver
 → completion queue entry                              | → completion queue entry
 ↓                                                     | ↓

Block Layer                                            | Block Layer
 → request completion → BIO completion                 | → request completion
 ↓                                                     | ↓

Filesystem                                             | Filesystem
 → disk block → file logical block                     | → disk block → file logical block
 → logical block → byte offset                         | → logical block → byte offset
 ↓                                                     | ↓

Page Cache                                             | Page Cache
 → cache fill (readahead possible)                     | → cache fill
 ↓                                                     | ↓

VFS                                                    | VFS
 ↓                                                     | ↓

Application                                            | Application
 → buffer filled                                       | → buffer filled
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

Application                                            | Application
write(fd, buffer, size)                                | write(fd, buffer, size)
 → fd + user buffer (bytes)                            | → fd + user buffer (bytes)
 ↓                                                     | ↓

VFS (Virtual File System)                              | VFS (Virtual File System)
 → fd → struct file (file object)                      | → fd → struct file
 → validates permissions, flags                        | → validates permissions
 → forwards write(file, offset, data)                  | → forwards write()
 ↓                                                     | ↓

Filesystem (ext4)                                      | Filesystem (NTFS / ext4 / xfs)
 → inode lookup                                        | → inode / MFT lookup
 → byte offset → file logical block                    | → byte offset → file logical block
 → allocate blocks (if needed)                         | → allocate clusters/blocks
 → file logical block → disk logical block (LBA)       | → file logical block → disk LBA
 ↓                                                     | ↓

Page Cache (RAM)                                       | Page Cache (RAM)
 → copy user buffer → page cache                       | → copy user buffer → page cache
 → mark pages DIRTY                                    | → mark pages DIRTY
 → update in-memory inode size/mtime                   | → update metadata in memory
 → write() RETURNS (usually)                           | → write() RETURNS (usually)
 ❗ not durable yet                                     | ❗ not durable yet
 ↓                                                     | ↓

Writeback Trigger                                      | Writeback Trigger
 → background flusher threads                          | → background flush threads
 → or fsync()/fdatasync()                              | → or fsync()/FlushFileBuffers
 ↓                                                     | ↓

Filesystem Journaling                                  | Filesystem Journaling
(ext4 journal)                                         | (NTFS log / ext4 journal)
 → metadata → journal log first                        | → metadata → log first
 → ensures crash consistency                           | → ensures crash consistency
 → may use ordered / writeback / journal mode          | → NTFS uses redo logging
 ↓                                                     | ↓

Block Layer                                            | Block Layer
 → dirty pages → BIO (LBA + length)                    | → dirty pages → BIO
 → BIO → request (blk-mq queue)                        | → BIO → request
 → merge / split / reorder writes                      | → merge / schedule writes
 ↓                                                     | ↓

Device Driver Layer                                    | Device Driver Layer
(NVMe driver)                                          | (SCSI or NVMe driver)
 → request → protocol command                          | → request → protocol command
 → LBA + length → NVMe WRITE command                   | → LBA → SCSI WRITE / NVMe WRITE
 → enqueue to submission queue                         | → enqueue to device queue
 ❗ no physical mapping here                            | ❗ no physical mapping here
 ↓                                                     | ↓

Device (Virtual Disk)                                  | Device (Virtual Disk)
(NVMe device via Nitro)                                | (Virtual disk via Azure fabric)
 → executes command semantics                          | → executes command semantics
 → DMA transfer from memory                            | → DMA transfer
 ↓                                                     | ↓

Hypervisor / Offload Layer                             | Azure Storage Fabric
→ AWS Nitro System           | → Azure host + storage fabric
 → NVMe cmd → network RPC                              | → protocol → internal RPC
 → virtual LBA → backend mapping                       | → virtual LBA → backend mapping
 ↓                                                     | ↓

Storage Backend                                        | Storage Backend
→ Amazon Elastic Block Store             | → Azure Managed Disks
 → LBA → physical chunks                               | → LBA → extents
 → replicated within AZ                                | → replicated (LRS/ZRS)
 → write committed (quorum / durability policy)        | → write committed
 → ACK returned                                        | → ACK returned
 ↓                                                     | ↓

---------------- RESPONSE PATH ------------------------|---------------- RESPONSE PATH ------------------------

EBS → Nitro → Device → Driver                          | Storage → Fabric → Device → Driver
 → completion queue entry                              | → completion entry
 ↓                                                     | ↓

Block Layer                                            | Block Layer
 → request completion                                  | → request completion
 ↓                                                     | ↓

Filesystem                                             | Filesystem
 → mark pages CLEAN (after writeback)                  | → mark pages CLEAN
 → journal commit may finalize metadata                | → log commit finalizes metadata
 ↓                                                     | ↓

Page Cache                                             | Page Cache
 → data now synced to storage                          | → data now synced
 ↓                                                     | ↓

VFS                                                    | VFS
 ↓                                                     | ↓

Application                                            | Application
 → fsync()/flush returns                               | → fsync()/flush returns
 → durability guaranteed here                          | → durability guaranteed here
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

