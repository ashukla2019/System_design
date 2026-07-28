# System Design - Complete Layer Diagram

```text
                                         USER
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. REQUIREMENTS                                             │
│-------------------------------------------------------------│
│ Defines what system should do and how well it should work   │
│                                                             │
│ Functional Requirements                                     │
│   → Features and business capabilities                     │
│                                                             │
│ Non-Functional Requirements                                 │
│   → Latency, Availability, Scalability, Security            │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Need to find where application exists
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. DNS RESOLUTION                                           │
│-------------------------------------------------------------│
│ Converts human-readable name into machine address           │
│                                                             │
│ Example:                                                    │
│ google.com  →  IP Address                                   │
│                                                             │
│ Purpose:                                                     │
│ Find destination server                                     │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ User request reaches known IP
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. TRAFFIC LAYER                                            │
│-------------------------------------------------------------│
│ Controls and manages incoming traffic                      │
│                                                             │
│ CDN                                                           │
│   → Serve static content closer to users                   │
│                                                             │
│ WAF                                                           │
│   → Block malicious requests                               │
│                                                             │
│ Rate Limiter                                                 │
│   → Protect system from excessive requests                 │
│                                                             │
│ Load Balancer                                                │
│   → Distribute requests across servers                     │
│                                                             │
│ API Gateway                                                  │
│   → Entry point for APIs                                   │
│                                                             │
│ Reverse Proxy                                                │
│   → Forward requests to backend services                   │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Request enters infrastructure
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. NETWORK LAYER                                            │
│-------------------------------------------------------------│
│ Provides connectivity between system components             │
│                                                             │
│ Internet                                                     │
│   → Public communication path                               │
│                                                             │
│ Router                                                       │
│   → Moves packets between networks                         │
│                                                             │
│ Firewall                                                     │
│   → Controls network access                                 │
│                                                             │
│ VPC/Subnet                                                   │
│   → Isolated cloud network environment                     │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Secure communication required
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. SECURITY LAYER                                           │
│-------------------------------------------------------------│
│ Protects data and controls access                           │
│                                                             │
│ TLS/SSL                                                      │
│   → Encrypt communication                                   │
│                                                             │
│ Authentication                                               │
│   → Verify user identity                                    │
│                                                             │
│ Authorization                                                │
│   → Verify permissions                                      │
│                                                             │
│ OAuth/JWT                                                    │
│   → Token-based access                                      │
│                                                             │
│ RBAC/ABAC                                                    │
│   → Role/attribute based permissions                       │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Valid request reaches execution layer
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. COMPUTE LAYER                                            │
│-------------------------------------------------------------│
│ Provides environment where application runs                 │
│                                                             │
│ Physical Server                                              │
│   → Actual hardware                                         │
│                                                             │
│ Hypervisor                                                   │
│   → Creates virtual machines                                │
│                                                             │
│ VM                                                            │
│   → Isolated operating environment                          │
│                                                             │
│ Container                                                    │
│   → Lightweight application packaging                       │
│                                                             │
│ Kubernetes                                                    │
│   → Manages containers at scale                            │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Decide application structure
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 7. ARCHITECTURE LAYER                                       │
│-------------------------------------------------------------│
│ Defines how application components are organized             │
│                                                             │
│ Monolith                                                     │
│   → Single deployable application                           │
│                                                             │
│ Microservices                                                │
│   → Independent services                                    │
│                                                             │
│ Event Driven                                                 │
│   → Components communicate through events                  │
│                                                             │
│ Stateless/Stateful                                          │
│   → Defines data ownership model                           │
│                                                             │
│ Serverless                                                   │
│   → Cloud manages infrastructure                           │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Components need communication
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 8. COMMUNICATION LAYER                                      │
│-------------------------------------------------------------│
│ Defines how services exchange information                   │
│                                                             │
│ REST                                                          │
│   → HTTP based APIs                                         │
│                                                             │
│ gRPC                                                          │
│   → High performance service communication                  │
│                                                             │
│ GraphQL                                                       │
│   → Flexible data queries                                   │
│                                                             │
│ WebSocket                                                     │
│   → Real-time communication                                 │
│                                                             │
│ Kafka/RabbitMQ                                                │
│   → Asynchronous messaging                                  │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Execute business operations
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 9. BUSINESS LOGIC LAYER                                     │
│-------------------------------------------------------------│
│ Implements actual application rules                         │
│                                                             │
│ Validation                                                    │
│   → Check input correctness                                 │
│                                                             │
│ Payment Processing                                            │
│   → Handle transactions                                     │
│                                                             │
│ Inventory                                                     │
│   → Manage available items                                  │
│                                                             │
│ Fraud Detection                                               │
│   → Detect suspicious activity                              │
│                                                             │
│ Order Processing                                              │
│   → Handle business workflow                                │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Check frequently used data
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 10. CACHE LAYER                                             │
│-------------------------------------------------------------│
│ Reduces database load and improves response time            │
│                                                             │
│ Browser Cache                                                │
│   → Client-side caching                                     │
│                                                             │
│ CDN Cache                                                    │
│   → Cache static content                                    │
│                                                             │
│ Redis/Memcached                                              │
│   → Fast in-memory storage                                  │
└─────────────────────────────────────────────────────────────┘
          │                           │
          │ Cache Hit                 │ Cache Miss
          │                           │
          ▼                           ▼
 Return Response              Access Database
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────┐
│ 11. DATA ACCESS LAYER                                       │
│-------------------------------------------------------------│
│ Provides controlled access to data                          │
│                                                             │
│ ORM                                                           │
│   → Object to database mapping                              │
│                                                             │
│ Repository Pattern                                            │
│   → Separates business logic from storage                  │
│                                                             │
│ DAO                                                           │
│   → Database access abstraction                             │
│                                                             │
│ Transactions                                                  │
│   → Maintain data consistency                               │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Read/write persistent data
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 12. DATA LAYER                                              │
│-------------------------------------------------------------│
│ Stores and manages application data                         │
│                                                             │
│ SQL                                                           │
│   → Relational databases                                    │
│                                                             │
│ NoSQL                                                         │
│   → Flexible/non-relational storage                         │
│                                                             │
│ Replication                                                   │
│   → Copy data for availability                              │
│                                                             │
│ Sharding                                                      │
│   → Split data across servers                               │
│                                                             │
│ CAP Theorem                                                   │
│   → Trade-offs in distributed systems                       │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Store data permanently
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 13. STORAGE LAYER                                           │
│-------------------------------------------------------------│
│ Provides physical data storage                              │
│                                                             │
│ Block Storage                                                 │
│   → Disk volumes                                             │
│                                                             │
│ File Storage                                                  │
│   → Files and directories                                    │
│                                                             │
│ Object Storage                                                │
│   → Large unstructured data                                 │
│                                                             │
│ Backup/Disaster Recovery                                     │
│   → Data protection                                         │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Systems can fail
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 14. RELIABILITY LAYER                                       │
│-------------------------------------------------------------│
│ Keeps system available during failures                      │
│                                                             │
│ Retry                                                          │
│   → Attempt failed operations again                         │
│                                                             │
│ Backoff                                                        │
│   → Increase wait time between retries                      │
│                                                             │
│ Circuit Breaker                                                │
│   → Stop calling unhealthy services                         │
│                                                             │
│ Failover                                                       │
│   → Switch to backup system                                 │
│                                                             │
│ Health Check                                                   │
│   → Detect service status                                   │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Need visibility into system
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 15. MONITORING LAYER                                        │
│-------------------------------------------------------------│
│ Observes system behavior                                    │
│                                                             │
│ Logs                                                          │
│   → Record events                                            │
│                                                             │
│ Metrics                                                       │
│   → Measure performance                                     │
│                                                             │
│ Traces                                                        │
│   → Follow request flow                                     │
│                                                             │
│ Alerts                                                        │
│   → Notify failures                                         │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ More users and traffic
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 16. SCALING LAYER                                           │
│-------------------------------------------------------------│
│ Handles increasing workload                                 │
│                                                             │
│ Horizontal Scaling                                            │
│   → Add more servers                                        │
│                                                             │
│ Vertical Scaling                                              │
│   → Increase server capacity                                │
│                                                             │
│ Auto Scaling                                                  │
│   → Automatically adjust resources                          │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Deliver new versions safely
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 17. DEPLOYMENT LAYER                                        │
│-------------------------------------------------------------│
│ Automates software delivery                                 │
│                                                             │
│ CI/CD                                                         │
│   → Build, test, deploy automatically                      │
│                                                             │
│ Containers                                                    │
│   → Package applications consistently                       │
│                                                             │
│ Infrastructure as Code                                       │
│   → Manage infrastructure using code                       │
│                                                             │
│ Blue-Green Deployment                                        │
│   → Zero downtime release                                  │
│                                                             │
│ Canary Deployment                                            │
│   → Release to small users first                           │
└─────────────────────────────────────────────────────────────┘
                     │
                     ▼

               RESPONSE TO USER
```

------------------------------------------------------------------------
# System Design Architecture Notes

---

# 1. Requirements Layer

## What is it?

The requirements layer defines what the system needs to achieve before designing the architecture.

It answers:

- What should the system do?
- How many users?
- What performance is expected?
- What reliability is required?

---

## Functional Requirements

Defines system features.

Examples:

- User registration
- Login
- Payment processing
- Search product
- Place order

Example:

```
User should be able to upload an image.
```

---

## Non-Functional Requirements

Defines system quality attributes.

Examples:

### Latency

How quickly should the system respond?

Example:

```
API response should be less than 200ms
```

---

### Availability

How much time should the system be available?

Example:

```
99.99% availability
```

---

### Scalability

Ability to handle increasing users.

Example:

```
1 million users today
10 million users tomorrow
```

---

### Security

Protect:

- User data
- Authentication
- Communication

---

# 2. DNS Layer

## What is DNS?

DNS (Domain Name System) converts a domain name into an IP address.

Example:

```
www.google.com
        |
        v
142.x.x.x
```

Humans remember names.

Machines communicate using IP addresses.

---

## DNS Flow

```
Browser
   |
   v
DNS Resolver
   |
   v
Root DNS
   |
   v
Authoritative DNS
   |
   v
IP Address
```

---

# 3. Traffic Layer

The traffic layer manages incoming user requests.

It sits before application servers.

---

# CDN (Content Delivery Network)

## Purpose

Serve content closer to users.

Without CDN:

```
User
 |
 |
USA Server
```

High latency.

With CDN:

```
User
 |
 |
Nearest CDN Edge Server
 |
 |
Origin Server
```

Used for:

- Images
- Videos
- Static files
- Javascript files

---

# WAF (Web Application Firewall)

## Purpose

Protect applications from malicious traffic.

Blocks:

- SQL injection
- XSS attacks
- Bad requests

Example:

```
User Request
      |
      v
     WAF
      |
      v
 Application
```

---

# Rate Limiter

## Purpose

Controls number of requests from users.

Example:

```
Maximum:

100 API calls/minute/user
```

Prevents:

- Abuse
- DDoS
- Resource exhaustion

---

# Load Balancer

## Purpose

Distributes traffic across multiple servers.

Without:

```
User
 |
Server A
```

Problem:

Server A becomes overloaded.


With load balancer:

```
              Load Balancer

             /     |      \

        Server1 Server2 Server3
```

Algorithms:

- Round Robin
- Least Connection
- IP Hash

---

# API Gateway

## Purpose

Single entry point for APIs.

Responsibilities:

- Authentication
- Routing
- Rate limiting
- Logging

Example:

```
Client

 |
 v

API Gateway

 |
 +---- User Service
 |
 +---- Payment Service
 |
 +---- Order Service
```

---

# Reverse Proxy

## Purpose

Receives client requests and forwards them to backend servers.

Examples:

- Nginx
- HAProxy

Benefits:

- Security
- Load balancing
- SSL termination

---

# 4. Network Layer

Provides communication between components.

---

# Internet

Public network connecting users and services.

---

# Router

Moves packets between networks.

Example:

```
Network A
    |
 Router
    |
Network B
```

---

# Firewall

Controls network access.

Example:

Allow:

```
Port 443 HTTPS
```

Block:

```
Port 22 from unknown IP
```

---

# VPC (Virtual Private Cloud)

Private network inside cloud.

Provides isolation.

Example:

```
VPC

 |
 +-- Public subnet
 |
 +-- Private subnet
```

---

# Subnet

Divides network into smaller sections.

Example:

```
VPC

 |
 +---- Web subnet
 |
 +---- Database subnet
```

---

# 5. Security Layer

---

# TLS/SSL

Encrypts communication.

Without:

```
Client -------- Data -------- Server
```

Anyone can read data.

With TLS:

```
Client === Encrypted === Server
```

---

# Authentication

Answers:

```
Who are you?
```

Examples:

- Username/password
- Tokens
- Certificates

---

# Authorization

Answers:

```
What are you allowed to do?
```

Example:

Admin:

```
Delete User
```

Normal User:

```
View Profile
```

---

# OAuth

Allows delegated access.

Example:

```
Login with Google
```

Application does not receive your password.

---

# JWT

JSON Web Token.

Contains:

- User identity
- Claims
- Expiry

Used for stateless authentication.

---

# RBAC

Role Based Access Control.

Example:

```
Admin
 |
 +-- Delete user

Customer
 |
 +-- View profile
```

---

# ABAC

Attribute Based Access Control.

Uses attributes:

Example:

```
User.department = Finance
```

Allow access.

---

# 6. Compute Layer

Where applications run.

---

# Physical Server

Actual hardware.

Contains:

- CPU
- Memory
- Storage

---

# Hypervisor

Creates virtual machines.

Example:

```
Physical Server

 |
 Hypervisor

 |
 +-- VM1
 +-- VM2
 +-- VM3
```

Examples:

- VMware
- KVM

---

# Virtual Machine

Complete virtual computer.

Contains:

- OS
- Libraries
- Application

---

# Container

Lightweight application environment.

Example:

```
Docker Container

Application
Libraries
Runtime
```

Shares host OS kernel.

---

# Kubernetes

Container orchestration platform.

Manages:

- Deployment
- Scaling
- Networking
- Recovery

---

# 7. Architecture Layer

Defines application structure.

---

# Monolith

Single application.

```
Application

 |
 +-- UI
 +-- Business Logic
 +-- Database
```

Simple but harder to scale.

---

# Microservices

Application split into independent services.

Example:

```
User Service

Order Service

Payment Service
```

Benefits:

- Independent scaling
- Independent deployment

---

# Event Driven Architecture

Services communicate using events.

Example:

```
Order Created Event

        |
        v

Payment Service
Inventory Service
Notification Service
```

---

# Stateless System

Server does not store user session.

Example:

```
Request
 |
Any Server
```

Easy scaling.

---

# Stateful System

Server maintains state.

Example:

Database connection/session.

---

# Serverless

Cloud manages servers.

Example:

- AWS Lambda

Developer only provides code.

---

# 8. Communication Layer

---

# REST

HTTP based communication.

Example:

```
GET /users/10
```

---

# gRPC

High-performance RPC framework.

Uses:

- Protocol Buffers
- HTTP/2

Common in microservices.

---

# GraphQL

Client requests required data.

Example:

Instead of:

```
GET user
GET orders
GET address
```

One query:

```
Get user {
 orders
 address
}
```

---

# WebSocket

Persistent two-way connection.

Used for:

- Chat
- Gaming
- Live updates

---

# Kafka

Distributed event streaming platform.

Used for:

- Logs
- Events
- Messaging

---

# RabbitMQ

Message queue.

Used for:

- Async processing
- Task queues

---

# 9. Business Logic Layer

Contains actual application rules.

Examples:

- Payment calculation
- Order validation
- Inventory rules

Example:

```
Order Service

Check stock
Calculate price
Apply discount
Create order
```

---

# 10. Cache Layer

Stores frequently accessed data in fast memory.

---

# Browser Cache

Stores data on client machine.

---

# CDN Cache

Caches static content globally.

---

# Redis

In-memory key-value database.

Example:

```
User Session

Key:
user123

Value:
login information
```

---

# Memcached

Simple distributed memory cache.

---

# Cache Flow

```
Request

 |
 v

Cache

 |
 +---- Hit
 |
 +---- Miss
        |
        v
     Database
```

---

# 11. Data Access Layer

Separates application logic from database.

Flow:

```
Business Logic

      |
      v

Data Access Layer

      |
      v

Database
```

---

# ORM

Object Relational Mapping.

Converts:

```
Object
 |
 v
Database Table
```

Example:

```
User object

becomes

USER table row
```

---

# Repository Pattern

Provides clean database interface.

Example:

```
userRepository.findUser()
```

Hides SQL details.

---

# DAO

Data Access Object.

Handles:

- Database queries
- Connections
- CRUD operations

---

# Transactions

Ensures multiple operations succeed together.

Example:

Bank transfer:

```
Debit Account A

Credit Account B
```

Either:

```
Both succeed
```

or:

```
Both rollback
```

---

# 12. Data Layer

Stores application data.

---

# SQL Database

Relational database.

Examples:

- PostgreSQL
- MySQL

Uses:

Tables
Rows
Columns

---

# NoSQL Database

Non-relational storage.

Examples:

- MongoDB
- Cassandra

Used for:

- Large scale
- Flexible schema

---

# Replication

Copies data to multiple servers.

Purpose:

- Availability
- Read scaling

---

# Sharding

Splits data across servers.

Example:

```
Users 1-1M
Server A

Users 1M-2M
Server B
```

---

# CAP Theorem

Distributed systems tradeoff:

- Consistency
- Availability
- Partition tolerance

Cannot maximize all three.

---

# 13. Storage Layer

---

# Block Storage

Raw disk storage.

Example:

VM disks.

---

# File Storage

Stores files/directories.

Example:

NFS.

---

# Object Storage

Stores objects with metadata.

Example:

Images, videos.

---

# Backup

Copy data for recovery.

---

# Disaster Recovery

Plan to restore service after major failure.

---

# 14. Reliability Layer

Keeps system working during failures.

---

# Retry

Try failed operation again.

---

# Backoff

Increase delay between retries.

Example:

```
1 sec
2 sec
4 sec
```

---

# Circuit Breaker

Stops calling failed service.

Prevents cascading failures.

---

# Failover

Switch to backup system.

---

# Health Check

Checks service availability.

---

# High Availability

Design system to minimize downtime.

---

# 15. Monitoring Layer

Observes system behavior.

---

# Logs

Detailed events.

Example:

```
User login failed
```

---

# Metrics

Numbers showing system health.

Examples:

- CPU usage
- Request count
- Latency

---

# Traces

Track request journey.

Example:

```
API Gateway
 |
User Service
 |
Database
```

---

# Alerts

Notify problems.

Example:

```
CPU > 90%
```

---

# 16. Scaling Layer

Handles growth.

---

# Horizontal Scaling

Add more servers.

```
1 Server

becomes

10 Servers
```

---

# Vertical Scaling

Increase server power.

Example:

```
CPU:
4 cores -> 16 cores
```

---

# Auto Scaling

Automatically add/remove resources.

---

# 17. Deployment Layer

Releases software safely.

---

# CI/CD

Automated:

- Build
- Test
- Deploy

---

# Infrastructure as Code

Manage infrastructure using code.

Examples:

- Terraform
- CloudFormation

---

# Blue-Green Deployment

Two environments:

```
Blue  -> Current version

Green -> New version
```

Switch traffic after validation.

---

# Canary Deployment

Release to small percentage first.

Example:

```
5% users
 |
Monitor
 |
100% users
```

---

# Complete System Flow

```
User

 |
 v

DNS

 |
 v

CDN/WAF/Load Balancer

 |
 v

Network/Security

 |
 v

Compute

 |
 v

Application Services

 |
 v

Business Logic

 |
 v

Cache

 |
 v

Data Access Layer

 |
 v

Database

 |
 v

Storage
```

---

# Interview Summary

A scalable system separates responsibilities:

```
Traffic Layer
        |
Network
        |
Security
        |
Compute
        |
Application Architecture
        |
Business Logic
        |
Data Access
        |
Database
        |
Storage
```

Each layer solves a specific problem and allows independent scaling, maintenance, and evolution.

