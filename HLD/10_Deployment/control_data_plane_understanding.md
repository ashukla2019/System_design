CONTROL PLANE (Management Layer)

Handles provisioning, configuration, authentication, and orchestration of resources.

```
User / Admin
   │
   ▼
Console / CLI / SDK
   │
   ▼
Identity & Access Layer
   │
   ├── AWS: IAM (Users / Roles / Policies)
   └── Azure: RBAC + Managed Identity
   │
   ▼
Authentication & Authorization
   │
   ├── AWS:
   │     ├── IAM validates permissions
   │     └── STS issues temporary credentials
   │
   └── Azure:
         ├── Entra ID validates identity
         └── Issues OAuth token (Managed Identity)
   │
   ▼
Service Control Planes
   │
    │
├── Compute
│     ├── AWS: EC2 Control Plane
│     │       → Create / terminate / start / stop instances
│     │       → Select instance type, AMI, networking
│     │       → Allocate physical host & capacity
│     │       → Attach IAM role, EBS volumes
│     │       → Orchestrate VM provisioning via hypervisor
│     │
│     └── Azure: VM Control Plane
│             → Create / delete / start / stop VMs
│             → Select VM size, image, VNet, subnet
│             → Assign Managed Identity
│             → Attach Managed Disks & NICs
│             → Orchestrate VM provisioning via fabric controller
│
├── Object Storage
│     ├── AWS: S3 Control Plane
│     │       → Create / delete buckets
│     │       → Manage bucket policies & ACLs
│     │       → Configure versioning & lifecycle rules
│     │       → Setup replication (CRR/SRR)
│     │       → Maintain object metadata (index, not actual data)
│     │
│     └── Azure: Blob Control Plane
│             → Create / delete storage accounts & containers
│             → Manage RBAC & access policies
│             → Configure lifecycle management
│             → Setup replication (LRS/GRS/ZRS)
│             → Maintain blob metadata
│
├── Block Storage
│     ├── AWS: EBS Control Plane
│     │       → Create / delete volumes
│     │       → Attach / detach volumes to EC2
│     │       → Resize volumes
│     │       → Manage snapshots & backups
│     │       → Configure encryption (KMS)
│     │
│     └── Azure: Managed Disk Control Plane
│             → Create / delete disks
│             → Attach / detach disks to VM
│             → Resize disks
│             → Snapshot & image management
│             → Configure encryption
│
├── File Storage
│     ├── AWS: EFS Control Plane
│     │       → Create / delete file systems
│     │       → Configure mount targets in subnets
│     │       → Manage access policies (NFS permissions)
│     │       → Set performance & throughput modes
│     │
│     └── Azure: Azure Files Control Plane
│             → Create / delete file shares
│             → Configure storage account & endpoints
│             → Manage access via RBAC / keys
│             → Set tiers (hot/cool)
│
├── Management
│     ├── AWS: SSM Control Plane
│     │       → Send commands to instances
│     │       → Patch management & automation
│     │       → Maintain inventory & state
│     │       → Session Manager (no SSH)
│     │
│     └── Azure: VM Agent / Run Command Control Plane
│             → Send commands to VM via agent
│             → Run scripts remotely
│             → Patch & configuration management
│             → Collect VM state & extensions
│
   ▼
Resource Configuration
   │
   ├── VM created with:
   │     ├── IAM Role (AWS)
   │     └── Managed Identity (Azure)
   │
   ├── Storage attached (EBS / Managed Disk)
   ├── File system mounted (EFS / Azure Files)
   └── Object storage permissions configured
   │
   ▼
Placement Decision
(AZ / Host / Cluster selection)

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
Application
   │
   ▼
Metadata Service
   │
   ├── AWS: IMDS (Instance Metadata Service)
   └── Azure: IMDS (Managed Identity endpoint)
   │
   ▼
Temporary Credentials / Token
   │
   ├── AWS: STS credentials
   │     (Access Key / Secret / Token)
   │
   └── Azure: OAuth Token (Entra ID)
   │
   ▼
Used in downstream service calls


2. Object Storage (S3 / Azure Blob)

Application
   │
   ▼
SDK / REST API
   │
   ▼
HTTPS Request
   │
   ▼
Auth Validation
   │
   ├── AWS:
   │     ├── SigV4 signature validation
   │     └── IAM policy enforcement
   │
   └── Azure:
         ├── Token validation (Entra ID)
         └── RBAC enforcement
   │
   ▼
Object Storage Endpoint
   │
   ▼
Distributed Storage Backend (Multi-AZ)
   │
   ▼
Object Data Returned

3. Block Storage (EBS / Managed Disk)

Application
   │
   ▼
File System (ext4 / NTFS)
   │
   ▼
OS Kernel (read/write syscalls)
   │
   ▼
Block Device Driver
   │
   ▼
Hypervisor / Virtual Storage Layer
   │
   ▼
EBS / Managed Disk Service
   │
   ▼
Physical Storage (replicated within AZ)


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