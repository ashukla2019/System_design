# AWS Architecture Flow (Step-by-Step Mental Model)

## Goal

Before learning AWS services, understand one thing:

> AWS is just a collection of physical computers, networking, security, storage, and managed services organized in layers.

Every AWS architecture follows the same flow:

```text
Physical Servers
    ↓
Availability Zones
    ↓
Region
    ↓
VPC
    ↓
Subnets
    ↓
Route Tables
    ↓
Internet Gateway / NAT Gateway
    ↓
Security (NACL + Security Groups)
    ↓
Compute (EC2 / ECS / EKS / Lambda)
    ↓
Database (RDS / DynamoDB)
    ↓
Storage (S3)
    ↓
Monitoring / Security / Management Services
```

---

# Step 1: Physical Infrastructure

## Problem

Applications need CPU, Memory, Disk, and Networking.

Someone must provide actual hardware.

## Solution

AWS owns millions of physical servers in data centers.

```text
Physical Server
├── CPU
├── RAM
├── Disk
└── Network
```

However, giving one server to one customer would waste resources.

So AWS virtualizes servers.

```text
Physical Server
       ↓
Hypervisor
       ↓
Virtual Machines
```

This leads to the next layer.

---

# Step 2: Availability Zone (AZ)

## Problem

What happens if a data center loses power?

Application becomes unavailable.

## Solution

AWS groups multiple data centers into an Availability Zone.

```text
Availability Zone (AZ)

├── Data Center 1
├── Data Center 2
└── Data Center 3
```

Each AZ is isolated from others.

If one AZ fails, another AZ can continue serving traffic.

```text
Application

├── AZ-A
└── AZ-B
```

This provides high availability.

---

# Step 3: Region

## Problem

Applications must be deployed in a geographic location.

Users in India should not always use servers in America.

## Solution

AWS creates Regions.

A Region contains multiple Availability Zones.

```text
Mumbai Region

├── AZ-A
├── AZ-B
└── AZ-C
```

Examples:

* Mumbai
* Singapore
* Frankfurt
* Virginia

Everything you create belongs to a Region.

---

# Step 4: VPC (Virtual Private Cloud)

## Problem

Thousands of customers share the same AWS infrastructure.

How do we isolate one customer's network from another?

## Solution

AWS provides a private virtual network called VPC.

```text
Region
   ↓
VPC
```

Example:

```text
VPC
CIDR: 10.0.0.0/16
```

Think of a VPC as:

```text
AWS Account
      ↓
Private Company Network
```

Everything inside the VPC can communicate privately.

---

# Step 5: Subnets

## Problem

Not all resources should be exposed to the internet.

Example:

```text
Web Server      → Public
Database        → Private
```

## Solution

Divide the VPC into smaller networks.

These are called subnets.

```text
VPC

├── Public Subnet
└── Private Subnet
```

Example:

```text
VPC (10.0.0.0/16)

├── Public Subnet
│     10.0.1.0/24
│
└── Private Subnet
      10.0.2.0/24
```

### Public Subnet

Used for:

* Load Balancer
* Bastion Host
* Public Web Servers

### Private Subnet

Used for:

* Databases
* Redis
* Internal APIs
* Backend Services

---

# Step 6: Route Tables

## Problem

Resources exist inside subnets.

How do packets know where to go?

## Solution

Route Tables.

```text
Subnet
   ↓
Route Table
```

Example:

```text
Destination      Target

10.0.0.0/16      Local
0.0.0.0/0        IGW
```

Meaning:

```text
VPC Traffic
      ↓
Local

Internet Traffic
      ↓
Internet Gateway
```

Routes determine network paths.

---

# Step 7: Internet Gateway (IGW)

## Problem

A web server exists in a public subnet.

But nobody on the internet can reach it.

## Solution

Attach an Internet Gateway.

```text
Internet
     ↑
IGW
     ↑
Public Subnet
```

Traffic Flow:

```text
User
 ↓
Internet
 ↓
Internet Gateway
 ↓
Web Server
```

Now the server becomes publicly accessible.

---

# Step 8: NAT Gateway

## Problem

Private resources should not be exposed publicly.

However, they still need internet access.

Example:

* OS updates
* Package downloads
* Docker image pulls

## Solution

Use NAT Gateway.

```text
Private EC2
      ↓
NAT Gateway
      ↓
Internet
```

Behavior:

```text
Outbound Access → Allowed
Inbound Access → Blocked
```

Internet cannot directly access the private server.

---

# Step 9: Security Layer

AWS provides two major security controls.

```text
NACL
Security Group
```

---

## Network ACL (NACL)

### Purpose

Protect subnet traffic.

### Applied To

```text
Subnet Level
```

### Characteristics

```text
Stateless
Allow Rules
Deny Rules
```

Example:

```text
Allow 80
Allow 443
Deny 22
```

---

## Security Group

### Purpose

Protect individual resources.

### Applied To

```text
EC2
RDS
EKS Nodes
```

### Characteristics

```text
Stateful
Allow Only
No Deny Rules
```

Example:

```text
Allow 80
Allow 443
Allow 22
```

Return traffic is automatically allowed.

---

## Security Flow

```text
Internet
   ↓
NACL
   ↓
Subnet
   ↓
Security Group
   ↓
Resource
```

Both layers must allow traffic.

---

# Step 10: Compute Layer

Now we can run applications.

---

## EC2

Virtual Machine.

```text
EC2
├── CPU
├── RAM
└── Storage
```

Used for:

* Java Applications
* Python Applications
* NodeJS Applications
* Web Servers

---

## ECS

Container Service.

```text
Container
     ↓
ECS
```

AWS manages container scheduling.

---

## EKS

Managed Kubernetes.

```text
Pods
 ↓
Nodes
 ↓
EKS Cluster
```

Used for large microservice architectures.

---

## Lambda

Serverless Compute.

```text
Upload Code
      ↓
AWS Executes It
```

No server management required.

---

# Step 11: Database Layer

## Problem

Applications need persistent data storage.

## Solution

Use databases.

### RDS

Managed relational database.

Examples:

* MySQL
* PostgreSQL
* SQL Server

```text
Application
      ↓
RDS
```

Usually deployed in private subnets.

---

## DynamoDB

Managed NoSQL database.

```text
Application
      ↓
DynamoDB
```

Fully managed by AWS.

---

# Step 12: Storage Layer

## Problem

Applications need file storage.

Examples:

* Images
* Videos
* Documents
* Backups
* Logs

## Solution

Amazon S3.

```text
Application
      ↓
S3 API
      ↓
Bucket
```

Important:

```text
S3 does NOT run inside your subnet.
```

AWS manages it completely.

---

# Step 13: Identity & Permissions

## Problem

Not every user or service should have full access.

## Solution

IAM.

```text
User
    ↓
IAM Policy
    ↓
AWS Resource
```

Examples:

* EC2 can read S3
* Lambda can write DynamoDB
* Developers can access only specific resources

---

# Step 14: Monitoring

## Problem

How do we know if something fails?

## Solution

CloudWatch.

```text
Application
      ↓
Metrics
      ↓
CloudWatch
      ↓
Alerts
```

Examples:

* CPU Usage
* Memory Metrics
* Error Rates
* Logs

---

# Step 15: DNS Layer

## Problem

Users remember names, not IP addresses.

## Solution

Route 53.

```text
www.example.com
        ↓
Route53
        ↓
Load Balancer
```

DNS converts names to IP addresses.

---

# Step 16: Typical Production Architecture

```text
User
 ↓
Route53 (DNS)
 ↓
Load Balancer
 ↓
Public Subnet
 ↓
EC2 / ECS / EKS
 ↓
Private Subnet
 ↓
RDS
```

Supporting Services:

```text
IAM
CloudWatch
S3
Lambda
Secrets Manager
KMS
```

---

# Final AWS Mental Model

```text
Physical Servers
      ↓
Availability Zones
      ↓
Region
      ↓
VPC
      ↓
Public / Private Subnets
      ↓
Route Tables
      ↓
Internet Gateway / NAT Gateway
      ↓
NACL
      ↓
Security Groups
      ↓
EC2 / ECS / EKS / Lambda
      ↓
RDS / DynamoDB
      ↓
S3
      ↓
CloudWatch / IAM / Route53
```

## One-Line Summary

AWS provides physical infrastructure inside Regions and Availability Zones. Customers create a VPC for network isolation, divide it into public and private subnets, control connectivity using Route Tables, Internet Gateways, and NAT Gateways, secure traffic using NACLs and Security Groups, run applications on EC2/ECS/EKS/Lambda, store data in RDS/DynamoDB/S3, manage access with IAM, and monitor everything using CloudWatch.
