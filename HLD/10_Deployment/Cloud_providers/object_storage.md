


AWS (S3)                                  Azure (Blob Storage)
────────                                  ─────────────────────
User/Application                          User/Application
        │                                         │
        ▼                                         ▼
S3 API Endpoint                           Azure Blob Endpoint
        │                                         │
        ▼                                         ▼
S3 Bucket                                 Storage Account
        │                                         │
        ▼                                         ▼
S3 Object Storage System                  Blob Container
        │                                         │
        ▼                                         ▼
Multi-AZ Replication                      Azure Storage Fabric
        │                                         │
        ▼                                         ▼
Physical Storage (Disks)                 Region + Zone Replicated Storage


Step-by-Step Working
1️⃣ Create Storage
AWS	Azure
Create S3 Bucket	Create Storage Account + Blob Container
Globally unique name	Globally unique storage account
2️⃣ Upload Object
AWS:
User ───── PUT ─────► S3 Bucket (Object)

Azure:
User ───── PUT ─────► Blob Container (Blob)
File becomes an object/blob
Stored with metadata + unique key/name
3️⃣ Object Structure
AWS S3 Object	Azure Blob
Data	Data
Metadata	Metadata
Key	Blob Name
🔹 Read / Write Flow
🔸 AWS S3 Flow
Application
   │
   ▼
HTTP/HTTPS (REST API)
   │
   ▼
S3 Endpoint (Auth + Routing)
   │
   ▼
S3 Bucket
   │
   ▼
Distributed Object Storage
   │
   ▼
Multi-AZ Replication
   │
   ▼
Response returned via same path
🔸 Azure Blob Flow
Application
   │
   ▼
HTTPS REST API
   │
   ▼
Azure Blob Endpoint
   │
   ▼
Storage Account
   │
   ▼
Blob Container
   │
   ▼
Azure Storage Fabric
   │
   ▼
Region / Zone Replicated Storage
   │
   ▼
Response returned via same path
🔹 Data Storage Internals
AWS (S3)	Azure (Blob Storage)
Object-based storage	Blob-based storage
Multi-AZ replication	LRS / ZRS / GRS replication
Erasure coding + replication	Replication + redundancy
11 9’s durability	Very high durability SLA
🔹 Access Control
AWS	Azure
IAM Policies	Azure RBAC
Bucket Policies	Storage Account Policies
ACLs (rare)	SAS Tokens
🔹 Storage Classes
AWS S3	Azure Blob Storage
Standard	Hot
Intelligent-Tiering	Cool
Standard-IA	Cool Tier
Glacier	Archive
Deep Archive	Archive Tier
🔹 Key Concepts
1️⃣ Object Storage Model
AWS	Azure
Key-value objects	Key-value blobs
No filesystem	No filesystem
No block structure	No block structure
2️⃣ No Mounting
AWS	Azure
API access only	API access only
No mount required	No mount required
3️⃣ Replication Model
AWS	Azure
Multi-AZ replication	LRS / ZRS / GRS
Automatic healing	Automatic replication + repair
