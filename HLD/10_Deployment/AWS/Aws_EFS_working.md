# AWS File Storage (EFS) – Complete Guide

## 🔹 What is File Storage?

In AWS, file storage is provided by **Amazon EFS (Elastic File System)**.

- Fully managed file storage
- Shared file system
- Accessible by multiple EC2 instances at the same time
- Uses standard file protocols (NFS)

---

## 🔹 Key Characteristics

---

## 🔹 Step-by-Step Working

### 1️⃣ Create EFS File System
- Created at **regional level**
- Automatically spans multiple AZs

---

### 2️⃣ Create Mount Targets
- One mount target per AZ
- Provides IP address for access

---

### 3️⃣ Attach (Mount) to EC2

```bash
sudo mount -t nfs4 fs-123456:/ /mnt/efs
Uses NFS protocol

4️⃣ Access from Multiple EC2
EC2-1 ─┐
       ├────► EFS (shared storage)
EC2-2 ─┤
       ├────►
EC2-3 ─┘
``` id="efsflow1"

👉 All instances see the same files

---

### 5️⃣ Read/Write Flow

``` id="efsflow2"

[EC2 Application]
        │
        ▼
(NFS request over network)
        │
        ▼
[Mount Target]  ← ENTRY POINT
        │
        ▼
[EFS File System]  ← LOGIC (files, dirs, metadata)
        │
        ▼
[Distributed Storage]  ← ACTUAL DATA

Step-by-step:
App calls read()
Linux sends NFS READ via NFS
Mount target receives request
Amazon Elastic File System:
Locates file metadata (inode-like info)
Finds where data is stored
Data fetched from distributed storage
Sent back to EC2

Step-by-step:
App calls write()
NFS WRITE sent over network
Mount target receives it
EFS:
Updates metadata
Splits data into chunks
Data written to multiple AZs (replication)
Acknowledgment sent back

Full flow:
the network to a mount target (entry point of EFS in that AZ), which then connects to the EFS file system, and EFS stores the data in distributed storage across multiple AZs.

```
