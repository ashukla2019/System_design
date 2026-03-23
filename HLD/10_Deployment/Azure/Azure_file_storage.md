What is File Storage?

In Azure, file storage is provided by Azure Files.

Fully managed file shares
Shared storage across multiple VMs
Accessible using standard file protocols (SMB / NFS)
Can be mounted concurrently by multiple VMs
🔹 Key Characteristics
Supports multiple VMs simultaneously
Automatically scales storage capacity
Regional service (can replicate to other regions with RA-GRS)
POSIX-compliant if using NFS (Linux clients)
🔹 Architecture Overview
```
Azure VMs (multiple)
│
▼
File Share Endpoint (Mount)
│
▼
Azure File Share (SMB / NFS)
│
▼
Storage Account
│
▼
Physical Storage (Disks)
```
🔹 Step-by-Step Working
1️⃣ Create Storage Account & File Share
Storage account: standard or premium
File share: define quota and protocol (SMB/NFS)
Optionally enable geo-redundancy
2️⃣ Mount File Share to VM
Using SMB (Windows/Linux) or NFS (Linux)

Example for SMB (Windows/Linux):

# Linux
sudo mount -t cifs //storageaccountname.file.core.windows.net/sharename /mnt/azurefiles \
-o vers=3.0,username=storageaccountname,password=storageaccountkey,dir_mode=0777,file_mode=0777

# Windows
net use Z: \\storageaccountname.file.core.windows.net\sharename /u:storageaccountname storageaccountkey
3️⃣ Access from Multiple VMs
VM-1 ─┐
       ├────► Azure File Share
VM-2 ─┤
       ├────►
VM-3 ─┘

All VMs see the same files

4️⃣ Read/Write Flow
```
Application
     │
     ▼
Operating System
     │
     ▼
SMB/NFS Client
     │
     ▼
Azure Network
     │
     ▼
File Share Endpoint
     │
     ▼
Azure File Share
```
5️⃣ Data Storage Internals
Data stored as files and directories
Automatically replicated based on redundancy option:
LRS → Locally redundant (single region, same data center)
ZRS → Zone redundant (multiple AZs within a region)
GRS / RA-GRS → Geo-redundant storage for disaster recovery
Highly available and durable
🔹 Full End-to-End Flow
```
User/Application
        │
        ▼
Azure VM
        │
        ▼
Mounted File Share (SMB/NFS)
        │
        ▼
Azure File Share (Regional)
        │
        ▼
Storage Account
        │
        ▼
Physical Storage (Disks)
```

Key Points

Azure Files = AWS EFS
Shared, fully managed file system
Supports SMB and NFS for multi-VM access
Redundancy options for durability and high availability
