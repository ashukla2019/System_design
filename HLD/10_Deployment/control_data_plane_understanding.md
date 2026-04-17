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
   ├── Compute
   │     ├── AWS: EC2 Control Plane
   │     └── Azure: VM Control Plane
   │
   ├── Object Storage
   │     ├── AWS: S3 Control Plane
   │     └── Azure: Blob Control Plane
   │
   ├── Block Storage
   │     ├── AWS: EBS Control Plane
   │     └── Azure: Managed Disk Control Plane
   │
   ├── File Storage
   │     ├── AWS: EFS Control Plane
   │     └── Azure: Azure Files Control Plane
   │
   ├── Management
   │     ├── AWS: SSM Control Plane
   │     └── Azure: VM Agent / Run Command Control Plane
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