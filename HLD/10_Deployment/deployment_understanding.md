# Cloud Architecture Journey: From Local Application to Serverless

## Example Application

Suppose you build a backup application:

```python
# backup.py
```

The application is just code.

The real question is:

**Where will this code run?**

---

# Complete Infrastructure Hierarchy

Every modern cloud deployment ultimately sits on top of the following hierarchy:

```text
Data Center
      ↓
Physical Server
      ↓
Hypervisor
      ↓
Virtual Machine (VM)
      ↓
Operating System
      ↓
Container Runtime (Docker)
      ↓
Containers
      ↓
Kubernetes
      ↓
Application
```

---

# Data Center

A data center is a building that contains:

- Power systems
- Cooling systems
- Networking equipment
- Thousands of physical servers

## Examples

- AWS Data Centers
- Azure Data Centers
- Google Cloud Data Centers

---

# Physical Server

A physical server is an actual computer.

```text
Physical Server
 ├─ CPU
 ├─ RAM
 ├─ Disk
 └─ Network Card
```

## Example Configuration

- 256 CPU Cores
- 1 TB RAM
- 10 TB SSD

---

# Hypervisor

A hypervisor divides a physical server into multiple Virtual Machines.

## Examples

- VMware ESXi
- Hyper-V
- KVM

```text
Physical Server
      ↓
Hypervisor
      ↓
VM1
VM2
VM3
VM4
```

---

# Virtual Machine (VM)

A VM behaves like a complete computer.

## Examples

- AWS EC2
- Azure VM

```text
Physical Server
      ↓
Hypervisor
      ↓
VM
```

Inside the VM:

```text
VM
 ├─ Virtual CPU
 ├─ Virtual RAM
 └─ Virtual Disk
```

---

# Operating System

The VM runs an operating system.

```text
VM
 └─ Linux
```

or

```text
VM
 └─ Windows
```

---

# Docker

Docker is software installed on the OS.

```text
VM
 └─ Linux
      ↓
    Docker
```

Docker creates and manages containers.

---

# Containers

Containers package:

- Application
- Runtime
- Dependencies
- Libraries

```text
Docker
 ├─ Container A
 ├─ Container B
 └─ Container C
```

---

# Kubernetes

Kubernetes manages containers.

## Responsibilities

- Scheduling
- Scaling
- Networking
- Self-healing
- Rolling updates

```text
Kubernetes
 ├─ Pod A
 ├─ Pod B
 └─ Pod C
```

Kubernetes itself runs on VMs.

```text
VM
 └─ Kubernetes Node
      └─ Containers
```
```
Data Center
│
├─ Power Systems
├─ Cooling Systems
├─ Network Infrastructure
│   ├─ Routers
│   ├─ Switches
│   └─ Cables
│
└─ Physical Servers
    │
    ├─ CPU
    ├─ RAM
    ├─ Disk (SSD/HDD)
    ├─ Network Interface Card (NIC)
    │
    └─ Hypervisor
        │
        ├─ Control Plane VM(s)
        │   │
        │   └─ Operating System (Linux)
        │       │
        │       └─ Kubernetes Control Plane
        │           ├─ API Server
        │           ├─ etcd
        │           ├─ Scheduler
        │           └─ Controller Manager
        │
        └─ Worker Node VM(s)
            │
            └─ Operating System (Linux/Windows)
                │
                └─ Kubernetes Worker Node Components
                    │
                    ├─ kubelet
                    ├─ kube-proxy
                    ├─ Container Runtime
                    │   ├─ containerd
                    │   ├─ CRI-O
                    │   └─ Docker (historically)
                    │
                    └─ Pods
                        │
                        ├─ Container A
                        │   ├─ Application
                        │   ├─ Runtime
                        │   ├─ Libraries
                        │   └─ Dependencies
                        │
                        └─ Container B
                            ├─ Application
                            ├─ Runtime
                            ├─ Libraries
                            └─ Dependencies

```

```
# Deployment Evolution

## Option 1: On-Premises

You own everything.

```text
Your Data Center
      ↓
Physical Server
      ↓
Linux
      ↓
backup.py
```

### You Manage

- Hardware
- Networking
- Security
- OS
- Runtime
- Application

---

## Option 2: IaaS (Infrastructure as a Service)

### Examples

- AWS EC2
- Azure VM

```text
Cloud Data Center
      ↓
Physical Server
      ↓
Hypervisor
      ↓
VM
      ↓
Linux
      ↓
backup.py
```

### Cloud Manages

- Data center
- Physical servers
- Storage
- Networking
- Hypervisor

### You Manage

- VM
- OS
- Runtime
- Application

---

## Option 3: Docker on VM

You install Docker yourself.

```text
Cloud Data Center
      ↓
Physical Server
      ↓
VM
      ↓
Linux
      ↓
Docker
      ↓
Backup Container
```

### Cloud Manages

- Physical infrastructure

### You Manage

- VM
- OS
- Docker
- Containers
- Application

### Example

```bash
sudo apt install docker.io
```

---

## Option 4: Self-Managed Kubernetes

As the application grows:

- Backup API
- Worker
- Scheduler

Multiple containers become difficult to manage.

Add Kubernetes:

```text
VM
 ↓
Kubernetes
 ↓
Containers
```

### You Manage

- VMs
- Kubernetes
- Containers
- Applications

---

## Option 5: Managed Kubernetes

### Examples

- AKS
- EKS
- GKE

```text
Cloud Provider
 ├─ Physical Servers
 ├─ Networking
 ├─ Kubernetes Control Plane
 └─ Worker Nodes

You
 ├─ Pods
 ├─ Deployments
 └─ Applications
```

### Cloud Manages

- Kubernetes control plane
- Infrastructure

### You Manage

- Workloads
- Containers
- Applications

---

## Option 6: Platform as a Service (PaaS)

### Examples

- Azure App Service
- Google App Engine

```text
Application
      ↓
App Service
```

### Cloud Manages

- Servers
- VMs
- OS
- Runtime
- Scaling

### You Manage

- Application

---

## Option 7: Container PaaS

### Examples

- Azure Container Apps
- AWS Fargate

```text
Container Image
      ↓
Cloud Platform
```

### Cloud Manages

- Servers
- VMs
- Docker runtime
- Scaling
- Networking

### You Manage

- Container image
- Application

---

## Option 8: Serverless (FaaS)

### Examples

- AWS Lambda
- Azure Functions

```text
Event
 ↓
Function
 ↓
Response
```

### Cloud Manages

- Servers
- VMs
- Containers
- Runtime
- Scaling

### You Manage

- Function code

### Example

```python
def lambda_handler(event, context):
    return "Hello"
```

---

# What Happens Under Lambda?

Even Lambda still runs on infrastructure.

```text
Function Code
      ↓
Container (Hidden)
      ↓
VM (Hidden)
      ↓
Physical Server (Hidden)
      ↓
Data Center (Hidden)
```

The cloud provider simply hides these layers.

---

# Responsibility Comparison

## On-Prem

You manage everything.

---

## VM (IaaS)

### Cloud Manages

- Hardware
- Networking

### You Manage

- VM
- OS
- Runtime
- Application

---

## Docker on VM

### Cloud Manages

- Infrastructure

### You Manage

- VM
- OS
- Docker
- Containers
- Application

---

## Managed Kubernetes

### Cloud Manages

- Infrastructure
- Kubernetes Control Plane

### You Manage

- Pods
- Deployments
- Containers
- Application

---

## PaaS

### Cloud Manages

- Infrastructure
- OS
- Runtime
- Scaling

### You Manage

- Application

---

## FaaS

### Cloud Manages

Everything except function code.

### You Manage

- Function code

---

# Cloud Service Models Mapping

| Deployment Style | Service Model |
|------------------|--------------|
| Physical Server | On-Premises |
| EC2 / Azure VM | IaaS |
| Docker on VM | IaaS + Containers |
| Self-Managed Kubernetes | IaaS |
| AKS / EKS / GKE | Managed Kubernetes |
| Azure App Service | PaaS |
| Azure Container Apps | Container PaaS |
| AWS Fargate | Container PaaS |
| AWS Lambda | FaaS |
| Azure Functions | FaaS |
| Microsoft 365 | SaaS |
| Salesforce | SaaS |

---

# Control vs Responsibility

```text
More Control  ←──────────────────────────────→ Less Control

On-Prem
   ↓
IaaS (EC2, Azure VM)
   ↓
Docker on VM
   ↓
Managed Kubernetes (AKS/EKS/GKE)
   ↓
PaaS (App Service)
   ↓
Container PaaS (Fargate/Container Apps)
   ↓
FaaS (Lambda/Functions)
   ↓
SaaS
```

```text
More Responsibility ←────────────→ Less Responsibility
```

---

# The Most Important Concept

Cloud evolution is **not about replacing technology**.

The underlying stack always exists:

```text
Data Center
      ↓
Physical Server
      ↓
VM
      ↓
OS
      ↓
Docker
      ↓
Containers
      ↓
Kubernetes
      ↓
Application
```

What changes is:

> How many of those layers are managed by you versus the cloud provider.

As you move from:

```text
On-Prem
   ↓
IaaS
   ↓
Kubernetes
   ↓
PaaS
   ↓
FaaS
   ↓
SaaS
```

More responsibility shifts from you to the cloud provider.