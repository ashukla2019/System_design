                                                ┌────────────────────────────┐
                                                │         End Users           │
                                                └──────────────┬─────────────┘
                                                               │
                                                               ▼
                                                     ┌─────────────────┐
                                                     │  Route 53 (DNS) │
                                                     └────────┬────────┘
                                                              │
                                                              ▼
                                           ┌──────────────────────────────┐
                                           │ AWS Shield + AWS WAF         │
                                           └──────────────┬───────────────┘
                                                          │
                                                          ▼
                                           ┌──────────────────────────────┐
                                           │ Application Load Balancer    │
                                           │ (Public Subnet - AZ1 & AZ2)  │
                                           └──────────────┬───────────────┘
                                                          │
                         ┌────────────────────────────────┴────────────────────────────────┐
                         ▼                                                                 ▼
            ┌────────────────────────┐                                   ┌────────────────────────┐
            │  EC2 Instance (AZ1)    │                                   │  EC2 Instance (AZ2)    │
            │  Private Subnet        │                                   │  Private Subnet        │
            │  Auto Scaling Group    │                                   │  Auto Scaling Group    │
            │  IAM Role Attached     │                                   │  IAM Role Attached     │
            │  SSM Agent Installed   │                                   │  SSM Agent Installed   │
            └──────────────┬─────────┘                                   └──────────────┬─────────┘
                           │                                                               │
                           │                                                               │
                ┌──────────┴──────────┐                                        ┌──────────┴──────────┐
                │ EBS Volume          │                                        │ EBS Volume          │
                │ (Encrypted via KMS) │                                        │ (Encrypted via KMS) │
                └──────────┬──────────┘                                        └──────────┬──────────┘
                           │                                                               │
                           └──────────────────────────────┬────────────────────────────────┘
                                                          ▼
                                           ┌──────────────────────────────┐
                                           │ RDS Primary (Multi-AZ)       │
                                           │ Private Subnet               │
                                           │ Encrypted (KMS)              │
                                           └──────────────┬───────────────┘
                                                          │
                                                          ▼
                                           ┌──────────────────────────────┐
                                           │ RDS Standby / Read Replica   │
                                           │ Secondary AZ                 │
                                           └──────────────────────────────┘


STATIC CONTENT:
EC2 ↔ S3 (via IAM Role + VPC Endpoint)

────────────────────────────────────────────────────────────────────────

NETWORK LAYER (Inside VPC)

VPC (CIDR 10.0.0.0/16)
│
├── Public Subnet (AZ1, AZ2)
│     ├── ALB
│     └── NAT Gateway
│
├── Private App Subnet (AZ1, AZ2)
│     └── EC2 Instances
│
├── Private DB Subnet
│     └── RDS
│
├── Internet Gateway (Attached to VPC)
│
└── VPC Endpoints
      ├── S3 Endpoint
      └── Systems Manager Endpoint

────────────────────────────────────────────────────────────────────────

SYSTEMS MANAGER (NO SSH MODEL)

Admin (Console / CLI)
        │
        ▼
AWS Systems Manager
        │  (HTTPS 443 outbound only)
        ▼
SSM Agent inside EC2
        │
        ▼
OS Command Execution
        │
        ▼
Logs → S3 / CloudWatch

(No Port 22, No Bastion, No Public IP required)

────────────────────────────────────────────────────────────────────────

IAM ARCHITECTURE

IAM Role Attached to EC2:
    ├── S3 Access Policy
    ├── CloudWatch Logs Policy
    ├── SSM Managed Instance Policy
    └── KMS Decrypt Permissions

IAM enforces least privilege.

────────────────────────────────────────────────────────────────────────

MONITORING & LOGGING

CloudWatch:
    ├── Metrics (CPU, Memory)
    ├── Logs
    ├── Alarms
    └── Dashboards

CloudTrail:
    └── API auditing

────────────────────────────────────────────────────────────────────────

CI/CD FLOW

Developer
   │
   ▼
CodeCommit → CodeBuild → CodeDeploy → EC2 Auto Scaling Group

────────────────────────────────────────────────────────────────────────

DISASTER RECOVERY

Multi-AZ Deployment
RDS Automatic Failover
S3 Cross-Region Replication
Route 53 Failover Routing
Snapshots Stored in S3

────────────────────────────────────────────────────────────────────────

SECURITY LAYERS SUMMARY

Layer 1: Shield (DDoS)
Layer 2: WAF (Application Firewall)
Layer 3: Security Groups (Instance Firewall)
Layer 4: NACL (Subnet Firewall)
Layer 5: IAM (Identity)
Layer 6: KMS (Encryption)
Layer 7: SSM (Secure Access)

------------------------------------------------------------------------------------------------
FULL END-TO-END WORKING FLOW
1️⃣ User Access

User → Route 53 → WAF/Shield → ALB

2️⃣ Load Balancing

ALB distributes traffic across EC2 in multiple AZs.

3️⃣ Application Processing

EC2:

Uses IAM Role (temporary credentials)

Reads/Writes to S3

Connects to RDS

Sends logs to CloudWatch

4️⃣ Database

RDS:

Primary handles writes

Standby for failover

Encrypted with KMS

5️⃣ Systems Manager

Admin executes command:
Console → SSM → EC2 Agent → Command runs → Logs stored

6️⃣ Monitoring

CloudWatch monitors health.
Alarms trigger scaling or notifications.
