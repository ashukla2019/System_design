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

All instances see the same files

---

### 5️⃣ Read/Write Flow

``` id="efsflow2"
### 🔹 Read / Write Flow (Amazon EFS)

[EC2 Application]
        │
        ▼
Linux Kernel (VFS + NFS Client)
        → Converts file operation into NFS request
        │
        ▼
NFS over Network (TCP/IP)
        │
        ▼
Mount Target (EFS Network Interface in VPC)
        → Entry point into EFS service
        │
        ▼
Amazon EFS Service
        → Metadata service (file names, directories, permissions)
        → Maps file → internal data blocks
        │
        ▼
Distributed Storage Layer
        → Stores actual file data in chunks
        → Automatically spread across multiple AZs

🔸 Read Flow (Step-by-step)
App calls read()
Linux NFS client converts to NFS READ request
Request goes to Mount Target (network endpoint)
EFS metadata service finds file location
Data blocks fetched from distributed storage
Data returned via NFS back to EC2
Kernel cache + application receives data

🔸 Write Flow (Step-by-step)
App calls write()
NFS WRITE request sent over network
Mount target forwards to EFS service
EFS:
Updates metadata
Splits data into chunks
Data stored in distributed storage layer
Replication handled automatically across AZs
Acknowledgement returned to EC2

```
