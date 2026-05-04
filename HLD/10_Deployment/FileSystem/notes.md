

# Filesystem + VFS Complete Notes (Interview Ready)

---

## 1.  What is a Filesystem?

A filesystem is a method to store, organize, and retrieve data from storage devices.

### Responsibilities:
- File storage & retrieval
- Metadata management
- Directory hierarchy
- Permissions & security
- Space allocation

### Examples:
- Linux: ext4, XFS, Btrfs
- Windows: NTFS
- Network: NFS

---

## 2. What is VFS (Virtual File System)?

VFS is a kernel abstraction layer that provides a uniform interface to multiple filesystems.

### It allows:
- Same syscalls (`open`, `read`, `write`) for all filesystems
- Plug-and-play filesystem support

---

## 3. Core VFS Data Structures (VERY IMPORTANT)

---

### 3.1 Superblock (`struct super_block`)

Represents a mounted filesystem.

#### Contains:
- Filesystem type (ext4, xfs)
- Block size
- Root inode
- Filesystem operations

#### Key Pointer:
super_block → root dentry


---

### 3.2 Inode (`struct inode`)

Represents file metadata (**NOT filename**).

#### Contains:
- File size
- Permissions
- Owner (UID/GID)
- Timestamps
- Block pointers (data location)

#### Important:
❗ Inode does NOT store filename

---

### 3.3 Dentry (`struct dentry`)

Represents directory entry (**name ↔ inode mapping**).

#### Contains:
- Filename
- Pointer to inode
- Parent directory

#### Purpose:
- Speeds up path lookup (dentry cache)

---

### 3.4 File Object (`struct file`)

Represents an open file instance.

#### Contains:
- File offset
- Flags (O_RDONLY, etc.)
- Pointer to inode
- File operations

---

### 3.5 File Descriptor (FD)

- Integer returned to user (0,1,2,...)
- Index into process file table

---


inode → superblock (filesystem info)

```
---

## 5. 🧭 Path Resolution (VERY IMPORTANT)

### Example:
open("/home/user/file.txt")


### Flow:
```
Start from root (/)
↓
Lookup "home" in dentry cache
↓
Lookup "user"
↓
Lookup "file.txt"
↓
Get inode

```
### Uses:
- Dentry cache
- Inode cache

---

## 6. 🔄 System Call Flow (End-to-End)

### 6.1 OPEN()
open("file.txt")
```
→ sys_open()
→ path lookup (dentry + inode)
→ create struct file
→ assign fd
→ return fd

```
---

### 6.2 READ()
read(fd, buf, size)
```
→ get struct file via fd
→ get inode
→ call filesystem read op
→ fetch data from page cache / disk
→ copy to user buffer

```
---

### 6.3 WRITE()
write(fd, buf, size)
```
→ struct file
→ inode
→ write to page cache
→ mark dirty
→ flush to disk later
```

---

## 7. Page Cache (CRITICAL)

- Caches file data in RAM
- Reduces disk I/O

### Flow:
read → page cache hit → return fast
write → page cache → flush later


---

## 8. VFS Operation Tables

Each structure defines function pointers:

### inode_operations:
- create
- lookup
- unlink

### file_operations:
- read
- write
- open
- mmap

### super_operations:
- mount
- sync
- statfs

👉 Implemented by actual filesystems (ext4, xfs, etc.)

---

## 9. 🔌 Filesystem Stack Integration
```
VFS Layer
↓
Filesystem (ext4 / xfs / nfs)
↓
Block Layer
↓
Device Driver
↓
Disk

```
---

## 10. Caching Layers

### Dentry Cache:
- Filename → inode mapping

### Inode Cache:
- Stores inode objects in memory

👉 Improves lookup performance

---

## 11. 🔄 Mounting Flow
mount /dev/sda1 /mnt

→ create superblock
→ attach to VFS
→ root dentry created


---

## 12. 📂 Directory Structure

A directory is a file containing:
filename → inode number


---

## 13. 🔐 File Permissions

Stored in inode:
- rwx for user / group / others

---

## 14. ⚡ Important Interview Questions

### Q1: Difference between inode and dentry?

| inode | dentry |
|------|--------|
| metadata | filename |
| no name | has name |
| unique per file | multiple dentries possible |

---

### Q2: Can multiple filenames point to same inode?
✅ YES (Hard links)

---

### Q3: What happens when file is deleted?
- dentry removed  
- inode freed when reference count = 0  

---

### Q4: Why VFS?
- Abstraction layer  
- Supports multiple filesystems  

---

### Q5: Difference between file and inode?

| file | inode |
|------|-------|
| open instance | metadata |
| has offset | no offset |

---

## 15. 🔥 Full Flow Diagram (INTERVIEW GOLD)

### USER SPACE
open(), read(), write()


### KERNEL SPACE
```
open("/home/user/file.txt")
↓
sys_open()
↓
path lookup
↓
super_block → s_root
↓
dentry walk: "/", home, user, file.txt
↓
dentry("file.txt")
↓
inode
↓
----------------------------------
CREATE FILE OBJECT
----------------------------------
alloc struct file
↓
file->f_path = {mnt, dentry}
↓
file->f_inode = inode
↓
file->f_op = inode->i_fop   ✅ KEY LINK
↓
if (f_op->open) call it
↓
file->f_pos = 0
↓
install fd
↓
return fd

```
---

## 16. 🧠 Memory Trick
FD → FILE → DENTRY → INODE → DATA


---

## 17. 🧩 Advanced Topics

- Journaling (ext4)
- mmap flow
- Direct I/O vs Buffered I/O
- NFS vs Local FS
- FUSE (user-space filesystem)

---

## 18. 📌 One-Line Summary

**VFS connects user syscalls to actual filesystem using:**
file descriptor → file → dentry → inode → disk

-----------------------
1. mkfs (filesystem creation)
   ↓
   Disk structures created:
   - superblock (disk)
   - inode table
   - data blocks

--------------------------------------

2. mount
   ↓
   Kernel creates:
   - struct super_block
   - root dentry
   - root inode

--------------------------------------

3. path lookup (open/read/etc)
   ↓
   Kernel creates (on demand):
   - dentries
   - loads inodes into memory

--------------------------------------

4. open()
   ↓
   Kernel creates:
   - struct file
   - assigns fd
