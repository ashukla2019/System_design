# Kubernetes Networking

One of the most important DevOps/SRE topics.

Question:

How do containers communicate?

Answer:

Kubernetes Networking.

---

# Kubernetes Networking Requirements

Every Pod must:

- Have its own IP
- Communicate with any Pod
- No NAT between Pods
- Communicate across Nodes

These are Kubernetes networking rules.

---

# Kubernetes Cluster

                Control Plane
                       │
       ┌───────────────┼───────────────┐
       │               │               │
   Worker1         Worker2         Worker3
       │               │               │
    Pods            Pods            Pods

---

# Pod

Smallest deployable unit.

Each Pod gets:

Own IP Address

Example:

Pod A

10.244.1.10

Pod B

10.244.2.20

---

# Problem

Pods may exist on different nodes.

How can they communicate?

Need:

CNI

---

# CNI

Container Network Interface

Provides networking for Pods.

Examples:

Flannel

Calico

Cilium

Weave

---

# Flannel

Simple networking.

Creates overlay network.

Easy setup.

---

# Calico

Most popular.

Provides:

Routing

Network Policies

Security

---

# Cilium

Modern eBPF networking.

High performance.

Observability.

Security.

---

# Pod-to-Pod Communication

PodA
 ↓
Node1
 ↓
CNI Network
 ↓
Node2
 ↓
PodB

Direct communication.

---

# Pod IP

Pod receives IP dynamically.

Example:

10.244.1.5

Not stable.

May change after restart.

---

# Problem

Applications need stable address.

Solution:

Service

---

# Service

Provides stable virtual IP.

Acts as load balancer.

---

# Service Types

ClusterIP

NodePort

LoadBalancer

ExternalName

---

# ClusterIP

Default service.

Internal only.

Example:

Frontend
   ↓
ClusterIP
   ↓
Backend Pods

---

# NodePort

Exposes application on node port.

Example:

NodeIP:30080

External access possible.

---

# LoadBalancer

Cloud Load Balancer created.

AWS:

NLB/ALB

Azure:

Azure Load Balancer

GCP:

Cloud Load Balancer

---

# ExternalName

Maps service to DNS name.

Example:

db-service
 ↓
database.company.com

---

# Service Discovery

How do Pods find each other?

DNS.

---

# CoreDNS

Built-in Kubernetes DNS.

Every service gets DNS name.

Example:

backend.default.svc.cluster.local

---

# Example

Frontend Pod

↓

backend.default.svc.cluster.local

↓

CoreDNS

↓

Backend Service

↓

Backend Pod

---

# kube-proxy

Runs on every node.

Handles service routing.

Maintains rules.

---

# Modes

iptables

IPVS

eBPF (modern)

---

# Ingress

HTTP/HTTPS entry point.

Without Ingress:

Many Load Balancers.

---

With Ingress:

Single entry point.

Internet
 ↓
Ingress
 ↓
Apps

---

# Example

/api
 ↓
App1

/images
 ↓
App2

/admin
 ↓
App3

---

# Ingress Controller

Implements ingress.

Examples:

NGINX Ingress

Traefik

HAProxy

AWS Load Balancer Controller

---

# Network Policy

Pod Firewall.

Controls traffic.

Example:

Frontend
 ↓ Allowed
Backend

Frontend
 ↓ Denied
Database

---

# Network Policy Components

Ingress Rules

Egress Rules

Selectors

Ports

Protocols

---

# Persistent Challenge

Pod IP changes.

Service IP stable.

Always use Service.

Never Pod IP.

---

# Kubernetes DNS Flow

Frontend Pod
 ↓
CoreDNS
 ↓
Backend Service
 ↓
Backend Pod

---

# Pod Communication Types

Pod → Pod

Pod → Service

Pod → Internet

External → Service

Ingress → Service

Service → Pod

---

# AWS EKS Networking

VPC
 ↓
Worker Node
 ↓
ENI
 ↓
Pod IP

Pods get VPC IPs.

Very different from many on-prem clusters.

---

# AWS LoadBalancer Service

Service Type:

LoadBalancer

↓

AWS creates

NLB

↓

Traffic reaches Pods

---

# Complete Kubernetes Packet Journey

User
 ↓
Route53
 ↓
CloudFront
 ↓
ALB
 ↓
Ingress
 ↓
Service
 ↓
Pod
 ↓
Database

Response

Database
 ↓
Pod
 ↓
Service
 ↓
Ingress
 ↓
ALB
 ↓
CloudFront
 ↓
User

---

# Interview Questions

Q1. What is CNI?

Container Network Interface.

Provides Pod networking.

---

Q2. Why Service needed?

Stable endpoint.

Pod IP changes.

---

Q3. Difference between ClusterIP and NodePort?

ClusterIP:
Internal

NodePort:
External

---

Q4. What is Ingress?

HTTP/HTTPS entry point.

---

Q5. What is CoreDNS?

Kubernetes DNS service.

---

Q6. What is Network Policy?

Pod-level firewall.

---

Q7. Most common CNI?

Calico

---

Q8. Why not use Pod IP directly?

Pod IP changes.

Service remains stable.