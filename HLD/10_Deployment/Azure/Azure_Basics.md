Azure Cloud Computing
│
├── Part I – Azure Fundamentals
│
├── 1. Introduction to Cloud Computing
│ │
│ ├── Cloud Computing
│ │ → On-demand delivery of IT resources over the internet
│ │ → Pay-as-you-go pricing
│ │ → Eliminates need for physical data centers
│ │
│ ├── Service Models
│ │
│ │ ├── IaaS (Infrastructure as a Service)
│ │ │ → Provides compute, storage, networking
│ │ │ → User manages OS, middleware, runtime, applications
│ │ │ → Examples:
│ │ │ Virtual Machines (VMs)
│ │ │ Azure Disks (Managed)
│ │ │
│ │ ├── PaaS (Platform as a Service)
│ │ │ → Managed platform for app deployment
│ │ │ → Infrastructure and runtime managed by Azure
│ │ │ → Example:
│ │ │ Azure App Service
│ │ │
│ │ └── SaaS (Software as a Service)
│ │ → Fully managed software delivered over internet
│ │ → Users access apps without infrastructure management
│ │ → Examples:
│ │ Microsoft 365
│ │ Power BI
│ │
│ ├── Deployment Models
│ │
│ │ ├── Public Cloud
│ │ │ → Infrastructure shared among multiple customers
│ │ │ → Example: Azure public cloud
│ │ │
│ │ ├── Private Cloud
│ │ │ → Dedicated infrastructure for one organization
│ │ │
│ │ └── Hybrid Cloud
│ │ → Combination of public and on-prem infrastructure
│ │
│ └── Shared Responsibility Model
│
│
├── 2. Azure Global Infrastructure
│
├── Regions
│
│ ├── Why Regions
│ │ → Serve users closer, meet data residency, disaster recovery
│ │
│ ├── Examples:
│ │ East US, West Europe, Southeast Asia
│ │
│ └── Analogy
│ → Like different cities in the cloud
│
├── Availability Zones (AZs)
│
│ ├── Why AZs
│ │ → High availability and fault tolerance
│ │
│ ├── What it Provides
│ │ ├── Isolated datacenter clusters inside a region
│ │ ├── High-speed connectivity between zones
│ │
│ └── Analogy
│ → Multiple safe zones (clusters of buildings) in the same city
│
├── Data Centers (Physical Layer)
│
│ ├── Why Data Centers
│ │ → Provide physical infrastructure for compute, storage, networking
│ │
│ └── Analogy
│ → Individual buildings inside a safe zone (AZ)
│
├── Physical Servers / Machines
│
│ ├── Why Servers
│ │ → Run applications, host VMs, store data
│ │
│ └── Analogy
│ → Rooms inside a building where actual work happens
│
├── Hypervisor
│
│ ├── Why
│ │ → Virtualization layer enabling multiple isolated VMs per server
│
│ └── Analogy
│ → Apartment manager dividing rooms for tenants
│
├── Edge Locations / CDN
│
│ ├── Why
│ │ → Reduce latency, deliver content faster
│ │
│ └── Example
│ → Azure Front Door / Azure CDN
│
├── High Availability Concepts
│
│ ├── Multi-AZ Deployment → Ensure services remain available
│ ├── Fault Tolerance → System continues if AZ fails
│ └── Automatic Failover → Switch to healthy resources
│
└── Final Hierarchy
Region
└── Availability Zones (AZs)
└── Data Centers
└── Physical Servers
└── Hypervisor
└── VMs
|
|
|├── Part II – Networking in Azure
│
├── 3. Virtual Network (VNet)
│
│ ├── Why VNet
│ │ → Isolate resources, control traffic, apply security
│ │
│ ├── Components
│ │ ├── Subnets → Public / Private
│ │ ├── Route Tables → Direct traffic
│ │ ├── Network Security Groups → Instance-level firewall
│ │ ├── Azure Firewall → Centralized firewall
│ │ └── VPN / ExpressRoute → Private connectivity to on-prem
│
│ └── Analogy
│ → Private neighborhood with streets and security gates
│
├── 4. DNS and Traffic Routing
│
│ ├── Azure DNS → Map domain names to IPs
│ ├── Traffic Manager → Route traffic based on performance, failover
│ └── Azure Front Door → Global HTTP/HTTPS routing
│
├── Part III – Compute Services
│
├── 5. Virtual Machines (VMs)
│
│ ├── Why VMs
│ │ → Core compute resource
│ │
│ ├── What it Provides
│ │ ├── CPU, RAM, Storage (Disk Options: Standard SSD, Premium SSD)
│ │ ├── OS images (Windows, Linux)
│ │ └── Configuration & Security (Managed Identities, Extensions)
│
│ └── Analogy
│ → Building blocks of cloud compute
│
├── 6. Load Balancing
│
│ ├── Azure Load Balancer → Layer 4 (TCP/UDP)
│ ├── Application Gateway → Layer 7 (HTTP/HTTPS)
│ ├── Traffic Manager → Global routing
│
├── 7. Auto Scaling (VM Scale Sets)
│
│ ├── Automatically adjusts VM count based on load
│ └── Works with load balancers for high availability
│
├── 8. Serverless Compute
│
│ ├── Azure Functions → Event-driven compute
│ ├── Logic Apps → Workflow automation
│ └── App Service → Managed PaaS hosting
|
| ├── Part IV – Storage Services
│
├── 9. Azure Blob Storage
│
│ ├── Why → Object storage for files, logs, backups, media
│ ├── Tiers → Hot, Cool, Archive
│ └── Analogy → Like S3
│
├── 10. Azure Managed Disks
│
│ ├── Why → Block storage for VMs
│ ├── Use Cases → OS disk, database storage
│ └── Analogy → Like EBS
│
├── 11. Azure Files
│
│ ├── Why → Shared storage for multiple VMs
│ ├── Protocol → SMB / NFS
│ └── Analogy → Like EFS
|
├── Part V – Database Services
│
├── 12. Azure SQL Database
│
│ ├── Managed relational database
│ ├── Supports High Availability / Geo-replication
│
├── 13. Azure Cosmos DB
│
│ ├── NoSQL globally distributed database
│ ├── Supports key-value, document, column, graph models
|
├── Part VI – Identity and Access
│
├── 14. Azure AD
│
│ ├── Users, Groups, Roles → Access control
│ ├── Multi-factor Authentication (MFA)
│ └── Role-based access control (RBAC)
|
├── 15. Management & Security
│
│ ├── Azure Policy → Enforce governance
│ ├── Azure Monitor / Log Analytics → Logging and metrics
│ ├── Azure Security Center → Threat detection
│ ├── Azure Key Vault → Encryption key management
│ └── Azure Bastion → Secure RDP/SSH access without public IP
|
└── Part VII – Admin Connection Flow (SSM Equivalent)
│
Admin/User
(Console / CLI / PowerShell / SDK)
│
▼
Azure Management Plane
(RBAC / Control Plane)
│
▼
VM Agent (on Azure VM)
│
▼
Azure VM (Execution / Session)
│
▼
Output & Logs → Azure Monitor / Storage / Log Analytics
