# Azure Complete Notes and Architecture Flows

---

## Part I – Azure Fundamentals

### 1. Introduction to Cloud Computing
- Cloud Computing: on-demand delivery of IT resources over the internet.
- Service Models:
  - **IaaS:** Compute, Storage, Network (Virtual Machines, Managed Disks, Virtual Network)
  - **PaaS:** Managed platforms (App Services, Azure Functions)
  - **SaaS:** Software delivered via cloud (Office 365, Power BI)
- Deployment Models:
  - **Public Cloud:** Azure shared infrastructure
  - **Private Cloud:** Azure Stack / on-premises
  - **Hybrid Cloud:** Combination of Azure + on-premises
- **Shared Responsibility Model:**
  - Azure: Security *of* cloud (hardware, networking, facilities)
  - Customer: Security *in* cloud (OS, data, IAM, applications)

### 2. Azure Global Infrastructure
- Regions: Geographical locations (e.g., East US)
- Availability Zones (AZs): Isolated datacenters inside a region
- Edge Locations: For CDN (Azure Front Door / Azure CDN)
- High Availability Concepts: Multi-AZ, fault-tolerant design

---

## Part II – Networking in Azure

### 3. Virtual Network (VNet)
- CIDR Blocks: Define network range (e.g., 10.0.0.0/16)
- Subnets: Public vs Private
- Route Tables: Traffic routing inside VNet
- Internet Connectivity: Azure Internet via default route
- NAT Gateway: Outbound internet for private subnets
- Network Security Groups (NSG) vs Azure Firewall:
  - NSG: Instance/subnet-level firewall
  - Azure Firewall: Network-level firewall
- VNet Peering: Connect multiple VNets
- NSG Flow Logs: Track traffic

### 4. DNS & Traffic Routing
- Azure DNS: Domain name resolution
- Routing Policies: Weighted, Priority-based, Geo-based
- Health Checks: Monitor endpoints via Application Gateway or Traffic Manager

---

## Part III – Compute Services

### 5. Virtual Machines (VMs)
- Instance Types: General Purpose, Compute Optimized, Memory Optimized
- VM Image: Marketplace or custom image
- SSH / Key Vault / Managed Identity
- Custom Script Extension & Bootstrapping

### 6. Load Balancing
- **Application Gateway:** Layer 7, HTTP/HTTPS, WAF integration
- **Azure Load Balancer:** Layer 4, TCP/UDP
- Backend Pools & Health Probes

### 7. Auto Scaling
- **Virtual Machine Scale Sets (VMSS)**
- Scaling Policies: Metric-based or scheduled
- VM Image + Extensions / Bootstrapping Templates

### 8. Serverless Compute
- **Azure Functions:** Event-driven compute
- Event Sources: Blob Storage, Event Hub, Service Bus, HTTP triggers
- Use Cases: Image processing, data transformation

---

## Part IV – Storage Services

### 9. Blob Storage
- Object storage, high durability (RA-GRS, LRS)
- Access tiers: Hot, Cool, Archive
- Versioning & Lifecycle Policies
- Security: Storage Account Keys, SAS, Azure RBAC

### 10. Managed Disks
- Block storage for VMs
- Disk Types: Standard HDD, Standard SSD, Premium SSD, Ultra Disk
- Snapshots & Encryption (Azure Key Vault / SSE)

### 11. Azure Files / NetApp Files
- Shared file storage for multiple VMs
- Mount via SMB/NFS across VMs
- Performance tiers: Standard, Premium

---

## Part V – Database Services

### 12. Azure SQL / Managed Databases
- Engines: SQL Server, PostgreSQL, MySQL
- Zone-redundant or Geo-redundant deployment
- Read Replicas
- Backup & Restore

### 13. Cosmos DB
- NoSQL key-value / document store
- Partition Key
- Provisioned or Serverless throughput
- Global distribution

---

## Part VI – Identity & Security

### 14. Azure Active Directory (AAD)
- Users, Groups, Roles, Policies
- Best Practices: Least privilege, MFA, Role-based access

### 15. Security Services
- **Azure WAF:** Web Application Firewall
- **Azure DDoS Protection**
- **Azure Key Vault:** Encryption keys & secrets
- **Azure Monitor & Log Analytics:** API auditing and monitoring
- **Azure Security Center / Defender:** Threat detection

### Azure Automation / Run Command Communication
- VMs run **Azure VM Agent**
- **Managed Identity** attached to VM allows secure access to Azure services
- Admin sends commands via **Azure Automation / Arc / Run Command**
- No SSH or public IP required
- Logs stored in **Azure Monitor / Blob Storage**
- VMs retrieve temporary credentials via **IMDS (Instance Metadata Service)**

---

## Key Architecture Diagram (Mermaid)

```mermaid
flowchart TD
    %% Step 1: User Traffic Entry
    User[Step 1: User / Client] --> DNS[Step 1: Azure DNS]
    DNS --> WAF[Step 1: Azure WAF + DDoS]
    WAF --> AppGW[Step 1: Application Gateway]

    %% VNet Layer
    subgraph VNet["VNet: 10.0.0.0/16"]
        %% Public Subnets
        subgraph PublicSubnets["Public Subnets"]
            AppGW
            IGW[Internet Gateway]
            AppGW --> IGW
        end

        %% Private App Subnets
        subgraph PrivateAppSubnets["Private App Subnets"]
            VM_1[Step 2: VM AZ1 with Managed Identity]
            VM_2[Step 2: VM AZ2 with Managed Identity]
            NAT[NAT Gateway]
            VM_1 --> NAT
            VM_2 --> NAT
        end

        %% Private DB Subnets
        subgraph PrivateDBSubnets["Private DB Subnets"]
            SQLPrimary[Azure SQL Primary AZ1]
            SQLStandby[Azure SQL Standby AZ2]
            SQLPrimary --> SQLStandby
        end
    end

    %% Managed Identity + IMDS
    ManagedIdentity[Managed Identity] --> IMDS[IMDS]
    IMDS --> VM_1
    IMDS --> VM_2

    %% Step 3: Admin via Automation / Arc / Run Command
    Admin[Step 3: Admin Portal / CLI] -->|Send Command| Automation[Step 3: Azure Automation / Arc]
    Automation -->|Command Delivery| VM_1
    Automation -->|Command Delivery| VM_2

    %% Step 4: Storage Access
    Disk1[Managed Disk AZ1] -->|Attach & Read/Write| VM_1
    Disk2[Managed Disk AZ2] -->|Attach & Read/Write| VM_2

    Files[Azure Files / NetApp] -->|Mount & Read/Write| VM_1
    Files -->|Mount & Read/Write| VM_2

    BlobStorage[Blob Storage - Static / Backups / Logs] -->|Read/Write via SDK/API| VM_1
    BlobStorage -->|Read/Write via SDK/API| VM_2

    VM_1 -->|Send Logs/Output| Monitor[Step 5: Azure Monitor / Log Analytics]
    VM_2 -->|Send Logs/Output| Monitor
    VM_1 -->|Send Logs/Output| BlobStorage
    VM_2 -->|Send Logs/Output| BlobStorage

    %% Step 2: VM Launch Sequence
    ScaleSet[Scale Set / Template] --> VM_1
    ScaleSet --> VM_2
    VM_1 -->|User Data / Bootstrapping| AppStart1[Application Startup]
    VM_2 -->|User Data / Bootstrapping| AppStart2[Application Startup]

    %% Monitoring SQL
    SQLPrimary --> Monitor
