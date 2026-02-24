# Azure VM, Storage, and Networking Guide

This guide covers:

- Azure VM launch (basic + internal architecture)
- Managed Disk attachment and mounting
- Azure Files setup for shared storage
- Azure Blob Storage usage from VM
- Managed Identity and networking behavior
- Production best practices

---

# 1️⃣ Launching an Azure Virtual Machine (Complete Flow)

## ✅ Step A — Launch VM (Portal Steps)

1. Go to **Azure Portal → Virtual Machines → Create → Azure VM**  
2. Choose Image (Windows / Linux)  
3. Choose VM size  
4. Configure:
   - Virtual Network (VNet)
   - Subnet
   - Public IP assignment (if public-facing)
5. Configure Management:
   - Enable **Azure Active Directory login** (optional)
   - Enable **System-assigned Managed Identity** (for Azure RBAC access)  
6. Configure Storage:
   - OS Disk (Managed Disk)
   - Optional Data Disks
7. Configure Networking:
   - Network Security Group (NSG)
   - Ports (SSH 22 for Linux, RDP 3389 for Windows)  
8. Review and create

---

## 🔎 What Happens Behind the Scenes

When you click **Create**:

1. Azure allocates compute resources in a host cluster  
2. Creates **Network Interface (NIC)**  
3. Assigns private IP from subnet  
4. Attaches public IP if configured  
5. Applies NSG rules  
6. Attaches OS disk (Managed Disk)  
7. Attaches optional Data Disks  
8. Binds **Managed Identity** to the VM  
9. VM starts running  

---

# 🔐 SSH / RDP Access

- Linux VM → SSH with key pair  
- Windows VM → RDP with generated password or Azure AD  
- NSG must allow inbound ports  

Example SSH:

```bash
ssh -i mykey.pem azureuser@<public-ip>
```

---

# 🌐 Networking Details

## Public Subnet

- VNet subnet route table: default route to Internet via Azure Gateway
- Public IP assigned for direct access

## Private Subnet

- No direct Internet route
- Requires NAT Gateway or Azure Firewall for outbound
- Used for backend VMs, databases

---

# 🧱 2️⃣ Azure VM + Managed Disk (Block Storage)

## 🔹 Scenario

Attach an extra Managed Disk to VM as `/data`.

---

## ✅ Step A — Create Managed Disk

1. Go to **Disks → Create**
2. Choose:
   - Subscription / Resource Group
   - Location (same region as VM)
   - Availability Zone (if zonal)
   - Size and type (Standard SSD / Premium SSD / Ultra SSD)
3. Create

---

## ✅ Step B — Attach Disk to VM

1. Go to VM → Disks → Add data disk  
2. Select created Managed Disk  
3. Save changes

---

## ✅ Step C — Mount Disk in Linux / Windows

Linux:

```bash
lsblk
sudo mkfs -t ext4 /dev/sdc
sudo mkdir /data
sudo mount /dev/sdc /data
```

Windows:

- Initialize disk in Disk Management  
- Create volume, assign drive letter  

Persist after reboot using `/etc/fstab` on Linux.

---

# 📂 3️⃣ Azure Files (Shared File Storage)

## 🔹 Scenario

Multiple VMs need shared access.

---

## ✅ Step A — Create Storage Account

1. Go to **Storage Accounts → Create**  
2. Select Subscription / Resource Group  
3. Choose **Standard / Premium**  
4. Location → Same region as VMs  
5. Review + create  

---

## ✅ Step B — Create File Share

1. Go to Storage Account → File Shares → + File Share  
2. Name share, configure quota

---

## ✅ Step C — Configure Networking

- Allow VNet access (Private Endpoint recommended)  
- Ensure NSG allows SMB port 445 from VMs  

---

## ✅ Step D — Mount Azure Files

Linux:

```bash
sudo mkdir /shared
sudo mount -t cifs //<storageaccount>.file.core.windows.net/<sharename> /shared -o vers=3.0,username=<storageaccount>,password=<key>,dir_mode=0777,file_mode=0777,serverino
```

Windows:

- Map network drive using UNC path:
```
\\<storageaccount>.file.core.windows.net\<sharename>
```

All VMs can now share the same files.

---

# 🗂 4️⃣ Azure Blob Storage Usage from VM

Blob Storage is object storage, like S3.

---

## ✅ Step A — Create Blob Container

1. Storage Account → Containers → + Container  
2. Name container, keep private (recommended)  

---

## ✅ Step B — Enable Managed Identity Access

1. VM → Identity → System-assigned → On  
2. Storage Account → Access Control (IAM) → Role assignment  
   - Example role: **Storage Blob Data Contributor**  

---

## ✅ Step C — Access Blob from VM

Install Azure CLI:

```bash
sudo apt install azure-cli -y
```

Login via Managed Identity:

```bash
az login --identity
```

Upload file:

```bash
az storage blob upload --container-name mycontainer --file file.txt --name file.txt --account-name <storageaccount>
```

Download:

```bash
az storage blob download --container-name mycontainer --name file.txt --file file.txt --account-name <storageaccount>
```

No keys needed — Managed Identity provides temporary credentials.

---

# 🔐 Managed Identity Flow

1. VM requests token from Azure Instance Metadata Service (IMDS):
```
http://169.254.169.254/metadata/identity/oauth2/token
```
2. Azure AD issues short-lived access token
3. Token is used to authenticate API requests to Storage, Key Vault, or other Azure services

---

# 🔎 Internal Differences Summary

| Feature | Managed Disk | Azure Files | Blob Storage |
|---------|--------------|------------|--------------|
| Type | Block | File (SMB/NFS) | Object |
| Scope | Single VM / AZ | Shared across VMs | Regional / Global |
| Shared across VMs | ❌ | ✅ | Via API |
| Mounted like disk | ✅ | ✅ | ❌ |
| Best for | OS / DB | Shared apps | Backup / static / data lake |

---

# 🧠 Production Example

- Frontend VM root disk → Managed Disk  
- Database → Premium Managed Disk  
- Shared uploads → Azure Files  
- Backups → Blob Storage  
- Logs → Blob Storage  

---

# 🚨 Common Mistakes

❌ Managed Disk in different region / zone than VM  
❌ SMB port 445 blocked for Azure Files  
❌ Exposing VM with wide-open NSG rules  
❌ Hardcoding storage keys instead of using Managed Identity  

---

# 🚀 Advanced Topics

- Managed Disk performance tiers (Standard SSD / Premium SSD / Ultra SSD)  
- Azure Files throughput modes  
- Blob Storage lifecycle policies  
- NAT Gateway vs Private Endpoint  
- Multi-region replication (RA-GRS)  
- Disaster recovery strategies

---

# 🎯 Summary

Use:

- Managed Disk → OS and database disk  
- Azure Files → Shared file storage  
- Blob Storage → Durable object storage  
- Managed Identity → Secure temporary credentials  
- Public Subnet → Internet-facing VMs  
- Private Subnet → Backend services
