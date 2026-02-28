## SSM Communication

### Notes
- Each EC2 instance runs the **SSM Agent**, which communicates securely with AWS Systems Manager.
- EC2 instances must have an **IAM Role** attached with permissions to use SSM and access required AWS services (like S3 or CloudWatch).
- Admins can send commands, run scripts, or manage instances via **AWS Systems Manager Console or CLI**.
- No SSH access or public IP is needed; all communication is over the SSM-managed channel.
- Logs and outputs from commands can be sent to **CloudWatch** or **S3** for auditing and monitoring.

### Architecture Diagram

```mermaid
flowchart TD
    %% Admin Interface
    Admin[Admin Console / CLI] --> AWS_SSM[AWS Systems Manager]

    %% EC2 Instances
    subgraph EC2_Instances["EC2 Instances"]
        EC2_1[EC2 AZ1 with SSM Agent]
        EC2_2[EC2 AZ2 with SSM Agent]
    end

    %% IAM Role
    IAMRole[IAM Role attached to EC2] --> EC2_1
    IAMRole --> EC2_2

    %% SSM Communication
    AWS_SSM --> EC2_1
    AWS_SSM --> EC2_2

    %% Logging
    EC2_1 --> CloudWatch[CloudWatch Logs / Metrics]
    EC2_2 --> CloudWatch
    EC2_1 --> S3[S3 Bucket for Logs]
    EC2_2 --> S3
