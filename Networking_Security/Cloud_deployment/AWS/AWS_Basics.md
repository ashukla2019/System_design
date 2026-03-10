# AWS Cloud Computing – Structured Notes

## Overview

This document provides a structured overview of AWS core services and architecture concepts, organized hierarchically for easier understanding and study.

---

# AWS Cloud Computing Architecture Tree

```
AWS Cloud Computing
│
├── Part I – AWS Fundamentals
│
├── 1. Introduction to Cloud Computing
│   │
│   ├── Cloud Computing
│   │   → On-demand delivery of IT resources over the internet
│   │   → Pay-as-you-go pricing model
│   │   → Eliminates need for physical data centers
│   │
│   ├── Service Models
│   │
│   │   ├── IaaS (Infrastructure as a Service)
│   │   │   → Provides compute, storage, and networking
│   │   │   → User manages OS, middleware, runtime, and applications
│   │   │   → Examples:
│   │   │        Amazon EC2
│   │   │        Amazon S3
│   │   │
│   │   ├── PaaS (Platform as a Service)
│   │   │   → Managed platform for application deployment
│   │   │   → Infrastructure and runtime handled by cloud provider
│   │   │   → Developer focuses on writing code
│   │   │   → Example:
│   │   │        AWS Elastic Beanstalk
│   │   │
│   │   └── SaaS (Software as a Service)
│   │       → Fully managed software delivered over internet
│   │       → Users access applications without infrastructure management
│   │       → Examples:
│   │            Amazon WorkDocs
│   │            Amazon QuickSight
│   │
│   ├── Deployment Models
│   │
│   │   ├── Public Cloud
│   │   │   → Infrastructure owned and operated by cloud provider
│   │   │   → Shared among multiple customers
│   │   │   → Example: AWS public cloud
│   │   │
│   │   ├── Private Cloud
│   │   │   → Dedicated infrastructure for one organization
│   │   │   → Hosted on-premise or private data center
│   │   │
│   │   └── Hybrid Cloud
│   │       → Combination of public cloud and private infrastructure
│   │       → Enables data portability and flexible workloads
│   │
│   └── Shared Responsibility Model
│
│       ├── AWS Responsibility (Security OF the Cloud)
│       │   → Physical data centers
│       │   → Hardware infrastructure
│       │   → Networking infrastructure
│       │   → Global infrastructure
│       │
│       └── Customer Responsibility (Security IN the Cloud)
│           → Operating systems
│           → Applications
│           → Data protection
│           → IAM policies and user access
│
│
├── 2. AWS Global Infrastructure
│
│   ├── Regions
│   │   → Large geographic locations with multiple data centers
│   │   → Regions are isolated from each other
│   │   → Used for latency optimization and compliance
│   │
│   │   Examples:
│   │       us-east-1   → Northern Virginia
│   │       eu-west-1   → Ireland
│   │       ap-south-1  → Mumbai
│   │
│   ├── Availability Zones (AZs)
│   │   → Independent data centers within a region
│   │   → Connected with low latency network
│   │   → Designed for high availability
│   │
│   │   Examples:
│   │       us-east-1a
│   │       us-east-1b
│   │       us-east-1c
│   │
│   ├── Edge Locations
│   │   → Global caching locations
│   │   → Used for content delivery
│   │   → Example: CloudFront CDN
│   │
│   └── High Availability Concepts
│       → Multi-AZ deployment
│       → Fault tolerant systems
│       → Automatic failover
│
│
├── Part II – Networking in AWS
│
├── 3. Virtual Private Cloud (VPC)
│
│   ├── VPC
│   │   → Logical isolated network inside AWS
│   │   → Similar to traditional data center network
│   │
│   ├── CIDR Blocks
│   │   → Defines IP address range
│   │   → Example:
│   │        10.0.0.0/16
│   │
│   │   Explanation:
│   │        /16 → first 16 bits represent network portion
│   │        Remaining bits used for host addresses
│   │
│   ├── Subnets
│   │
│   │   ├── Public Subnet
│   │   │   → Connected to Internet Gateway
│   │   │   → Used for load balancers and bastion hosts
│   │   │
│   │   └── Private Subnet
│   │       → No direct internet access
│   │       → Used for application servers and databases
│   │
│   ├── Route Tables
│   │   → Controls how traffic flows inside VPC
│   │
│   ├── Internet Gateway (IGW)
│   │   → Enables inbound and outbound internet access
│   │
│   ├── NAT Gateway / NAT Instance
│   │   → Allows private instances to access internet
│   │   → Outbound connections only
│   │
│   ├── Security Groups
│   │   → Instance level firewall
│   │   → Stateful
│   │
│   ├── Network ACLs
│   │   → Subnet level firewall
│   │   → Stateless
│   │
│   ├── VPC Peering
│   │   → Direct network connection between VPCs
│   │
│   └── VPC Flow Logs
│       → Capture network traffic information
│
│
├── 4. DNS and Traffic Routing
│
│   ├── Amazon Route 53
│   │   → Highly available DNS service
│   │
│   ├── Routing Policies
│   │   ├── Simple Routing
│   │   ├── Weighted Routing
│   │   ├── Latency Based Routing
│   │   └── Failover Routing
│   │
│   └── Health Checks
│       → Monitors endpoints
│       → Automatically redirects traffic on failure
│
│
├── Part III – Compute Services
│
├── 5. Elastic Compute Cloud (EC2)
│
│   ├── EC2 Instances
│   │   → Virtual machines running in AWS cloud
│   │
│   ├── Instance Types
│   │   ├── General Purpose
│   │   ├── Compute Optimized
│   │   └── Memory Optimized
│   │
│   ├── Amazon Machine Image (AMI)
│   │   → Template used to launch EC2 instances
│   │
│   ├── Key Pairs
│   │   → Used for secure SSH access
│   │
│   └── User Data
│       → Bootstrapping scripts executed during launch
│
│
├── 6. Load Balancing
│
│   ├── Application Load Balancer (ALB)
│   │   → Layer 7 load balancing
│   │   → Supports HTTP and HTTPS routing
│   │
│   ├── Network Load Balancer (NLB)
│   │   → Layer 4 load balancing
│   │   → Supports TCP and UDP
│   │
│   └── Target Groups
│       → Group of instances receiving traffic
│
│
├── 7. Auto Scaling
│
│   ├── Auto Scaling Groups
│   │   → Automatically scale EC2 instances
│   │
│   ├── Scaling Policies
│   │   ├── Target Tracking
│   │   └── Step Scaling
│   │
│   └── Launch Templates
│       → Defines configuration for new instances
│
│
├── 8. Serverless Compute
│
│   ├── AWS Lambda
│   │   → Event driven serverless compute
│   │
│   ├── Event Sources
│   │   ├── Amazon S3
│   │   ├── DynamoDB Streams
│   │   └── API Gateway
│   │
│   └── Use Cases
│       → Image processing
│       → Data transformation
│       → Automation tasks
│
│
├── Part IV – Storage Services
│
├── 9. Amazon S3
│
│   ├── Object Storage
│   │   → Stores files as objects in buckets
│   │
│   ├── Durability
│   │   → 99.999999999% (11 nines)
│   │
│   ├── Storage Classes
│   │   ├── Standard
│   │   ├── Infrequent Access
│   │   └── Glacier
│   │
│   ├── Versioning
│   │   → Maintains object history
│   │
│   ├── Lifecycle Policies
│   │   → Automatic data tiering
│   │
│   └── Encryption
│       → AWS KMS
│
│
├── 10. Elastic Block Store (EBS)
│
│   ├── Block storage attached to EC2
│   │
│   ├── Volume Types
│   │   ├── gp3
│   │   ├── io2
│   │   └── st1
│   │
│   ├── Snapshots
│   │   → Stored in S3
│   │
│   └── Encryption
│       → Using AWS KMS
│
│
├── 11. Elastic File System (EFS)
│
│   ├── Shared network file storage
│   │
│   └── Performance Modes
│       ├── General Purpose
│       └── Max I/O
│
│
├── Part V – Database Services
│
├── 12. Amazon RDS
│
│   ├── Supported Engines
│   │   ├── MySQL
│   │   ├── PostgreSQL
│   │   ├── SQL Server
│   │   └── Amazon Aurora
│   │
│   ├── Multi-AZ Deployment
│   │   → High availability database
│   │
│   ├── Read Replicas
│   │   → Improve read performance
│   │
│   └── Automated Backups
│
│
├── 13. Amazon DynamoDB
│
│   ├── NoSQL Key Value Database
│   │
│   ├── Key Structure
│   │   ├── Partition Key
│   │   └── Sort Key
│   │
│   ├── Capacity Modes
│   │   ├── Provisioned
│   │   └── On Demand
│   │
│   └── Global Tables
│       → Multi region replication
```
