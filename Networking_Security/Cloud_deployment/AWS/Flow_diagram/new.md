# AWS Complete Architecture with Storage & SSM

---

## Notes
- EC2 Instances run applications in private subnets and retrieve credentials via IMDS using attached IAM Roles.
- ALB distributes traffic across EC2 instances in multiple AZs.
- RDS is deployed in Multi-AZ mode for high availability.
- SSM allows admin access without SSH or public IP.
- EBS is block storage attached to specific EC2 instances.
- EFS is shared file storage accessible by multiple EC2 instances.
- S3 is object storage used for static content, backups, and logs.
- CloudWatch monitors EC2 and RDS metrics.

---

## Architecture Diagram

```mermaid
flowchart TD
    %% Internet Layer
    User[User / Client] --> Route53[Route 53 DNS]
    Route53 --> WAF[WAF + Shield]
    WAF --> ALB[Application Load Balancer]

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
            EC2_1[EC2 AZ1 with SSM Agent]
            EC2_2[EC2 AZ2 with SSM Agent]
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

    %% IAM and IMDS
    IAMRole[IAM Role attached to EC2] --> IMDS[Instance Metadata Service - IMDS]
    IMDS --> EC2_1
    IMDS --> EC2_2

    %% SSM Communication
    Admin[Step 1: Admin Console / CLI] -->|Send Command| AWS_SSM[Step 2: AWS Systems Manager]
    AWS_SSM -->|Command Delivery| EC2_1
    AWS_SSM -->|Command Delivery| EC2_2
    EC2_1 -->|Logs/Output| CloudWatch[CloudWatch Logs / Metrics]
    EC2_2 -->|Logs/Output| CloudWatch
    EC2_1 -->|Logs/Output| S3[S3 Bucket for Logs]
    EC2_2 -->|Logs/Output| S3

    %% Storage
    EBS1[EBS Volume AZ1] -->|Attach| EC2_1
    EBS2[EBS Volume AZ2] -->|Attach| EC2_2
    EC2_1 -->|Read/Write| EBS1
    EC2_2 -->|Read/Write| EBS2

    EFS[EFS Shared File System] -->|Mount| EC2_1
    EFS -->|Mount| EC2_2
    EC2_1 -->|Read/Write| EFS
    EC2_2 -->|Read/Write| EFS

    S3_Static[S3 Bucket for Static Content/Backups] -->|Read/Write via SDK/API| EC2_1
    S3_Static -->|Read/Write via SDK/API| EC2_2

    %% EC2 Launch Sequence
    LaunchTemplate[Launch Template / ASG] --> EC2_1
    LaunchTemplate --> EC2_2
    EC2_1 -->|User Data / Bootstrapping| AppStart1[Application Startup]
    EC2_2 -->|User Data / Bootstrapping| AppStart2[Application Startup]

    %% Monitoring
    EC2_1 --> CloudWatch
    EC2_2 --> CloudWatch
    RDSPrimary --> CloudWatch
