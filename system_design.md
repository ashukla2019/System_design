# System Design Handbook
## From User Request to Planet-Scale Systems

---

# How to Study This Handbook

Most people learn System Design incorrectly.

They learn:

- DNS
- CDN
- Load Balancer
- Cache
- Database
- Kafka
- Microservices

as separate topics.

The problem:

They never understand where each component fits.

This handbook follows a dependency chain.

Every chapter answers:

```text
Problem
 ↓
Why Current System Fails
 ↓
Solution
 ↓
Architecture
 ↓
Internal Working
 ↓
Tradeoffs
 ↓
Cloud Mapping
 ↓
Interview Questions
 ↓
What Problem Comes Next?
```

---

# Complete System Design Mental Model

```text
User
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Reverse Proxy
 ↓
API Gateway
 ↓
Application
 ↓
Cache
 ↓
Database
 ↓
Replication
 ↓
Sharding
 ↓
Message Queue
 ↓
Storage
 ↓
Analytics
 ↓
Monitoring
```

---

# Complete Dependency Chain

```text
Need More Users
      ↓
Scalability
      ↓
More Servers
      ↓
Load Balancer
      ↓
Need Lower Latency
      ↓
CDN
      ↓
Database Overloaded
      ↓
Caching
      ↓
Single Database
      ↓
Replication
      ↓
Write Bottleneck
      ↓
Sharding
      ↓
Services Blocking Each Other
      ↓
Message Queue
      ↓
Too Many Services
      ↓
Microservices
      ↓
Need Service Discovery
      ↓
Service Discovery
      ↓
Need Monitoring
      ↓
Observability
      ↓
Need Reliability
      ↓
Circuit Breakers
      ↓
Need Cloud Scale
      ↓
Kubernetes
```

---

# Complete Architecture Journey

```text
Physical Network
 ↓
Internet
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Reverse Proxy
 ↓
API Gateway
 ↓
Application
 ↓
Cache
 ↓
Database
 ↓
Replication
 ↓
Sharding
 ↓
Message Queue
 ↓
Microservices
 ↓
Kubernetes
 ↓
Cloud
```

---

# Volume 1 — Foundations

Before designing systems, understand what makes a system successful.

```text
Requirements
    ↓
Scalability
    ↓
Availability
    ↓
Reliability
    ↓
Latency vs Throughput
    ↓
CAP Theorem
    ↓
Consistency Models
```

## Chapters

```text
Chapter 1  What is System Design?
Chapter 2  Scalability
Chapter 3  Availability
Chapter 4  Reliability
Chapter 5  Latency vs Throughput
Chapter 6  CAP Theorem
Chapter 7  Consistency Models
```

---

# Chapter 1 — What is System Design?

## Goal

Build systems that are:

- Scalable
- Reliable
- Available
- Secure
- Maintainable
- Cost Effective

---

## Evolution

### Stage 1

```text
User
 ↓
Application
 ↓
Database
```

Works for:

```text
100 Users
```

---

### Stage 2

```text
Users
 ↓
Load Balancer
 ↓
Multiple Servers
 ↓
Database
```

Works for:

```text
Thousands of Users
```

---

### Stage 3

```text
Users
 ↓
CDN
 ↓
Load Balancer
 ↓
Microservices
 ↓
Cache
 ↓
Database
```

Works for:

```text
Millions of Users
```

---

### Stage 4

```text
Global Users
 ↓
CDN
 ↓
API Gateway
 ↓
Microservices
 ↓
Kafka
 ↓
Databases
 ↓
Analytics
```

Modern Architecture.

---

# Chapter 2 — Scalability

## Definition

Ability to handle increasing load.

```text
100 Users
 ↓
1000 Users
 ↓
1 Million Users
```

System should continue working.

---

## Vertical Scaling

```text
4 CPU
 ↓
16 CPU
```

Advantages:

- Simple

Disadvantages:

- Hardware limits
- Expensive

---

## Horizontal Scaling

```text
Server1

Server2

Server3
```

Advantages:

- Almost unlimited growth

Preferred approach.

---

## Problem Created

```text
Multiple Servers
```

Need:

```text
Load Balancer
```

---

# Chapter 3 — Availability

## Definition

Percentage of uptime.

Formula:

```text
Availability

=
(Uptime / Total Time)

×100
```

---

## Common Targets

```text
99%      = 3.65 days downtime/year

99.9%    = 8.76 hours/year

99.99%   = 52 minutes/year

99.999%  = 5 minutes/year
```

---

## Improve Availability

```text
Load Balancer
 ↓
Multiple Servers
 ↓
Replication
 ↓
Multi AZ
 ↓
Multi Region
```

---

## Problem Created

Need data copies.

Next:

```text
Replication
```

---

# Chapter 4 — Reliability

## Definition

System behaves correctly.

---

Available:

```text
System Running
```

Reliable:

```text
System Running
+
Correct Results
```

---

## Techniques

```text
Retries

Replication

Transactions

Checksums

Backups
```

---

# Chapter 5 — Latency vs Throughput

## Latency

Time for one request.

Example:

```text
100 ms
```

---

## Throughput

Requests per second.

Example:

```text
10000 req/sec
```

---

## Goal

```text
Low Latency

High Throughput
```

---

## Optimization

```text
CDN

Cache

Load Balancer

Indexes
```

---

# Chapter 6 — CAP Theorem

Distributed systems can guarantee only two:

```text
Consistency

Availability

Partition Tolerance
```

---

## Consistency

All nodes see same data.

---

## Availability

Every request gets response.

---

## Partition Tolerance

System survives network failure.

---

## Bank Example

```text
CP

Consistency
+
Partition Tolerance
```

---

## Social Media Example

```text
AP

Availability
+
Partition Tolerance
```

---

# Chapter 7 — Consistency Models

```text
Strong Consistency
 ↓
Read Your Writes
 ↓
Eventual Consistency
```

---

## Strong Consistency

Every read gets latest value.

Example:

Bank Account.

---

## Eventual Consistency

Updates spread gradually.

Example:

Social Media Likes.

---

# Volume 2 — Traffic Layer

How traffic reaches the application.

```text
User
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Reverse Proxy
 ↓
API Gateway
```

---

## Chapters

```text
Chapter 8   DNS
Chapter 9   CDN
Chapter 10  Load Balancer
Chapter 11  Reverse Proxy
Chapter 12  API Gateway
```

---

# Volume 3 — Data Layer

How applications store and retrieve data.

```text
Application
 ↓
Cache
 ↓
Database
 ↓
Replication
 ↓
Sharding
 ↓
Storage
```

---

## Chapters

```text
Chapter 13  Caching
Chapter 14  Databases
Chapter 15  Replication
Chapter 16  Sharding
Chapter 17  Storage Systems
```

---

# Data Growth Journey

```text
Database Slow
      ↓
Caching

Single Database
      ↓
Replication

Write Bottleneck
      ↓
Sharding

Huge Files
      ↓
Storage Systems
```

---

# Volume 4 — Communication Layer

How services communicate.

```text
Frontend
 ↓
User Service
 ↓
Order Service
 ↓
Payment Service
```

---

Problem:

```text
Everything waits.
```

---

Solution:

```text
REST
 ↓
gRPC
 ↓
Kafka
```

---

## Chapters

```text
Chapter 18 REST
Chapter 19 GraphQL
Chapter 20 gRPC
Chapter 21 WebSocket
Chapter 22 Message Queue
```

---

# Volume 5 — Architecture Layer

System evolution.

```text
Startup
 ↓
Monolith
 ↓
Growing Company
 ↓
Microservices
 ↓
Enterprise
 ↓
Event Driven
 ↓
Kubernetes
```

---

## Chapters

```text
Chapter 23 Monolith
Chapter 24 Microservices
Chapter 25 Service Discovery
Chapter 26 Event Driven Architecture
Chapter 27 Kubernetes Architecture
```

---

# Volume 6 — Reliability Layer

Systems fail.

Need recovery.

```text
Retry
 ↓
Backoff
 ↓
Circuit Breaker
 ↓
Failover
 ↓
Disaster Recovery
```

---

## Chapters

```text
Chapter 28 Monitoring
Chapter 29 Logging
Chapter 30 Metrics
Chapter 31 Tracing
Chapter 32 Circuit Breaker
Chapter 33 Disaster Recovery
```

---

# Volume 7 — Security Layer

Protect the system.

```text
Firewall
 ↓
WAF
 ↓
Authentication
 ↓
Authorization
 ↓
Encryption
```

---

## Identity Flow

```text
API Key
 ↓
JWT
 ↓
OAuth
 ↓
SSO
```

---

## Chapters

```text
Chapter 34 Authentication
Chapter 35 Authorization
Chapter 36 JWT
Chapter 37 OAuth
Chapter 38 Encryption
```

---

# Volume 8 — Complete System Designs

Combine all concepts.

```text
Chapter 39 URL Shortener
Chapter 40 WhatsApp
Chapter 41 YouTube
Chapter 42 Uber
Chapter 43 Netflix
Chapter 44 Twitter/X
Chapter 45 E-Commerce
```

---

# Example — URL Shortener

```text
User
 ↓
DNS
 ↓
Load Balancer
 ↓
API Gateway
 ↓
URL Service
 ↓
Redis Cache
 ↓
Database
```

Uses:

```text
DNS
Load Balancer
Cache
Database
Replication
Monitoring
```

---

# Example — Netflix

```text
User
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Microservices
 ↓
Kafka
 ↓
Storage
 ↓
Analytics
```

Uses:

```text
CDN
Cache
Microservices
Kafka
Object Storage
Monitoring
Tracing
```

---

# Final Mental Model

```text
User
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Reverse Proxy
 ↓
API Gateway
 ↓
Application
 ↓
Cache
 ↓
Database
 ↓
Replication
 ↓
Sharding
 ↓
Message Queue
 ↓
Microservices
 ↓
Storage
 ↓
Observability
 ↓
Kubernetes
 ↓
Cloud
```

If you understand this flow, every System Design topic naturally fits into a single end-to-end architecture.