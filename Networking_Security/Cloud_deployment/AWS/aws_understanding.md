# AWS Complete Notes and Architecture Flows

---

## Part I – AWS Fundamentals

### 1. Introduction to Cloud Computing
- Cloud Computing: on-demand delivery of IT resources over the internet.
- Service Models:
  - IaaS: Compute, Storage, Network (EC2, S3)
  - PaaS: Managed platforms (Elastic Beanstalk)
  - SaaS: Software delivered via cloud (WorkDocs, QuickSight)
- Deployment Models:
  - Public Cloud: AWS shared infrastructure
  - Private Cloud: On-premises or dedicated cloud
  - Hybrid Cloud: Combination of both
- **Shared Responsibility Model**:
  - AWS: Security *of* cloud (hardware, networking, facilities)
  - Customer: Security *in* cloud (OS, data, IAM, applications)

### 2. AWS Global Infrastructure
- Regions: Geographical locations (e.g., us-east-1)
- Availability Zones (AZs): Isolated data centers inside a region
- Edge Locations: For CDN (CloudFront)
- High Availability Concepts: Multi-AZ, fault-tolerant design

---

## Part II – Networking in AWS

### 3. Virtual Private Cloud (VPC)
- CIDR Blocks: Define network range (e.g., 10.0.0.0/16)
- Subnets: Public vs Private
- Route Tables: Traffic routing inside VPC
- Internet Gateway (IGW): Public subnet internet access
- NAT Gateway/Instance: Outbound internet for private subnets
- Security Groups vs NACLs:
  - SG: Instance-level firewall
  - NACL: Subnet-level firewall
- VPC Peering: Connects multiple VPCs
- VPC Flow Logs: Track traffic

### 4. DNS & Traffic Routing
- Route 53: Domain name resolution
- Routing Policies: Simple, Weighted, Latency-based, Failover
- Health Checks: Monitor endpoints

---

## Part III – Compute Services

### 5. Elastic Compute Cloud (EC2)
- Instance Types: General Purpose, Compute Optimized, Memory Optimized
- AMI: Amazon Machine Image
- Key Pairs for SSH/SSM
- User Data & Bootstrapping

### 6. Load Balancing
- ALB: Layer 7, HTTP/HTTPS
- NLB: Layer 4, TCP/UDP
- Target Groups & Health Checks

### 7. Auto Scaling
- Auto Scaling Groups (ASG)
- Scaling Policies: Target tracking, Step scaling
- Launch Templates

### 8. Serverless Compute
- AWS Lambda: Event-driven compute
- Event sources: S3, DynamoDB Streams, API Gateway
- Use Cases: Image processing, data transformation

---

## Part IV – Storage Services

### 9. Amazon S3
- Object storage, 99.999999999% durability
- Storage Classes: Standard, IA, Glacier
- Versioning & Lifecycle Policies
- Security: Bucket policies, Encryption (KMS)

### 10. Elastic Block Store (EBS)
- Block storage for EC2
- Volume Types: gp3, io2, st1
- Snapshots & Encryption (KMS)

### 11. Elastic File System (EFS)
- Shared file storage for multiple EC2
- Performance Modes: General Purpose, Max I/O

---

## Part V – Database Services

### 12. RDS
- Engines: MySQL, PostgreSQL, SQL Server, Aurora
- Multi-AZ Deployment
- Read Replicas
- Backup & Restore

### 13. DynamoDB
- NoSQL key-value store
- Partition & Sort Key
- Provisioned & On-Demand Throughput
- Global Tables for multi-region replication

---

## Part VI – Identity & Security

### 14. IAM
- Users, Groups, Roles, Policies
- Best Practices: Least privilege, MFA, Role-based access

### 15. Security Services
- AWS WAF: Web application firewall
- AWS Shield: DDoS protection
- KMS: Encryption keys
- CloudTrail: API auditing
- GuardDuty: Threat detection

### SSM Communication
- EC2 runs SSM Agent
- IAM Role attached to EC2 allows SSM access
- Admin sends commands via Systems Manager
- No SSH or public IP required
- Logs stored in CloudWatch/S3

---
