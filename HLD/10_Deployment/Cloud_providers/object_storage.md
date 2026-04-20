# AWS Object Storage (S3) / Azure Object Storage (Blob Storage) – Complete Guide

---

## 🔹 What is Object Storage?

| AWS (S3) | Azure (Blob Storage) |
|----------|----------------------|
| Amazon S3 (Simple Storage Service) | Azure Blob Storage |
| Stores data as objects (files) | Stores data as blobs |
| Highly scalable and durable | Highly scalable and durable |
| Accessed over HTTP/HTTPS | Accessed over REST APIs |
| Used for images, videos, backups, logs | Used for images, videos, backups, logs |

---

## 🔹 Key Components

| AWS | Azure |
|-----|------|
| Bucket | Storage Account + Container |
| Object | Blob |
| Key | Blob Name |

---

## 🔹 Architecture Overview

```text
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
Object Storage System                     Blob Container
        │                                         │
        ▼                                         ▼
Multi-AZ Replication                      Azure Storage Fabric
        │                                         │
        ▼                                         ▼
Physical Storage (Disks)                 Region/Zone Replicated Storage

Step-by-Step Working
1️⃣ Create Storage
AWS	Azure
Create S3 Bucket	Create Storage Account + Blob Container
Globally unique name	Globally unique storage account
2️⃣ Upload Object
AWS:
User ───── uploads ─────► S3 Bucket (Object)

Azure:
User ───── uploads ─────► Blob Container (Blob)
🔹 Object Structure
AWS S3 Object	Azure Blob
Data	Data
Metadata	Metadata
Key	Blob Name
🔹 Read / Write Flow
🔸 AWS S3 Flow vs Azure Blob Flow
AWS (S3)                                  Azure (Blob Storage)
────────                                  ─────────────────────
Application                               Application
   │                                         │
   ▼                                         ▼
HTTP/HTTPS (REST API)                     HTTPS REST API
   │                                         │
   ▼                                         ▼
S3 Endpoint (Auth + Routing)              Azure Blob Endpoint
   │                                         │
   ▼                                         ▼
S3 Bucket                                 Storage Account
   │                                         │
   ▼                                         ▼
Distributed Object Storage                Blob Container
   │                                         │
   ▼                                         ▼
Multi-AZ Replication                      Azure Storage Fabric
   │                                         │
   ▼                                         ▼
Response returned                         Response returned
🔹 Data Storage Internals
AWS	Azure
Object-based storage	Blob-based storage
Multi-AZ replication	LRS / ZRS / GRS replication
Erasure coding + replication	Replication + redundancy
11 9’s durability	High durability SLA
🔹 Access Control
AWS	Azure
IAM Policies	Azure RBAC
Bucket Policies	Storage Account Policies
ACLs (rare)	Shared Access Signatures (SAS)
🔹 Storage Classes
AWS S3	Azure Blob Storage
Standard	Hot
Intelligent-Tiering	Cool
Standard-IA	Cool Tier
Glacier	Archive
Deep Archive	Deep Archive
🔹 Key Concepts
1️⃣ Object Storage Model
AWS	Azure
Key-value objects	Key-value blobs
No filesystem	No filesystem
No block structure	No block structure
2️⃣ No Mounting
AWS	Azure
API-based access	API-based access
No mount required	No mount required
3️⃣ Replication Model
AWS	Azure
Multi-AZ replication	LRS / ZRS / GRS
Automatic healing	Auto replication + repair

🔹 Full End-to-End Flow
AWS (S3)                                  Azure (Blob Storage)
────────                                  ─────────────────────
User / Application                        User / Application
        │                                         │
        ▼                                         ▼
Cloud API (S3 Endpoint)                   Cloud API (Blob Endpoint)
        │                                         │
        ▼                                         ▼
Bucket                                    Storage Account
        │                                         │
        ▼                                         ▼
Object Storage System                     Blob Storage System
        │                                         │
        ▼                                         ▼
Replication (Multi-AZ)                    Replication (LRS/ZRS/GRS)
        │                                         │
        ▼                                         ▼
Physical Storage (Disks)                 Physical Storage (Disks)
🔹 Key Takeaways
AWS	Azure
S3 = Object Storage	Blob Storage = Object Storage
Fully API-based	Fully API-based
No filesystem	No filesystem
Highly durable	Highly durable
Global scale	Global scale

---
