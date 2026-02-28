# Azure Complete Architecture – Notes & Diagram

---

## Detailed Notes – 5-Step Architecture Flow

- **Step 1: User Traffic Entry & Filtering**  
  - Users/clients initiate requests (web, API, mobile apps).  
  - **Azure DNS** resolves the domain to Application Gateway.  
  - Traffic passes through **Azure WAF** (blocks attacks) and **Azure DDoS Protection**.  
  - Requests reach **Application Gateway** for Layer 7 routing, SSL termination, and health checks.

- **Step 2: VM Request Distribution & Auto Scaling**  
  - Application Gateway forwards requests to **VMs** in private subnets.  
  - **Scale Sets** adjust the number of VMs based on load.  
  - VMs launched with **VM Image**, **Network Security Groups**, **Managed Identity**, and startup scripts.

- **Step 3: Admin Access via Azure Automation / Run Command & Managed Identity**  
  - VMs register with **Azure Arc / Azure Automation** for remote management.  
  - Admin sends commands via portal/CLI; no public SSH needed.  
  - VMs use **Managed Identity + IMDS** for temporary credentials to access Azure resources.  
  - Logs sent to **Azure Monitor / Log Analytics** or **Blob Storage**.

- **Step 4: VM Storage Interactions**  
  - **Managed Disks:** Block storage attached to VM for OS/app data; snapshots go to Blob Storage.  
  - **Azure Files / NetApp Files:** Shared file system mounted across VMs.  
  - **Blob Storage:** Object storage for static content, backups, and logs; accessed via SDK/API.

- **Step 5: Monitoring, Logging & Auditing**  
  - **Azure Monitor** collects metrics from VMs, SQL, Application Gateway, and custom apps.  
  - **Log Analytics** receives system/application logs; Blob Storage stores long-term logs.  
  - Managed SQL metrics monitored (CPU, connections, IOPS, failovers).  
  - **Azure Activity Log** audits admin/API actions for security and compliance.

---

## Architecture Diagram (Mermaid)

```mermaid
flowchart TD
    %% Step 1: User Traffic Entry
    User(User / Client - Step 1) --> DNS(Azure DNS)
    DNS --> WAF(Azure WAF + DDoS)
    WAF --> AppGW(Application Gateway)

    %% VNet Layer
    subgraph VNet["VNet: 10.0.0.0/16"]
        %% Public Subnets
        subgraph PublicSubnets["Public Subnets"]
            AppGW
            IGW(Internet Gateway)
            AppGW --> IGW
        end

        %% Private App Subnets
        subgraph PrivateAppSubnets["Private App Subnets"]
            VM_1(VM AZ1 with Managed Identity - Step 2)
            VM_2(VM AZ2 with Managed Identity - Step 2)
            NAT(NAT Gateway)
            VM_1 --> NAT
            VM_2 --> NAT
        end

        %% Private DB Subnets
        subgraph PrivateDBSubnets["Private DB Subnets"]
            SQLPrimary(Azure SQL Primary AZ1)
            SQLStandby(Azure SQL Standby AZ2)
            SQLPrimary --> SQLStandby
        end
    end

    %% Managed Identity + IMDS
    ManagedIdentity(Managed Identity) --> IMDS(IMDS)
    IMDS --> VM_1
    IMDS --> VM_2

    %% Step 3: Admin via Azure Automation / Run Command
    Admin(Admin Portal / CLI - Step 3) -->|Send Command| Automation(Azure Automation / Arc)
    Automation -->|Command Delivery| VM_1
    Automation -->|Command Delivery| VM_2

    %% Step 4: Storage Access
    Disk1(Managed Disk AZ1) -->|Attach & Read/Write| VM_1
    Disk2(Managed Disk AZ2) -->|Attach & Read/Write| VM_2

    Files(Shared File System - Azure Files / NetApp) -->|Mount & Read/Write| VM_1
    Files -->|Mount & Read/Write| VM_2

    BlobStorage(Blob Storage - Static / Backups / Logs) -->|Read/Write via SDK/API| VM_1
    BlobStorage -->|Read/Write via SDK/API| VM_2

    %% Step 5: Logging & Monitoring
    VM_1 -->|Send Logs/Output| Monitor(Azure Monitor / Log Analytics)
    VM_2 -->|Send Logs/Output| Monitor
    VM_1 -->|Send Logs/Output| BlobStorage
    VM_2 -->|Send Logs/Output| BlobStorage

    %% VM Launch Sequence
    ScaleSet(Scale Set / Template) --> VM_1
    ScaleSet --> VM_2
    VM_1 -->|User Data / Bootstrapping| AppStart1(Application Startup)
    VM_2 -->|User Data / Bootstrapping| AppStart2(Application Startup)

    %% Monitoring SQL
    SQLPrimary --> Monitor
