AWS Cloud Computing

│
├── Part I – AWS Fundamentals
│
├── 1. Introduction to Cloud Computing
│ ├── Cloud Computing
│ │ → On-demand delivery of IT resources over the internet
│ │ → Pay-as-you-go pricing
│ │ → Eliminates need for on-premise infrastructure
│ │
│ ├── Service Models
│ │
│ │ ├── IaaS (Infrastructure as a Service)
│ │ │ → Provides compute, storage, and networking infrastructure
│ │ │ → Customer manages OS, applications, runtime
│ │ │ → Examples: Amazon EC2, Amazon S3
│ │
│ │ ├── PaaS (Platform as a Service)
│ │ │ → Managed application platform
│ │ │ → Developers focus only on application code
│ │ │ → Example: AWS Elastic Beanstalk
│ │
│ │ └── SaaS (Software as a Service)
│ │ → Fully functional software delivered via internet
│ │ → No infrastructure or platform management needed
│ │ → Examples: Amazon WorkDocs, Amazon QuickSight
│
│ ├── Deployment Models
│ │ ├── Public Cloud
│ │ │ → Infrastructure owned by cloud provider
│ │ │ → Shared among multiple customers
│ │ │ → Example: AWS public cloud
│ │ │
│ │ ├── Private Cloud
│ │ │ → Dedicated infrastructure for one organization
│ │ │ → Hosted on-premise or private data center
│ │ │
│ │ └── Hybrid Cloud
│ │ → Combination of public and private cloud
│ │ → Enables workload portability
│
│ └── Shared Responsibility Model
│ ├── AWS Responsibility (Security of the Cloud)
│ │ → Physical data centers
│ │ → Hardware infrastructure
│ │ → Networking infrastructure
│ │
│ └── Customer Responsibility (Security in the Cloud)
│ → Operating systems
│ → Applications
│ → Data protection
│ → IAM configuration
│
│
├── 2. AWS Global Infrastructure
│
│ ├── Regions
│ │ → Large geographic areas containing multiple data centers
│ │ → Regions are isolated from each other
│ │ → Examples:
│ │ us-east-1 → Northern Virginia
│ │ eu-west-1 → Ireland
│ │ ap-south-1 → Mumbai
│
│ ├── Availability Zones (AZs)
│ │ → Isolated data centers within a region
│ │ → Connected via low-latency network
│ │ → Examples:
│ │ us-east-1a
│ │ us-east-1b
│ │ us-east-1c
│
│ ├── Edge Locations
│ │ → Global caching locations for content delivery
│ │ → Used mainly by Amazon CloudFront
│ │ → Reduces latency for end users
│
│ └── High Availability Concepts
│ → Multi-AZ deployment
│ → Fault-tolerant architecture
│ → Automatic failover mechanisms
│
│
├── Part II – Networking in AWS
│
├── 3. Virtual Private Cloud (VPC)
│
│ ├── VPC
│ │ → Isolated virtual network inside AWS
│ │ → Enables full control over networking configuration
│
│ ├── CIDR Blocks
│ │ → Defines network IP range
│ │ → Example: 10.0.0.0/16
│ │ → /16 means first 16 bits represent network portion
│
│ ├── Subnets
│ │ ├── Public Subnet
│ │ │ → Has internet access through Internet Gateway
│ │ │
│ │ └── Private Subnet
│ │ → No direct internet access
│ │ → Used for backend resources (DB, internal apps)
│
│ ├── Route Tables
│ │ → Controls network traffic routing within the VPC
│
│ ├── Internet Gateway (IGW)
│ │ → Enables internet connectivity for public subnets
│
│ ├── NAT Gateway / NAT Instance
│ │ → Allows private subnet instances to access internet
│ │ → Outbound only (no inbound traffic allowed)
│
│ ├── Security Groups vs Network ACLs
│ │
│ │ ├── Security Groups
│ │ │ → Instance-level firewall
│ │ │ → Stateful
│ │
│ │ └── Network ACLs
│ │ → Subnet-level firewall
│ │ → Stateless
│
│ ├── VPC Peering
│ │ → Connects multiple VPC networks together
│
│ └── VPC Flow Logs
│ → Captures IP traffic information
│ → Used for monitoring and troubleshooting
│
│
├── 4. DNS & Traffic Routing
│
│ ├── Domain Name System
│ │ → Managed using Amazon Route 53
│
│ ├── Routing Policies
│ │ ├── Simple Routing
│ │ ├── Weighted Routing
│ │ ├── Latency-Based Routing
│ │ └── Failover Routing
│
│ └── Health Checks
│ → Monitor application endpoints
│ → Automatically redirect traffic if endpoint fails
│
│
├── Part III – Compute Services
│
├── 5. Elastic Compute Cloud (EC2)
│
│ ├── EC2 Instances
│ │ → Virtual servers running in AWS cloud
│
│ ├── Instance Types
│ │ ├── General Purpose
│ │ ├── Compute Optimized
│ │ └── Memory Optimized
│
│ ├── AMI (Amazon Machine Image)
│ │ → Template used to launch EC2 instances
│
│ ├── Key Pairs
│ │ → Secure login to EC2 instances (SSH)
│
│ └── User Data & Bootstrapping
│ → Scripts executed during instance startup
│
│
├── 6. Load Balancing
│
│ ├── Application Load Balancer (ALB)
│ │ → Layer 7 load balancing
│ │ → Supports HTTP / HTTPS routing
│
│ ├── Network Load Balancer (NLB)
│ │ → Layer 4 load balancing
│ │ → Supports TCP / UDP traffic
│
│ └── Target Groups
│ → Group of instances receiving traffic
│ → Health checks monitor instance availability
│
│
├── 7. Auto Scaling
│
│ ├── Auto Scaling Groups (ASG)
│ │ → Automatically adjust number of EC2 instances
│
│ ├── Scaling Policies
│ │ ├── Target Tracking
│ │ └── Step Scaling
│
│ └── Launch Templates
│ → Define instance configuration for scaling
│
│
├── 8. Serverless Compute
│
│ ├── AWS Lambda
│ │ → Event-driven serverless compute service
│
│ ├── Event Sources
│ │ ├── Amazon S3
│ │ ├── Amazon DynamoDB Streams
│ │ └── Amazon API Gateway
│
│ └── Use Cases
│ → Image processing
│ → Data transformation
│ → Automation tasks
│
│
├── Part IV – Storage Services
│
├── 9. Amazon S3
│ → Object storage service
│ → Durability: 99.999999999% (11 nines)
│
│ ├── Storage Classes
│ │ ├── Standard
│ │ ├── Infrequent Access (IA)
│ │ └── Glacier (archival storage)
│
│ ├── Versioning
│ │ → Maintains multiple versions of objects
│
│ ├── Lifecycle Policies
│ │ → Automatically move data between storage classes
│
│ └── Security
│ → Bucket policies
│ → Encryption using AWS Key Management Service
│
│
├── 10. Elastic Block Store (EBS)
│
│ ├── Block storage attached to EC2 instances
│
│ ├── Volume Types
│ │ ├── gp3 (General purpose SSD)
│ │ ├── io2 (Provisioned IOPS SSD)
│ │ └── st1 (Throughput optimized HDD)
│
│ ├── Snapshots
│ │ → Backup stored in S3
│
│ └── Encryption
│ → Using KMS keys
│
│
├── 11. Elastic File System (EFS)
│
│ ├── Shared file system storage for multiple EC2 instances
│
│ └── Performance Modes
│ ├── General Purpose
│ └── Max I/O
│
│
├── Part V – Database Services
│
├── 12. Relational Database Service (RDS)
│
│ ├── Supported Engines
│ │ ├── MySQL
│ │ ├── PostgreSQL
│ │ ├── SQL Server
│ │ └── Aurora
│
│ ├── Multi-AZ Deployment
│ │ → High availability database replication
│
│ ├── Read Replicas
│ │ → Improves read performance
│
│ └── Backup & Restore
│ → Automated backups and snapshots
│
│
├── 13. DynamoDB
│
│ ├── Fully managed NoSQL database
│
│ ├── Key Structure
│ │ ├── Partition Key
│ │ └── Sort Key
│
│ ├── Capacity Modes
│ │ ├── Provisioned throughput
│ │ └── On-Demand capacity
│
│ └── Global Tables
│ → Multi-region replication
