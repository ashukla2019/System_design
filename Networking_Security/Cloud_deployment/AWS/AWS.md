# AWS Complete Notes – Interview & Practical Guide

---

# Part I – AWS Fundamentals

## 1. Introduction to Cloud Computing

### 1.1 What is Cloud Computing
Cloud computing is the on-demand delivery of computing resources over the internet with pay-as-you-go pricing.

### Key Characteristics
- On-demand self-service
- Broad network access
- Resource pooling
- Rapid elasticity
- Measured service

### Benefits
- No upfront hardware cost
- Scalability
- High availability
- Global reach
- Operational efficiency

---

### 1.2 IaaS vs PaaS vs SaaS

| Model | You Manage | Provider Manages | Example |
|--------|------------|-----------------|----------|
| IaaS | OS, runtime, apps | Hardware | EC2 |
| PaaS | Application code | OS + infra | Elastic Beanstalk |
| SaaS | Nothing | Everything | Gmail |

---

### 1.3 Public vs Private vs Hybrid Cloud

- **Public Cloud**: Shared infrastructure (AWS)
- **Private Cloud**: Dedicated infrastructure
- **Hybrid Cloud**: Combination of on-prem + cloud

---

### 1.4 Shared Responsibility Model

AWS:  
- Physical security  
- Hardware  
- Networking infrastructure  

Customer:  
- OS patching  
- Data protection  
- IAM configuration  
- Application security  

---

# Part II – AWS Global Infrastructure

## 2. AWS Global Infrastructure

### 2.1 Regions
- Geographic area (e.g., us-east-1)
- Data residency & compliance

### 2.2 Availability Zones (AZ)
- Multiple isolated data centers in a region
- Fault isolation
- Used for high availability

### 2.3 Edge Locations
- Used by CDN services
- Improves latency
- Supports caching & DNS

### 2.4 High Availability Concepts
- Multi-AZ deployment
- Auto Scaling
- Load balancing
- Failover mechanisms

---

# Part III – Networking in AWS

## 3. Virtual Private Cloud (VPC)

### 3.1 CIDR Blocks
Defines IP range (e.g., 10.0.0.0/16)

### 3.2 Subnets
- Public Subnet → Route to Internet Gateway
- Private Subnet → No direct internet access

### 3.3 Route Tables
Defines routing rules:
- Local route
- 0.0.0.0/0 to IGW or NAT

### 3.4 Internet Gateway (IGW)
- Enables internet access
- Attached to VPC

### 3.5 NAT Gateway vs NAT Instance

| Feature | NAT Gateway | NAT Instance |
|----------|-------------|--------------|
| Managed | Yes | No |
| HA | Yes | Manual |
| Scaling | Auto | Manual |

### 3.6 Security Groups vs NACL

| Feature | Security Group | NACL |
|----------|---------------|------|
| Stateful | Yes | No |
| Level | Instance | Subnet |
| Rules | Allow only | Allow & Deny |

### 3.7 VPC Peering
- Connect two VPCs privately
- No transitive routing

### 3.8 VPC Flow Logs
- Capture IP traffic logs
- Used for troubleshooting & auditing

---

## 4. DNS & Traffic Routing

### 4.1 Route 53
- Managed DNS
- Domain registration
- Health checks

### 4.2 Routing Policies
- Simple
- Weighted
- Latency-based
- Failover
- Geolocation
- Multi-value answer

### 4.3 Health Checks
- Monitors endpoint health
- Enables automatic failover

---

# Part III – Compute Services

## 5. EC2

### 5.1 EC2 Architecture
- AMI
- Instance Type
- EBS Volume
- Security Group
- Key Pair
- Network Interface

### 5.2 Instance Types
- General Purpose (balanced)
- Compute Optimized
- Memory Optimized
- Storage Optimized
- GPU Instances

### 5.3 Instance Lifecycle
- Pending
- Running
- Stopping
- Stopped
- Terminated

### 5.4 Key Pairs
- SSH authentication
- Public & Private key model

### 5.5 User Data
- Bootstrapping scripts
- Executes at launch

### 5.6 AMI
- OS + Application template
- Customizable

---

## 6. Load Balancing

### Types
- Application Load Balancer (Layer 7)
- Network Load Balancer (Layer 4)
- Gateway Load Balancer

### Target Groups
- EC2
- IP
- Lambda

### Health Checks
- Ensures traffic goes to healthy targets

---

## 7. Auto Scaling

### Auto Scaling Groups (ASG)
- Maintains desired capacity
- Ensures availability

### Scaling Policies
- Target tracking
- Step scaling
- Scheduled scaling

### Launch Templates
- Instance configuration blueprint

---

## 8. Serverless Compute

### Lambda
- Event-driven compute
- No server management
- Pay per execution

### Event Sources
- S3
- DynamoDB
- API Gateway
- CloudWatch Events

### Use Cases
- Backend APIs
- Automation
- Data processing

---

# Part IV – Storage Services

## 9. S3

### Object Storage Architecture
- Buckets
- Objects
- Metadata

### Storage Classes
- Standard
- Intelligent-Tiering
- Standard-IA
- One Zone-IA
- Glacier
- Deep Archive

### Versioning
- Protects from accidental deletion

### Lifecycle Policies
- Automates transition between classes

### Security
- IAM policies
- Bucket policies
- Encryption (SSE-S3, SSE-KMS)

---

## 10. EBS

### Block Storage
- Attached to EC2
- Persistent storage

### Volume Types
- gp3 (General purpose)
- io2 (Provisioned IOPS)
- st1 (Throughput optimized)
- sc1 (Cold HDD)

### Snapshots
- Stored in S3
- Used for backup & AMI creation

### Encryption
- KMS-based encryption

---

## 11. EFS

### Shared File Storage
- NFS-based
- Multiple EC2 access

### Use Cases
- Shared content
- Containers
- CMS platforms

### Performance Modes
- General Purpose
- Max I/O

---

# Part V – Database Services

## 12. RDS

### Supported Engines
- MySQL
- PostgreSQL
- Oracle
- SQL Server
- MariaDB
- Aurora

### Multi-AZ
- Synchronous standby
- Automatic failover

### Read Replicas
- Asynchronous
- Read scaling

### Backup
- Automated backups
- Manual snapshots

---

## 13. DynamoDB

### NoSQL Concepts
- Key-value database
- Serverless
- Fully managed

### Partition Key & Sort Key
- Determines data distribution
- Impacts performance

### Throughput Modes
- Provisioned
- On-demand

### Global Tables
- Multi-region replication
- Active-active setup

---

# Part VI – Identity & Security

## 14. IAM

### Components
- Users
- Groups
- Roles
- Policies

### Best Practices
- Least privilege
- Enable MFA
- Avoid root account use
- Use roles for EC2

---

## 15. Security Services

### WAF
- Protects web apps from common attacks

### Shield
- DDoS protection

### KMS
- Key management
- Encryption control

### CloudTrail
- Logs API calls

### GuardDuty
- Threat detection service

---

# Part VII – High Availability & DR

## 16. Highly Available Web Architecture
- ALB across multiple AZs
- EC2 in private subnets
- RDS Multi-AZ
- S3 for static content
- CloudFront CDN

---

## 17. Disaster Recovery Strategies

| Strategy | Cost | RTO |
|----------|------|-----|
| Backup & Restore | Low | High |
| Pilot Light | Medium | Medium |
| Warm Standby | High | Low |
| Active/Active | Very High | Very Low |

---

# Part VIII – Monitoring & DevOps

## 18. CloudWatch
- Metrics
- Logs
- Alarms
- Dashboards
- Insights queries

---

## 19. CI/CD Services

- CodeCommit → Source control
- CodeBuild → Build service
- CodeDeploy → Deployment automation
- CodePipeline → CI/CD orchestration

---

# Part IX – Cost Optimization

## 20. Pricing Models

- On-Demand
- Reserved Instances
- Spot Instances
- Savings Plans

## Cost Optimization Best Practices
- Right-size resources
- Use Auto Scaling
- Monitor idle resources
- Use S3 lifecycle policies
- Use Spot for non-critical workloads

---

# Part X – Advanced Topics

## 21. Microservices Architecture
- API Gateway + Lambda
- Independent scaling
- Container orchestration (ECS/EKS)

## 22. Serverless Architecture
- Fully event-driven
- Managed services
- Minimal infrastructure management

## 23. Multi-Region Architecture
- Route 53 failover
- Cross-region replication
- Global databases

## 24. Security Architecture Patterns
- Private subnets
- Bastion hosts
- Encryption everywhere
- Zero trust model

## 25. Common Interview Scenarios
- Design 3-tier architecture
- High availability design
- Sudden traffic spike handling
- Cost optimization case
- DR strategy selection

---

# End of Notes
