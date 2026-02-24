Cloud Fundamentals
    Deployment Models: Public (AWS), Private (on-premise), and Hybrid (mix of both).
    Service Models:
      Cloud service models define what level of control and responsibility you get when using cloud computing. The three core models are IaaS, PaaS, 
      and SaaS (with some modern extensions).

Cloud Service Models:
More work → left
Less work → right

On-Prem → IaaS → PaaS → FaaS → BaaS → SaaS
  a) On-Prem (Everything is YOUR problem )
    You manage:
    Hardware
    OS
    Network
    App
    Security

    Example
    Company data center

    Memory: “I do everything”
------------------------
  b) IaaS — Infrastructure as a Service
    AWS gives:
    VM
    Storage
    Network
    
    You manage:
    OS
    App
    Patching

    Examples
    EC2
    EBS
    VPC
    Memory: “I manage OS”
-------------------------
  c) PaaS — Platform as a Service
    AWS manages:
    Hardware
    OS
    Runtime

    You manage:
    App code
    Data

    Examples
    Elastic Beanstalk
    
    App Runner
    RDS
    
    Memory: “I only write app code”
-----------------------------

   d) FaaS — Function as a Service
    AWS manages:
    Everything
    
    You manage:
    Function logic
    
    Example
    Lambda
    
    Memory: “I write a function”
------------------------
  e) BaaS — Backend as a Service
    AWS gives ready-made backend services:

    Database
    Auth
    Storage
    
    Examples
    DynamoDB
    Cognito
    S3
    
    Memory: “Backend is ready”
------------------------

f) SaaS — Software as a Service
  Just use the software

    AWS (or vendor) manages:
    Everything
    
    Examples
    Gmail
    Google Drive
    Salesforce
    Zoom
    
    Memory: “Just login and use”
---------------------------
Does it RUN code?      → Compute
Does it STORE data?   → Storage
Does it CONNECT?      → Networking
Does it CONTROL access? → Security
Does it WATCH things? → Monitoring

Map AWS services to these jobs:
a) Compute = “Who is doing the work?”
EC2 → Virtual machine doing work
Lambda → Code doing work
ECS/EKS → Containers doing work

If CPU/RAM involved → Compute
----------------------------------------------------------------------
b) Storage = “Where is data kept?”
S3 → Files, images, backups
EBS → Disk for EC2
EFS → Shared folder

If data survives after shutdown → Storage
------------------------------------------------------------------------------
c) Networking = “How things talk?”
VPC → Private network
Subnet → Smaller network
Load Balancer → Traffic distributor
Route table → Path rules
Internet Gateway → Internet access

If packets move → Networking
-------------------------------------------------------------------------------
d) Database = “Structured storage”
RDS → SQL tables
DynamoDB → Key-value
(Still storage, but specialized)
-------------------------------------------------------------------------------
e) Security = “Who is allowed?”
IAM → Permissions
Security Groups → Firewall
NACL → Network firewall
--------------------------------------------------------------------------
f) Monitoring = “Who is watching?”
CloudWatch → Metrics, logs
CloudTrail → Audit logs

Compute runs, Storage stores, Networking connects, Security protects, Monitoring watches

------------------------------

What is Fleet Manager?

Fleet Manager is a capability inside AWS Systems Manager that helps you:

Manage EC2 instances
Manage on-prem servers
Manage virtual machines
View OS-level details
Perform remote actions (like RDP/SSH from console)

AWS
 └── AWS Systems Manager
       └── Fleet Manager

How It Works

Fleet Manager works using:

SSM Agent installed on instance

IAM roles attached to instance

Systems Manager service

Communication happens over HTTPS — no need to open SSH (22) or RDP (3389) ports.
----------------------
What is SSM Agent?

SSM Agent is a software installed on your EC2 instance or server.

It acts like:
A communication bridge between your server and AWS Systems Manager.

What it does:

Receives commands from Systems Manager
Executes them on the instance
Sends output back to AWS
Enables Session Manager, Fleet Manager, Patch Manager, etc.

Without SSM Agent → Systems Manager cannot control the instance.

Where it runs
Installed by default on most Amazon Linux & Windows AMIs
Must be installed manually on custom AMIs
Can also run on on-prem servers
---------------------
2️⃣ What is IAM Role (for EC2)?

IAM Role is the permission identity attached to an EC2 instance.

Think of it like:

Temporary AWS credentials given to the instance.

When you attach a role to EC2:

AWS automatically provides temporary credentials

Instance can securely call AWS APIs

3️⃣ Why IAM Role is Required for SSM
SSM Agent needs permission to:
Register with Systems Manager
Send logs/output
Get commands
Access Parameter Store / Secrets Manager

If no IAM role is attached ❌
→ SSM Agent cannot talk to AWS.

4️⃣ Required IAM Policy

Usually you attach this AWS managed policy:

👉 AmazonSSMManagedInstanceCore

This policy allows:

ssm:*

ec2messages:*

ssmmessages:*

Since you're learning AWS architecture deeply, we can go internal level next.
