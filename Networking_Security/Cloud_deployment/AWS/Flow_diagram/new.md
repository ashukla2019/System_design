# AWS Complete Architecture – Notes & Diagram

---

## Detailed Notes – 5-Step Architecture Flow

- **Step 1: User Traffic Entry & Filtering**  
  - Users/clients initiate requests (web, API, mobile apps).  
  - Route 53 resolves DNS to the ALB endpoint.  
  - Traffic passes through AWS WAF (blocks attacks) and AWS Shield (DDoS protection).  
  - Requests reach Application Load Balancer (ALB) for Layer 7 routing, SSL termination, and health checks.

- **Step 2: EC2 Request Distribution & Auto Scaling**  
  - ALB forwards requests to EC2 instances in private subnets.  
  - Auto Scaling Group (ASG) adjusts the number of EC2s based on load.  
  - EC2 instances launched via Launch Template with AMI, Security Groups, IAM Role, and bootstrapping scripts.

- **Step 3: Admin Access via SSM & IAM/IMDS**  
  - EC2 runs SSM Agent to communicate securely with AWS Systems Manager.  
  - Admin sends commands through SSM Console/CLI (no SSH or public IP needed).  
  - EC2 uses IAM Role + IMDS (Instance Metadata Service) to get temporary credentials for AWS services.  
  - Logs and outputs from commands are sent to CloudWatch or S3.

- **Step 4: EC2 Storage Interactions**  
  - **EBS:** Block storage attached to EC2, used for OS and application data; snapshots can go to S3.  
  - **EFS:** Shared file system mounted on multiple EC2s across AZs.  
  - **S3:** Object storage for static content, backups, and logs; accessed via SDK/API with IAM Role.

- **Step 5: Monitoring, Logging & Auditing**  
  - CloudWatch collects metrics from EC2, RDS, ALB, and custom apps.  
  - CloudWatch Logs receive application/system logs; S3 can store long-term logs.  
  - RDS metrics monitored (CPU, connections, IOPS, failovers).  
  - CloudTrail audits admin and API actions for security and compliance.

---

## Architecture Diagram (Mermaid)

```mermaid
flowchart TD
    %% Step 1: User Traffic Entry
    User(User / Client - Step 1) --> Route53(Route 53 DNS)
    Route53 --> WAF(AWS WAF + Shield)
    WAF --> ALB(Application Load Balancer)

    %% VPC Layer
    subgraph VPC["VPC: 10.0.0.0/16"]
        %% Public Subnets
        subgraph PublicSubnets["Public Subnets"]
            ALB
            IGW(Internet Gateway)
            ALB --> IGW
        end

        %% Private App Subnets
        subgraph PrivateAppSubnets["Private App Subnets"]
            EC2_1(EC2 AZ1 with SSM Agent - Step 2)
            EC2_2(EC2 AZ2 with SSM Agent - Step 2)
            NAT(NAT Gateway)
            EC2_1 --> NAT
            EC2_2 --> NAT
        end

        %% Private DB Subnets
        subgraph PrivateDBSubnets["Private DB Subnets"]
            RDSPrimary(RDS Primary AZ1)
            RDSStandby(RDS Standby AZ2)
            RDSPrimary --> RDSStandby
        end
    end

    %% IAM and IMDS for EC2
    IAMRole(IAM Role attached to EC2) --> IMDS(IMDS)
    IMDS --> EC2_1
    IMDS --> EC2_2

    %% Step 3: Admin via SSM
    Admin(Admin Console / CLI - Step 3) -->|Send Command| AWS_SSM(AWS Systems Manager)
    AWS_SSM -->|Command Delivery| EC2_1
    AWS_SSM -->|Command Delivery| EC2_2

    %% Step 4: Storage Access
    EBS1(EBS Volume AZ1) -->|Attach & Read/Write| EC2_1
    EBS2(EBS Volume AZ2) -->|Attach & Read/Write| EC2_2

    EFS(EFS Shared File System) -->|Mount & Read/Write| EC2_1
    EFS -->|Mount & Read/Write| EC2_2

    S3_Static(S3 Bucket - Static Content/Backups) -->|Read/Write via SDK/API| EC2_1
    S3_Static -->|Read/Write via SDK/API| EC2_2

    %% Step 5: Logging & Monitoring
    EC2_1 -->|Send Logs/Output| CloudWatch(CloudWatch Logs / Metrics)
    EC2_2 -->|Send Logs/Output| CloudWatch
    EC2_1 -->|Send Logs/Output| S3(S3 Bucket for Logs)
    EC2_2 -->|Send Logs/Output| S3

    %% EC2 Launch Sequence
    LaunchTemplate(Launch Template / ASG) --> EC2_1
    LaunchTemplate --> EC2_2
    EC2_1 -->|User Data / Bootstrapping| AppStart1(Application Startup)
    EC2_2 -->|User Data / Bootstrapping| AppStart2(Application Startup)

    %% Monitoring RDS
    RDSPrimary --> CloudWatch
