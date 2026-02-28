# AWS SSM Communication Notes and Architecture

## Notes
- Each EC2 instance runs the **SSM Agent**, which communicates securely with AWS Systems Manager.
- EC2 instances must have an **IAM Role** attached with permissions to use SSM and access AWS services (S3, CloudWatch).
- Admins can send commands, run scripts, or manage instances via **AWS Systems Manager Console or CLI**.
- No SSH access or public IP is required; all communication is over the SSM-managed channel.
- Logs and outputs from commands are sent to **CloudWatch** or **S3** for auditing and monitoring.
- EC2 instances retrieve temporary credentials via **IMDS** (Instance Metadata Service) for accessing AWS services securely.

## Architecture Diagram with Sequencing

```mermaid
flowchart TD
    %% Step 1: Admin sends command
    Admin["1️⃣ Admin Console / CLI"] -->|Step 1: Send Command| AWS_SSM["2️⃣ AWS Systems Manager"]

    %% EC2 Instances
    subgraph EC2_Instances["EC2 Instances"]
        EC2_1["3️⃣ EC2 AZ1 with SSM Agent"]
        EC2_2["3️⃣ EC2 AZ2 with SSM Agent"]
    end

    %% IAM Role and IMDS
    IAMRole["IAM Role attached to EC2"] --> IMDS["IMDS (Instance Metadata Service)"]
    IMDS --> EC2_1
    IMDS --> EC2_2

    %% Step 2: SSM delivers command
    AWS_SSM -->|Step 2: Command Delivery| EC2_1
    AWS_SSM -->|Step 2: Command Delivery| EC2_2

    %% Step 3: Logging and monitoring
    EC2_1 -->|Step 3: Logs/Output| S3["S3 Bucket for Logs"]
    EC2_1 -->|Step 3: Logs/Output| CloudWatch["CloudWatch Logs / Metrics"]
    EC2_2 -->|Step 3: Logs/Output| S3
    EC2_2 -->|Step 3: Logs/Output| CloudWatch
