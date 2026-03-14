Part VII – SSM Communication

├── EC2 Instance Launch
│   → Instance starts the operating system
│
├── SSM Agent Starts
│   → SSM Agent runs inside the EC2 instance
│   → Enables remote management without SSH or public IP
│
├── IAM Role Attached to EC2
│   → Instance has IAM role: AmazonSSMManagedInstanceCore
│   → Grants permission to communicate with AWS Systems Manager
│
├── Credential Retrieval
│   → SSM Agent requests temporary credentials
│   → Retrieved from Instance Metadata Service (IMDS)
│
├── Agent Authentication
│   → Using temporary credentials, SSM Agent authenticates with
│     AWS Systems Manager APIs
│
├── Agent Polling
│   → SSM Agent periodically checks Systems Manager
│   → Asks if any command is available for this instance
│
├── Admin Interaction
│   → Admin sends command using:
│     • AWS Management Console
│     • AWS CLI
│     • SDK / automation tools
│
├── Command Retrieval
│   → Systems Manager stores the command
│   → SSM Agent retrieves it during polling
│
├── Command Execution
│   → SSM Agent executes the command inside the EC2 operating system
│
└── Logging & Output
    → Execution results returned to Systems Manager
    → Logs stored in CloudWatch Logs or Amazon S3
