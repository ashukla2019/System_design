# AWS Complete Architecture with Storage, SSM, and 5-Step Sequencing

---

## Notes
- Step 1: User traffic enters via Route 53 and is filtered by WAF + Shield, reaching ALB.  
- Step 2: ALB distributes requests to EC2 instances in private subnets.  
- Step 3: Admin sends commands via SSM; EC2 processes commands with IAM role + IMDS credentials.  
- Step 4: EC2 reads/writes data to storage: EBS (attached), EFS (shared), S3 (static content/backups/logs).  
- Step 5: CloudWatch collects metrics and logs for EC2 and RDS; auditing and monitoring occur.  

---

## Architecture Diagram with 5 Steps

```mermaid
flowchart TD
    %% Step 1: User Traffic
    User[Step 1: User / Client] --> Route53[Route 1: Route 53 DNS]
    Route53 --> WAF[Step 1: WAF + Shield]
    WAF --> ALB[Step 1: Application Load Balancer]

    %% VPC Layer
    subgraph VPC["VPC: 10.0.0.0/16"]
        %% Public Subnets
        subgraph PublicSubnets["Public Subnets"]
            ALB
            IGW[Internet Gateway]
            ALB --> IGW
        end

        %% Private App Subnets
        subgraph PrivateAppSubnets["Private App Subnets"]
            EC2_1[Step 2: EC2 AZ1 with SSM Agent]
            EC2_2[Step 2: EC2 AZ2 with SSM Agent]
            NAT[NAT Gateway]
            EC2_1 --> NAT
            EC2_2 --> NAT
        end

        %% Private DB Subnets
        subgraph PrivateDBSubnets["Private DB Subnets"]
            RDSPrimary[RDS Primary AZ1]
            RDSStandby[RDS Standby AZ2]
            RDSPrimary --> RDSStandby
        end
    end

    %% IAM and IMDS for EC2
    IAMRole[IAM Role attached to EC2] --> IMDS[Instance Metadata Service (IMDS)]
    IMDS --> EC2_1
    IMDS --> EC2_2

    %% Step 3: Admin via SSM
    Admin[Step 3: Admin Console / CLI] -->|Send Command| AWS_SSM[Step 3: AWS Systems Manager]
    AWS_SSM -->|Command Delivery| EC2_1
    AWS_SSM -->|Command Delivery| EC2_2

    %% Step 4: Storage Access
    EBS1[EBS Volume AZ1] -->|Attach & Read/Write| EC2_1
    EBS2[EBS Volume AZ2] -->|Attach & Read/Write| EC2_2

    EFS[EFS Shared File System] -->|Mount & Read/Write| EC2_1
    EFS -->|Mount & Read/Write| EC2_2

    S3_Static[S3 Bucket for Static Content / Backups] -->|Read/Write via SDK/API| EC2_1
    S3_Static -->|Read/Write via SDK/API| EC2_2

    EC2_1 -->|Send Logs/Output| CloudWatch[Step 5: CloudWatch Logs / Metrics]
    EC2_2 -->|Send Logs/Output| CloudWatch
    EC2_1 -->|Send Logs/Output| S3[S3 Bucket for Logs]
    EC2_2 -->|Send Logs/Output| S3

    %% Step 2: EC2 Launch Sequence
    LaunchTemplate[Launch Template / ASG] --> EC2_1
    LaunchTemplate --> EC2_2
    EC2_1 -->|User Data / Bootstrapping| AppStart1[Application Startup]
    EC2_2 -->|User Data / Bootstrapping| AppStart2[Application Startup]

    %% Monitoring RDS
    RDSPrimary --> CloudWatch
