What is Object Storage?

In Azure, object storage is provided by Azure Blob Storage.

Stores data as objects (blobs)
Highly scalable and durable
Accessed over HTTP/HTTPS
Used for images, videos, backups, logs, data lakes, etc.

Storage Account → Logical container for blobs, tables, queues
Container → Grouping of blobs within the storage account
Blob → The object/file itself
Blob Name / Key → Unique identifier of the blob within a container

Architecture Overview
```
User/Application
│
▼
Azure Blob Storage (Container)
│
▼
Blob Storage System
│
▼
Multiple AZ/Region Replication
│
▼
Physical Storage (Disks)
```
🔹 Step-by-Step Working
1️⃣ Create Storage Account & Container
Storage account: globally unique name
Select performance tier: Standard / Premium
Container: holds blobs, access level (private, blob, container)
2️⃣ Upload Blob

User ───── uploads ─────► Blob Storage Container

File is stored as a blob
Each blob gets a unique name/key
3️⃣ Blob Structure

Each blob contains:

Data (file content)
Metadata (size, type, custom tags)
Key (blob name/path)
4️⃣ Read/Write Flow
```
Application
     │
     ▼
HTTP/HTTPS Request
     │
     ▼
Azure Blob Storage REST API / SDK
     │
     ▼
Blob Container
     │
     ▼
Blob Storage System
```
5️⃣ Data Storage Internals
Stored as objects (blobs, not blocks)
Replicated based on redundancy option:
LRS → Locally Redundant Storage (single AZ)
ZRS → Zone-Redundant Storage (multiple AZs)
GRS → Geo-Redundant Storage (replicated to secondary region)
RA-GRS → Read-Access Geo-Redundant Storage
Designed for high durability (≥ 99.999999999%)
6️⃣ Access Control
Azure RBAC → Role-based access to storage account
Shared Access Signatures (SAS) → Temporary URL/token-based access
Container-level access policies → Private / Blob / Container
7️⃣ Storage Tiers
Hot → Frequent access
Cool → Infrequent access
Archive → Long-term archival
🔹 Full End-to-End Flow
```
User/Application
        │
        ▼
Internet / Azure Network
        │
        ▼
Blob Storage Endpoint
        │
        ▼
Blob Container
        │
        ▼
Blob Storage System
        │
        ▼
Data replicated across multiple AZs or Regions
```

Key Points
Azure Blob Storage = AWS S3
Storage account → Container → Blob hierarchy
Multiple redundancy options for durability
Access via HTTP/HTTPS APIs or SDKs
Hot / Cool / Archive tiers for cost optimization
