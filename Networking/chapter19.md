# Load Balancers

A Load Balancer distributes incoming traffic across multiple servers.

Without Load Balancer:

Users
  |
Server1

Problems:

- Single Point of Failure
- Limited Capacity

---

# With Load Balancer

            LB
          /    \
     Server1  Server2

Benefits:

- High Availability
- Scalability
- Fault Tolerance

---

# Why Needed

Suppose:

Server Capacity:

1000 Requests/sec

Traffic:

5000 Requests/sec

One server cannot handle load.

Add:

5 Servers

Use Load Balancer.

---

# Load Balancing Algorithms

## Round Robin

Request1 → Server1

Request2 → Server2

Request3 → Server3

Request4 → Server1

Simple.

---

## Weighted Round Robin

Server1 (Weight 3)

Server2 (Weight 1)

Server1 gets more traffic.

---

## Least Connections

Send traffic to server with fewest active connections.

Useful:

Long-lived connections.

---

## Least Response Time

Chooses fastest server.

---

# Layer 4 Load Balancer

Works using:

TCP
UDP

Decisions based on:

IP
Port

Examples:

AWS NLB

Advantages:

Very fast.

---

# Layer 7 Load Balancer

Works using:

HTTP
HTTPS

Can inspect URLs.

Example:

/api → Backend1

/images → Backend2

Examples:

AWS ALB
Nginx

---

# Health Checks

Load Balancer continuously verifies server health.

Example:

GET /health

Healthy:

200 OK

Unhealthy:

Remove from rotation.

---

# Sticky Sessions

User always routed to same server.

Useful:

Legacy applications.

Problem:

Uneven traffic distribution.

---

# SSL Termination

Without LB:

Client
 ↓
HTTPS
 ↓
Server

With LB:

Client
 ↓
HTTPS
 ↓
LB
 ↓
HTTP
 ↓
Server

Server workload reduced.

---

# AWS Mapping

ALB
→ Layer 7

NLB
→ Layer 4

Target Group
→ Backend Server Pool

---

# Interview Questions

Q1. Difference between ALB and NLB?

ALB:
Layer 7

NLB:
Layer 4

---

Q2. What are health checks?

Verify server availability.

---

Q3. Why load balancing?

Scalability and HA.