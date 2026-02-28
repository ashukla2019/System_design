# Azure Complete Architecture, Storage, Networking & Management Notes

---

## Part I – Azure Fundamentals

### 1. Introduction to Cloud Computing
- Cloud Computing: On-demand delivery of IT resources over the internet.
- Service Models:
  - IaaS: Virtual Machines (VMs), Storage, Networking
  - PaaS: App Service, Azure Functions
  - SaaS: Microsoft 365, Dynamics 365
- Deployment Models:
  - Public Cloud: Azure shared infrastructure
  - Private Cloud: Azure Stack, on-premises
  - Hybrid Cloud: Combination of Azure and on-premises
- **Shared Responsibility Model**:
  - Azure: Security *of* cloud (hardware, networking, facilities)
  - Customer: Security *in* cloud (OS, data, IAM, apps)

### 2. Azure Global Infrastructure
- Regions: Geographical locations (e.g., East US, West Europe)
- Availability Zones (AZs): Isolated datacenters inside a region
- Edge Locations: For CDN (Azure CDN)
- High Availability Concepts: Multi-AZ, fault-tolerant design

---

## Part II – Networking in Azure

### 3. Virtual Network (VNet)
- CIDR Blocks: Define network range (e.g., 10.0.0.0/16)
- Subnets: Public vs Private
- Route Tables: Control traffic routing inside VNet
- Internet Gateway equivalent: Public IP + NSG
- NAT Gateway: Outbound internet for private subnets
- Network Security Groups (NSG) vs Azure Firewall:
  - NSG: Subnet/VM-level firewall
  - Azure Firewall: Centralized firewall with advanced features
- VNet Peering: Connects multiple VNets
- Network Watcher & Flow Logs: Monitor traffic

### 4. DNS & Traffic Routing
- Azure DNS: Domain name resolution
- Traffic Manager: Global traffic routing
  - Routing Methods: Priority, Weighted, Performance, Geographic
- Azure Front Door: Global HTTP load balancing, WAF
- Health Probes: Monitor endpoints

---

## Part III – Compute Services

### 5. Virtual Machines (VMs)
- Instance Sizes: General Purpose, Compute Optimized, Memory Optimized
- Images: Marketplace images or custom images
- Managed Disks: OS and Data disks
- Key Pairs / Azure AD login / Managed Identity

### 6. Load Balancing
- Azure Load Balancer (Layer 4): TCP/UDP traffic
- Application Gateway (Layer 7): HTTP/HTTPS, WAF, SSL termination
- Backend Pools & Health Probes

### 7. Auto Scaling
- Virtual Machine Scale Sets (VMSS)
- Scaling Policies: Metric-based, schedule-based
- Integration with Load Balancer/Application Gateway

### 8. Serverless Compute
- Azure Functions: Event-driven compute
- Event Sources: Blob Storage, Event Grid, Service Bus
- Use Cases: Image processing, data transformation

---

## Part IV – Storage Services

### 9. Azure Blob Storage
- Object storage, 99.999999999% durability
- Access Tiers: Hot, Cool, Archive
- Versioning & Lifecycle Management
- Security: Access policies, Azure Storage encryption

### 10. Azure Managed Disks
- Block storage for VMs
- Disk Types: Standard HDD, Standard SSD, Premium SSD, Ultra Disk
- Snapshots & Encryption

### 11. Azure Files
- Fully managed file shares accessible via SMB/NFS
- Performance Tiers: Standard, Premium

| Feature             | Blob Storage           | Managed Disks               | Azure Files                   |
|--------------------|----------------------|----------------------------|--------------------------------|
| Type               | Object               | Block                      | File                          |
| Access             | HTTP/SDK             | VM-attached                | SMB/NFS mount                 |
| Durability         | 99.999999999%        | 99.8–99.9%                 | 99.99%                        |
| Scalability        | Virtually unlimited  | Disk-limited per VM         | Automatic                     |
| Performance        | High throughput, variable latency | Low-latency, high IOPS | Low-latency or high throughput |
| Latency            | Milliseconds         | Single-digit ms            | Single to tens of ms          |
| Encryption         | Azure Storage encryption | Azure Disk Encryption (ADE) | At-rest encryption           |
| Versioning         | Yes                  | Snapshots (point-in-time)  | N/A                           |
| Lifecycle Policies  | Yes (tiering Hot/Cool/Archive) | Manual snapshot lifecycle | N/A                           |
| Use Case           | Backups, archives, static files, big data | OS/DB volumes, low-latency apps | Shared web content, NAS replacement |

---

## Part V – Database Services

### 12. Azure SQL Database
- Managed relational database service
- Single DB, Elastic Pool, or Managed Instance
- Geo-replication & Auto-failover groups
- Backup & Restore

### 13. Azure Cosmos DB
- Globally distributed NoSQL database
- Multi-model (Document, Key-Value, Graph)
- Partition Key & Throughput (RU/s)
- Multi-region replication & consistency levels

---

## Part VI – Identity & Security

### 14. Azure Active Directory (AAD)
- Users, Groups, Roles, Conditional Access Policies
- Best Practices: Least privilege, MFA, Role-based access

### 15. Security Services
- Azure WAF: Web application firewall
- Azure DDoS Protection
- Key Vault: Encryption keys and secrets
- Azure Monitor / Log Analytics: API and activity auditing
- Defender for Cloud: Threat detection

---

## Part VII – VM Management (SSM Equivalent)

- Azure VMs can use **Azure Arc / Run Command / Azure Automation**.
- Managed Identity grants VMs access to Azure resources without credentials.
- Admin executes commands via portal, CLI, or PowerShell.
- No public IP or SSH required for management.
- Logs stored in **Azure Monitor / Log Analytics / Storage Account**.

---

## Part VIII – Detailed 5-Step Azure Architecture Flow

### Stepwise Explanation

- **Step 1: User Traffic Entry & Filtering**  
  - Users/clients initiate requests (web, API, mobile apps).  
  - DNS resolved via **Azure DNS** or **Traffic Manager**.  
  - Traffic passes through **Azure WAF** and **DDoS Protection**.  
  - Requests reach **Application Gateway** for Layer 7 routing and SSL termination.

- **Step 2: VM Request Distribution & Auto Scaling**  
  - Application Gateway forwards requests to VMs in **private subnets**.  
  - **VM Scale Sets (VMSS)** adjust VM count based on load.  
  - VMs launched using **Managed Images**, NSGs, and Managed Identity.

- **Step 3: Admin Access via Run Command / Managed Identity**  
  - Admin sends commands via **Azure Portal CLI / PowerShell / Run Command**.  
  - VM retrieves temporary credentials via **Managed Identity**.  
  - Logs stored in **Azure Monitor / Storage Accounts**.

- **Step 4: VM Storage Interactions**  
  - **Managed Disks:** Block storage attached to VMs, snapshots to Blob.  
  - **Azure Files:** Shared file system for multiple VMs.  
  - **Blob Storage:** Object storage for static content, backups, logs; accessed via SDK/API.

- **Step 5: Monitoring, Logging & Auditing**  
  - **Azure Monitor** collects metrics from VMs, SQL, Application Gateway, and custom apps.  
  - **Log Analytics** receives app/system logs; long-term storage in Blob.  
  - **SQL metrics** monitored (CPU, DTU, IOPS).  
  - **Azure Activity Log** audits admin and API actions.

---

## Part IX – OSI & TCP/IP Models – Networking Notes

### OSI Model (7 Layers)

| Layer | Name | Function | Protocols |
|-------|------|---------|-----------|
| 7 | Application | Services for apps | HTTP, FTP, SMTP, DNS |
| 6 | Presentation | Translation, encryption | SSL/TLS, JPEG |
| 5 | Session | Session management | NetBIOS, RPC |
| 4 | Transport | Reliable/unreliable delivery | TCP, UDP |
| 3 | Network | Logical addressing & routing | IP, ICMP, BGP |
| 2 | Data Link | MAC addressing, switching | Ethernet, VLAN, ARP |
| 1 | Physical | Bits transmission | Ethernet cables, Wi-Fi |

### TCP/IP Model (4 Layers)

| Layer | Maps to OSI | Function | Protocols |
|-------|-------------|---------|-----------|
| Application | 7+6+5 | Services to apps | HTTP, HTTPS, FTP, DNS |
| Transport | 4 | End-to-end delivery | TCP, UDP |
| Internet | 3 | Logical addressing & routing | IP, ICMP |
| Network Access | 2+1 | Physical & MAC addressing | Ethernet, Wi-Fi, PPP |

---

## Part X – OSI & TCP/IP Diagram

```mermaid
flowchart TB
    %% OSI Model
    subgraph OSI["OSI Model (7 Layers)"]
        L7[7: Application] --> L6[6: Presentation]
        L6 --> L5[5: Session]
        L5 --> L4[4: Transport]
        L4 --> L3[3: Network]
        L3 --> L2[2: Data Link]
        L2 --> L1[1: Physical]
    end

    %% TCP/IP Model
    subgraph TCPIP["TCP/IP Model (4 Layers)"]
        App[Application] --> Tran[Transport]
        Tran --> Internet[Internet]
        Internet --> NetAcc[Network Access / Link]
    end

    OSI -. maps to .-> TCPIP
