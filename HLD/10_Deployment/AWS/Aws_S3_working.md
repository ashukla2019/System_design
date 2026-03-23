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
