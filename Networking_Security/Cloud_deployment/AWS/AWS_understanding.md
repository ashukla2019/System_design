# AWS Complete Architecture, Storage, SSM & Networking Notes

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

| Feature             | S3                     | EBS                        | EFS                            |
|--------------------|-----------------------|----------------------------|--------------------------------|
| Type               | Object                | Block                      | File                           |
| Access             | HTTP/SDK              | EC2-attached               | NFS mount                      |
| Durability         | 99.999999999%         | 99.8–99.9%                 | 99.99%                         |
| Scalability        | Virtually unlimited   | Volume-limited per instance| Automatic                      |
| Performance        | High throughput, variable latency | Low-latency, high IOPS (gp3/io2), sequential optimized (st1) | Low-latency for General Purpose, high throughput for Max I/O |
| Latency            | Milliseconds          | Single-digit ms            | Single to tens of ms           |
| Encryption         | KMS at rest, SSL in transit | KMS at rest, encryption in transit | KMS at rest, encryption in transit |
| Versioning         | Yes                   | Snapshots (point-in-time)  | N/A (manual via snapshots)     |
| Lifecycle Policies  | Yes (auto transition to IA/Glacier) | Snapshots lifecycle (manual) | N/A                             |
| Use Case           | Backups, archives, static files, big data | Boot volumes, DB storage, low-latency apps | Shared web content, analytics, NAS replacement |

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

---

## Part VII – SSM Communication

- EC2 runs **SSM Agent**.
- IAM Role attached to EC2 allows SSM access.
- Admin sends commands via **Systems Manager**.
- No SSH or public IP required.
- Logs stored in **CloudWatch** or **S3**.
- EC2 retrieves temporary credentials via **IMDS (Instance Metadata Service)**.

---

## Part VIII – Detailed 5-Step AWS Architecture Flow

### Stepwise Explanation

- **Step 1: User Traffic Entry & Filtering**  
  - Users/clients initiate requests (web, API, mobile apps).  
  - **Route 53** resolves DNS to ALB endpoint.  
  - Traffic passes through **AWS WAF** and **AWS Shield**.  
  - Requests reach **ALB** for Layer 7 routing, SSL termination, and health checks.

- **Step 2: EC2 Request Distribution & Auto Scaling**  
  - ALB forwards requests to EC2 instances in **private subnets**.  
  - **Auto Scaling Group (ASG)** adjusts EC2 count based on load.  
  - EC2 launched using **Launch Template** with AMI, Security Groups, IAM Role, bootstrapping scripts.

- **Step 3: Admin Access via SSM & IAM/IMDS**  
  - EC2 runs **SSM Agent**, communicates with **AWS Systems Manager**.  
  - Admin sends commands via SSM Console/CLI.  
  - EC2 uses **IAM Role** + **IMDS** to retrieve temporary credentials.  
  - Logs and outputs sent to **CloudWatch** or **S3**.

- **Step 4: EC2 Storage Interactions**  
  - **EBS:** Block storage attached to EC2, snapshots can go to S3.  
  - **EFS:** Shared file system mounted on multiple EC2s.  
  - **S3:** Object storage for static content, backups, logs; accessed via SDK/API.

- **Step 5: Monitoring, Logging & Auditing**  
  - **CloudWatch** collects metrics from EC2, RDS, ALB, and custom apps.  
  - CloudWatch Logs receive app/system logs; S3 stores long-term logs.  
  - **RDS metrics** monitored (CPU, connections, IOPS).  
  - **CloudTrail** audits admin and API actions.

---
