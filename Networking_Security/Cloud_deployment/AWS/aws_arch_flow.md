## Key Architecture Diagram

```mermaid
flowchart TD
    %% Internet Layer
    User[User / Client] --> Route53[Route 53 DNS]
    Route53 --> WAF[WAF + Shield]

    %% VPC Layer
    subgraph VPC["VPC: 10.0.0.0/16"]
        subgraph PublicSubnets["Public Subnets"]
            ALB[Application Load Balancer]
            IGW[Internet Gateway]
        end

        subgraph PrivateAppSubnets["Private App Subnets"]
            EC2App1[EC2 AZ1]
            EC2App2[EC2 AZ2]
            NAT[NAT Gateway]
        end

        subgraph PrivateDBSubnets["Private DB Subnets"]
            RDSPrimary[RDS Primary AZ1]
            RDSStandby[RDS Standby AZ2]
            RDSPrimary --> RDSStandby
        end
    end

    %% Connect Public to Private
    WAF --> ALB
    ALB --> EC2App1
    ALB --> EC2App2
    ALB --> IGW

    %% IAM Roles
    IAMRole[IAM Role] --> EC2App1
    IAMRole --> EC2App2

    %% Systems Manager
    Admin[Admin Console/CLI] --> AWS_SSM[AWS Systems Manager]
    AWS_SSM --> SSMAgent1[SSM Agent AZ1]
    AWS_SSM --> SSMAgent2[SSM Agent AZ2]
    SSMAgent1 --> EC2App1
    SSMAgent2 --> EC2App2

    %% Storage
    EC2App1 --> EBS1[EBS Volume AZ1]
    EC2App2 --> EBS2[EBS Volume AZ2]
    EC2App1 --> S3[S3 Bucket]
    EC2App2 --> S3
    EC2App1 --> EFS[EFS Shared File Storage]
    EC2App2 --> EFS
    EBS1 --> S3Backup["S3 - EBS Snapshots"]
    EBS2 --> S3Backup

    %% Monitoring
    EC2App1 --> CloudWatchA[CloudWatch Metrics]
    EC2App2 --> CloudWatchB[CloudWatch Metrics]
    RDSPrimary --> CloudWatchRDS[CloudWatch RDS Metrics]

    %% EC2 Launch Sequence
    LaunchTemplate[Launch Template / ASG] --> EC2App1
    LaunchTemplate --> EC2App2
    EC2App1 -->|User Data / Bootstrapping| AppStart1[Application Startup]
    EC2App2 -->|User Data / Bootstrapping| AppStart2[Application Startup]
