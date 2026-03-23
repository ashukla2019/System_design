What is Block Storage?

In Azure, block storage is provided by Azure Managed Disks.

Provides raw disk volumes
Works like a hard drive (Standard SSD, Premium SSD, Ultra Disk)
Can be attached to Azure Virtual Machines (VMs)
You can format, partition, and mount it
```
Azure VM (OS)
│
▼
Managed Disk (Block Storage)
│
▼
Azure Disk Service (replicated within Availability Zone)
│
▼
Physical Storage (disks in Azure Data Center)
```
🔹 Step-by-Step Working
1️⃣ Create Managed Disk
Create a Managed Disk in a specific Availability Zone or Region
Example: 128 GB Premium SSD

Note: Managed Disk is network-attached storage

2️⃣ Attach to Azure VM

Azure VM ───── attaches ─────► Managed Disk

Appears as:
/dev/sdc (Linux)
D: drive (Windows)
3️⃣ Format & Mount (Inside VM)
# Linux example
sudo mkfs -t ext4 /dev/sdc
sudo mkdir /data
sudo mount /dev/sdc /data

# Windows example
Initialize-Disk -Number 1
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter
Format-Volume -DriveLetter D -FileSystem NTFS

Now the disk behaves like a local disk.

4️⃣ Read/Write Flow
```
Application
   │
   ▼
Operating System (File System)
   │
   ▼
Block Device Driver
   │
   ▼
Azure Storage Network
   │
   ▼
Managed Disk (Block Storage)
   │
   ▼
Physical Disks in Data Center
```
Data travels over Azure internal network, not directly local to VM

5️⃣ Data Storage Internals
Data is split into blocks (e.g., 4KB, 8KB)
Stored across multiple physical disks within the same AZ
Automatically replicated for durability and fault tolerance
6️⃣ Snapshot (Backup)
Managed Disk ─────► Snapshot ─────► Azure Storage (Zone-Redundant or Geo-Redundant)

Uses:

Backup
Disaster recovery
Disk cloning / VM replication
🔹 Full End-to-End Flow
```
User/Application
        │
        ▼
Azure VM (OS + File System)
        │
        ▼
Managed Disk (Block Device)
        │
        ▼
Azure Network Layer
        │
        ▼
Managed Disk Service (AZ)
        │
        ▼
Physical Disks in Data Center
```
