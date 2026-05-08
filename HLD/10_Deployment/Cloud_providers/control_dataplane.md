# ☁️ AWS & Azure Control Plane vs Data Plane (Short Notes)

---

# 📌 Core Idea

| Plane | Meaning |
|---|---|
| Control Plane | Management & configuration |
| Data Plane | Actual workload execution |

---

# 🧠 Memory Trick

```text
Control Plane:
"Tell infrastructure WHAT to do"

Data Plane:
"Infrastructure actually DOES it"
```

---

# ☁️ AWS

## ✅ AWS Control Plane

Management APIs & orchestration.

### Examples
- Create EC2
- Create S3 bucket
- Configure IAM
- Create VPC
- Configure Security Groups
- Create EKS cluster
- AutoScaling config

### Flow

```text
User/API/Terraform
        ↓
AWS Control Plane APIs
        ↓
Infrastructure configured
```

---

## ✅ AWS Data Plane

Actual runtime traffic/workload.

### Examples
- EC2 serving traffic
- S3 read/write
- EBS disk IO
- Lambda execution
- RDS queries
- EKS pod traffic
- VPC packet forwarding

### Flow

```text
Application Traffic
        ↓
AWS Infrastructure executes workload
```

---

# ☁️ Azure

## ✅ Azure Control Plane

Managed mainly via:
```text
Azure Resource Manager (ARM)
```

### Examples
- Create VM
- Create VNet
- Configure NSG
- Assign RBAC roles
- Create AKS cluster
- Configure Load Balancer

### Flow

```text
Portal/CLI/Terraform
        ↓
ARM Control Plane
        ↓
Azure provisions resources
```

---

## ✅ Azure Data Plane

Actual runtime execution.

### Examples
- VM serving app traffic
- Blob read/write
- SQL queries
- AKS pod traffic
- Disk IO
- Packet forwarding

---

# 📦 Kubernetes Relation

| Kubernetes Component | Plane |
|---|---|
| API Server | Control Plane |
| ETCD | Control Plane |
| Scheduler | Control Plane |
| Controller Manager | Control Plane |
| Kubelet | Data Plane side |
| Pods | Data Plane |
| Service Traffic | Data Plane |

---

# 🌐 Networking Example

## Control Plane
```text
Create route table
Configure firewall
Setup Load Balancer
```

## Data Plane
```text
Actual packet forwarding
TCP/UDP traffic
Load balancing requests
```

---

# 🔐 Identity Example

## Control Plane
```text
Create IAM/RBAC roles
Attach permissions
```

## Data Plane
```text
Application accesses S3/Blob
VM uses credentials
```

---

# 📌 Key Difference

| Aspect | Control Plane | Data Plane |
|---|---|---|
| Purpose | Configure/manage | Execute workload |
| Traffic | API/configuration | Runtime/app traffic |
| Used By | Admin/DevOps | Applications/users |
| Examples | Create VM | VM serves requests |

---

# 🚀 Simple Real Example

## EC2/VM Creation

### Control Plane
```text
Create VM
Attach IAM role
Configure Security Group
```

### Data Plane
```text
VM running application
Serving HTTP traffic
Disk IO happening
```

---

# 🎯 One-Line Interview Answer

```text
Control Plane manages and configures infrastructure,
while Data Plane executes actual application traffic and workloads.
```