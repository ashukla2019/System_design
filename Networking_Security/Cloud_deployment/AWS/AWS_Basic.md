# AWS Fundamentals & Architecture Notes

---

# 📦 AWS Service Categories

## 🔹 Compute = “Who is doing the work?”

- EC2 → Virtual machine doing work  
- Lambda → Code doing work  
- ECS/EKS → Containers doing work  

👉 If CPU/RAM is involved → **Compute**

---

## 🔹 Storage = “Where is data kept?”

- S3 → Files, images, backups  
- EBS → Disk for EC2  
- EFS → Shared file system  

👉 If data survives after shutdown → **Storage**

---

## 🔹 Networking = “How things talk?”

- VPC → Private network  
- Subnet → Smaller network  
- Load Balancer → Traffic distributor  
- Route Table → Path rules  
- Internet Gateway → Internet access  

👉 If packets move → **Networking**

---

## 🔹 Database = “Structured storage”

- RDS → SQL tables  
- DynamoDB → Key-value  

👉 Specialized storage system

---

## 🔹 Security = “Who is allowed?”

- IAM → Permissions  
- Security Groups → Instance firewall  
- NACL → Subnet firewall  

---

## 🔹 Monitoring = “Who is watching?”

- CloudWatch → Metrics, logs  
- CloudTrail → API audit logs  

---

## ✅ Core Principle

> Compute runs  
> Storage stores  
> Networking connects  
> Security protects  
> Monitoring watches  

---

# 🌍 AWS Resource Hierarchy
Account
→ Region
→ VPC (network boundary)
→ Subnet (IP boundary)
→ EC2 (compute)
→ EBS (block disk)
→ S3 (regional object storage)
→ EFS (regional file system)

---

# ☁️ Cloud Fundamentals

## Deployment Models

- Public Cloud (AWS)
- Private Cloud (On-premise)
- Hybrid Cloud (Mix of both)

---

# 🏗 Cloud Service Models

Cloud service models define the level of control and responsibility in cloud computing.

### More Work → Left  
### Less Work → Right  
On-Prem → IaaS → PaaS → FaaS → BaaS → SaaS


---

## a) On-Prem — Everything is YOUR problem

### You manage:
- Hardware  
- OS  
- Network  
- Application  
- Security  

**Example:** Company data center  

**Memory:** “I do everything”

---

## b) IaaS — Infrastructure as a Service

### AWS provides:
- VM  
- Storage  
- Network  

### You manage:
- OS  
- Application  
- Patching  

### Examples:
- EC2  
- EBS  
- VPC  

**Memory:** “I manage OS”

---

## c) PaaS — Platform as a Service

### AWS manages:
- Hardware  
- OS  
- Runtime  

### You manage:
- Application code  
- Data  

### Examples:
- Elastic Beanstalk  
- App Runner  
- RDS  

**Memory:** “I only write app code”

---

## d) FaaS — Function as a Service

### AWS manages:
- Everything  

### You manage:
- Function logic  

### Example:
- Lambda  

**Memory:** “I write a function”

---

## e) BaaS — Backend as a Service

AWS provides ready-made backend services:

- Database  
- Authentication  
- Storage  

### Examples:
- DynamoDB  
- Cognito  
- S3  

**Memory:** “Backend is ready”

---

## f) SaaS — Software as a Service

Just use the software.

### Vendor manages:
- Everything  

### Examples:
- Gmail  
- Google Drive  
- Salesforce  
- Zoom  

**Memory:** “Just login and use”

---

# 🧠 Categorizing AWS Services

| Question | Category |
|----------|----------|
| Does it RUN code? | Compute |
| Does it STORE data? | Storage |
| Does it CONNECT systems? | Networking |
| Does it CONTROL access? | Security |
| Does it WATCH systems? | Monitoring |

---

# 🖥 Fleet Manager

Fleet Manager is a capability inside AWS Systems Manager that helps you:

- Manage EC2 instances  
- Manage on-prem servers  
- Manage virtual machines  
- View OS-level details  
- Perform remote actions (RDP/SSH from console)

AWS
└── AWS Systems Manager
└── Fleet Manager


---

## How Fleet Manager Works

Fleet Manager uses:

- SSM Agent installed on the instance  
- IAM role attached to the instance  
- Systems Manager service  

Communication happens over HTTPS.  
No need to open:
- SSH (22)
- RDP (3389)

---

# 🔧 What is SSM Agent?

SSM Agent is software installed on your EC2 instance or server.

It acts as:

> A communication bridge between your server and AWS Systems Manager.

### Responsibilities:
- Receives commands  
- Executes them  
- Sends output back to AWS  
- Enables Session Manager, Fleet Manager, Patch Manager  

Without SSM Agent → Systems Manager cannot control the instance.

### Installation:

- Pre-installed on most Amazon Linux & Windows AMIs  
- Manual install required on custom AMIs  
- Can run on on-prem servers  

---

# 🔐 IAM Role (for EC2)

IAM Role is the permission identity attached to an EC2 instance.

It provides:

- Temporary AWS credentials  
- Secure API access  
- Automatic credential rotation  

When attached:

- AWS generates temporary credentials  
- Instance can call AWS APIs securely  

---

# 🔑 Why IAM Role is Required for SSM

SSM Agent needs permission to:

- Register with Systems Manager  
- Send logs/output  
- Receive commands  
- Access Parameter Store / Secrets Manager  

Without IAM Role ❌  
SSM Agent cannot communicate with AWS.

---

# 📜 Required IAM Policy

Attach the AWS managed policy:
AmazonSSMManagedInstanceCore
This policy allows:
ssm:*
ec2messages:*
ssmmessages:*

----------------------
# Step by step communication flow:
🟢 Step 1 — Admin → Fleet Manager
Admin interacts with UI.

🟢 Step 2 — Fleet Manager → Systems Manager
Request sent to Systems Manager API.

🟢 Step 3 — SSM Agent Polling
SSM Agent already maintains outbound connection:
EC2 → Systems Manager (HTTPS 443)

It checks:
“Do you have any commands for me?”

🟢 Step 4 — Credential Retrieval
Before talking to Systems Manager:
SSM Agent → IMDS → Temporary IAM Credentials
IMDS gets credentials from attached IAM role.

🟢 Step 5 — Command Execution
SSM Agent:
Receives command
Executes locally
Sends output back

🟢 Step 6 — Output Flow
SSM Agent → Systems Manager → Fleet Manager → Admin
