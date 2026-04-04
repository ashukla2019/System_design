# AWS File Storage (EFS) – Complete Guide

## 🔹 What is File Storage?

In AWS, file storage is provided by **Amazon EFS (Elastic File System)**.

- Fully managed file storage
- Shared file system
- Accessible by multiple EC2 instances at the same time
- Uses standard file protocols (NFS)

---

## 🔹 Key Characteristics

- Supports **multiple EC2 instances simultaneously**
- Automatically scales storage up/down
- Regional service (spans multiple AZs)
- POSIX-compliant (like Linux file system)

---

## 🔹 Architecture Overview

```
EC2 Instances (multiple)
│
▼
Mount Targets (in each AZ)
│
▼
Amazon EFS (File System)
│
▼
Storage distributed across multiple AZs
│
▼
Physical Storage (disks)

```

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
Application
     │
     ▼
Operating System
     │
     ▼
NFS Client
     │
     ▼
AWS Network
     │
     ▼
Mount Target
     │
     ▼
EFS File System

6️⃣ Data Storage Internals
Data stored as files and directories
Automatically replicated across multiple AZs
Highly available and durable

Full End-to-End Flow
User/Application
        │
        ▼
EC2 Instance
        │
        ▼
NFS Mount
        │
        ▼
Mount Target (AZ-specific)
        │
        ▼
EFS File System (Regional)
        │
        ▼
Distributed Storage across AZs
