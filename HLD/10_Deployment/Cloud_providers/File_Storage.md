
AWS File Storage (EFS) / Azure File Storage (Azure Files)
🔹 What is File Storage?
AWS	                             Azure
Amazon EFS (Elastic File System)	Azure Files (Azure File Storage)
---

## 🔹 Key Characteristics
AWS EFS	                         Azure Files
Uses NFS protocol	                  Uses SMB (and NFS optional in premium)
Linux-focused	                         Works with Linux + Windows
Mount via NFS client	                  Mount via SMB/NFS client
Regional service across AZs	           Stored in Azure Storage Account (region-redundant options available)
---

## 🔹 Step-by-Step Working

### 1️⃣ Create EFS File System
AWS (EFS)                                | Azure (Azure Files)
----------------------------------------|----------------------------------------
Created at regional level               | Created at storage account level
Spans multiple AZs automatically        | Can be ZRS (Zone Redundant Storage)

---

### 2️⃣ Create Mount Targets
AWS (EFS)                                | Azure (Azure Files)
----------------------------------------|----------------------------------------
Mount Target per AZ (VPC ENI)          | Storage endpoint (SMB/NFS endpoint)
Provides IP for NFS access              | Provides UNC path / NFS endpoint

---

### 3️⃣ Attach (Mount) to EC2

```bash
AWS (EFS)
sudo mount -t nfs4 fs-123456:/ /mnt/efs

Azure (Files - SMB example)
sudo mount -t cifs //storageaccount.file.core.windows.net/share /mnt/azure

4️⃣ Access from Multiple EC2
AWS (EFS)                               | Azure (Azure Files)
---------------------------------------|----------------------------------------
EC2-1 ─┐                               | VM-1 ─┐
       ├────► EFS                      |      ├────► Azure Files
EC2-2 ─┤                               | VM-2 ─┤
       ├────► Shared file system       |      ├────► Shared file share
EC2-3 ─┘                               | VM-3 ─┘
``` id="efsflow1"

All instances see the same files

---

### 5️⃣ Read/Write Flow

``` id="efsflow2"
### 🔹 Read / Write Flow (Amazon EFS)


🟩 AWS (EFS)                                         | 🔵 Azure (Azure Files)

[EC2 Application]                                   | [VM Application]
        ↓                                           |        ↓
VFS + NFS Client                                   | VFS + SMB/NFS Client
        ↓                                           |        ↓
NFS over TCP/IP                                    | SMB/NFS over TCP/IP
        ↓                                           |        ↓
Mount Target (VPC ENI)                             | Storage Endpoint (File Share)
        ↓                                           |        ↓
EFS Service                                        | Azure Files Service
   → metadata service                              |    → file share metadata service
   → file → block mapping                          |    → file → storage mapping
        ↓                                           |        ↓
Distributed Storage Layer                          | Azure Storage Backend
   → multi-AZ chunk storage                        |    → replicated storage (LRS/ZRS/GRS)
-------------------------------------------------------------
🔸 Read Flow (Step-by-step)
AWS EFS
NFS READ request from EC2
Mount target forwards request
Metadata service locates file
Data fetched from distributed storage
Returned to EC2 via NFS

Azure Files
SMB/NFS READ request from VM
Azure file endpoint processes request
Metadata lookup in storage service
Data retrieved from Azure storage backend
Returned to VM
-------------------------------------------------------------------------------------
🔸 Write Flow (Step-by-step)
AWS EFS
NFS WRITE request
Metadata updated
Data split into chunks
Stored across multiple AZs
Acknowledgement returned

Azure Files
SMB/NFS WRITE request
File metadata updated
Data stored in Azure Storage backend
Replicated based on redundancy (LRS/ZRS/GRS)
ACK returned to VM

```
