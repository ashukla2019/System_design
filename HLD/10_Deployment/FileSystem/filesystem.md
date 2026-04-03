USER SPACE
   ↓
open("/home/user/file.txt")
   ↓
────────────────────────────────────
KERNEL SPACE (VFS)
────────────────────────────────────

[1] PATH STRING
   "/home/user/file.txt"
   ↓
Split into components
["home", "user", "file.txt"]
   ↓

[2] DENTRY CACHE LOOKUP (for each component)
   ↓
[ PATH COMPONENT ]
(parent_inode, name)
        │
        ▼
   ┌───────────────┐
   │ dcache lookup │
   └───────────────┘
        │
 ┌──────┴───────┐
 │              │
YES            NO
 │              │
 ▼              ▼
dentry->inode   parent_inode->i_op->lookup()
  │                │
  │         ┌───────────────────────────┐
  │         │ filesystem finds inode    │
  │         │ (disk may be accessed)    │
  │         └──────────────┬────────────┘
  │                        ▼
  │              [4] INODE INITIALIZATION
  │                 inode->i_op = ext4_inode_operations
  │                 inode->i_fop = ext4_file_operations
  │                        ▼
  │              [5] CREATE DENTRY
  │                 dentry->d_inode = inode
  │                 (cached in parent + name)
  │                        ▼
  └───────────────► next time cache hit!

────────────────────────────────────
[6] OPEN() PHASE
────────────────────────────────────

struct file *file
   ↓
file->f_inode = inode
file->f_op    = inode->i_fop
file->f_pos   = 0
   ↓
file->f_op->open() → ext4_file_open()
   ↓
fdtable[fd] → file*

────────────────────────────────────
[8] READ SYSTEM CALL
────────────────────────────────────
[1] User calls read()
read(fd, buf, size)
        │
        ▼
[2] fd → struct file
fdtable lookup → file*
        │
        ▼
[3] VFS read path
vfs_read()
 → new kernels use:
file->f_op->read_iter()
        │
        ▼
[4] Generic buffered read path
filemap_read()   ← (page cache handler)
        │
        ▼
[5] File Offset Handling
pos = file->f_pos   (or passed iocb position)
        │
        ▼
[6] Page Cache Lookup (per page)
For each required page:
 ┌───────────────┐
 │ Page present? │
 └──────┬────────┘
        │
   YES  │  NO
        │
        ▼
   (cache hit)      (cache miss)
        │                │
        │                ▼
        │        [7] Allocate page
        │        add to page cache
        │
        ▼
[8] If MISS → Read from disk
        │
        ▼
[9] Filesystem Mapping (EXT4)
logical_block = pos / block_size
ext4_map_blocks()
→ logical_block → physical_block
(using extent tree in inode)
        │
        ▼
[10] Block → Sector conversion
sector = physical_block * (block_size / 512)
        │
        ▼
[11] Create BIO
bio:
 → target sector
 → page cache page
 → READ operation
        │
        ▼
[12] Submit I/O
submit_bio()
        │
        ▼
[13] Block Layer (blk-mq)
bio → request
 → merge / schedule
 → dispatch to device queue
        │
        ▼
[14] Device Driver (NVMe / Xen)
 → build device command (NVMe)
 → submit to hardware queue
        │
        ▼
[15] (Cloud case - AWS EBS)
NVMe device
 → Nitro Hypervisor
 → Network
 → EBS storage backend
        │
        ▼
[16] I/O Completion
 → DMA writes into page cache page
 → page marked Uptodate
        │
        ▼
[17] Copy to User
copy_to_user()
(page cache → user buffer)
        │
        ▼
[18] Update file offset
file->f_pos += bytes_read
 