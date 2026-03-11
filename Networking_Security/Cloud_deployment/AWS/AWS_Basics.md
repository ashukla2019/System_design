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
|
|├── 2. AWS Global Infrastructure
│
├── Regions
│
│   ├── Why Regions
│   │   → Serve users closer to their location (low latency)
│   │   → Meet legal or data residency requirements
│   │   → Provide disaster recovery across countries
│   │
│   ├── What it Provides
│   │   ├── Large geographic locations containing multiple data centers
│   │   ├── Isolation from other regions for fault tolerance
│   │   └── Examples:
│   │       ├── us-east-1 → Northern Virginia
│   │       ├── eu-west-1 → Ireland
│   │       └── ap-south-1 → Mumbai
│   │
│   └── Analogy
│       → Like “different cities” in the cloud, each with multiple office buildings (data centers)
│
├── Availability Zones (AZs)
│
│   ├── Why AZs
│   │   → Ensure high availability and fault tolerance within a region
│   │
│   ├── What it Provides
│   │   ├── Independent data centers inside a region
│   │   ├── Connected with low-latency network
│   │   └── Examples:
│   │       ├── us-east-1a
│   │       ├── us-east-1b
│   │       └── us-east-1c
│   │
│   └── Analogy
│       → Like “multiple buildings in the same city” to ensure services keep running if one building fails
│
├── Edge Locations
│
│   ├── Why Edge Locations
│   │   → Deliver content to users with minimal latency
│   │
│   ├── What it Provides
│   │   ├── Global caching locations for content delivery
│   │   └── Example: CloudFront CDN
│   │
│   └── Analogy
│       → Like “local pickup stations” near users to deliver files faster
│
├── High Availability Concepts
│
│   ├── Why
│   │   → To ensure systems remain available and fault-tolerant
│   │
│   ├── What it Provides
│   │   ├── Multi-AZ deployment → Applications run across multiple AZs
│   │   ├── Fault-tolerant systems → Continue operating even if some components fail
│   │   └── Automatic failover → Switch to healthy resources on failure
│   │
│   └── Analogy
│       → Like having multiple backup offices and automatic rerouting to avoid downtime
│
├── Key Insight
│   → Edge locations = speed to the user
│   → AZs = reliability, redundancy, and actual processing power
│
|├── Part II – Networking in AWS
│
├── 3. Virtual Private Cloud (VPC)
│
│   ├── Why VPC
│   │   → Isolates cloud resources from other users
│   │   → Provides security control with security groups, NACLs, and firewalls
│   │   → Ensures only allowed communication between resources
│   │
│   ├── What it Provides
│   │   ├── CIDR Blocks → Defines IP address range (e.g., 10.0.0.0/16)
│   │   │   → /16 → first 16 bits represent network portion; remaining bits for hosts
│   │   ├── Subnets → Smaller networks inside VPC for organizing resources
│   │   │   ├── Public Subnet
│   │   │   │   → Connected to Internet Gateway
│   │   │   │   → Hosts resources needing direct internet access (Web Servers, Load Balancers, Bastion Hosts)
│   │   │   │   → Example flow: Internet → Internet Gateway → Public Subnet → Web Server
│   │   │   └── Private Subnet
│   │   │       → No direct internet access (for security)
│   │   │       → Outbound internet via NAT Gateway / NAT Instance
│   │   │       → Hosts Databases, Application Servers, Internal Services
│   │   ├── Route Tables → Controls traffic flow inside VPC
│   │   ├── Internet Gateway (IGW) → Enables inbound/outbound internet access
│   │   ├── NAT Gateway / NAT Instance → Allows private subnet instances to access internet (outbound only)
│   │   ├── Security Groups → Instance-level, stateful firewall
│   │   ├── Network ACLs → Subnet-level, stateless firewall
│   │   ├── VPC Peering → Direct network connection between VPCs
│   │   └── VPC Flow Logs → Capture network traffic information
│   │
│   └── Analogy
│       → Like creating your own “private neighborhood” in the cloud, with roads, gates, and security rules
│
├── 4. DNS and Traffic Routing
│
│   ├── Why Route 53
│   │   → Maps human-readable domain names to IP addresses
│   │   → Ensures traffic reaches the right resource reliably
│   │
│   ├── What it Provides
│   │   ├── Amazon Route 53 → Highly available DNS service
│   │   ├── Routing Policies
│   │   │   ├── Simple Routing → Single resource
│   │   │   ├── Weighted Routing → Distribute traffic across resources
│   │   │   ├── Latency-Based Routing → Direct users to lowest-latency region
│   │   │   └── Failover Routing → Redirect traffic on failure
│   │   └── Health Checks → Monitors endpoints and automatically reroutes traffic if failure occurs
│   │
│   └── Analogy
│       → Like a “smart traffic controller” that directs visitors to the best available path
|├── Part III – Compute Services
│
├── 5. Elastic Compute Cloud (EC2)
│
│   ├── Why EC2
│   │   → Core compute resource; need servers to run applications
│   │
│   ├── What it Provides
│   │   ├── Virtual machines
│   │   ├── Choice of CPU, memory, storage (Instance Types)
│   │   ├── OS templates (AMIs)
│   │   └── Security & configuration (Key Pairs, User Data)
│   │
│   └── Analogy
│       → Building blocks of cloud compute architecture
│
├── 6. Load Balancing
│
│   ├── Why Load Balancer
│   │   → Distributes traffic efficiently across multiple EC2 instances
│   │
│   ├── What it Provides
│   │   ├── Balances requests across instances
│   │   ├── Improves availability & fault tolerance
│   │   └── Handles protocols (HTTP/HTTPS/TCP/UDP)
│   │
│   └── Analogy
│       → Traffic managers directing user requests to the right server
│
├── 7. Auto Scaling
│
│   ├── Why Auto Scaling
│   │   → Handles dynamic demand by adding/removing EC2 instances automatically
│   │
│   ├── What it Provides
│   │   ├── Ensures applications don’t crash during traffic spikes
│   │   ├── Saves cost by scaling down during low usage
│   │   └── Works with Load Balancers to maintain availability
│   │
│   └── Analogy
│       → Elastic growth/shrink of server fleet
│
├── 8. Serverless Compute
│
│   ├── Why Serverless
│   │   → Event-driven compute; no servers to manage
│   │
│   ├── What it Provides
│   │   ├── No servers to manage
│   │   ├── Scales automatically with demand
│   │   └── Integrates with S3, DynamoDB, API Gateway
│   │
│   └── Analogy
│       → Just run your code, AWS handles everything else
│
|├── Part IV – Storage Services
│
├── 9. Amazon S3
│
│   ├── Why Amazon S3
│   │   → Store and retrieve files at massive scale from anywhere
│   │
│   ├── What it Provides
│   │   ├── Stores files as objects in buckets
│   │   ├── File storage (Images, Videos, Documents)
│   │   ├── Backup and Disaster Recovery
│   │   ├── Versioning → Maintains object history
│   │   ├── Lifecycle Policies → Automatic data tiering
│   │   ├── Storage Classes
│   │   │   ├── Standard
│   │   │   ├── Infrequent Access
│   │   │   └── Glacier
│   │   └── Encryption → Using AWS KMS
│   │
│   └── Analogy
│       → Like a “cloud hard drive for objects” that scales infinitely
│
├── 10. Elastic Block Store (EBS)
│
│   ├── Why EBS
│   │   → Persistent block-level storage for EC2 instances
│   │
│   ├── What it Provides
│   │   ├── Works like a virtual hard drive for OS, applications, databases, logs
│   │   ├── Persistent Storage → Data remains even if EC2 stops
│   │   ├── Volume Types
│   │   │   ├── gp3 (general purpose SSD)
│   │   │   ├── io2 (high performance SSD)
│   │   │   └── st1 (throughput optimized HDD)
│   │   ├── Snapshots → Backups stored in S3
│   │   └── Encryption → Using AWS KMS
│   │
│   └── Analogy
│       → Like attaching a hard drive to your cloud server
│
├── 11. Elastic File System (EFS)
│
│   ├── Why EFS
│   │   → Shared network file storage for multiple EC2 instances
│   │
│   ├── What it Provides
│   │   ├── File sharing between multiple servers
│   │   ├── Centralized storage → Single source of truth for files
│   │   └── Performance Modes
│   │       ├── General Purpose → Low latency for most workloads
│   │       └── Max I/O → High throughput for analytics, big data
│   │
│   └── Analogy
│       → Like a “shared network drive” accessible by many servers at once
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
