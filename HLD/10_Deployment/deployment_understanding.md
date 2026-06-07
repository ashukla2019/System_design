Cloud Architecture Journey: From Local Application to Serverless
Example Application

Suppose you build a backup application:

backup.py

The application is just code.

The real question is:

Where will this code run?

Complete Infrastructure Hierarchy

Every modern cloud deployment ultimately sits on top of the following hierarchy:

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
Data Center

A data center is a building that contains:

Power systems
Cooling systems
Networking equipment
Thousands of physical servers

Examples:

AWS Data Centers
Azure Data Centers
Google Cloud Data Centers
Physical Server

A physical server is an actual computer.

Physical Server
 ├─ CPU
 ├─ RAM
 ├─ Disk
 └─ Network Card

Example:

256 CPU Cores
1 TB RAM
10 TB SSD
Hypervisor

A hypervisor divides a physical server into multiple Virtual Machines.

Examples:

VMware ESXi
Hyper-V
KVM
Physical Server
      ↓
Hypervisor
      ↓
VM1
VM2
VM3
VM4
Virtual Machine (VM)

A VM behaves like a complete computer.

Examples:

AWS EC2
Azure VM
Physical Server
      ↓
Hypervisor
      ↓
VM

Inside the VM:

VM
 ├─ Virtual CPU
 ├─ Virtual RAM
 └─ Virtual Disk
Operating System

The VM runs an operating system.

VM
 └─ Linux

or

VM
 └─ Windows
Docker

Docker is software installed on the OS.

VM
 └─ Linux
      ↓
    Docker

Docker creates and manages containers.

Containers

Containers package:

Application
Runtime
Dependencies
Libraries
Docker
 ├─ Container A
 ├─ Container B
 └─ Container C
Kubernetes

Kubernetes manages containers.

Responsibilities:

Scheduling
Scaling
Networking
Self-healing
Rolling updates
Kubernetes
 ├─ Pod A
 ├─ Pod B
 └─ Pod C

Kubernetes itself runs on VMs.

VM
 └─ Kubernetes Node
      └─ Containers
Deployment Evolution
Option 1: On-Premises

You own everything.

Your Data Center
      ↓
Physical Server
      ↓
Linux
      ↓
backup.py

You manage:

Hardware
Networking
Security
OS
Runtime
Application
Option 2: IaaS (Infrastructure as a Service)

Examples:

AWS EC2
Azure VM
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

Cloud manages:

Data center
Physical servers
Storage
Networking
Hypervisor

You manage:

VM
OS
Runtime
Application
Option 3: Docker on VM

You install Docker yourself.

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

Cloud manages:

Physical infrastructure

You manage:

VM
OS
Docker
Containers
Application

Example:

sudo apt install docker.io
Option 4: Self-Managed Kubernetes

As the application grows:

Backup API
Worker
Scheduler

Multiple containers become difficult to manage.

Add Kubernetes:

VM
 ↓
Kubernetes
 ↓
Containers

You manage:

VMs
Kubernetes
Containers
Applications
Option 5: Managed Kubernetes

Examples:

AKS
EKS
GKE
Cloud Provider
 ├─ Physical Servers
 ├─ Networking
 ├─ Kubernetes Control Plane
 └─ Worker Nodes

You
 ├─ Pods
 ├─ Deployments
 └─ Applications

Cloud manages:

Kubernetes control plane
Infrastructure

You manage:

Workloads
Containers
Applications
Option 6: Platform as a Service (PaaS)

Examples:

Azure App Service
Google App Engine
Application
      ↓
App Service

Cloud manages:

Servers
VMs
OS
Runtime
Scaling

You manage:

Application
Option 7: Container PaaS

Examples:

Azure Container Apps
AWS Fargate
Container Image
      ↓
Cloud Platform

Cloud manages:

Servers
VMs
Docker runtime
Scaling
Networking

You manage:

Container image
Application
Option 8: Serverless (FaaS)

Examples:

AWS Lambda
Azure Functions
Event
 ↓
Function
 ↓
Response

Cloud manages:

Servers
VMs
Containers
Runtime
Scaling

You manage:

Function code

Example:

def lambda_handler(event, context):
    return "Hello"
What Happens Under Lambda?

Even Lambda still runs on infrastructure.

Function Code
      ↓
Container (Hidden)
      ↓
VM (Hidden)
      ↓
Physical Server (Hidden)
      ↓
Data Center (Hidden)

The cloud provider simply hides these layers.

Responsibility Comparison
On-Prem
You manage everything
VM (IaaS)
Cloud manages:
- Hardware
- Networking

You manage:
- VM
- OS
- Runtime
- App
Docker on VM
Cloud manages:
- Infrastructure

You manage:
- VM
- OS
- Docker
- Containers
- App
Managed Kubernetes
Cloud manages:
- Infrastructure
- Kubernetes Control Plane

You manage:
- Pods
- Deployments
- Containers
- App
PaaS
Cloud manages:
- Infrastructure
- OS
- Runtime
- Scaling

You manage:
- App
FaaS
Cloud manages:
- Everything except function code

You manage:
- Function code
Cloud Service Models Mapping
Deployment Style	Service Model
Physical Server	On-Premises
EC2 / Azure VM	IaaS
Docker on VM	IaaS + Containers
Self-Managed Kubernetes	IaaS
AKS / EKS / GKE	Managed Kubernetes
Azure App Service	PaaS
Azure Container Apps	Container PaaS
AWS Fargate	Container PaaS
AWS Lambda	FaaS
Azure Functions	FaaS
Microsoft 365	SaaS
Salesforce	SaaS
Control vs Responsibility
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

More Responsibility ←────────────→ Less Responsibility
The Most Important Concept

Cloud evolution is not about replacing technology.

The underlying stack always exists:

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

What changes is:

How many of those layers are managed by you versus the cloud provider.

As you move from On-Prem → IaaS → Kubernetes → PaaS → FaaS → SaaS, more responsibility shifts from you to the cloud provider.