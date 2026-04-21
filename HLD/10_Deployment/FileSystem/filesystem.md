# Linux File I/O Internals (Complete End-to-End Flow)

---

# 🧠 Big Picture Mental Model

A file operation is always:


PATH → inode → file → offset → blocks → device I/O


Split into 3 phases:

1. open() → build file context
2. read()/write() → use file context
3. filesystem → translate to disk/EBS I/O

---

# 🔹 1. OPEN FLOW (Path → file creation)

Example:

```c
fd = open("/home/user/file.txt", O_RDONLY);
Step 1: Path is tokenized
"/home/user/file.txt"
        ↓
["home", "user", "file.txt"]
Step 2: Start from root inode
current = "/"
Step 3: Path walk (component by component)

For each token:

3.1 Lookup in dentry cache (dcache)
"home" under "/"
If FOUND → get inode directly
If NOT FOUND → go to filesystem
3.2 If dentry miss → filesystem lookup

Filesystem (ext4/xfs):

read directory blocks
find entry
create dentry
attach inode
Step 4: inode loading (IMPORTANT)

If inode is not in memory:

disk inode table → read inode → initialize in RAM

Creates:

struct inode {
    size
    permissions
    timestamps
    block mapping (extents)
}
Step 5: dentry → inode mapping
dentry ("file.txt") → inode
Step 6: create struct file

Kernel creates:

struct file {
    loff_t f_pos = 0;        // file offset
    struct inode *inode;     // file metadata
}
Step 7: assign file descriptor
fd → struct file*
🔥 RESULT OF OPEN()
fd → file → inode
🔹 2. READ FLOW (fd → data → user buffer)

Example:

read(fd, buf, 4096);
Step 1: fd → file
fd → struct file
Step 2: get file offset
offset = file->f_pos
Step 3: check page cache (RAM first)
Case A: HIT
page cache → copy_to_user()

DONE (no disk access)

Case B: MISS (go deeper)
Step 4: filesystem mapping (CORE STEP)

Filesystem translates:

offset → logical block → physical block

Example:

offset = 8192
block size = 4096

logical block = 2
inode → physical block = 9050
Step 5: block layer
physical block → sector → BIO request

Block layer responsibilities:

merges I/O
schedules requests
queues operations
Step 6: device driver
BIO → NVMe/SATA command

Or for cloud:

virtio → AWS Nitro
Step 7: storage device (or EBS)

If using AWS EBS:

driver → Nitro → network → EBS backend

EBS:

locates block
reads replicated storage
returns data
Step 8: return path
device → driver → block layer → page cache → user buffer
Step 9: update file pointer
file->f_pos += bytes_read
🔹 3. WRITE FLOW (fd → disk update)

Example:

write(fd, buf, 4096);
Step 1: fd → file
fd → struct file
Step 2: write into page cache
user buffer → page cache
mark DIRTY

👉 No immediate disk I/O

Step 3: update file pointer
file->f_pos += bytes_written
Step 4: writeback (async or fsync)

Triggered by:

kernel flush
memory pressure
fsync()
Step 5: filesystem allocation
allocate blocks
update inode mapping
Step 6: block layer
physical block → sector → BIO
Step 7: driver → device / EBS
BIO → driver → EBS

EBS:

replicates data
ensures durability
sends ACK
🔹 4. COMPLETE END-TO-END VIEW
READ
fd
 → file (f_pos)
 → page cache
 → filesystem (inode mapping)
 → block layer
 → driver
 → storage (disk/EBS)
 → page cache
 → user buffer
WRITE
fd
 → file (f_pos)
 → page cache (dirty)
 → writeback
 → filesystem (block allocation)
 → block layer
 → driver
 → storage (EBS/disk)
🔹 5. KEY OBJECT RELATIONSHIP
inode  = file metadata + block map (persistent)
file   = open instance (offset + state)
fd     = index to file
🔹 6. CRITICAL INSIGHT
Concept	Role
dentry	name → inode mapping
inode	file structure + block mapping
file	runtime state (f_pos)
page cache	RAM acceleration
filesystem	block translation logic
block layer	I/O scheduling
driver	hardware communication
🔥 FINAL ONE-LINE FLOW
open() builds file context (inode + file object),
read/write uses file offset → inode mapping → filesystem → block layer → device I/O.
