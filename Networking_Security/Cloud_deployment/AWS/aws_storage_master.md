# AWS Storage – Complete Architecture & Workflow Guide

This document covers:

1. Amazon EBS (Block Storage)
2. Amazon EFS (File Storage)
3. Amazon S3 (Object Storage)
4. Internal Data Flow
5. Architecture Comparison
6. Interview-Ready Summary


============================================================
PART 1 – AMAZON EBS (Elastic Block Store)
============================================================

What is EBS?

EBS is block storage attached to EC2 instances like a virtual hard disk.

- Single AZ
- Attached to one EC2 (except Multi-Attach specific types)
- Low latency
- Used for OS, databases, transactional systems


EBS Architecture

EC2 Instance
     ↓
OS Block Layer
     ↓
EBS Volume
     ↓
EBS Storage Backend (Replicated within AZ)


EBS Attachment Workflow

1. Create EBS Volume (Choose AZ)
2. Launch EC2 in same AZ
3. Attach Volume
4. OS detects new block device (/dev/xvdf)
5. Create filesystem (ext4/xfs)
6. Mount to directory
7. Read/Write data


Internal Data Flow (Write Operation)

Application
   ↓
Linux VFS
   ↓
Filesystem (ext4/xfs)
   ↓
Block Layer
   ↓
EBS Virtual Device
   ↓
EBS Backend Storage (replicated inside AZ)


Important Characteristics

- AZ-level redundancy (not multi-AZ)
- Snapshots stored in S3
- Volume types: gp3, io2, st1, sc1


============================================================
PART 2 – AMAZON EFS (Elastic File System)
============================================================

What is EFS?

Managed NFS-based shared file storage.

- Regional
- Multi-AZ
- Shared across EC2
- POSIX compliant


EFS Architecture

VPC
├── Subnet (AZ-a) → EC2
├── Subnet (AZ-b) → EC2
└── EFS File System
       ├── Mount Target (AZ-a ENI)
       ├── Mount Target (AZ-b ENI)


EFS Workflow

1. Create EFS (Regional)
2. Create Mount Targets (per AZ)
3. Configure Security Group (Allow TCP 2049)
4. Install NFS client on EC2
5. Mount using DNS name
6. Read/Write shared data

Example mount command:

sudo mount -t nfs4 fs-12345.efs.region.amazonaws.com:/ /mnt/efs


EFS Data Flow

Application
   ↓
Linux VFS
   ↓
NFS Client
   ↓
TCP 2049
   ↓
Mount Target ENI
   ↓
EFS Backend (Multi-AZ replicated)


Performance Modes

- General Purpose
- Max I/O


Throughput Modes

- Bursting
- Provisioned
- Elastic


Failure Scenario

If AZ-a fails:

- EC2 in AZ-a becomes unavailable
- EFS data remains safe (regional replication)
- EC2 in AZ-b continues accessing EFS via its mount target


============================================================
PART 3 – AMAZON S3 (Simple Storage Service)
============================================================

What is S3?

Object storage service accessed via API/SDK/HTTP.

- Regional
- Multi-AZ
- Virtually unlimited scale
- Internet accessible (if allowed)


S3 Architecture

Client / Application
        ↓
HTTPS (REST API)
        ↓
S3 Endpoint
        ↓
S3 Storage Nodes (Multi-AZ replicated)


S3 Upload Workflow

1. Client sends HTTPS request
2. IAM authentication
3. Object stored in bucket
4. Replicated across multiple AZs
5. Metadata updated


S3 Data Model

Object consists of:

- Key
- Value (data)
- Metadata
- Version ID (if enabled)


Storage Classes

- Standard
- Intelligent-Tiering
- Standard-IA
- One Zone-IA
- Glacier
- Glacier Deep Archive


============================================================
Deep Architecture Comparison
============================================================

| Feature | EBS | EFS | S3 |
|----------|------|------|------|
| Type | Block | File | Object |
| Access | Attach to EC2 | NFS Mount | API |
| Shared | No | Yes | Yes |
| Multi-AZ | No | Yes | Yes |
| Latency | Very Low | Low | Higher |
| Use Case | OS, DB | Shared apps | Backup, media |


============================================================
When To Use What?
============================================================

Use EBS When:
- Running database
- Need low latency
- Need boot volume

Use EFS When:
- Multiple EC2 need shared files
- Web servers sharing uploads
- Container storage

Use S3 When:
- Backup
- Static website
- Logs
- Big data
- Media storage


============================================================
Complete Storage Architecture View
============================================================

                ┌───────────────┐
                │  Application  │
                └───────┬───────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
      EBS             EFS              S3
   (Block)          (File)           (Object)
   Single AZ        Regional         Regional
   Attached         Shared           API Based


============================================================
60-Second Interview Summary
============================================================

AWS provides three primary storage types:

- EBS: Block storage attached to EC2 within a single AZ.
- EFS: Regional NFS-based shared file storage.
- S3: Highly durable, scalable object storage accessed via API.

Choice depends on:
- Access pattern
- Performance requirement
- Sharing requirement
- Availability design


============================================================
Memory Trick
============================================================

Block → Attach
File → Mount
Object → API

EBS → EC2 Disk
EFS → Shared Folder
S3 → Internet Storage