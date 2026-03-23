# Azure Cloud Computing – Structured Notes

## Part I – Azure Fundamentals

### 1. Introduction to Cloud Computing

- **Cloud Computing**
  - On-demand delivery of IT resources over the internet
  - Pay-as-you-go pricing
  - Eliminates need for physical data centers

- **Service Models**
  - **IaaS (Infrastructure as a Service)**
    - Provides compute, storage, networking
    - User manages OS, middleware, runtime, applications
    - Examples: Virtual Machines (VMs), Azure Managed Disks
  - **PaaS (Platform as a Service)**
    - Managed platform for application deployment
    - Infrastructure and runtime handled by Azure
    - Example: Azure App Service
  - **SaaS (Software as a Service)**
    - Fully managed software delivered over the internet
    - Users access apps without infrastructure management
    - Examples: Microsoft 365, Power BI

- **Deployment Models**
  - **Public Cloud:** Shared infrastructure among multiple customers (Azure Public Cloud)
  - **Private Cloud:** Dedicated infrastructure for a single organization
  - **Hybrid Cloud:** Combination of public and on-premises infrastructure

- **Shared Responsibility Model:** Security and management responsibilities shared between Azure and customer

---

## Part II – Azure Global Infrastructure

- **Regions**
  - Provide low-latency access, meet legal/data residency requirements, enable disaster recovery
  - Examples: East US, West Europe, Southeast Asia

- **Availability Zones (AZs)**
  - Physically separate datacenter clusters inside a region
  - Provide high availability, fault tolerance, low-latency connectivity
  - Analogy: Multiple safe zones (clusters of buildings) in a city

- **Data Centers (Physical Layer)**
  - Buildings containing servers, storage, networking
  - Provide physical infrastructure for compute and storage

- **Physical Servers / Machines**
  - Run applications, host VMs, store data
  - Analogy: Rooms inside buildings where work happens

- **Hypervisor**
  - Virtualization layer enabling multiple isolated VMs per server
  - Analogy: Apartment manager dividing rooms for tenants

- **Edge Locations / CDN**
  - Reduce latency, deliver content faster
  - Examples: Azure Front Door, Azure CDN

- **High Availability Concepts**
  - Multi-AZ deployment
  - Fault tolerance
  - Automatic failover

**Hierarchy Overview:**
Region
└── Availability Zones
└── Data Centers
└── Physical Servers
└── Hypervisor
└── Virtual Machines (VMs)


---

## Part III – Networking in Azure

- **Virtual Network (VNet)**
  - Isolates resources, controls traffic, applies security
  - Components: Subnets (Public/Private), Route Tables, NSGs, Azure Firewall, VPN/ExpressRoute

- **DNS and Traffic Routing**
  - Azure DNS → Maps domain names to IPs
  - Traffic Manager → Directs traffic based on performance/failover
  - Azure Front Door → Global HTTP/HTTPS routing

---

## Part IV – Compute Services

- **Virtual Machines (VMs)**
  - CPU, RAM, Storage (Standard SSD, Premium SSD)
  - OS Images: Windows, Linux
  - Managed Identities, Extensions

- **Load Balancing**
  - Azure Load Balancer → Layer 4 (TCP/UDP)
  - Application Gateway → Layer 7 (HTTP/HTTPS)
  - Traffic Manager → Global routing

- **Auto Scaling**
  - VM Scale Sets adjust VM count based on load
  - Works with load balancers for high availability

- **Serverless Compute**
  - Azure Functions → Event-driven compute
  - Logic Apps → Workflow automation
  - App Service → Managed PaaS hosting

---

## Part V – Storage Services

- **Azure Blob Storage**
  - Object storage for files, logs, backups, media
  - Tiers: Hot, Cool, Archive

- **Azure Managed Disks**
  - Block storage for VMs
  - Use cases: OS disks, database storage
  - Analogy: Like AWS EBS

- **Azure Files**
  - Shared storage for multiple VMs
  - Protocols: SMB / NFS
  - Analogy: Like AWS EFS

---

## Part VI – Database Services

- **Azure SQL Database**
  - Managed relational database
  - Supports high availability and geo-replication

- **Azure Cosmos DB**
  - Globally distributed NoSQL database
  - Supports key-value, document, column, graph models

---

## Part VII – Identity and Access

- **Azure AD**
  - Users, Groups, Roles → Access control
  - Multi-factor Authentication (MFA)
  - Role-based Access Control (RBAC)

---

## Part VIII – Management & Security

- **Azure Policy** → Enforce governance
- **Azure Monitor / Log Analytics** → Logging & metrics
- **Azure Security Center** → Threat detection
- **Azure Key Vault** → Encryption key management
- **Azure Bastion** → Secure RDP/SSH access without public IP

---

## Part IX – Admin / User Connection Flow (SSM Equivalent)

**Azure Equivalent of AWS SSM:**  
- Azure VM Agent + Azure Run Command / Azure Automation + Azure Bastion

**Flow:**
'''
Admin/User (Console / CLI / PowerShell / SDK)
│
▼
Azure Management Plane (RBAC / Control Plane)
│
▼
VM Agent (on Azure VM)
│
▼
Azure VM (Execution / Session)
│
▼
Output & Logs → Azure Monitor / Storage / Log Analytics
'''
