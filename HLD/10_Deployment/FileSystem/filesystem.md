# 🧠 Linux VFS: Complete Flow (Dentry, Inode, File, FD)

---

## 🔗 Core Mental Model

When you call:

```c
fd = open("/home/user/file.txt");
```

Linux creates a chain:

```
PATH → DENTRY → INODE → FILE → FD
```

---

## 📌 Object Definitions

### 🔹 DENTRY (Directory Entry)

* Represents a **filename in a directory**
* Maps:

```
"name" → inode
```

* Cached for fast lookup

👉 Think: *filename wrapper*

---

### 🔹 INODE

* Represents the **actual file**
* Contains:

  * metadata (size, permissions, timestamps)
  * disk block mapping

👉 Think: *real file*

---

### 🔹 FILE (`struct file`)

* Created **on open()**
* Represents an **open instance**

Contains:

* pointer to inode
* file offset (`f_pos`)

👉 Think: *your session with file*

---

### 🔹 FD (File Descriptor)

* Integer per process
* Points to `struct file`

👉 Think: *handle/index*

---

## 🔥 Core Relationship

```
fd (int)
  │
  ▼
struct file
  │
  ├── f_pos (offset)
  └── inode
        │
        ▼
      INODE
        │
        ▼
   data on disk

DENTRY:
"name" → inode
```

---

## 🚀 OPEN FLOW

### Step 1: Path Resolution

```
/ → home → user → file.txt
```

For each component:

* Check dentry cache

  * HIT → reuse
  * MISS → filesystem lookup → create dentry

---

### Step 2: Final Result

```
dentry ("file.txt") → inode
```

---

### Step 3: Create FILE

```
file = new struct file
file->inode = inode
file->f_pos = 0
```

---

### Step 4: Assign FD

```
process_fd_table[fd] = file
return fd
```

---

## 📖 READ FLOW

```
read(fd, buf, N)
```

### Step 1:

```
fd → file
```

### Step 2:

```
file → inode
```

### Step 3: Page Cache Check

```
inode → page cache
```

#### ✅ Cache HIT

```
copy_to_user()
```

#### ❌ Cache MISS

```
filesystem → block mapping
           → block layer
           → device driver
           → disk
           → load into page cache
           → copy_to_user()
```

### Step 4:

```
file->f_pos += bytes_read
```

---

## ✍️ WRITE FLOW

```
write(fd, buf, N)
```

### Step 1:

```
fd → file → inode
```

### Step 2: Write to Page Cache

```
modify page
mark DIRTY
```

### Step 3: Async Writeback

```
flush to disk later
```

### Step 4:

```
file->f_pos += bytes_written
```

---

## 🧩 Important Relationships

### 🔹 DENTRY vs INODE vs FILE

| Object | Role          |
| ------ | ------------- |
| DENTRY | name → inode  |
| INODE  | actual file   |
| FILE   | open instance |

---

### 🔹 Multiple Opens

```c
fd1 = open("file.txt");
fd2 = open("file.txt");
```

```
fd1 → file1 → inode
fd2 → file2 → inode
```

* Same inode
* Different file objects
* Different offsets

---

### 🔹 fork() Behavior

```
fd → SAME file → SAME offset
```

(parent & child share file)

---

### 🔹 Page Cache

```
inode → page cache
```

* Shared across processes
* Improves performance

---

### 🔹 FD Scope

```
Process A: fd 3 → file A
Process B: fd 3 → file B
```

* FD is per-process

---

### 🔹 Offset Location

```
f_pos belongs to FILE (not inode)
```

---

## 🎯 Final Unified Diagram

```
         PATH
          │
          ▼
       DENTRY  ("file.txt")
          │
          ▼
        INODE  (metadata + disk blocks)
          │
          ▼
   ┌───────────────┐
   │  PAGE CACHE   │
   └───────────────┘
          ▲
          │
        FILE (open instance)
          │
          ▼
         FD (int)
```

---

## ⚡ Key Takeaways

* Dentry = name mapping
* Inode = actual file
* File = open instance
* FD = handle
* Page cache belongs to inode
* Offset belongs to file

---

## 🚀 Optional Advanced Topics

* mmap vs read/write
* Direct I/O (O_DIRECT)
* ext4 block mapping
* journaling
* NFS behavior
* mapping to cloud storage (EBS/NVMe)

---
