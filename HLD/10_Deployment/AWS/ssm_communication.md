# AWS Systems Manager (SSM) – Single Diagram Flow

```text
Admin / User
(Console / CLI / SDK / Automation)
   │
   ▼
AWS Systems Manager (Control Plane)
   │
   ▼
SSM Agent (polling from EC2)
   │
   ▼
EC2 Instance (Command Execution / Session)
   │
   ▼
Operating System / Applications
   │
   ▼
Output & Logs
   │
   ▼
CloudWatch Logs / Amazon S3

Admin / User: Sends a command or session request using Console, CLI, SDK, or automation tools.
Systems Manager Control Plane: Stores commands and manages communication with EC2 instances.
SSM Agent: Runs on EC2, polls Systems Manager for commands, authenticates using IAM role credentials retrieved via IMDS.
EC2 Instance Execution: Commands or sessions are executed locally on the instance—no SSH or public IP required.
Output & Logging: Results are returned to Systems Manager and optionally logged to CloudWatch Logs or Amazon S3.
