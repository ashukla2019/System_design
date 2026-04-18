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
1. Identity Usage:

IAM Roles and Managed Identities are instance-bound identities that allow workloads to securely access cloud services using temporary credentials instead of hardcoded secrets.”

Application layer → requests credentials via SDK (no auth logic inside app)

Metadata service (IMDS) → provides instance-bound identity

IAM / Entra ID layer → validates identity and issues token/temporary creds

STS / Token service → generates short-lived credentials (AWS creds / Azure OAuth token)

SDK layer → caches credentials + auto-refreshes

Signing layer → AWS SigV4 / Azure Bearer token added to every request

Transport layer → HTTPS call to services using signed identity

2. Object storage:

 
Provide all flows with single line details what layer is doing? 1. Identity Usage (Runtime Auth Bridge)

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
   │  PutObject / GetObject / Upload / Download request
   ▼
SDK (adds auth + retry logic)
   │
   │  - Fetches credentials (IMDS / environment)
   │  - AWS: Signs request using SigV4
   │  - Azure: Adds Bearer token (Authorization header)
   │  - Handles retries (exponential backoff)
   │  - May split large files (multipart upload / chunking)
   ▼
HTTPS Request (over Internet / Private Endpoint)
   │
   │  - DNS resolves endpoint (bucket.s3 / blob.core.windows.net)
   │  - TLS handshake (encryption in transit)
   │  - Routed via Internet OR Private Endpoint (VPC/VNet)
   ▼
Edge Layer
   │
   ├── AWS: Amazon S3 Frontend Fleet
   │       - Load balances incoming requests
   │       - Performs request normalization
   │       - Protects against DDoS (Shield integration)
   │
   └── Azure: Azure Blob Storage Frontend
           - Global entry point
           - Handles throttling + request distribution
   │
   ▼
Authentication Layer
   │
   ├── AWS:
   │     ├── Validates SigV4 signature (request integrity)
   │     ├── Checks timestamp (prevents replay attack)
   │     └── Evaluates IAM policies + bucket policies
   │
   └── Azure:
         ├── Validates OAuth token (Entra ID)
         ├── Checks token expiry & scope
         └── Enforces RBAC / ACL permissions
   │
   ▼
Request Routing Layer
   │
   │  - Parses object key (bucket + path)
   │  - Maps to internal partition (shard)
   │  - Uses consistent hashing / partition map
   │  - May redirect to correct region/partition
   ▼
Metadata Service
   │
   │  - Stores object metadata (size, location, version)
   │  - Resolves which storage nodes hold the data
   ▼
Storage Nodes (Distributed System)
   │
   │  - Object split into chunks/blocks
   │  - Data replicated across multiple AZs
   │  - Metadata stored separately for fast lookup
   │  - Background processes handle rebalancing & healing
   ▼
Data Read/Write
   │
   ├── READ:
   │     - Fetch chunks from storage nodes
   │     - Reassemble object
   │
   └── WRITE:
         - Validate request
         - Store chunks across replicas
         - Ensure durability (multi-AZ)
         - Update metadata
   │
   ▼
Response returned via same path
   │
   │  - Includes status (200 OK / errors)
   │  - May include headers (ETag, version ID)
   │  - Retries handled by SDK if failure
   ▼
Application receives response
   │
   │  - Data returned to caller
   │  - Appears as simple API response

------------------------

3. Block Storage (EBS / Managed Disk)

Application
   │
   │  read()/write() on file (e.g., DB, logs, etc.)
   ▼
File System (ext4 / NTFS)
   │
   │  - Translates file → block mapping (inode / MFT)
   │  - Uses page cache (may serve reads from memory)
   │  - Buffers writes before flushing (write-back cache)
   ▼
System Calls (read/write)
   │
   │  - User space → kernel space transition
   │  - read(), write(), fsync() etc.
   ▼
OS Kernel (I/O Scheduler)
   │
   │  - Queues and reorders I/O requests
   │  - Optimizes for throughput & latency
   │  - Merges adjacent requests (sequential optimization)
   ▼
Block Device Driver
   │
   │  - Converts I/O into block-level operations
   │  - Handles device-specific protocol (virtio / NVMe)
   │  - Maintains request queues
   ▼
Virtualization Layer
   │
   ├── AWS: Nitro Hypervisor
   │       - Offloads I/O to dedicated hardware
   │       - Provides near bare-metal performance
   │
   └── Azure: Hyper-V
           - Manages VM isolation
           - Routes disk I/O to storage backend
   │
   ▼
Network Storage Protocol (internal, not public)
   │
   │  - High-speed internal network (not internet)
   │  - Uses optimized protocols (NVMe-over-network, proprietary)
   │  - Very low latency, high throughput
   ▼
EBS / Managed Disk Service
   │
   ├── AWS: Amazon EBS
   │       - Provides virtual block device
   │       - Handles volume abstraction & scaling
   │
   └── Azure: Azure Managed Disk
           - Abstracts storage as disk resource
           - Integrates with VM lifecycle
   │
   ▼
Storage Layer (Distributed Backend)
   │
   │  - Data split into blocks/chunks
   │  - Replicated across multiple storage nodes
   │  - Maintains durability within AZ
   │  - Background healing if failures occur
   ▼
Replicated Storage (within AZ)
   │
   │  - Synchronous replication (write must hit multiple copies)
   │  - Ensures strong durability guarantees
   ▼
ACK returned → propagated back to app
   │
   │  - Storage confirms write success
   │  - ACK flows back through hypervisor → kernel → filesystem
   │  - fsync() ensures durability before returning
   ▼
Application continues execution
   │
   │  - Appears as fast local disk (but actually network storage)

-----------------------------
4. File Storage (EFS / Azure Files)

Application
   │
   │  read()/write() call (file.txt)
   ▼
POSIX / File API
   │
   │  OS treats it like local filesystem
   │  (open, read, write syscalls)
   ▼
Client Layer
   │
   ├── AWS: NFS Client (EFS)
   │       - Converts syscalls → NFSv4 requests
   │       - Handles retries, buffering, caching
   │
   └── Azure: SMB Client (Azure Files)
           - Converts syscalls → SMB protocol messages
           - Maintains session, locking, state
   │
   ▼
VPC / VNet Network
   │
   │  - DNS resolves file endpoint
   │  - Traffic over private network (no internet)
   │  - TCP connection established (NFS:2049 / SMB:445)
   ▼
Mount Target / File Endpoint
   │
   ├── AWS: Amazon EFS Mount Target (ENI per AZ)
   │       - Entry point inside VPC
   │       - Routes request to storage nodes
   │
   └── Azure: Azure Files Endpoint
           - Frontend service for file share
           - Handles request routing
   │
   ▼
Authentication
   │
   ├── AWS:
   │     - Security Group allows NFS traffic
   │     - (Optional) IAM via Access Points
   │     - POSIX (UID/GID) permission check
   │
   └── Azure:
         - Storage Key OR Entra ID (AD auth)
         - Maps identity → file ACL permissions
   │
   ▼
Distributed File Storage Backend
   │
   │  - File split into chunks/blocks
   │  - Metadata service tracks file structure
   │  - Data replicated across multiple nodes/AZs
   │  - Scales automatically
   ▼
Read / Write Execution
   │
   ├── READ:
   │     - Locate metadata → fetch chunks → assemble
   │
   └── WRITE:
         - Validate → write to replicas → ACK
   │
   ▼
Data served back to client
   │
   │  - Travels back via same network path
   │  - OS may cache data
   ▼
Application receives data
   │
   │  read() returns bytes (appears local)
---------------------------------

5. Remote process:
User / Admin (Console / CLI / SDK)
   │
   │  Sends command (RunCommand / Script / Patch / Session)
   ▼
Control Plane
   │
   ├── AWS: AWS Systems Manager (SSM)
   │       - Stores command + target instances
   │       - Validates IAM permissions
   │
   └── Azure: Azure Virtual Machines Control Plane
           - Stores RunCommand / Extension request
           - Validates RBAC permissions
   │
   ▼
Agent inside VM
   │
   ├── AWS: SSM Agent
   │       - Background service
   │       - Uses IAM Role (via IMDS)
   │
   └── Azure: VM Agent
           - Lightweight agent
           - Uses Managed Identity (via IMDS)
           - Triggers Extensions (plugin-based execution)
   │
   ▼
Polls service endpoint (pull model)
   │
   │  - Outbound HTTPS call (no inbound ports required)
   │  - Periodic / long polling
   │  - Authenticates using:
   │        AWS: IAM Role
   │        Azure: Managed Identity
   ▼
Receives command
   │
   │  - Command payload (script / instructions)
   │  - Metadata (timeout, parameters, execution type)
   │
   ├── AWS:
   │     - Directly handled by SSM Agent
   │
   └── Azure:
         - VM Agent invokes appropriate Extension
         - (Custom Script / RunCommand / DSC)
   │
   ▼
Executes inside VM
   │
   │  - Runs shell / PowerShell
   │  - Executes as root / SYSTEM (default)
   │  - Can access files, services, network
   ▼
Captures output/logs
   │
   │  - stdout / stderr
   │  - Exit status
   ▼
Returns output/logs
   │
   │  - Sent back via HTTPS to control plane
   │
   ├── AWS:
   │     - Stored in SSM
   │     - Optional: S3 / CloudWatch Logs
   │
   └── Azure:
         - Stored in Azure Monitor / Log Analytics
         - Visible in Instance View
   │
   ▼
User retrieves results
   │
   │  - View via Console / CLI / API
   │  - Used for automation / alerting
--------------------------------
6. Logging & monitoring:
Application / OS / Agent
   │
   │  - App logs (stdout, files, structured logs)
   │  - OS logs (syslog, event logs)
   │  - Metrics (CPU, memory, disk, custom metrics)
   ▼
Logs & Metrics Generated
   │
   │  - Logs: unstructured / semi-structured text
   │  - Metrics: time-series data points
   │
   │  - Buffered locally (agent/SDK)
   │  - Batched to reduce network overhead
   ▼
Ingestion Agent / SDK
   │
   ├── AWS:
   │     - CloudWatch Agent / SDK
   │     - Collects logs, system metrics
   │
   └── Azure:
         - Azure Monitor Agent (AMA) / SDK
         - Collects logs, metrics
   │
   ▼
HTTPS Ingestion API
   │
   │  - Secure transmission (TLS)
   │  - Retries on failure (backoff)
   │  - Handles throttling
   ▼
Ingestion Service
   │
   ├── AWS: Amazon CloudWatch
   │       - Receives logs & metrics
   │       - Streams into processing pipeline
   │
   └── Azure: Azure Monitor / Log Analytics
           - Central ingestion point
           - Routes to analytics workspace
   │
   ▼
Processing Pipeline
   │
   │  - Parsing (JSON, text)
   │  - Filtering / enrichment
   │  - Aggregation (metrics rollups)
   │  - Indexing for fast queries
   ▼
Stored in Monitoring Backend
   │
   │  - Logs stored in indexed storage
   │  - Metrics stored as time-series DB
   │  - Retention policies applied
   ▼
Query / Analysis Layer
   │
   │  - AWS: Logs Insights / Metrics Explorer
   │  - Azure: KQL (Log Analytics queries)
   │
   │  - Dashboards, charts, visualization
   ▼
Alerting & Automation
   │
   │  - Threshold / anomaly-based alerts
   │  - Triggers notifications or actions
   │
   ├── AWS:
   │     - CloudWatch Alarms → SNS / Lambda
   │
   └── Azure:
         - Alerts → Action Groups / Logic Apps
   │
   ▼
Queried via Control Plane
   │
   │  - Console / CLI / API access
   │  - Used for monitoring, debugging, autoscaling
   ▼
User / System consumes insights

---------------------------------
✅ 1. Identity Usage (Runtime Auth Bridge)
Application layer → requests credentials via SDK (no auth logic inside app)

Metadata service (IMDS) → provides instance-bound identity

IAM / Entra ID layer → validates identity and issues token/temporary creds

STS / Token service → generates short-lived credentials (AWS creds / Azure OAuth token)

SDK layer → caches credentials + auto-refreshes

Signing layer → AWS SigV4 / Azure Bearer token added to every request

Transport layer → HTTPS call to services using signed identity

--------------------------
✅ 2. Object Storage (S3 / Azure Blob)
Application layer → issues object API calls (PUT/GET)

SDK layer → handles auth, retries, multipart upload/download

Network layer → DNS + TLS + routing via public or private endpoint

Edge/front door layer → request load balancing + throttling + DDoS protection

Auth layer → validates SigV4 / OAuth token + IAM/RBAC policies

Routing layer → maps bucket/object → internal partition/shard

Metadata layer → finds object location + versioning info

Storage backend layer → distributed nodes store chunks across AZs

Replication layer → ensures durability via multi-AZ copies

Response layer → reassembles object and returns via same path

----------------------------------
3. Block Storage (EBS / Azure Managed Disk)

Application layer → performs file/db read-write operations
 
Filesystem layer → converts files → blocks (inode/MFT mapping)

OS kernel layer → handles syscalls + caching + I/O scheduling

Block driver layer → translates requests to disk protocol

Hypervisor layer → virtualization (Nitro / Hyper-V)

Network storage layer → internal low-latency storage network

EBS / Managed Disk service → exposes virtual block device

Storage backend layer → distributed block replication + durability

ACK path → confirmation flows back ensuring fsync durability

------------------------------------
4. File Storage (EFS / Azure Files)
Application layer → POSIX file operations (open/read/write)

Filesystem client layer → NFS (AWS) / SMB (Azure) protocol translation

OS network stack → TCP connection over VPC/VNet

Mount endpoint layer → EFS mount target / Azure file endpoint

Auth layer → IAM / POSIX permissions / Storage keys / Entra ID

Distributed file backend → file split into chunks + metadata tracking

Replication layer → multi-AZ redundant storage

Return path → reassembled file returned to application

--------------------------------
5. Remote process(Remote Process Execution (SSM / RunCommand)
User/CLI layer → sends command (script/run task)

Control plane layer → stores command + validates IAM/RBAC

Agent layer → SSM Agent / VM Agent inside instance

Identity layer → IAM role / Managed Identity via IMDS

Communication model → pull-based polling (no inbound ports)

Execution layer → runs command in OS (shell/PowerShell)

Runtime layer → accesses system resources inside VM

Output layer → logs stdout/stderr + exit status

Telemetry layer → sends results to CloudWatch / Azure Monitor

------------------------------------
6. Logging & Monitoring (CloudWatch / Azure Monitor)
Application/OS layer → generates logs, metrics, traces

Agent layer → CloudWatch Agent / Azure Monitor Agent collects data

Buffering layer → local batching + compression

Ingestion API layer → secure HTTPS ingestion endpoint

Monitoring backend → CloudWatch / Azure Monitor stores data

Processing pipeline → parsing, indexing, aggregation

Query layer → Logs Insights / KQL for analytics

Alerting layer → alarms trigger SNS / Action Groups / Logic Apps

Visualization layer → dashboards + metrics graphs
```