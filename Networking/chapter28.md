# AWS VPC Networking

VPC = Virtual Private Cloud

A logically isolated network in AWS.

Think of VPC as:

Your own private data center inside AWS.

---

# Traditional Datacenter

Router
Switch
Firewall
Servers
Storage

---

# AWS Equivalent

VPC
Subnets
Route Tables
Security Groups
EC2
EBS

---

# VPC Architecture

VPC (10.0.0.0/16)
│
├── Public Subnet (10.0.1.0/24)
│     ├── ALB
│     └── Bastion Host
│
├── Private App Subnet (10.0.2.0/24)
│     └── Application Servers
│
└── Private DB Subnet (10.0.3.0/24)
      └── Database

---

# VPC CIDR

Example:

10.0.0.0/16

Provides:

65536 addresses

Can be divided into subnets.

---

# Subnet

A subnet is a smaller network inside a VPC.

Example:

VPC

10.0.0.0/16

Subnets

10.0.1.0/24

10.0.2.0/24

10.0.3.0/24

---

# Public Subnet

Has route to:

Internet Gateway

Example:

0.0.0.0/0
    ↓
IGW

Resources:

ALB

Bastion

Public EC2

---

# Private Subnet

No direct route to Internet.

Resources:

Application Servers

Databases

Internal Services

---

# Internet Gateway (IGW)

Provides Internet access.

Attached to VPC.

Without IGW:

No public Internet.

---

# Public EC2 Requirements

Must have:

Public IP

AND

Route to IGW

AND

Security Group Allowing Access

---

# Route Table

AWS Router Configuration.

Example:

Destination     Target

10.0.0.0/16     Local

0.0.0.0/0       IGW

---

# Local Route

Automatically created.

Allows communication inside VPC.

---

# NAT Gateway

Allows:

Private → Internet

But blocks:

Internet → Private

---

# Example

Private EC2
     ↓
NAT Gateway
     ↓
Internet

Used for:

OS Updates

Package Downloads

Docker Pull

---

# NAT Flow

Private EC2

10.0.2.10

↓

NAT Gateway

↓

Public IP

↓

Internet

---

# Security Groups

Stateful Firewall.

Attached to:

EC2

ALB

RDS

EKS

---

# Example

Allow:

TCP 80

TCP 443

TCP 22

Everything else denied.

---

# Stateful Means

Request Allowed

↓

Response Automatically Allowed

---

# Network ACL

Subnet Firewall

Stateless

Must allow:

Inbound

AND

Outbound

---

# Security Group vs NACL

Security Group

Stateful

Instance Level

---

NACL

Stateless

Subnet Level

---

# Elastic IP

Static Public IP

Useful for:

Bastion

NAT Gateway

Legacy Systems

---

# ENI

Elastic Network Interface

Contains:

Private IP

MAC Address

Security Group

---

# VPC Peering

Connects two VPCs.

Example:

VPC A
↔
VPC B

Private communication.

---

# Limitation

No Transitive Routing.

A ↔ B

B ↔ C

Does NOT mean

A ↔ C

---

# Transit Gateway

Central router.

Hub-and-Spoke design.

        TGW
       / | \
      /  |  \
    VPC VPC VPC

Large enterprises use TGW.

---

# Site-to-Site VPN

On-Prem
    ↓
VPN Tunnel
    ↓
AWS VPC

Encrypted connectivity.

---

# Direct Connect

Dedicated private connection.

Benefits:

Low Latency

Consistent Performance

Private Connectivity

---

# VPC Endpoints

Access AWS services privately.

No Internet needed.

Example:

EC2
 ↓
S3 Endpoint
 ↓
S3

Traffic stays inside AWS.

---

# Types

Gateway Endpoint

S3

DynamoDB

---

Interface Endpoint

PrivateLink

Most AWS Services

---

# Flow Logs

Capture network metadata.

Used for:

Troubleshooting

Security

Auditing

---

# DNS in VPC

Provided automatically.

VPC Resolver:

169.254.169.253

Used by EC2 instances.

---

# Multi-AZ Design

AZ-A

App1

AZ-B

App2

If one AZ fails:

Application survives.

---

# Three-Tier Architecture

Internet
    ↓
ALB
    ↓
Public Subnet
    ↓
App Servers
    ↓
Private Subnet
    ↓
Database
    ↓
Private DB Subnet

Most common production architecture.

---

# Interview Questions

Q1. Difference between IGW and NAT Gateway?

IGW:
Inbound + Outbound

NAT:
Outbound only

---

Q2. Difference between SG and NACL?

SG:
Stateful

NACL:
Stateless

---

Q3. Why private subnet?

Better security.

---

Q4. Why VPC Endpoint?

Private AWS service access.

---

Q5. Why Transit Gateway?

Connect many VPCs efficiently.