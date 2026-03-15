# ☁️ Azure Complete Architecture Master Notes

### Interactive + Memory-Friendly Guide

This guide explains **how Azure works internally**.

**Goals:**

✔ Understand Azure architecture  
✔ Learn why each service exists  
✔ Build mental models you can remember  
✔ Quickly revise before interviews

---

# 📚 Table of Contents

1. Mental Model of Azure  
2. Azure Global Infrastructure  
3. Datacenter Architecture  
4. Hypervisor & Virtualization  
5. Virtual Network (VNet)  
6. Subnets  
7. Internet Gateway / Public IP  
8. NAT Gateway  
9. Security Layers  
10. Virtual Machines (VMs)  
11. Load Balancer  
12. Scale Sets  
13. Storage Accounts  
14. Identity & Access (Azure AD)  
15. Monitoring (Azure Monitor)  
16. Automation & Management  
17. Service Communication  
18. Private Endpoints  
19. Production Architecture  
20. Data Flow  
21. Control Plane vs Data Plane  

---

# 🧠 Mental Model of Azure

Most internet systems follow this simple architecture:

```text
Internet
   ↓
DNS
   ↓
Load Balancer
   ↓
Application Servers
   ↓
Database / Storage

PART 1 — AZURE GLOBAL INFRASTRUCTURE
Azure Global Network
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

Memory Trick:

Region > AZ > Datacenter > Server
<details> <summary>Why Azure designed it this way</summary>

Traditional hosting problems:

❌ Single datacenter failure
❌ Natural disasters
❌ Limited scalability

Azure solution:

✔ Multiple regions
✔ Multiple AZs
✔ Infrastructure isolation

</details>
🏢 PART 2 — DATACENTER ARCHITECTURE
Rack
 ├── Physical Server
 │    ├── CPU
 │    ├── RAM
 │    ├── SSD / NVMe
 │    └── Network Card

Thousands of racks exist per facility.

⚙️ PART 3 — HYPERVISOR

Azure uses Hyper-V for virtualization.

Physical Server
     │
     ▼
Hypervisor (Hyper-V)
     │
     ▼
Multiple Virtual Machines

Memory Trick:

Server = Building
VMs = Apartments
Hypervisor = Building manager
🌐 PART 4 — VIRTUAL NETWORK (VNet)

Private Azure network.

Azure Region
    │
    ▼
VNet
    │
    ├── Public Subnet
    └── Private Subnet
<details> <summary>Why VNet exists</summary>

Provides private network isolation

Controls IP addressing

Enables routing & firewall rules

</details>
🔀 PART 5 — SUBNETS
VNet
 ├── Public Subnet
 │      ├── Load Balancer
 │      └── Web Servers
 └── Private Subnet
        ├── App Servers
        └── Database

Memory Trick:

Public Subnet → Internet-facing
Private Subnet → Internal servers
🌍 PART 6 — INTERNET GATEWAY / PUBLIC IP
Internet
   │
   ▼
Public IP / Internet Gateway
   │
   ▼
Route Table
   │
   ▼
Public Subnet

Acts as the front door of your VNet.

🔁 PART 7 — NAT GATEWAY
Private VM
     │
     ▼
NAT Gateway
     │
     ▼
Internet

✔ Outbound allowed
❌ Inbound blocked

<details> <summary>Why NAT exists</summary>

Private VMs often need to:

Download updates

Access APIs

Fetch packages

But must not expose themselves publicly

</details>
🔐 PART 8 — SECURITY LAYERS
Layer	Scope
Network Security Group (NSG)	VM / Subnet
Azure Firewall / Route Table	VNet / Subnet
NSG
VM
 │
 ▼
Network Security Group

Stateful firewall

Controls traffic per VM or subnet

Azure Firewall
VNet / Subnet
 │
 ▼
Azure Firewall

Central firewall for VNet traffic

Stateless filtering

🖥 PART 9 — VIRTUAL MACHINES (VMs)

Typical request flow:

User
 │
 ▼
DNS
 │
 ▼
Load Balancer
 │
 ▼
VMs
 │
 ▼
Application
⚖️ PART 10 — LOAD BALANCER
User
 │
 ▼
Azure Load Balancer
 │
 ├─ VM #1
 ├─ VM #2
 └─ VM #3
📈 PART 11 — SCALE SETS

Automatically scale VMs:

High CPU / Traffic
   ↓
Scale Set deploys new VM
💾 PART 12 — STORAGE ACCOUNTS
Storage	Type
Managed Disks	Block storage
Azure Files	File storage
Blob Storage	Object storage
🪣 BLOB STORAGE
Container
 └── Blobs

Used for:

images

videos

backups

logs

🔑 PART 13 — AZURE AD (IDENTITY & ACCESS)
User
 │
 ▼
Azure AD
 │
 ▼
Azure Services

Principle: Least Privilege

📊 PART 14 — AZURE MONITOR
VM Metrics
     │
     ▼
Azure Monitor
     │
     ▼
Alerts / Dashboards
🖥 PART 15 — AUTOMATION & MANAGEMENT
VM
 │
 ▼
Azure Automation / Runbooks
 │
 ▼
Management Tasks

No SSH required

Centralized patching & updates

🔗 PART 16 — SERVICE COMMUNICATION

VM accessing storage:

VM
 │
 ▼
Managed Identity
 │
 ▼
Blob Storage
🔒 PART 17 — PRIVATE ENDPOINTS
VM
 │
 ▼
Private Endpoint
 │
 ▼
Azure Service

Provides private access

No internet exposure

🏗 PART 18 — PRODUCTION ARCHITECTURE
User
 │
 ▼
DNS
 │
 ▼
CDN / Front Door
 │
 ▼
Load Balancer
 │
 ▼
Scale Set VMs
 │
 ▼
Database
🔄 PART 19 — DATA FLOW
User
 ↓
DNS
 ↓
Load Balancer
 ↓
VM / App Server
 ↓
Database
 ↓
Response
⚙️ PART 20 — CONTROL PLANE VS DATA PLANE
User / API
     │
     ▼
CONTROL PLANE
(Resource management)
     │
     ▼
DATA PLANE
(Application traffic)
Control Plane

Manages infrastructure:

Create VM
Create VNet
Create Storage Account
Assign RBAC Policy
Data Plane

Handles real application traffic:

Upload file to Blob Storage
Download file
Send HTTP request to VM
Query SQL Database
Analogy
Restaurant Owner → Control Plane
Customers Eating → Data Plane
🚀 60-Second Revision

Architecture stack:

Region
 ↓
VNet
 ↓
Subnet
 ↓
Load Balancer
 ↓
VM
 ↓
Storage

Security:

Azure AD
NSG
Firewall

Monitoring:

Azure Monitor
🧠 Final Memory Story
User visits website
 → DNS finds server
 → Load Balancer distributes traffic
 → VM runs application
 → Database stores data
