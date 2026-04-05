# AWS Object Storage (S3) – Complete Guide

## 🔹 What is Object Storage?

In AWS, object storage is provided by **Amazon S3 (Simple Storage Service)**.

- Stores data as objects (files)
- Highly scalable and durable
- Accessed over HTTP/HTTPS
- Used for images, videos, backups, logs, etc.

---

## 🔹 Key Components

- **Bucket** → Container for storing objects  
- **Object** → File + metadata  
- **Key** → Unique name of the object in a bucket  

---

## 🔹 Architecture Overview
```
User/Application
│
▼
Amazon S3 (Bucket)
│
▼
Object Storage System
│
▼
Multiple AZ Replication
│
▼
Physical Storage (Disks)
```

---

## 🔹 Step-by-Step Working

### 1️⃣ Create Bucket
- Globally unique name
- Region-specific (but accessible globally)

---

### 2️⃣ Upload Object
User ───── uploads ─────► S3 Bucket


- File is stored as an **object**
- Each object gets a unique **key**

---

### 3️⃣ Object Structure

Each object contains:
- Data (file content)
- Metadata (size, type, etc.)
- Key (file name/path)

Example:

---

### 4️⃣ Read/Write Flow

``` id="s3flow2"
Application
     │
     ▼
HTTP/HTTPS Request
     │
     ▼
S3 API
     │
     ▼
S3 Bucket
     │
     ▼
Object Storage System

5️⃣ Data Storage Internals
Stored as objects (not blocks)
Automatically replicated across multiple AZs
Designed for 11 9’s durability (99.999999999%)
6️⃣ Access Control
IAM Policies
Bucket Policies
ACLs (less commonly used)

7️⃣ Storage Classes
Standard (frequent access)
Intelligent-Tiering
Standard-IA (infrequent access)
Glacier (archival)
Glacier Deep Archive

Full working:
User/Application
        │
        ▼
Internet / AWS Network
        │
        ▼
S3 Endpoint
        │
        ▼
S3 Bucket
        │
        ▼
Object Storage Cluster
        │
        ▼
Data replicated across multiple AZs


working: 
 
1. User / Application
This is your code or tool:
CLI (aws s3 cp)
SDK (Python boto3, Java SDK)
Browser upload

You create a request like:
PUT /my-bucket/file.txt


2. Internet / AWS Network
Request travels over:
Public Internet OR
Private AWS network (if using VPC endpoint)

Uses:
HTTPS (TLS encrypted)
DNS resolves S3 URL → nearest AWS endpoint


3. S3 Endpoint
This is the entry point of Amazon S3.

Think of it as:
API gateway for S3
Handles:
Authentication (IAM, signatures)
Authorization (bucket policies)
Request routing

Example:
https://my-bucket.s3.amazonaws.com

4. S3 Bucket
Logical container:
Like a namespace / folder
Stores objects (files)

Important:
Buckets are global (name unique)
No real “folder” → just key prefixes

Example:
my-bucket/photos/img1.jpg


5. Object Storage Cluster
Now the real magic happens internally inside AWS.

When you upload:
File is split into chunks
Metadata created:
Object key
Size
version
checksum

Stored in:
Distributed storage system
Spread across many machines

6. Data Replicated Across Multiple AZs
This is why S3 is highly durable (11 9’s).

Internally:

Data is replicated across multiple Availability Zones

Not just copied — often uses:
Erasure coding (efficient redundancy)
Automatic healing if disk/node fails

So:

Your file → split → distributed → replicated → self-healing
Full Flow (Simple Visualization)
Application (PUT request)
        │
        ▼
AWS Network (HTTPS, DNS routing)
        │
        ▼
S3 Endpoint (Auth + Routing)
        │
        ▼
S3 Bucket (Logical container)
        │
        ▼
Distributed Object Storage System
        │
        ▼
Replication across multiple AZs (durability)
Key Concepts (Very Important)
1. S3 is NOT like EBS/EFS
No block storage

No filesystem

✅ Object storage (key-value)

2. No “mounting”
Unlike EFS:
You don’t mount S3
You access via:
API (HTTP)