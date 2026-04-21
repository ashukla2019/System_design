======================== USER SPACE ========================

open("/home/user/file.txt")
read(fd, buf, N)
write(fd, buf, N)

============================================================


======================== KERNEL SPACE =======================

            ┌────────────────────────────────────┐
            │  VFS (Path Resolution Layer)       │
            │                                    │
            │  Path split:                       │
            │  /home/user/file.txt               │
            │     → home → user → file.txt       │
            │                                    │
            │  dentry cache lookup               │
            │   HIT  → dentry → inode            │
            │   MISS → filesystem lookup         │
            └────────────────────────────────────┘
                          │
                          ▼
            ┌────────────────────────────────────┐
            │  INODE (loaded or initialized)     │
            │  - metadata                        │
            │  - block mapping (extents)        │
            └────────────────────────────────────┘
                          │
                          ▼
            ┌────────────────────────────────────┐
            │  FILE OBJECT (struct file)         │
            │                                    │
            │  file {                            │
            │     inode *inode                  │
            │     f_pos = 0  ← FILE POINTER     │
            │  }                                │
            │                                    │
            │  fd → file                        │
            └────────────────────────────────────┘
                          │
        ┌─────────────────┴─────────────────┐
        ▼                                   ▼

===================== READ PATH =====================   ===================== WRITE PATH =====================

      ┌──────────────────────┐                     ┌────────────────────────┐
      │ fd → file            │                     │ fd → file              │
      │ f_pos = offset       │                     │ write to page cache    │
      └──────────────────────┘                     │ mark DIRTY            │
                │                                 └────────────────────────┘
                ▼                                             │
      ┌──────────────────────┐                                ▼
      │ PAGE CACHE CHECK     │                     ┌────────────────────────┐
      │ HIT → return         │                     │ FILESYSTEM ALLOCATION  │
      │ MISS → continue      │                     │ offset → logical block │
      └──────────────────────┘                     │ logical → physical     │
                │                                 └────────────────────────┘
                ▼                                             │
      ┌──────────────────────┐                                ▼
      │ FILESYSTEM            │                     ┌────────────────────────┐
      │ logical → physical    │                     │ BLOCK LAYER            │
      └──────────────────────┘                     │ physical → sector      │
                │                                 └────────────────────────┘
                ▼                                             │
      ┌──────────────────────┐                                ▼
      │ BLOCK LAYER          │                     ┌────────────────────────┐
      │ physical → sector     │                     │ DEVICE DRIVER          │
      └──────────────────────┘                     │ NVMe / virtio / SATA   │
                │                                 └────────────────────────┘
                ▼                                             │
      ┌──────────────────────┐                                ▼
      │ DEVICE DRIVER        │                     ┌────────────────────────┐
      │ NVMe / virtio        │                     │ STORAGE (EBS/DISK)     │
      └──────────────────────┘                     │ fetch / write block    │
                │                                 └────────────────────────┘
                ▼                                             │
      ┌──────────────────────┐                                ▼
      │ STORAGE (DISK/EBS)   │                     ┌────────────────────────┐
      │ read block data      │                     │ write ACK returned     │
      └──────────────────────┘                     └────────────────────────┘
                │
                ▼
      ┌──────────────────────┐
      │ PAGE CACHE UPDATE    │
      └──────────────────────┘
                │
                ▼
      ┌──────────────────────┐
      │ copy_to_user()       │
      └──────────────────────┘

============================================================


==================== FINAL STEP ====================

file->f_pos += bytes_read/write
