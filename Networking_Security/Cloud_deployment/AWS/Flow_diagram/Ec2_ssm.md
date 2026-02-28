## SSM Communication

### Notes
- Each EC2 instance runs the **SSM Agent**, which communicates securely with AWS Systems Manager.
- EC2 instances must have an **IAM Role** attached with permissions to use SSM and access required AWS services (like S3 or CloudWatch).
- Admins can send commands, run scripts, or manage instances via **AWS Systems Manager Console or CLI**.
- No SSH access or public IP is needed; all communication is over the SSM-managed channel.
- Logs and outputs from commands can be sent to **CloudWatch** or **S3** for auditing and monitoring.

### Architecture Diagram with Sequencing

```mermaid
flowchart TD
    %% Step 1: Admin sends command
    Admin[Step 1: Admin Console / CLI] -->|Send Command| AWS_SSM[Step 2: AWS Systems Manager]

    %% Step 2: SSM communicates with EC2
    subgraph EC2_Instances["EC2 Instances"]
        EC2_1[Step 3: EC2 AZ1 with SSM Agent]
        EC2_2[Step 3: EC2 AZ2 with SSM Agent]
    end

    %% IAM Role grants permissions
    IAMRole[IAM Role attached to EC2] --> EC2_1
    IAMRole --> EC2_2

    %% Step 2 Communication
    AWS_SSM -->|Command Delivery| EC2_1
    AWS_SSM -->|Command Delivery| EC2_2

    %% Step 3: Logging
    EC2_1 -->|Logs/Output| CloudWatch[CloudWatch Logs / Metrics]
    EC2_2 -->|Logs/Output| CloudWatch
    EC2_1 -->|Logs/Output| S3[S3 Bucket for Logs]
    EC2_2 -->|Logs/Output| S3
