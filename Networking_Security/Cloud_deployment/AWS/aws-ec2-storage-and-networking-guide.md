# AWS EC2, Storage, and Networking Guide

This guide covers:

- EC2 launch (basic + internal architecture)
- EBS attachment and mounting
- EFS shared storage setup
- S3 usage from EC2
- IAM roles and networking behavior
- Production best practices

---

# 1️⃣ Launching an EC2 Instance (Complete Flow)

## ✅ Step A — Launch EC2 (Console Steps)

1. Go to EC2 → Launch instance
2. Choose AMI (Amazon Linux, Ubuntu, etc.)
3. Choose instance type
4. Configure:
   - VPC
   - Subnet
   - Auto-assign Public IP (if public subnet)
5. Select or create Security Group
6. Select Key Pair (for SSH)
7. Configure storage (EBS root + optional additional volumes)
8. Attach IAM Role (if needed)
9. Launch

---

## 🔎 What Happens Behind the Scenes

When you click **Launch**:

1. AWS allocates physical host via hypervisor
2. Creates Elastic Network Interface (ENI)
3. Assigns private IP from subnet CIDR
4. Attaches Security Groups to ENI
5. Creates and attaches EBS root volume
6. Binds IAM role via Instance Profile
7. Initializes Instance Metadata Service (IMDS)
8. Instance state changes to `running`

---

# 🔐 Key Pair

- Used for SSH authentication
- Private key (.pem) stays with you
- Public key injected into instance at launch
- Security Group must allow port 22 (SSH)

Example SSH:

```bash
ssh -i mykey.pem ec2-user@<public-ip>
```

---

# 🌐 Networking Details

## Public Subnet Requirements

- Route table must include:
  ```
  0.0.0.0/0 → Internet Gateway
  ```
- Instance must:
  - Have public IP
  - Allow inbound traffic in Security Group

## Private Subnet

- No direct route to Internet Gateway
- Requires NAT Gateway for outbound internet access
- Used for databases and backend services

---

# 🧱 2️⃣ EC2 + EBS (Block Storage)

## 🔹 Scenario

You want:

- EC2 instance
- Extra EBS volume mounted at `/data`

---

## ✅ Create Additional EBS

1. EC2 → Volumes → Create volume
2. Must be in SAME Availability Zone as EC2
3. Choose:
   - Volume type (gp3 recommended)
   - Size
4. Create

---

## ✅ Attach Volume

1. Select volume → Attach
2. Choose instance
3. Device name (e.g., `/dev/xvdb`)

---

## ✅ Mount in Linux

```bash
lsblk
sudo mkfs -t ext4 /dev/xvdb
sudo mkdir /data
sudo mount /dev/xvdb /data
```

Persist after reboot:

```bash
sudo nano /etc/fstab
```

Add:

```
/dev/xvdb /data ext4 defaults,nofail 0 2
```

---

# 📂 3️⃣ EFS (Shared File System)

## 🔹 Scenario

Multiple EC2 instances need shared storage.

---

## ✅ Create EFS

1. EFS → Create file system
2. Select VPC
3. Create Mount Targets (one per AZ)
4. Attach Security Group

EFS SG must allow:

```
Inbound: TCP 2049 from EC2 SG
```

---

## ✅ Mount on EC2

Install EFS utils:

```bash
sudo yum install amazon-efs-utils -y
```

Mount:

```bash
sudo mkdir /shared
sudo mount -t efs fs-12345678:/ /shared
```

Now all EC2 instances mounting this path share files.

---

# 🗂 4️⃣ S3 Usage from EC2

S3 is object storage and is NOT inside your VPC.

---

## ✅ Create S3 Bucket

1. S3 → Create bucket
2. Choose Region
3. Unique name
4. Keep private (recommended)

---

## ✅ Attach IAM Role to EC2

Create role with S3 permissions.

Attach to EC2.

Instance retrieves temporary credentials automatically from IMDS.

---

## ✅ Install AWS CLI

```bash
sudo yum install aws-cli -y
```

---

## ✅ Use S3

Upload:

```bash
aws s3 cp file.txt s3://my-bucket/
```

Download:

```bash
aws s3 cp s3://my-bucket/file.txt .
```

List:

```bash
aws s3 ls s3://my-bucket/
```

No credentials stored locally.

---

# 🔐 IAM Role Internal Flow

1. EC2 queries:
   ```
   http://169.254.169.254/latest/meta-data/
   ```
2. Metadata Service requests temporary credentials from STS
3. STS returns:
   - Access key
   - Secret key
   - Session token
   - Expiration
4. Credentials auto-rotate

No hardcoded secrets required.

---

# 🔎 Internal Differences Summary

| Feature | EBS | EFS | S3 |
|----------|------|------|------|
| Type | Block | File (NFS) | Object |
| Scope | Single AZ | Regional | Regional |
| Shared across EC2 | ❌ | ✅ | Via API |
| Mounted like disk | ✅ | ✅ | ❌ |
| Best for | OS / DB | Shared apps | Backup / static / data lake |

---

# 🧠 Production Example (3-Tier Architecture)

Frontend EC2:
- Root disk → EBS
- Static assets → S3

Backend EC2:
- Database → EBS (io2/gp3)

Shared uploads:
- EFS

Backups:
- S3

Logs:
- S3

---

# 🚨 Common Mistakes

❌ Creating EBS in different AZ than EC2  
❌ Forgetting NFS port 2049 for EFS  
❌ Exposing EC2 with wide-open Security Groups  
❌ Hardcoding AWS credentials instead of IAM role  
❌ Using EFS for high-IOPS database  

---

# 🚀 Advanced Topics (Optional Study)

- gp3 vs io2 performance tuning
- EFS throughput modes
- S3 lifecycle policies
- NAT vs VPC Endpoints
- Multi-AZ high availability patterns
- Disaster recovery strategies

---

# 🎯 Summary

Use:

- EBS → OS and database disk
- EFS → Shared file storage
- S3 → Durable object storage
- IAM Roles → Secure temporary credentials
- Public Subnet → Internet-facing services
- Private Subnet → Backend services
