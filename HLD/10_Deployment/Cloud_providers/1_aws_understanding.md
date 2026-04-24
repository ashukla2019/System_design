# AWS Cloud Computing – Structured Notes

## Overview

This document provides a structured overview of AWS core services and architecture concepts, organized hierarchically for easier understanding and study.


## Baucally these services or servers provided:
Compute: EC2, Auto Scaling, ELB

Serverless: Lambda, Fargate

Containers: EKS, ECS

Storage: EBS (attached), EFS (shared), S3 (object, outside VPC)

Database: RDS/Aurora (SQL), DynamoDB (NoSQL)


“AWS resources are deployed inside a VPC, which is a logical network boundary.
Inside the VPC, we create public and private subnets. Public subnets connect to the internet via an Internet Gateway, while private subnets use a NAT Gateway for outbound access.
Services like EC2, RDS, and EKS run inside subnets, while services like S3 and Lambda are managed services outside the VPC but can be accessed securely.
Security is handled using Security Groups(statefull: allows rule only) at instance level and NACLs(stateless: allow & deny rules) at subnet level.
Underneath, AWS regions contain multiple AZs, each with data centers and physical servers running hypervisors"

## IAM
“In AWS, we create an IAM identity(user/role) and attach policies defining permissions. The identity obtains credentials—either access keys or temporary credentials from STS. These credentials are used to sign API requests to AWS services like S3. The service then evaluates the request against IAM policies and allows or denies access.”

## permission sample: 

{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::my-bucket/*"
}
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
│
│── 2. AWS Global Infrastructure
│
├── Regions
│
│   ├── Why Regions
│   │   → Serve users closer to their location (low latency)
│   │   → Meet legal or data residency requirements
│   │   → Provide disaster recovery across countries
│   │
│   ├── What it Provides
│   │   ├── Large geographic locations containing multiple Availability Zones (AZs)
│   │   ├── Complete isolation from other regions for fault tolerance
│   │   └── Examples:
│   │       ├── us-east-1 → Northern Virginia
│   │       ├── eu-west-1 → Ireland
│   │       └── ap-south-1 → Mumbai
│   │
│   └── Analogy
│       → Like “different cities” in the cloud
│
├── Availability Zones (AZs)
│
│   ├── Why AZs
│   │   → Ensure high availability and fault tolerance within a region
│   │
│   ├── What it Provides
│   │   ├── Logical grouping of one or more Data Centers
│   │   ├── Isolated from other AZs (fault isolation)
│   │   ├── Connected with high-speed, low-latency network
│   │   └── Examples:
│   │       ├── us-east-1a
│   │       ├── us-east-1b
│   │       └── us-east-1c

             Region
             ├── AZ1
             │   ├── Data Center
             │   └── Data Center
             │
             ├── AZ2
             │   ├── Data Center
             │   └── Data Center
             │
             └── AZ3
                 ├── Data Center
                 └── Data Center
│   │
│   └── Analogy
│       → Like “multiple safe zones (clusters of buildings) in the same city”
│
├── Data Centers (Physical Layer)
│
│   ├── Why Data Centers
│   │   → Provide physical infrastructure for computing
│   │
│   ├── What it Provides
│   │   ├── Actual buildings containing hardware
│   │   ├── Power, cooling, and networking systems
│   │   ├── Multiple data centers can exist inside one AZ
│   │   └── Hidden from users (managed by AWS)
│   │
│   └── Analogy
│       → Like “individual buildings inside a safe zone (AZ)”
│
├── Physical Servers / Machines
│
│   ├── Why Servers
│   │   → Execute applications and store data
│   │
│   ├── What it Provides
│   │   ├── CPU, RAM, Storage (real hardware)
│   │   ├── Run:
│   │   │   ├── Virtual Machines (EC2)
│   │   │   ├── Containers
│   │   │   └── Storage systems
│   │   └── Multiple servers exist inside each data center
│   │
│   └── Analogy
│       → Like “rooms inside a building where actual work happens”
│
├── Edge Locations
│
│   ├── Why Edge Locations
│   │   → Deliver content to users with minimal latency
│   │
│   ├── What it Provides
│   │   ├── Global caching locations
│   │   └── Example: CloudFront CDN
│   │
│   └── Analogy
│       → Like “local pickup stations” near users
│
├── High Availability Concepts
│
│   ├── Why
│   │   → Ensure systems remain available and fault-tolerant
│   │
│   ├── What it Provides
│   │   ├── Multi-AZ deployment → Run apps across multiple AZs
│   │   ├── Fault tolerance → System continues even if one AZ fails
│   │   ├── Data replication across AZs
│   │   └── Automatic failover → Switch to healthy resources
│   │
│   └── Analogy
│       → Like having backup offices in different zones of a city
│
├── Key Insight
│   → Region = Geographic boundary
│   → AZ = Fault-isolated infrastructure unit (contains multiple Data Centers)
│   → Data Center = Physical building
│   → Server = Actual machine
│   → Edge locations = Speed (closer to users)
│   → AZs = Reliability + Compute power
│
└── Final Hierarchy (Must Remember)
    Region
     └── Availability Zones (AZs)
          └── Data Centers
               └── Physical Servers(CPU, RAM, SSD, Networking interface)
                        └── Hypervisor(A hypervisor is the virtualization layer that sits on physical hardware and enables multiple isolated EC2 instances to run on a single server)
                              └── EC2
|
|
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
                     Internet
                       │
                       ▼
                    Internet Gateway (IGW)
                       │
                       ▼
                    VPC
                       │
                       ▼
                    Route Table
                       │
                       ▼
                    Public Subnet
                       │
                       ▼
                    EC2

│   │   │   └── Private Subnet
│   │   │       → No direct internet access (for security)
│   │   │       → Outbound internet via NAT Gateway / NAT Instance
│   │   │       → Hosts Databases, Application Servers, Internal Services
                         Private EC2
                           │
                           ▼
                      (VPC uses Route Table to decide next hop → NAT Gateway)
                           │
                           ▼
                      NAT Gateway
                           │
                           ▼
                      Internet Gateway
                           │
                           ▼
                      Internet
│   │   ├── Route Tables → Controls traffic flow inside VPC
│   │   ├── Internet Gateway (IGW) → Enables inbound/outbound internet access
│   │   ├── NAT Gateway / NAT Instance → Allows private subnet instances to access internet (outbound only)
│   │   ├── Security Groups → Instance-level, stateful firewall(supports allow rules)
│   │   ├── Network ACLs → Subnet-level, stateless firewall(supports allow and deny rule)
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
├── 6. Load Balancing(ALB, NLB, GWLB)
| ALB: allplication load balancing(http,         https: level7)
| NLB(network: tcp/udp)layer4
| GWLB: Gateway(security appliances)
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
| ├── Part IV – Storage Services
│
├├── 9. Amazon S3
│
│   ├── Why
│   │   → Store files at massive scale (object storage)
│   │
│   ├── When to Use
│   │   ├── Static files (images, videos, documents)
│   │   ├── Backups / logs / analytics
│   │   └── Large-scale storage (TBs–PBs)
|   |  
│   │├── Large Scale Storage
│
│   ├── Best Choice
│   │   → Amazon S3
│   │
│   ├── Why
│   │   → Unlimited storage (TBs → PBs → Exabytes)
│   │   → High durability (11 9’s)
│   │   → Cost-effective for huge data
│   │
│   ├── When to Use
│   │   ├── Big data / analytics
│   │   ├── Logs, backups
│   │   ├── Media storage (images/videos)
│   │   └── Data lakes
│   │
│   ├── Not Suitable
│   │   ├── OS / boot disk
│   │   ├── Databases (high I/O)
│   │   └── Low-latency workloads
│   │
│   └── Memory
│       → “If data is huge → S3”
│   ├── How It Works
│   │   ├── Stores data as objects in buckets
│   │   └── EC2/App → API (HTTP) → S3
│   │
│   └── Analogy
│       → Cloud storage (like Google Drive)
│
├── 10. Elastic Block Store (EBS)
│
│   ├── Why
│   │   → Disk storage for EC2 (block storage)
│   │
│   ├── When to Use
│   │   ├── OS (boot disk)
│   │   ├── Databases
│   │   └── Applications (low latency)
│   │
│   ├── How It Works
│   │   ├── Attached to EC2 as disk
│   │   └── OS → File System → EBS
│   │
│   └── Analogy
│       → Internal hard drive of server
│
├── 11. Elastic File System (EFS)
│
│   ├── Why
│   │   → Shared storage for multiple EC2
│   │
│   ├── When to Use
│   │   ├── Shared files across servers
│   │   ├── Microservices / web servers
│   │   └── Common storage
│   │
│   ├── How It Works
│   │   ├── Network file system (NFS)
│   │   └── EC2 → Network → EFS
|   |    
│   │   ├── How It Works
│ → EFS is created inside a VPC
│ → Mounted to EC2 using NFS protocol (port 2049)
│ → EC2 instances connect via mount targets in each AZ
│   │
│   └── Analogy
│       → Shared network drive
│
└── Quick Memory
    → S3 = Store
    → EBS = Run
    → EFS = Share
|
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
|
├── 14. IAM (Identity and Access Management)
│
│   ├── Why IAM
│   │   → Control who can access AWS resources
│   │   → Provide fine-grained permissions
│   │
│   ├── What it Provides
│   │   ├── Users → Individual identities
│   │   ├── Groups → Collection of users
│   │   ├── Roles → Assignable temporary credentials
│   │   └── Policies → Define permissions
│   │
│   └── Best Practices
│       → Least privilege
│       → Multi-Factor Authentication (MFA)
│       → Role-based access control
│
├── 15. Security Services
│
│   ├── AWS WAF
│   │   → Web Application Firewall, filters malicious web traffic
│   │
│   ├── AWS Shield
│   │   → DDoS protection service
│   │
│   ├── KMS
│   │   → Manages encryption keys for data security
│   │
│   ├── CloudTrail
│   │   → Auditing and logging of AWS API calls
│   │
│   └── GuardDuty
│       → Threat detection service monitoring suspicious activity
│
│
          Total production architecture
                    User
                     │
                     ▼
                    Route53
                     │
                     ▼
                    CloudFront
                     │
                     ▼
                    Load Balancer
                     │
                     ▼
                    EC2 Auto Scaling
                     │
                     ▼
                    RDS Database
                     │
                     ▼
                    EBS Storage
├
```
