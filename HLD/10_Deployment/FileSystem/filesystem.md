# Linux Filesystem Architecture & Internals (Deep Dive)

---

## 1. What is a Filesystem?

A filesystem is a **mapping + abstraction engine** that:

* Provides abstraction → files, directories, paths
* Manages metadata → permissions, size, timestamps
* Translates:

```text
file offset → logical block → physical block → sector
```

* Ensures consistency (journaling, crash recovery)

---

## 2. End-to-End Architecture (Correct Order)

```text
USER SPACE
   │
   ▼
System Calls (open, read, write)
   │
   ▼
KERNEL SPACE
────────────────────────────────────────

[1] VFS (Virtual File System)
   │
   ▼
[2] Page Cache (RAM)
   │
   ▼
[3] Filesystem (ext4/xfs/btrfs)
   │
   ▼
[4] Block Layer
   │
   ▼
[5] Device Driver
   │
   ▼
[6] Storage Device (HDD / SSD / NVMe / EBS)
```

---

## 3. VFS Internals (Path Resolution)

### Flow:

```text
Path string
   ↓
dentry (name lookup)
   ↓
inode (metadata)
   ↓
file (open instance)
```

### Key Structures

#### dentry (Directory Entry)

* Maps: `filename → inode`
* Cached (dcache)
* Speeds up path lookup

#### inode

* Represents the actual file
* Contains:

  * size
  * permissions
  * timestamps
  * block mapping info

❗ Does NOT store filename

#### file (Open File Object)

* Created during `open()`
* Contains:

  * current offset (`f_pos`)
  * pointer to inode
  * file operations

```text
fd → file → inode
```

---

## 4. Page Cache (Performance Layer)

### Purpose:

* Avoid disk I/O
* Serve most reads from memory

---

### Read Path

```text
Check Page Cache
   │
   ├── HIT → return immediately
   └── MISS → go to filesystem
```

---

### Write Path

```text
write()
   ↓
Page Cache updated
   ↓
Mark page DIRTY
   ↓
Writeback (async)
```

---

### Writeback Triggers

* Memory pressure
* Periodic kernel flush
* `fsync()`

---

## 5. Filesystem Layer (CORE LOGIC)

This is the **most important layer**.

### 🔥 Responsibilities

---

### 5.1 Offset → Logical Block

```text
logical_block = offset / block_size
```

* Uses file offset (`file->f_pos`)
* Block size typically 4KB

---

### 5.2 Logical → Physical Block (CRITICAL)

Done using:

* inode
* extent tree (modern FS)

Example:

```text
logical block 10 → physical block 9050
```

---

### How Mapping is Determined

* Created during **write/allocate time**
* Stored in inode metadata
* Read path only **looks up mapping**

---

### Extents (Optimization)

Instead of:

```text
block1, block2, block3...
```

Use:

```text
start_block + length
```

Benefits:

* Fewer lookups
* Better performance
* Less fragmentation

---

### Journaling (Crash Safety)

* Ensures consistency
* Used in ext4

Types:

* Metadata journaling
* Full journaling

---

## 6. Block Layer (I/O Engine)

### Responsibilities

---

### 6.1 Physical Block → Sector

```text
sector = physical_block × (block_size / 512)
```

---

### 6.2 I/O Handling

* Builds BIO requests
* Merges requests
* Schedules I/O
* Manages queues

---

### Important

* Does NOT understand files
* Works only with blocks/sectors

---

## 7. Device Driver

### Responsibilities

* Converts BIO → hardware commands

Examples:

* SATA
* NVMe
* virtio (used for cloud like EBS)

---

## 8. Storage Layer

| Type | Behavior                    |
| ---- | --------------------------- |
| HDD  | Mechanical, slower          |
| SSD  | Flash-based                 |
| NVMe | Parallel queues, very fast  |
| EBS  | Network-backed block device |

---

## 9. Read Flow (End-to-End, Deep)

```text
read(fd)
   ↓
VFS → file → inode
   ↓
Page Cache
   │
   ├── HIT → return
   │
   └── MISS
         ↓
Filesystem:
   offset → logical block
   logical → physical block
         ↓
Block Layer:
   block → sector → BIO
         ↓
Driver:
   sector → device command
         ↓
Storage (EBS/disk)
         ↓
Data returned
         ↓
Page Cache updated
         ↓
copy_to_user()
```

---

## 10. Write Flow (Deep)

```text
write(fd)
   ↓
VFS
   ↓
Page Cache updated
   ↓
Mark DIRTY
   ↓
(Async)
Writeback
   ↓
Filesystem:
   allocate blocks
   logical → physical mapping
   ↓
Block Layer:
   block → sector
   ↓
Driver:
   send write
   ↓
Storage (EBS/disk)
```

---

## 11. Mapping Responsibility (Critical)

| Transformation           | Layer Responsible |
| ------------------------ | ----------------- |
| Path → dentry            | VFS               |
| Dentry → inode           | VFS               |
| Inode → file             | VFS               |
| Offset → logical block   | Filesystem        |
| Logical → physical block | Filesystem        |
| Physical → sector        | Block Layer       |
| Sector → hardware        | Driver            |

---

## 12. EBS Integration (Cloud View)

```text
Application
   ↓
Filesystem (ext4)
   ↓
Block Layer
   ↓
virtio / NVMe driver
   ↓
Network (AWS internal)
   ↓
EBS
   ↓
Physical storage (replicated)
```

### Key Points

* EBS looks like a local disk (`/dev/nvmeX`)
* Actually remote storage
* Adds network latency
* Provides durability via replication

---

## 13. Key Insights (No Confusion Version)

### ❌ Common Mistakes

* VFS does block mapping → ❌
* Block layer understands files → ❌

---

### ✅ Correct Model

* VFS → name resolution
* Page Cache → performance layer
* Filesystem → mapping logic
* Block Layer → I/O execution
* Driver → hardware communication

---

## 14. One-Line Master Summary

VFS resolves names, page cache optimizes access, filesystem maps logical-to-physical blocks, block layer converts to sectors, and the driver executes I/O on the storage device.

---

## 15. Advanced Topics (Next Level)

* Kernel functions:

  * `filemap_read()`
  * `ext4_map_blocks()`
  * `submit_bio()`

* Writeback threads

* Direct I/O (`O_DIRECT`)

* `mmap()` behavior

* NVMe vs HDD path differences

* Debugging latency (especially with EBS)

---
