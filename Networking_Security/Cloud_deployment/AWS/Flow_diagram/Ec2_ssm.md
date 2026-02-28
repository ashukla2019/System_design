# AWS SSM Communication Notes and Architecture

## Notes
1. Each EC2 instance runs the **SSM Agent**, which communicates securely with AWS Systems Manager.
2. EC2 instances must have an **IAM Role** attached with permissions to use SSM and access AWS services (S3, CloudWatch).
3. Admins can send commands, run scripts, or manage instances via **AWS Systems Manager Console or CLI**.
4. No SSH access or public IP is required; all communication is over the SSM-managed channel.
5. Logs and outputs from commands are sent to **CloudWatch** or **S3** for auditing and monitoring.
6. EC2 instances retrieve temporary credentials via **IMDS** (Instance Metadata Service) for accessing AWS services securely.

## Architecture Diagram

```mermaid
flowchart TD
    %% Admin sends commands
    Admin["Admin Console or CLI"] --> AWS_SSM["AWS Systems Manager"]

    %% EC2 Instances
    subgraph EC2_Instances["EC2 Instances"]
        EC2_1["EC2 AZ1 with SSM Agent"]
        EC2_2["EC2 AZ2 with SSM Agent"]
    end

    %% IAM Role and IMDS
    IAMRole["IAM Role attached to EC2"] --> IMDS["Instance Metadata Service IMDS"]
    IMDS --> EC2_1
    IMDS --> EC2_2

    %% SSM Communication
    AWS_SSM --> EC2_1
    AWS_SSM --> EC2_2

    %% Logging and Monitoring
    EC2_1 --> S3["S3 Bucket for Logs"]
    EC2_1 --> CloudWatch["CloudWatch Logs and Metrics"]
    EC2_2 --> S3
    EC2_2 --> CloudWatch
