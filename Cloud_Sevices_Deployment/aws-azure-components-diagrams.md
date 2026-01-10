
1. GLOBAL & ACCOUNT LEVEL CONCEPTS
AWS Account
Definition: A root-level container for all AWS resources. Usage: Billing, isolation, security boundary.

Azure Subscription
Definition: Logical billing and access container for Azure resources. Usage: Cost tracking, quota limits, access control.

Resource Group (Azure only)
Definition: Logical container for related resources. Usage: Lifecycle management (deploy, delete together).
----------------------------------
2. REGIONS, ZONES & GLOBAL INFRASTRUCTURE
Region (AWS / Azure)
Definition: A geographical area containing multiple data centers. Usage: Latency reduction, compliance, disaster recovery.

Availability Zone (AZ)
Definition: Physically separate data centers within a region. Usage: High availability and fault tolerance.

Edge Location (AWS) / Edge POP (Azure)
Definition: CDN endpoints close to users. Usage: Low‑latency content delivery.
--------------------------------
3. IDENTITY & ACCESS MANAGEMENT (SECURITY CORE)
Diagram – IAM / Entra ID Flow
User / Service
      |
      v
+-------------------+
| IAM / Entra ID    |
| (AuthN + AuthZ)  |
+-------------------+
      |
      v
 Role / Policy Evaluation
      |
      v
 AWS / Azure Resource
Explanation:

Authentication verifies who you are

Authorization decides what you can do

Roles are preferred over static credentials
------------------------------
4. NETWORKING COMPONENTS
Diagram – AWS vs Azure Networking
AWS                                   Azure
----                                  -----
Region                                Region
  |                                     |
  v                                     v
 VPC                                   VNet
  |                                     |
  v                                     v
 Subnet (Public/Private)               Subnet
  |                                     |
  v                                     v
 EC2  <--SG-->                         VM  <--NSG-->
  |
  +--> Internet Gateway / NAT Gateway
Explanation:

VPC/VNet is a private network boundary

Subnets divide workloads

Security Groups/NSGs act as firewalls
----------------------------
5. COMPUTE SERVICES
Diagram – Compute Models
Traditional VM
--------------
App
OS
VM (EC2 / VM)
Hypervisor
Hardware

Container
---------
App
Container Runtime
Host OS
VM / Bare Metal

Serverless
----------
App Code
Lambda / Function
Cloud Managed Runtime
Explanation:

VMs give control

Containers give portability

Serverless gives zero infra management
-----------------------------
6. STORAGE SERVICES
Diagram – Storage Types
Object Storage (S3 / Blob)
-------------------------
Bucket
 ├── file1
 ├── file2

Block Storage (EBS / Disk)
-------------------------
[ OS | DB | App ]  <-- attached to VM

File Storage (EFS / Files)
--------------------------
Shared Folder
 ├── VM1
 ├── VM2
Explanation:

Object: unlimited, cheap, durable

Block: low-latency disk

File: shared access
-------------------------------
7. DATABASE SERVICES
Diagram – Database Selection
Application
   |
   +--> RDS / Azure SQL  ---> Relational (ACID)
   |
   +--> DynamoDB / Cosmos ---> NoSQL (Scale)
   |
   +--> Redshift / Synapse -> Analytics
Explanation:

Choose based on access pattern

OLTP vs OLAP separation
-----------------------------
8. MONITORING & LOGGING
Diagram – Observability Flow
App / VM / Service
        |
        v
 Metrics + Logs
        |
        v
 CloudWatch / Azure Monitor
        |
        v
 Alerts / Dashboards
Explanation:

Metrics for health

Logs for debugging

Alerts for action
-------------------------
9. SECURITY SERVICES
WAF
Definition: Web Application Firewall. Usage: Protect web apps.

Shield (AWS) / DDoS Protection (Azure)
Definition: DDoS mitigation. Usage: Availability protection.

KMS / Key Vault
Definition: Key management. Usage: Encryption.

Secrets Manager (AWS) / Key Vault Secrets
Definition: Secret storage. Usage: Secure credentials.
------------------------
10. DEVOPS & AUTOMATION
CloudFormation (AWS) / ARM / Bicep (Azure)
Definition: Infrastructure as Code. Usage: Automated provisioning.

CodePipeline / Azure DevOps
Definition: CI/CD tools. Usage: Automated deployment.
---------------------------
11. MESSAGING & INTEGRATION
Diagram – Async Communication
Producer
   |
   v
 Queue / Topic
   |
   v
 Consumer(s)
Explanation:

Decouples services

Improves resilience
---------------------------
12. GOVERNANCE & COST
CloudWatch Billing / Cost Explorer (AWS)
Azure Cost Management
Usage: Cost tracking & optimization.

Organizations (AWS) / Management Groups (Azure)
Usage: Multi‑account governance.
-------------------------
13. COMMON ARCHITECTURE MAPPING (MENTAL MODEL)
AWS: Account → VPC → Subnet → EC2 → Security Group

Azure: Subscription → Resource Group → VNet → Subnet → VM → NSG




