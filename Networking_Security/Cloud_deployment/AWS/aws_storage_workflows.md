# AWS Storage Connectivity Workflows: EBS, EFS & S3

---

## 1. Amazon EBS (Elastic Block Store)

EBS is **block storage** attached to EC2 instances.

### a) Attach & Mount Workflow
1. Attach volume to EC2 (console, CLI, or IaC).
2. Check volume status:
```bash
aws ec2 describe-volumes --volume-ids <volume-id>
# Status should be in-use

Check device on EC2:

lsblk

Format & mount (if new volume):

sudo mkfs -t xfs /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data

Verify read/write:

df -h
echo "test" > /data/testfile.txt
cat /data/testfile.txt
b) Snapshots / Backup Workflow
aws ec2 create-snapshot --volume-id <volume-id> --description "Backup"

Restore volume from snapshot and attach to EC2.

Test data consistency.

c) Connectivity Checks

EC2 must be in the same AZ as the EBS volume.

Security groups do not affect block-level storage.

OS-level checks: lsblk, mount, read/write operations.

2. Amazon EFS (Elastic File System)

EFS is a shared network file system, multiple EC2s can mount via NFS.

a) Mount & Connectivity Workflow

Configure Security Groups:

EFS SG: Allow NFS port 2049 inbound from EC2 SG.

EC2 SG: Allow outbound to EFS.

Mount EFS on EC2:

sudo yum install -y amazon-efs-utils   # Amazon Linux
sudo mkdir /mnt/efs
sudo mount -t efs fs-xxxx:/ /mnt/efs

Verify:

df -h | grep efs
echo "test" > /mnt/efs/testfile.txt
cat /mnt/efs/testfile.txt

Check from multiple EC2 instances for shared access.

b) Troubleshooting

NFS port blocked (2049)

Wrong VPC/Subnet/AZ

Missing IAM policies if using EFS IAM authorization

3. Amazon S3

S3 is object storage, accessible via SDK, CLI, or mounted via tools.

a) Connectivity & Access Workflow

Check bucket existence & permissions:

aws s3 ls s3://my-bucket

Read/Write Test:

aws s3 cp testfile.txt s3://my-bucket/
aws s3 cp s3://my-bucket/testfile.txt ./downloaded.txt

Verify IAM Role / Policy:

EC2 instance role must have s3:GetObject / s3:PutObject.

Optional: mount via s3fs or access via SDK.

b) Workflow Verification

Test from multiple clients or Lambda functions.

Logging via S3 access logs or CloudTrail.

Summary Table
Storage	Connectivity Type	EC2 Required?	Checks
EBS	Block-level	Yes	Attach status, lsblk, mount, read/write
EFS	NFS (network)	Yes	Mount NFS, security group, read/write
S3	HTTP/SDK/CLI	No (optional)	IAM permissions, CLI/SDK read/write, logs
