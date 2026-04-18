CONTROL PLANE (Management Layer)

Handles provisioning, configuration, authentication, and orchestration of resources.

```
Launch EC2 instance
Create S3 bucket
Attach IAM role
Configure security groups

Key Services
IAM → authentication & authorization
EC2 → compute provisioning APIs
S3 → storage management APIs


```

DATA PLANE (Execution Layer)

Handles actual workload execution, I/O operations, and runtime traffic.

```
Compute Runtime
EC2 Instance / Azure VM
   │
   ▼
OS Kernel
   │
   ▼
Application Starts

1. Identity Usage (Runtime Auth Bridge)

Application (inside VM / Pod)
   │
   ▼
Requests credentials (HTTP call)
   │
   ▼
Metadata Service (link-local: 169.254.169.254)
   │
   ├── AWS IMDS:
   │     ├── Validates instance + IAM Role attached
   │     ├── Calls STS internally
   │     └── Returns temporary credentials
   │
   └── Azure IMDS:
         ├── Validates Managed Identity
         ├── Calls Entra ID (AAD)
         └── Returns OAuth access token
   │
   ▼
Temporary Credentials Cached in Application/SDK
   │
   ▼
SDK Automatically Signs Requests
   │
   ├── AWS: SigV4 signing
   └── Azure: Bearer Token (Authorization header)
   │
   ▼
Used in downstream API calls (S3 / Blob / DB etc.)

---------------------------

2. Object Storage (S3 / Azure Blob)

Application
   │
   ▼
SDK (adds auth + retry logic)
   │
   ▼
HTTPS Request (over Internet / Private Endpoint)
   │
   ▼
Edge Layer
   │
   ├── AWS: S3 Frontend Fleet
   └── Azure: Blob Frontend
   │
   ▼
Authentication Layer
   │
   ├── AWS:
   │     ├── SigV4 signature verification
   │     └── IAM policy evaluation
   │
   └── Azure:
         ├── Token validation (Entra ID)
         └── RBAC check
   │
   ▼
Request Routing Layer
   │
   ├── Determines partition (bucket/container shard)
   │
   ▼
Storage Nodes (Distributed System)
   │
   ├── Data replicated across multiple AZs
   ├── Metadata stored separately
   │
   ▼
Data Read/Write
   │
   ▼
Response returned via same path

------------------------

3. Block Storage (EBS / Managed Disk)


Application
   │
   ▼
File System (ext4 / NTFS)
   │
   ▼
System Calls (read/write)
   │
   ▼
OS Kernel (I/O Scheduler)
   │
   ▼
Block Device Driver
   │
   ▼
Virtualization Layer
   │
   ├── AWS: Nitro Hypervisor
   └── Azure: Hyper-V
   │
   ▼
Network Storage Protocol (internal, not public)
   │
   ▼
EBS / Managed Disk Service
   │
   ▼
Replicated Storage (within AZ)
   │
   ▼
ACK returned → propagated back to app

-----------------------------
4. File Storage (EFS / Azure Files)

Application
   │
   ▼
POSIX / File API
   │
   ▼
NFS (AWS EFS) / SMB (Azure Files) Client
   │
   ▼
Network (VPC / VNet)
   │
   ▼
EFS / Azure Files Endpoint
   │
   ▼
Distributed File Storage Backend
---------------------------------

5. Remote Management (SSM / VM Agent)

Agent inside VM
   │
   ├── AWS: SSM Agent
   └── Azure: VM Agent
   │
   ▼
Polls service endpoint (pull model)
   │
   ▼
Receives command
   │
   ▼
Executes inside VM
   │
   ▼
Returns output/logs

--------------------------------
6. Logging & Monitoring

Application / OS / Agent
   │
   ▼
Logs & Metrics Generated
   │
   ▼
Ingestion Service
   │
   ├── AWS: CloudWatch
   └── Azure: Azure Monitor / Log Analytics
   │
   ▼
Stored in monitoring backend
   │
   ▼
Queried via Control Plane
(Dashboards / Alerts)
```