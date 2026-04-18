CONTROL PLANE (Management Layer)

Handles provisioning, configuration, authentication, and orchestration of resources.

```
Launch EC2 instance
Create S3 bucket
Attach IAM role
Configure security groups

Key Services
IAM → authentication & authorization
EC2 → compute provisioning APIs
S3 → storage management APIs


```

DATA PLANE (Execution Layer)

Handles actual workload execution, I/O operations, and runtime traffic.

```
1. Identity Usage:
Application layer → requests credentials via SDK (no auth logic inside app)
Metadata service (IMDS) → provides instance-bound identity
IAM / Entra ID layer → validates identity and issues token/temporary creds
STS / Token service → generates short-lived credentials (AWS creds / Azure OAuth token)
SDK layer → caches credentials + auto-refreshes
Signing layer → AWS SigV4 / Azure Bearer token added to every request
Transport layer → HTTPS call to services using signed identity
```