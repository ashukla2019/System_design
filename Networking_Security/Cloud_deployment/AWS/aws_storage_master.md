
AWS Storage – Complete Architecture & Internal Data Flow Guide
This document covers:

Amazon EBS (Block Storage)

Amazon EFS (File Storage)

Amazon S3 (Object Storage)

Correct Internal Data Flow

Control Plane vs Data Plane

Deep Architecture Comparison

Interview-Ready Summary

============================================================
PART 1 – AMAZON EBS (Elastic Block Store)
What is Amazon EBS?
Amazon Web Services Elastic Block Store (EBS) is network-attached block storage designed for EC2 instances.

Scoped to a Single Availability Zone (AZ)

Provides persistent block-level storage

Low latency

Used for OS disks, databases, transactional workloads

Automatically replicated within the same AZ

EBS is not a physical disk attached directly to EC2.
It is distributed storage accessed over the AWS internal storage network.

EBS High-Level Architecture
EC2 Instance
     ↓
Operating System
     ↓
Block Device (NVMe)
     ↓
Nitro Hypervisor
     ↓
AWS Internal Storage Network
     ↓
EBS Storage Cluster (within same AZ)
EBS Volume Creation & Attachment Workflow
Create EBS Volume (Choose AZ)

Launch EC2 in the same AZ

Attach Volume

OS detects block device (e.g., /dev/nvme1n1)

Create filesystem (ext4/xfs)

Mount to directory

Application performs read/write

Correct Internal Data Flow (Write Operation)
Application
   ↓
Linux VFS
   ↓
Filesystem (ext4/xfs)
   ↓
Linux Block Layer
   ↓
NVMe Driver
   ↓
Nitro Hypervisor
   ↓
AWS Storage Network
   ↓
EBS Storage Servers
   ↓
Synchronous Replication (within AZ)
Important Technical Clarifications
EBS traffic stays inside AWS private network

Replication happens within the same AZ only

Cross-AZ replication requires snapshots or other services

Snapshots are stored in S3 (incremental)

EBS Volume Types
gp3 (General Purpose SSD)

io2 (Provisioned IOPS SSD)

st1 (Throughput HDD)

sc1 (Cold HDD)

============================================================
PART 2 – AMAZON EFS (Elastic File System)
What is Amazon EFS?
Amazon Web Services Elastic File System (EFS) is a managed NFS-based shared file system.

Regional service

Multi-AZ storage

POSIX compliant

Automatically scalable

Shared across multiple EC2 instances

EFS Architecture
VPC (Regional)
├── Subnet (AZ-a)
│     └── EC2
├── Subnet (AZ-b)
│     └── EC2
└── EFS File System (Regional)
      ├── Mount Target (AZ-a ENI)
      ├── Mount Target (AZ-b ENI)
      └── Distributed Multi-AZ Storage Backend
Mount Target = NFS endpoint in each AZ
Actual storage = Regional distributed system

EFS Workflow
Create EFS (Regional)

Create Mount Targets (one per AZ)

Configure Security Group (Allow TCP 2049)

Install NFS client on EC2

Mount using DNS

Perform read/write operations

Example:

sudo mount -t nfs4 fs-12345.efs.region.amazonaws.com:/ /mnt/efs
Correct EFS Data Flow
Application
   ↓
Linux VFS
   ↓
NFS Client
   ↓
TCP 2049
   ↓
VPC Network
   ↓
Mount Target ENI
   ↓
Regional EFS Control Plane
   ↓
Distributed Storage Nodes
   ↓
Multi-AZ Replication
Failure Scenario
If AZ-a fails:

EC2 in AZ-a becomes unavailable

EFS remains available

EC2 in AZ-b continues accessing data

No data loss (regional replication)

============================================================
PART 3 – AMAZON S3 (Simple Storage Service)
What is Amazon S3?
Amazon Web Services Simple Storage Service (S3) is distributed object storage accessed via HTTPS API.

Regional service

Multi-AZ durability

Virtually unlimited scale

Strong read-after-write consistency

Accessed via API/SDK/HTTP

S3 High-Level Architecture
Client / Application
        ↓
DNS Resolution
        ↓
S3 Regional Endpoint
        ↓
S3 Front-End Fleet (Request Routers)
        ↓
Authentication (IAM)
        ↓
Partition Layer (Key-based routing)
        ↓
Storage Nodes
        ↓
Multi-AZ Replication / Erasure Coding
S3 is a massively distributed object storage system — not a single storage server.

S3 Upload Workflow
Client sends HTTPS PUT request

DNS resolves to regional endpoint

Front-end authenticates request

Key-based routing determines partition

Object written to storage nodes

Data replicated across multiple AZs

Metadata updated

Success response returned

S3 Object Structure
Each object consists of:

Key

Value (Data)

Metadata

Version ID (if enabled)

S3 Storage Classes
Standard

Intelligent-Tiering

Standard-IA

One Zone-IA

Glacier

Glacier Deep Archive

============================================================
CONTROL PLANE vs DATA PLANE
EBS
Control Plane:

Create Volume

Attach/Detach

Snapshot

Data Plane:

Block read/write operations

EFS
Control Plane:

Create file system

Create mount targets

Data Plane:

NFS read/write traffic

S3
Control Plane:

Create bucket

Lifecycle policies

Bucket policies

Data Plane:

PUT, GET, DELETE object operations

============================================================
Deep Architecture Comparison
Feature	EBS	EFS	S3
Type	Block	File	Object
Scope	Single AZ	Regional	Regional
Access Method	Attach to EC2	NFS Mount	HTTPS API
Shared	No (except specific types)	Yes	Yes
Multi-AZ Data	No	Yes	Yes
Network Based	Yes	Yes	Yes
Latency	Very Low	Low	Higher
Best Use Case	OS, DB	Shared apps	Backup, logs, media
============================================================
Complete Storage Architecture View
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
AWS provides three primary storage models:

EBS → Network-attached block storage within a single AZ

EFS → Regional distributed shared file system

S3 → Highly durable multi-AZ object storage

Selection depends on:

Access pattern

Performance requirement

Sharing requirement

Availability architecture

============================================================
Memory Trick
Block → Attach
File → Mount
Object → API

EBS → EC2 Disk
EFS → Shared Folder
S3 → Internet Storage

