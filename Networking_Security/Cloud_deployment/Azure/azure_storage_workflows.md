# Azure Storage Connectivity Workflows: Managed Disks, Azure Files & Blob Storage

---

## 1. Azure Managed Disks

Azure Managed Disks are **block-level storage** attached to VMs.

### a) Attach & Mount Workflow
1. Attach managed disk to VM (Azure Portal, CLI, or ARM template).
2. Check disk status on VM:
```bash
lsblk         # Linux
Get-Disk      # PowerShell / Windows

Initialize, format & mount (Linux example):

sudo mkfs -t xfs /dev/sdc
sudo mkdir /data
sudo mount /dev/sdc /data

Verify read/write:

df -h
echo "test" > /data/testfile.txt
cat /data/testfile.txt
b) Snapshots / Backup Workflow
az snapshot create --resource-group MyResourceGroup --source <disk-name> --name MyDiskSnapshot

Restore disk from snapshot and attach to VM.

Test data consistency.

c) Connectivity Checks

VM and disk must be in the same region.

OS-level checks: lsblk, mount, read/write operations.

No network-level security restrictions (handled at OS).

2. Azure Files

Azure Files is a shared network file system accessible via SMB or NFS.

a) Mount & Connectivity Workflow

Configure network/security:

Allow SMB/NFS ports (445 for SMB, 2049 for NFS) in NSGs.

Ensure VM can reach storage account endpoint.

Mount Azure File Share (Linux SMB example):

sudo mkdir /mnt/azurefiles
sudo mount -t cifs //<storageaccount>.file.core.windows.net/<sharename> /mnt/azurefiles -o vers=3.0,username=<storageaccount>,password=<key>,dir_mode=0777,file_mode=0777,sec=ntlmssp

Verify:

df -h | grep azurefiles
echo "test" > /mnt/azurefiles/testfile.txt
cat /mnt/azurefiles/testfile.txt

Test from multiple VMs for shared access.

b) Troubleshooting

Ports 445 (SMB) or 2049 (NFS) blocked

Wrong VNet / NSG configuration

Missing storage account keys or identity permissions

3. Azure Blob Storage

Blob Storage is object storage, accessible via SDK, CLI, or mounted via tools like Blobfuse.

a) Connectivity & Access Workflow

Check container existence:

az storage container list --account-name <storageaccount>

Read/Write Test:

az storage blob upload --account-name <storageaccount> --container-name mycontainer --name testfile.txt --file ./testfile.txt
az storage blob download --account-name <storageaccount> --container-name mycontainer --name testfile.txt --file ./downloaded.txt

Verify IAM / RBAC Permissions:

VM Managed Identity or SAS Token must have Storage Blob Data Contributor or Reader/Writer roles.

b) Workflow Verification

Test from multiple VMs, Azure Functions, or Logic Apps.

Enable logging via Azure Storage Analytics or Azure Monitor.

Summary Table
Storage	Connectivity Type	VM Required?	Checks
Managed Disk	Block-level	Yes	Attach status, lsblk/Get-Disk, mount, read/write
Azure Files	SMB/NFS (network)	Yes	Mount SMB/NFS, NSG rules, read/write
Blob Storage	HTTP/SDK/CLI	No (optional)	IAM/RBAC permissions, CLI/SDK read/write, logs
