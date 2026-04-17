CONTROL PLANE (Management Layer)

Handles provisioning, configuration, authentication, and orchestration of resources.

User / Admin
   │
   ▼
Console / CLI / SDK
   │
   ▼
Identity & Access Layer
   │
   ├── AWS: IAM (Users / Roles / Policies)
   └── Azure: RBAC + Managed Identity
   │
   ▼
Authentication & Authorization
   │
   ├── AWS:
   │     ├── IAM validates permissions
   │     └── STS issues temporary credentials
   │
   └── Azure:
         ├── Entra ID validates identity
         └── Issues OAuth token (Managed Identity)
   │
   ▼
Service Control Planes
   │
   ├── Compute
   │     ├── AWS: EC2 Control Plane
   │     └── Azure: VM Control Plane
   │
   ├── Object Storage
   │     ├── AWS: S3 Control Plane
   │     └── Azure: Blob Control Plane
   │
   ├── Block Storage
   │     ├── AWS: EBS Control Plane
   │     └── Azure: Managed Disk Control Plane
   │
   ├── File Storage
   │     ├── AWS: EFS Control Plane
   │     └── Azure: Azure Files Control Plane
   │
   ├── Management
   │     ├── AWS: SSM Control Plane
   │     └── Azure: VM Agent / Run Command Control Plane
   │
   ▼
Resource Configuration
   │
   ├── VM created with:
   │     ├── IAM Role (AWS)
   │     └── Managed Identity (Azure)
   │
   ├── Storage attached (EBS / Managed Disk)
   ├── File system mounted (EFS / Azure Files)
   └── Object storage permissions configured
   │
   ▼
Placement Decision
(AZ / Host / Cluster selection)