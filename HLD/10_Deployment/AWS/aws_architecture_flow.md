── Part VIII – Detailed 5-Step AWS Architecture Flow
│
├── Step 1: User Traffic Entry & Filtering
│
│   ├── Users/Clients
│   │   → Initiate requests (web, API, mobile apps)
│   │
│   ├── DNS Resolution
│   │   → Route 53 resolves domain to ALB endpoint
│   │
│   ├── Traffic Filtering
│   │   → AWS WAF and AWS Shield inspect requests
│   │
│   └── Request Handling
│       → Requests reach ALB for Layer 7 routing, SSL termination, and health checks
│
├── Step 2: EC2 Request Distribution & Auto Scaling
│
│   ├── Load Balancing
│   │   → ALB forwards requests to EC2 instances in private subnets
│   │
│   ├── Auto Scaling
│   │   → Auto Scaling Group adjusts EC2 count based on demand
│   │
│   └── Launch Configuration
│       → EC2 launched using Launch Template with AMI, Security Groups, IAM Role, bootstrapping scripts
│
├── Step 3: Admin Access via SSM & IAM/IMDS
│
│   ├── SSM Agent on EC2
│   │   → Communicates with AWS Systems Manager
│   │
│   ├── Admin Commands
│   │   → Sent via SSM Console or CLI
│   │
│   ├── Credential Handling
│   │   → EC2 uses IAM Role + IMDS to retrieve temporary credentials
│   │
│   └── Logging
│       → Logs and outputs sent to CloudWatch or S3
│
├── Step 4: EC2 Storage Interactions
│
│   ├── EBS
│   │   → Block storage attached to EC2; snapshots can go to S3
│   │
│   ├── EFS
│   │   → Shared file system mounted on multiple EC2 instances
│   │
│   └── S3
│       → Object storage for static content, backups, logs; accessed via SDK/API
│
├── Step 5: Monitoring, Logging & Auditing
│
│   ├── CloudWatch Metrics
│   │   → Collects metrics from EC2, RDS, ALB, and custom apps
│   │
│   ├── CloudWatch Logs
│   │   → Receives app/system logs; S3 stores long-term logs
│   │
│   ├── RDS Monitoring
│   │   → Tracks CPU, connections, IOPS
│   │
│   └── CloudTrail
│       → Audits admin and API actions