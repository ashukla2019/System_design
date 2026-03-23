# AWS Complete Architecture & Communication Guide

This document explains the **complete AWS architecture** including:

* Global infrastructure
* Datacenter architecture
* Hypervisor (Nitro)
* VPC networking
* Internet connectivity
* Security layers
* Compute architecture
* Storage systems
* Monitoring systems
* Service communication
* Control plane vs data plane

Each section explains:

* What it is
* Architecture diagram
* Why it was required

---

# PART 1 — AWS GLOBAL INFRASTRUCTURE

## What it is

AWS infrastructure is globally distributed to provide **high availability, fault tolerance, and scalability**.

```
AWS Global Network
        │
        ▼
Regions
        │
        ▼
Availability Zones
        │
        ▼
Data Centers
        │
        ▼
Physical Servers
        │
        ▼
Hypervisor
        │
        ▼
Virtual Machines (EC2)
```
A hypervisor is the virtualization layer that sits on physical hardware and enables multiple isolated EC2 instances to run on a single server.
## Why it was required

Traditional hosting had problems:

* single datacenter failures
* natural disasters
* scaling limitations

AWS solved this by distributing infrastructure across **regions and availability zones**.

---

# PART 2 — REGIONS AND AVAILABILITY ZONES

## Architecture

```
Region
 ├── AZ1
 │   ├── Data Center
 │   └── Data Center
 │
 ├── AZ2
 │   ├── Data Center
 │   └── Data Center
 │
 └── AZ3
     ├── Data Center
     └── Data Center
```

## Why it was required

If a **datacenter fails**, applications would go down.

Availability Zones allow applications to run across **multiple isolated datacenters**.

Benefits:

* fault tolerance
* disaster recovery
* high availability

---

# PART 3 — PHYSICAL DATA CENTER ARCHITECTURE

Inside AWS datacenters:

```
Rack
 ├── Physical Servers
 │
 ├── CPU
 ├── RAM
 ├── NVMe SSD
 └── Network Interface
```

Thousands of servers are connected with **high-speed internal networking**.

## Why it was required

AWS must support:

* millions of customers
* massive compute workloads
* petabytes of storage

This requires **large-scale optimized infrastructure**.

---

# PART 4 — AWS HYPERVISOR (NITRO SYSTEM)

AWS runs EC2 instances using the **Nitro Hypervisor**.

```
Physical Server
     │
     ▼
Nitro Hypervisor
     │
     ▼
Virtual Machines (EC2)
```

Nitro components:

```
Nitro System
 ├── Nitro Hypervisor
 ├── Nitro Security Chip
 ├── Nitro Card for Networking
 └── Nitro Card for Storage
```

## Why it was required

Without virtualization:

```
Hardware
  ↓
Operating System
  ↓
Application
```

Only **one application per server**.

With hypervisor:

```
Hardware
  ↓
Hypervisor
  ↓
Multiple Virtual Machines
```

Benefits:

* better hardware utilization
* cost efficiency
* isolation

---

# PART 5 — VIRTUAL PRIVATE CLOUD (VPC)

## What it is

A **VPC** is a logically isolated virtual network in AWS.

```
AWS Region
    │
    ▼
VPC (10.0.0.0/16)
    │
    ├── Public Subnet
    └── Private Subnet
```

## Why it was required

Companies need:

* isolated networks
* private IP addressing
* routing control
* firewall rules

VPC allows building **enterprise-like networks in the cloud**.

---

# PART 6 — SUBNET ARCHITECTURE

Subnets divide the VPC network.

```
VPC
 │
 ├── Public Subnet
 │      │
 │      ├── EC2
 │      └── Load Balancer
 │
 └── Private Subnet
        │
        ├── EC2
        └── RDS
```

## Why it was required

Infrastructure layers should be separated.

Example:

Public Layer

* load balancer
* web servers

Private Layer

* application servers
* databases

This improves **security and architecture design**.

---

# PART 7 — INTERNET CONNECTIVITY

Internet connectivity is provided by **Internet Gateway (IGW)**.

```
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Route Table
   │
   ▼
Public Subnet
```

Request flow:

```
User
 ↓
Internet
 ↓
IGW
 ↓
Route Table
 ↓
EC2
```

## Why it was required

Instances must communicate with:

* users
* external APIs
* external systems

IGW enables **public internet access**.

---

# PART 8 — PRIVATE INTERNET ACCESS (NAT GATEWAY)

Private instances cannot be accessed from the internet.

Outbound internet access is enabled using **NAT Gateway**.

```
Private EC2
     │
     ▼
Route Table
     │
     ▼
NAT Gateway
     │
     ▼
Internet Gateway
     │
     ▼
Internet
```

## Why it was required

Private servers often need to:

* download updates
* access APIs
* pull packages

But they should **not accept inbound internet traffic**.

NAT solves this.

---

# PART 9 — SECURITY LAYERS

AWS networking security has two layers.

```
Layer 1 → Security Groups
Layer 2 → Network ACLs
```

---

## Security Groups

```
EC2
 │
 ▼
Security Group
 ├── Inbound Rules
 └── Outbound Rules
```

Characteristics:

* Stateful
* Instance-level firewall

### Why it was required

Applications require **fine-grained security rules**.

Example:

Allow:

* HTTP
* SSH

Block everything else.

---

## Network ACL

```
Subnet
 │
 ▼
Network ACL
```

Characteristics:

* Stateless
* Subnet-level firewall

### Why it was required

Security groups protect **instances**.

NACL protects **entire subnet boundaries**.

This creates **defense in depth**.

---

# PART 10 — EC2 INSTANCE ARCHITECTURE

```
User Request
      │
      ▼
Internet
      │
      ▼
Load Balancer
      │
      ▼
EC2 Instance
      │
      ▼
Application
```

Inside EC2:

```
EC2
 │
 ├── Operating System
 ├── Application
 ├── SSM Agent
 └── Monitoring Agent
```

## Why it was required

Companies need **on-demand compute resources**.

Instead of buying hardware:

* launch VM in minutes
* scale instantly
* pay for usage

---

# PART 11 — AMAZON EBS ARCHITECTURE

Amazon EBS provides **block storage**.

```
EC2
 │
 ▼
AWS Internal Storage Network
 │
 ▼
EBS Storage Cluster
```

Characteristics:

* block device
* low latency
* AZ-scoped

## Why it was required

Applications need **persistent disks**.

Examples:

* operating system disks
* databases
* transactional workloads

---

# PART 12 — AMAZON EFS ARCHITECTURE

Amazon EFS provides **shared file storage**.

```
Multiple EC2
      │
      ▼
NFS Protocol
      │
      ▼
EFS Mount Target
      │
      ▼
EFS Storage Cluster
```

## Why it was required

Some workloads require **shared file systems**.

Examples:

* container clusters
* ML workloads
* shared content platforms

---

# PART 13 — AMAZON S3 ARCHITECTURE

Amazon S3 provides **object storage**.

```
User / EC2
     │
     ▼
S3 API Endpoint
     │
     ▼
S3 Control Plane
     │
     ▼
S3 Storage Nodes
```

Data structure:

```
Bucket
   │
   └── Objects
```

## Why it was required

Block storage cannot scale to billions of files.

S3 provides:

* massive scalability
* durability
* cost-efficient storage

---

# PART 14 — LOAD BALANCER COMMUNICATION

```
User
 │
 ▼
DNS (Route53)
 │
 ▼
Load Balancer
 │
 ▼
Target Group
 │
 ▼
EC2 Instances
```

Types:

```
ALB → HTTP / HTTPS
NLB → TCP / UDP
GWLB → Security appliances
```

## Why it was required

Without load balancing:

* single server overload
* application downtime

Load balancers distribute traffic across servers.

---

# PART 15 — AUTO SCALING

```
CloudWatch Metrics
        │
        ▼
Auto Scaling Policy
        │
        ▼
Launch / Terminate EC2
```

Example:

```
CPU > 70%
   │
   ▼
Launch new EC2
```

## Why it was required

Traffic varies dramatically.

Example:

* product launches
* seasonal traffic

Auto scaling automatically adjusts infrastructure.

---

# PART 16 — IAM AUTHENTICATION FLOW

```
User / Service
      │
      ▼
IAM Policy
      │
      ▼
AWS Service
```

Example:

```
EC2
 │
 ▼
IAM Role
 │
 ▼
S3 Access
```

## Why it was required

Cloud environments require **secure access control**.

IAM provides:

* authentication
* authorization
* least privilege access

---

# PART 17 — SYSTEMS MANAGER (SSM)

```
EC2 Instance
     │
     ▼
SSM Agent
     │
     ▼
SSM Endpoint
     │
     ▼
Systems Manager Service
```

Protocol:

```
HTTPS (443)
```

## Why it was required

Traditional server access used:

* SSH
* RDP

Problems:

* open ports
* security risks
* key management

SSM removes the need for direct access.

---

# PART 18 — CLOUDWATCH MONITORING

```
EC2 Instance
      │
      ▼
CloudWatch Agent
      │
      ▼
CloudWatch Service
      │
      ▼
Metrics / Logs
      │
      ▼
Alarms
```

## Why it was required

Production systems require monitoring of:

* CPU usage
* memory usage
* logs
* failures

CloudWatch centralizes monitoring.

---

# PART 19 — SERVICE COMMUNICATION

Example: EC2 accessing S3.

```
EC2
 │
 ▼
IAM Role
 │
 ▼
Network Path
 │
 ▼
S3 Service
```

## Why it was required

AWS services must communicate securely using:

* authentication
* authorization
* controlled networking

---

# PART 20 — VPC ENDPOINT

Private service access:

```
EC2
 │
 ▼
VPC Endpoint
 │
 ▼
AWS Service
```

Without endpoint:

```
EC2 → Internet → AWS Service
```

With endpoint:

```
EC2 → AWS Private Network → AWS Service
```

## Why it was required

Benefits:

* better security
* reduced latency
* no internet exposure

---

# PART 21 — COMPLETE APPLICATION ARCHITECTURE

Typical production architecture:

```
User
 │
 ▼
Route53
 │
 ▼
CloudFront
 │
 ▼
Load Balancer
 │
 ▼
EC2 Auto Scaling
 │
 ▼
RDS Database
 │
 ▼
EBS Storage
```

## Why it was required

Modern applications require:

* global distribution
* high availability
* scalability

---

# PART 22 — DATA FLOW SUMMARY

```
User
 │
 ▼
DNS
 │
 ▼
Load Balancer
 │
 ▼
Application Servers
 │
 ▼
Database / Storage
```

This represents the **typical request lifecycle**.

---

# PART 23 — CONTROL PLANE VS DATA PLANE

## Control Plane

Infrastructure management operations.

Examples:

```
Create EC2
Create VPC
Create S3 Bucket
```

API examples:

```
RunInstances
CreateBucket
```

---

## Data Plane

Operations interacting with data.

Examples:

```
Upload file
Download file
Send request
```

API examples:

```
GET Object
PUT Object
```

## Why it was required

Separating planes improves:

* reliability
* scalability
* security

Control plane failures do **not impact running workloads**.

---

# END OF DOCUMENT
