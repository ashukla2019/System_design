# ☁️ AWS Complete Architecture Master Notes

### Interactive + Memory-Friendly Guide

This guide explains how cloud architecture works inside **Amazon Web Services**.

Goals:

✔ Understand **how AWS works internally**
✔ Learn **why each service exists**
✔ Build **easy mental models**
✔ Quickly revise before interviews

---

# 📚 Table of Contents

1. Mental Model of AWS
2. AWS Global Infrastructure
3. Datacenter Architecture
4. Hypervisor (Nitro System)
5. Virtual Private Cloud
6. Subnets
7. Internet Gateway
8. NAT Gateway
9. Security Layers
10. EC2 Compute
11. Load Balancer
12. Auto Scaling
13. Storage Systems
14. IAM
15. Monitoring (CloudWatch)
16. Systems Manager
17. Service Communication
18. VPC Endpoints
19. Production Architecture
20. Data Flow
21. Control Plane vs Data Plane

---

# 🧠 Mental Model of AWS

Most internet systems follow this architecture:

```
Internet
   ↓
DNS
   ↓
Load Balancer
   ↓
Application Servers
   ↓
Database / Storage
```

Most AWS services exist to support **this flow**.

---

# 🌍 PART 1 — AWS GLOBAL INFRASTRUCTURE

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
```

### Why AWS built it this way

<details>
<summary>Show explanation</summary>

Problems with traditional hosting:

❌ single datacenter failure
❌ natural disasters
❌ limited scalability

AWS solution:

✔ multiple regions
✔ multiple AZs
✔ infrastructure isolation

</details>

---

### Memory Trick

```
Region > AZ > Datacenter > Server
```

---

# 🏢 PART 2 — DATACENTER ARCHITECTURE

Inside AWS datacenters:

```
Rack
 ├── Physical Server
 │
 ├── CPU
 ├── RAM
 ├── NVMe SSD
 └── Network Card
```

Thousands of racks exist in a facility.

---

# ⚙️ PART 3 — HYPERVISOR (NITRO)

Virtualization layer:

```
Physical Server
     │
     ▼
Hypervisor
     │
     ▼
Multiple Virtual Machines
```

### Memory Trick

```
Server = Building
VMs = Apartments
Hypervisor = Building manager
```

---

# 🌐 PART 4 — VIRTUAL PRIVATE CLOUD (VPC)

Your private AWS network.

```
AWS Region
    │
    ▼
VPC
    │
    ├── Public Subnet
    └── Private Subnet
```

---

# 🔀 PART 5 — SUBNETS

Subnets divide a VPC.

```
VPC
 │
 ├── Public Subnet
 │      ├── Load Balancer
 │      └── Web Servers
 │
 └── Private Subnet
        ├── App Servers
        └── Database
```

---

# 🌍 PART 6 — INTERNET GATEWAY

Connects VPC to the internet.

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

Think of it as the **front door of your VPC**.

---

# 🔁 PART 7 — NAT GATEWAY

Allows private servers to access the internet securely.

```
Private EC2
     │
     ▼
NAT Gateway
     │
     ▼
Internet
```

✔ outbound traffic allowed
❌ inbound traffic blocked

---

# 🔐 PART 8 — SECURITY LAYERS

Two main network security layers.

| Layer          | Scope    |
| -------------- | -------- |
| Security Group | Instance |
| Network ACL    | Subnet   |

---

### Security Group

```
EC2
 │
 ▼
Security Group
```

Stateful firewall.

---

### Network ACL

```
Subnet
 │
 ▼
Network ACL
```

Stateless firewall.

---

# 🖥 PART 9 — EC2 COMPUTE

Typical request flow.

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
EC2 Instances
 │
 ▼
Application
```

---

# ⚖️ PART 10 — LOAD BALANCER

Distributes traffic.

```
User
 │
 ▼
Load Balancer
 │
 ├─ EC2 #1
 ├─ EC2 #2
 └─ EC2 #3
```

---

# 📈 PART 11 — AUTO SCALING

Automatically launches servers.

```
High CPU
   ↓
Launch new EC2
```

---

# 💾 PART 12 — STORAGE TYPES

Three primary AWS storage systems.

| Storage | Type           |
| ------- | -------------- |
| EBS     | Block storage  |
| EFS     | File storage   |
| S3      | Object storage |

---

# 🪣 S3 OBJECT STORAGE

```
Bucket
 └── Objects
```

Used for:

* images
* videos
* backups
* logs

---

# 🔑 PART 13 — IAM (Identity & Access)

Controls permissions.

```
User
 │
 ▼
IAM Policy
 │
 ▼
AWS Service
```

Security principle:

**Least Privilege**

---

# 📊 PART 14 — CLOUDWATCH

Monitoring system.

```
Server Metrics
     │
     ▼
CloudWatch
     │
     ▼
Alarms
```

Monitors:

* CPU
* memory
* logs

---

# 🖥 PART 15 — SYSTEMS MANAGER

Server management without SSH.

```
EC2
 │
 ▼
SSM Agent
 │
 ▼
Systems Manager
```

---

# 🔗 PART 16 — SERVICE COMMUNICATION

Example: EC2 accessing storage.

```
EC2
 │
 ▼
IAM Role
 │
 ▼
S3
```

---

# 🔒 PART 17 — VPC ENDPOINTS

Private access to AWS services.

```
EC2
 │
 ▼
VPC Endpoint
 │
 ▼
AWS Service
```

No internet required.

---

# 🏗 PART 18 — PRODUCTION ARCHITECTURE

Typical production system.

```
User
 │
 ▼
DNS
 │
 ▼
CDN
 │
 ▼
Load Balancer
 │
 ▼
Auto Scaling EC2
 │
 ▼
Database
```

---

# 🔄 PART 19 — DATA FLOW

Application request lifecycle.

```
User
 ↓
DNS
 ↓
Load Balancer
 ↓
Application Server
 ↓
Database
 ↓
Response
```

---

# ⚙️ PART 20 — CONTROL PLANE VS DATA PLANE

AWS services operate using **two layers**.

```
User / API
     │
     ▼
CONTROL PLANE
(Resource management)
     │
     ▼
DATA PLANE
(Application traffic)
```

---

## Control Plane

Manages infrastructure.

Examples:

```
Create EC2 instance
Create VPC
Create S3 bucket
Attach IAM policy
```

These operations **configure infrastructure**.

---

## Data Plane

Handles real application traffic.

Examples:

```
Upload file to S3
Download file
Send HTTP request to EC2
Query database
```

These operations **handle user workloads**.

---

### Simple Analogy

```
Restaurant Owner → Control Plane
Customers Eating → Data Plane
```

Infrastructure vs real usage.

---

# 🚀 60-Second Revision

Architecture stack:

```
Region
 ↓
VPC
 ↓
Subnet
 ↓
Load Balancer
 ↓
EC2
 ↓
Storage
```

Security:

```
IAM
Security Groups
Network ACL
```

Monitoring:

```
CloudWatch
```

---

# 🧠 Final Memory Story

```
User visits website
 → DNS finds server
 → Load balancer distributes traffic
 → EC2 runs application
 → Database stores data
```

That explains **most cloud architectures**.
