SSM Communication Flow
EC2 Instance Launch
│
├── Operating System Starts
│
├── SSM Agent Starts
│   ├── Runs inside the EC2 instance
│   └── Enables remote management without SSH or public IP
│
├── IAM Role Attached to EC2
│   ├── Instance has IAM Role
│   └── Policy: AmazonSSMManagedInstanceCore
│
├── Credential Retrieval
│   ├── SSM Agent requests temporary credentials
│   └── Retrieved from Instance Metadata Service (IMDS)
│
├── Agent Authentication
│   └── SSM Agent authenticates with AWS Systems Manager APIs
│
├── Agent Polling
│   ├── Agent periodically contacts Systems Manager
│   └── Checks if any command is available
│
├── Admin Interaction
│   ├── AWS Management Console
│   ├── AWS CLI
│   └── SDK / Automation tools
│
├── Command Stored
│   └── Systems Manager stores the command in the control plane
│
├── Command Retrieval
│   └── SSM Agent retrieves command during polling
│
├── Command Execution
│   └── Command executed inside EC2 operating system
│
└── Logging & Output
    ├── Output returned to Systems Manager
    └── Logs stored in CloudWatch Logs or Amazon S3