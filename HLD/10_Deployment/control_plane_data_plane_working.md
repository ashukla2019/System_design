# Control Plane vs Data Plane in Cloud (AWS & Azure)

Cloud services operate using two key planes:

- **Control Plane** → Management / orchestration
- **Data Plane** → Execution / traffic / workload

---

## 🔹 Control Plane (Management / Orchestration)

**Purpose:** Configures, monitors, and orchestrates resources.

**What lives here:**
- Regions & Availability Zones
- VPC / VNet, Subnets
- Security Groups / NSGs
- IAM / RBAC Policies
- Provisioning/deprovisioning resources (EC2, VM, RDS, SQL DB)
- Scaling policies, snapshots, backups
- Load balancer routing configuration (not the actual traffic)
- APIs, CLI, management console interactions

**AWS Examples:**
- Creating an EC2 instance → Control Plane
- Launching an EBS volume → Control Plane
- Modifying S3 bucket policy → Control Plane

**Azure Examples:**
- Creating a VM → Control Plane
- Creating a Managed Disk → Control Plane
- Configuring Azure Storage Account → Control Plane

**Key Idea:** “I want a resource to exist or change its configuration.”

---

## 🔹 Data Plane (Actual Usage / Traffic / Data Flow)

**Purpose:** Handles real data, I/O, network traffic, and workload execution.

**What lives here:**
- EC2/VM network traffic (HTTP requests, database queries)
- Read/write operations on EBS / Managed Disk / S3 / Blob / EFS / Azure Files
- Application-level operations inside VMs or containers
- DNS queries, CDN content delivery
- Load balancer actual traffic flow
- Streaming data / API requests to storage

**AWS Examples:**
- EC2 sending/receiving HTTP requests → Data Plane
- EBS volume reads/writes → Data Plane
- S3 GET/PUT operations → Data Plane

**Azure Examples:**
- VM network traffic → Data Plane
- Managed Disk reads/writes → Data Plane
- Blob storage access → Data Plane

**Key Idea:** “I’m using the resource; I’m moving or accessing real data.”

---

## 🔹 Edge Cases / Notes

- **Monitoring & Logging:** CloudWatch / Azure Monitor metrics often come from the Data Plane, but queries/alerts run on Control Plane.  
- **Snapshots / Backups:** Initiating snapshot → Control Plane; actual data copy → Data Plane  
- **Scaling / Auto Scaling:** Configuring policy → Control Plane; actual spin-up/down of VMs → partially Control Plane, partially Data Plane  
- **CDN / Front Door / CloudFront:** Configuring routing → Control Plane; serving content → Data Plane

---

## 🔹 Global Infrastructure Mapping

**Control Plane (management)**
```
Region / Location
│ ├── AWS: us-east-1, eu-west-1
│ └── Azure: East US, West Europe
│
Availability Zone (AZ)
│ └── Cluster of data centers
│
VPC / VNet
│ └── Subnets (Public / Private)
│
IAM / RBAC Policies
│
Resource provisioning & configuration
├── EC2 / VM creation
├── Storage provisioning (EBS / Managed Disk)
├── Load balancer setup
├── Auto scaling policies
└── DNS / Traffic routing rules
```

**Data Plane (execution / I/O)**
```
Actual compute workloads
│ ├── EC2 / VM running applications
│ └── Containers / Functions
│
Storage I/O
│ ├── EBS / Managed Disks
│ ├── S3 / Blob / EFS / Azure Files
│ └── Snapshots, backups in progress
│
Network traffic
│ ├── User requests via Load Balancer / Application Gateway
│ ├── VPC / VNet data flow
│ └── CDN / Front Door content delivery
│
Logs & Monitoring
├── CloudWatch / Azure Monitor
└── Data plane metrics collection
```

---

## 🔹 Compute Example

**AWS:** EC2  
**Azure:** Virtual Machine (VM)

**Control Plane:**
```
User/Admin ──► Launch EC2 / VM
│
▼
Configure instance type, OS, networking, IAM
│
▼
Attach Storage / Security / Scaling Policies
```

**Data Plane:**
EC2 / VM ──► Processes application workload
├── Reads/Writes EBS / Managed Disk
├── Serves HTTP/S requests
└── Logs metrics


---

## 🔹 Storage Example

**AWS:** EBS, S3, EFS  
**Azure:** Managed Disks, Blob, Azure Files

**Control Plane:**
Create volume / disk / bucket / file system
│
Attach to instance / VM
│
Configure access permissions, lifecycle, replication

**Data Plane:**
Application → File System / Object Storage
│
Read / Write operations
│
Replication across AZs / regions
│
Snapshot / Backup in progress


---

## 🔹 Networking Example

**AWS:** VPC, Subnets, IGW, NAT, Security Groups  
**Azure:** VNet, Subnets, Azure Firewall, NSG, VPN/ExpressRoute

**Control Plane:**
Create VPC / VNet
│
Create subnets / route tables
│
Attach Security Groups / NSGs / Firewalls

**Data Plane:**
Instance → Sends/receives network traffic
│
Traffic flows via Load Balancer / NAT / Application Gateway
│
Data plane routing executed


---

## 🔹 Serverless Example

**AWS:** Lambda  
**Azure:** Functions

**Control Plane:**
Deploy function, set triggers, configure permissions


**Data Plane:**

Trigger event occurs
│
Function executes
│
Reads/Writes data to S3 / Blob / Database
│
Logs sent to CloudWatch / Azure Monitor


---

## 🔹 Admin / Remote Management Example

**AWS:** Systems Manager (SSM)  
**Azure:** VM Agent / Azure Bastion / Run Command

**Control Plane:**

Admin/User → AWS Management Console / CLI / SDK
│
Send command / session request
│
Policy / IAM / RBAC validated
│
Command stored in Control Plane


**Data Plane:**

VM Agent on EC2 / Azure VM
│
Pulls command
│
Executes command inside VM
│
Output / logs returned to Management / Monitor


---

## 🔹 Storage Mapping Summary

| Type      | AWS                     | Azure             | Control Plane                         | Data Plane                     |
|-----------|------------------------|-----------------|--------------------------------------|--------------------------------|
| Block     | EBS                     | Managed Disks    | Create, attach, snapshot             | Read/write I/O                 |
| Object    | S3                      | Blob             | Create bucket, configure ACLs        | Upload/download objects        |
| File      | EFS                     | Azure Files      | Create file system, mount targets    | NFS/SMB read/write             |
| Snapshot  | EBS Snapshots           | Managed Disk Snapshots | Initiate snapshot              
