# Azure Cloud Computing – Structured Notes

## Overview

This document provides a structured overview of Microsoft Azure core services and architecture concepts, organized hierarchically for easier understanding and study.

---

# Azure Cloud Computing Architecture Tree

```
Azure Cloud Computing
│
├── Part I – Azure Fundamentals
│
├── 1. Introduction to Cloud Computing
│   │
│   ├── Cloud Computing
│   │   → On-demand delivery of IT resources over the internet
│   │   → Pay-as-you-go pricing model
│   │   → Eliminates need for physical data centers
│   │
│   ├── Service Models
│   │
│   │   ├── IaaS (Infrastructure as a Service)
│   │   │   → Provides compute, storage, and networking
│   │   │   → User manages OS, middleware, runtime, and applications
│   │   │   → Examples:
│   │   │        Azure Virtual Machines
│   │   │        Azure Managed Disks
│   │   │
│   │   ├── PaaS (Platform as a Service)
│   │   │   → Managed platform for application deployment
│   │   │   → Infrastructure and runtime handled by cloud provider
│   │   │   → Developer focuses on writing code
│   │   │   → Example:
│   │   │        Azure App Service
│   │   │
│   │   └── SaaS (Software as a Service)
│   │       → Fully managed software delivered over internet
│   │       → Users access applications without infrastructure management
│   │       → Examples:
│   │            Microsoft 365
│   │            Power BI
│   │
│   ├── Deployment Models
│   │
│   │   ├── Public Cloud
│   │   │   → Infrastructure owned and operated by cloud provider
│   │   │   → Shared among multiple customers
│   │   │   → Example: Azure public cloud
│   │   │
│   │   ├── Private Cloud
│   │   │   → Dedicated infrastructure for one organization
│   │   │   → Hosted on-premises or private data center (Azure Stack)
│   │   │
│   │   └── Hybrid Cloud
│   │       → Combination of public cloud and private infrastructure
│   │       → Enables data portability and flexible workloads
│   │
│   └── Shared Responsibility Model
│
│       ├── Azure Responsibility (Security OF the Cloud)
│       │   → Physical data centers
│       │   → Hardware infrastructure
│       │   → Networking infrastructure
│       │   → Global infrastructure
│       │
│       └── Customer Responsibility (Security IN the Cloud)
│           → Operating systems
│           → Applications
│           → Data protection
│           → Role-based access and identity management
│
├── Part II – Azure Global Infrastructure
│
├── Regions
│
│   ├── Why Regions
│   │   → Serve users closer to their location (low latency)
│   │   → Meet legal or data residency requirements
│   │   → Provide disaster recovery across countries
│   │
│   ├── What it Provides
│   │   ├── Large geographic locations containing multiple data centers
│   │   ├── Isolation from other regions for fault tolerance
│   │   └── Examples:
│   │       ├── East US → Virginia
│   │       ├── West Europe → Netherlands
│   │       └── Southeast Asia → Singapore
│   │
│   └── Analogy
│       → Like “different cities” in the cloud, each with multiple office buildings (data centers)
│
├── Availability Zones (AZs)
│
│   ├── Why AZs
│   │   → Ensure high availability and fault tolerance within a region
│   │
│   ├── What it Provides
│   │   ├── Independent data centers inside a region
│   │   ├── Connected with low-latency network
│   │   └── Examples:
│   │       ├── East US 2-1
│   │       ├── East US 2-2
│   │       └── East US 2-3
│   │
│   └── Analogy
│       → Like “multiple buildings in the same city” to ensure services keep running if one building fails
│
├── Edge Locations / Azure CDN
│
│   ├── Why
│   │   → Deliver content to users with minimal latency
│   │
│   ├── What it Provides
│   │   ├── Global caching locations for content delivery
│   │   └── Example: Azure CDN
│   │
│   └── Analogy
│       → Like “local pickup stations” near users to deliver files faster
│
├── High Availability Concepts
│
│   ├── Why
│   │   → To ensure systems remain available and fault-tolerant
│   │
│   ├── What it Provides
│   │   ├── Multi-AZ deployment → Applications run across multiple zones
│   │   ├── Fault-tolerant systems → Continue operating even if some components fail
│   │   └── Automatic failover → Switch to healthy resources on failure
│   │
│   └── Analogy
│       → Like having multiple backup offices and automatic rerouting to avoid downtime
│
├── Key Insight
│   → Edge locations = speed to the user
│   → AZs = reliability, redundancy, and actual processing power
│
├── Part III – Networking in Azure
│
├── 3. Virtual Network (VNet)
│
│   ├── Why VNet
│   │   → Isolates cloud resources from other users
│   │   → Provides security control with NSGs, firewalls, and routing rules
│   │   → Ensures only allowed communication between resources
│   │
│   ├── What it Provides
│   │   ├── Address Space → Defines IP ranges (CIDR)
│   │   ├── Subnets → Organize resources within VNet
│   │   │   ├── Public Subnet → Connected to Internet Gateway (via Public IP)
│   │   │   └── Private Subnet → Access via NAT Gateway / VPN
│   │   ├── Route Tables → Controls traffic flow
│   │   ├── Network Security Groups (NSGs) → Instance/subnet-level firewall
│   │   ├── VNet Peering → Connect multiple VNets
│   │   └── Flow Logs → Captures traffic for auditing
│   │
│   └── Analogy
│       → Like your own “private neighborhood” in Azure, with roads, gates, and security rules
│
├── 4. DNS and Traffic Routing
│
│   ├── Why Azure DNS
│   │   → Maps domain names to IP addresses
│   │   → Ensures traffic reaches the right resource reliably
│   │
│   ├── What it Provides
│   │   ├── Azure DNS → Highly available DNS service
│   │   ├── Traffic Manager → Global routing with policies:
│   │   │   ├── Priority routing → Primary resource first
│   │   │   ├── Weighted routing → Distribute traffic
│   │   │   ├── Performance routing → Lowest-latency endpoint
│   │   │   └── Failover routing → Redirect on failure
│   │
│   └── Analogy
│       → Like a “smart traffic controller” that directs visitors to the best available path
│
├── Part IV – Compute Services
│
├── 5. Azure Virtual Machines (VMs)
│
│   ├── Why VMs
│   │   → Core compute resource for running applications
│   │
│   ├── What it Provides
│   │   ├── Virtual machines
│   │   ├── Choice of CPU, memory, storage (VM Sizes)
│   │   ├── OS images
│   │   └── Security & configuration (Managed Identities, Boot Diagnostics)
│   │
│   └── Analogy
│       → Building blocks of cloud compute architecture
│
├── 6. Load Balancing
│
│   ├── Why
│   │   → Distribute traffic efficiently across VMs
│   │
│   ├── What it Provides
│   │   ├── Azure Load Balancer → L4
│   │   ├── Application Gateway → L7, SSL termination
│   │   └── Traffic distribution & high availability
│   │
│   └── Analogy
│       → Traffic managers directing user requests to the right server
│
├── 7. Auto Scaling
│
│   ├── Why
│   │   → Handles dynamic demand by adding/removing VMs automatically
│   │
│   ├── What it Provides
│   │   ├── Scale Sets → Manage VM groups
│   │   ├── Autoscale rules → Based on CPU, memory, or custom metrics
│   │   └── Saves cost during low usage
│   │
│   └── Analogy
│       → Elastic growth/shrink of VM fleet
│
├── 8. Serverless Compute
│
│   ├── Why
│   │   → Event-driven compute; no servers to manage
│   │
│   ├── What it Provides
│   │   ├── Azure Functions → Run code on demand
│   │   ├── Logic Apps → Workflow automation
│   │   └── Integrates with Storage, Event Grid, API Management
│   │
│   └── Analogy
│       → Just run your code, Azure handles everything else
│
├── Part V – Storage Services
│
├── 9. Azure Blob Storage
│
│   ├── Why
│   │   → Store and retrieve files at massive scale from anywhere
│   │
│   ├── Use Cases / When to Use
│   │   ├── Static files, media, documents
│   │   ├── Backups and disaster recovery
│   │   └── Archive / cool storage tiers
│   │
│   ├── Key Features
│   │   ├── Object storage in containers
│   │   ├── Versioning → Maintains object history
│   │   ├── Lifecycle Management → Automatic tiering
│   │   └── Encryption → Managed by Azure Key Vault
│   │
│   └── Analogy
│       → Like a “cloud hard drive for objects” that scales infinitely
│
├── 10. Azure Managed Disks
│
│   ├── Why
│   │   → Persistent block-level storage attached to VMs
│   │
│   ├── Use Cases / When to Use
│   │   ├── OS disks, application files, databases, logs
│   │   ├── Persistent storage → Data remains if VM stops
│   │   └── High-performance workloads → Premium SSD, Ultra Disk
│   │
│   ├── Key Features
│   │   ├── Virtual hard drive for VMs
│   │   ├── Snapshots → Backups stored in Blob storage
│   │   └── Encryption → Azure Key Vault
│   │
│   └── Analogy
│       → Like attaching a hard drive to your cloud server
│
├── 11. Azure Files
│
│   ├── Why
│   │   → Shared network file storage for multiple VMs
│   │
│   ├── Use Cases / When to Use
│   │   ├── Shared files across servers
│   │   ├── Centralized storage → Single source of truth
│   │   ├── Low-latency workloads → Standard / Premium tiers
│   │   └── Big data / analytics → High throughput
│   │
│   ├── Key Features
│   │   ├── SMB/NFS file sharing between VMs
│   │   └── Performance tiers (Standard / Premium)
│   │
│   └── Analogy
│       → Like a “shared network drive” accessible by many servers at once
|
|├── Part VI – Identity & Security
│
├── 12. Azure Active Directory (AAD)
│
│   ├── Why AAD
│   │   → Manage user identities and access to Azure resources
│   │   → Single Sign-On (SSO) for cloud applications
│   │
│   ├── What it Provides
│   │   ├── Users → Individual identities
│   │   ├── Groups → Collection of users
│   │   ├── Roles → Assignable permissions
│   │   └── Policies → Conditional access, MFA, and access reviews
│   │
│   └── Best Practices
│       → Least privilege principle
│       → Enable Multi-Factor Authentication (MFA)
│       → Role-based access control (RBAC)
│
├── 13. Security Services
│
│   ├── Azure Firewall
│   │   → Managed network firewall for traffic filtering
│   │
│   ├── Azure DDoS Protection
│   │   → Protects resources from volumetric and protocol attacks
│   │
│   ├── Azure Key Vault
│   │   → Stores encryption keys, secrets, certificates
│   │
│   ├── Azure Security Center / Microsoft Defender for Cloud
│   │   → Continuous security assessment and threat detection
│   │
│   └── Azure Monitor + Azure Log Analytics
│       → Collects logs and metrics, provides alerting and auditing
│
├── Part VII – VM Communication & Management
│
├── 14. Azure VM Run Command / Automation
│
│   ├── Why
│   │   → Manage VMs without RDP/SSH or public IP
│   │
│   ├── How it Works
│   │   ├── VM runs Azure VM Agent
│   │   ├── Admin sends commands via Azure Portal, CLI, or PowerShell
│   │   ├── Managed Identity attached to VM provides temporary credentials
│   │   └── Logs and outputs stored in Azure Monitor or Blob Storage
│   │
│   └── Analogy
│       → Like controlling your servers remotely through a secure console
│
├── Part VIII – Detailed 5-Step Azure Architecture Flow
│
├── Step 1: User Traffic Entry & Filtering
│
│   ├── Users/Clients
│   │   → Initiate requests via web, API, or mobile apps
│   │
│   ├── DNS Resolution
│   │   → Azure DNS or Traffic Manager resolves domain to Application Gateway / Front Door
│   │
│   ├── Traffic Filtering
│   │   → Azure Web Application Firewall (WAF) and DDoS Protection inspect requests
│   │
│   └── Request Handling
│       → Requests reach Azure Application Gateway / Front Door for L7 routing, SSL termination, and health checks
│
├── Step 2: VM Request Distribution & Auto Scaling
│
│   ├── Load Balancing
│   │   → Application Gateway or Azure Load Balancer forwards requests to VM Scale Sets in private subnets
│   │
│   ├── Auto Scaling
│   │   → Scale Sets adjust VM count automatically based on CPU, memory, or custom metrics
│   │
│   └── VM Deployment
│       → VMs launched using custom images (Managed Disks), NSGs, Managed Identity, and bootstrapping scripts
│
├── Step 3: Admin Access via VM Run Command & Managed Identity
│
│   ├── VM Agent
│   │   → Installed on VMs for management
│   │
│   ├── Admin Commands
│   │   → Sent via Azure Portal, CLI, or PowerShell using Run Command
│   │
│   ├── Credential Handling
│   │   → VM uses Managed Identity to obtain temporary tokens for resource access
│   │
│   └── Logging
│       → Logs and outputs sent to Azure Monitor or Blob Storage
│
├── Step 4: VM Storage Interactions
│
│   ├── Managed Disks
│   │   → Persistent block storage for VMs; snapshots stored in Blob Storage
│   │
│   ├── Azure Files
│   │   → Shared file system mounted on multiple VMs
│   │
│   └── Azure Blob Storage
│       → Object storage for static content, backups, and logs; accessed via SDK/API
│
├── Step 5: Monitoring, Logging & Auditing
│
│   ├── Azure Monitor Metrics
│   │   → Collects VM, SQL Database, Load Balancer, and custom app metrics
│   │
│   ├── Azure Monitor Logs / Log Analytics
│   │   → Receives system and app logs; long-term logs stored in Blob Storage
│   │
│   ├── SQL Database Monitoring
│   │   → Tracks DTU, CPU, connections, and IOPS
│   │
│   └── Azure Activity Logs
│       → Audits admin and API actions across subscriptions and resources

```
