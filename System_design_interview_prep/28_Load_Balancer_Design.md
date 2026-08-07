# 28. Load Balancer Design

> Designing a scalable load balancing system similar to AWS Elastic Load Balancer, Google Cloud Load Balancing, HAProxy, NGINX, Envoy, and F5.

---

# Table of Contents

1. Introduction
2. Why Load Balancers?
3. Requirements
4. High-Level Architecture
5. Types of Load Balancers
6. Layer 4 Load Balancing
7. Layer 7 Load Balancing
8. Reverse Proxy
9. Request Routing
10. Load Balancing Algorithms
11. Health Checking
12. Session Management
13. Service Discovery
14. Global Load Balancing
15. Anycast Routing
16. TLS Termination
17. Connection Management
18. Scaling
19. Failure Handling
20. Security
21. Monitoring
22. Real-World Systems
23. Interview Questions
24. Summary

---

# 1. Introduction

A load balancer distributes incoming network traffic across multiple servers.

Without a load balancer:

```
Client

↓

Single Server
```

Problem:

- Server overload
- Single point of failure
- Poor scalability

With load balancing:

```
              Client

                |

          Load Balancer

        /       |       \

    Server1  Server2  Server3
```

---

# 2. Why Load Balancers?

Load balancers provide:

- High availability
- Horizontal scaling
- Fault tolerance
- Better latency
- Traffic distribution
- Security filtering

---

# 3. Functional Requirements

A load balancer should:

- Receive requests
- Select backend servers
- Forward traffic
- Detect failures
- Remove unhealthy servers
- Add new servers dynamically
- Support millions of connections

---

# 4. Non-Functional Requirements

Availability:

99.99%+

Latency:

<1 ms overhead

Throughput:

Millions requests/sec

Scalability:

Thousands of backend servers

---

# 5. High-Level Architecture

```
                 Users

                   |

             DNS / Anycast

                   |

            Load Balancer

                   |

        +----------+----------+

        |          |          |

     Server A   Server B   Server C
```

---

# 6. Components

## Frontend Listener

Accepts:

- TCP connections
- HTTP requests
- TLS connections

---

## Routing Engine

Decides:

```
Request

↓

Backend Server
```

---

## Health Checker

Continuously monitors servers.

Example:

```
GET /health

200 OK

Healthy
```

---

## Configuration Manager

Stores:

- Backend list
- Routing rules
- Certificates
- Policies

---

# 7. Types of Load Balancers

## Hardware Load Balancers

Examples:

- F5 BIG-IP
- Citrix ADC

Advantages:

- Very high performance

Disadvantages:

- Expensive

---

## Software Load Balancers

Examples:

- NGINX
- HAProxy
- Envoy

Advantages:

- Flexible
- Cloud friendly

---

## Cloud Load Balancers

Examples:

- AWS ELB
- Google Cloud Load Balancer
- Azure Load Balancer

Managed services.

---

# 8. Layer 4 Load Balancing

Operates at transport layer.

Protocols:

- TCP
- UDP

Routing based on:

```
Source IP

Destination IP

Port
```

Example:

```
Client

↓

TCP Load Balancer

↓

Server
```

Advantages:

- Very fast
- Low latency

Disadvantages:

- Limited application awareness

---

# 9. Layer 7 Load Balancing

Application-level routing.

Understands:

- HTTP
- Headers
- Cookies
- URLs

Example:

```
/api/users

↓

User Service


/api/orders

↓

Order Service
```

Advantages:

- Smart routing
- Content-based decisions

Disadvantages:

- More CPU overhead

---

# 10. Reverse Proxy

A load balancer often acts as a reverse proxy.

Client sees:

```
example.com
```

Actual servers are hidden:

```
Server1

Server2

Server3
```

Benefits:

- Security
- TLS termination
- Compression
- Caching

---

# 11. Load Balancing Algorithms

## Round Robin

Requests rotate.

Example:

```
Request1 → A

Request2 → B

Request3 → C
```

Advantages:

Simple

Disadvantages:

Ignores server capacity.

---

# 12. Weighted Round Robin

Servers have different weights.

Example:

```
Server A

Weight 3


Server B

Weight 1
```

A receives more traffic.

---

# 13. Least Connections

Send request to server with fewest active connections.

Example:

```
Server A

100 connections


Server B

20 connections

↓

Choose B
```

Good for long-lived connections.

---

# 14. Least Response Time

Selects server with:

- Lowest latency
- Fewest connections

Useful for performance-sensitive systems.

---

# 15. IP Hash

Uses client IP.

```
hash(client_ip)

↓

Server
```

Advantages:

Session affinity.

Disadvantages:

Uneven distribution.

---

# 16. Consistent Hashing

Used for distributed systems.

```
Hash Ring

Node A

Node B

Node C
```

Only small traffic movement occurs when nodes change.

Useful for:

- Caches
- Stateful services

---

# 17. Health Checking

Load balancers continuously check servers.

Types:

## Active Health Check

LB sends requests.

Example:

```
GET /health
```

---

## Passive Health Check

Observes failures.

Example:

```
Connection failures

↓

Mark unhealthy
```

---

# 18. Backend Removal

Failure:

```
Server B

↓

Health Check Failed

↓

Remove From Pool
```

Traffic moves automatically.

---

# 19. Session Management

Some applications require user sessions.

Problem:

```
User

↓

Server A

Session stored locally
```

Next request:

```
Server B

No Session
```

---

# 20. Solutions

## Sticky Sessions

Same user always goes to same server.

Using:

- Cookies
- IP hash

---

## External Session Store

Store sessions in:

- Redis
- Database

Then any server can handle requests.

---

# 21. Service Discovery

Dynamic systems have changing servers.

Example:

```
Server Added

↓

Register

↓

Load Balancer Updates
```

Sources:

- Kubernetes Service
- Consul
- Eureka
- DNS

---

# 22. TLS Termination

Option 1:

Client

↓

HTTPS

↓

Load Balancer

↓

HTTP

↓

Server


LB decrypts traffic.

---

Option 2:

TLS Passthrough

```
Client

↓

Encrypted

↓

Backend
```

Backend handles encryption.

---

# 23. Connection Management

Important techniques:

## Keep Alive

Reuse TCP connections.

---

## Connection Pooling

Maintain backend connections.

---

## Timeout Management

Prevent stuck requests.

---

# 24. Global Load Balancing

For worldwide applications:

```
User

↓

Global Load Balancer

↓

Nearest Region

↓

Application Servers
```

---

# 25. DNS Load Balancing

Example:

```
example.com

↓

Multiple IPs
```

DNS returns different addresses.

Limitations:

- Cache delays
- Slow failure detection

---

# 26. Anycast Routing

Multiple locations advertise same IP.

Example:

```
IP: 1.1.1.1


US Server

EU Server

Asia Server
```

Network routes user to nearest location.

Used by:

- CDNs
- DNS providers

---

# 27. Scaling Load Balancers

A load balancer itself can become a bottleneck.

Solutions:

## Horizontal Scaling

```
LB1

LB2

LB3
```

---

## Active-Passive

```
Primary LB

↓

Backup LB
```

---

## Active-Active

```
LB1

LB2

LB3
```

All serve traffic.

---

# 28. Failure Handling

## Load Balancer Failure

Solutions:

- Multiple LBs
- Anycast
- Floating IP
- DNS failover

---

## Backend Failure

```
Health Check

↓

Remove Node

↓

Redirect Traffic
```

---

## Network Failure

Use:

- Multiple regions
- Redundant links
- Automatic routing

---

# 29. Security

Load balancers provide:

- DDoS protection
- Rate limiting
- IP filtering
- TLS management
- WAF integration

---

# 30. Monitoring

Metrics:

## Traffic

- Requests/sec
- Bytes/sec
- Active connections

## Performance

- Latency
- Error rate
- Queue depth

## Backend

- Healthy servers
- Failed health checks
- Connection count

## Availability

- Failover events
- Region status

---

# 31. Real-World Systems

## NGINX

Features:

- Reverse proxy
- HTTP load balancing
- TLS termination
- Caching

---

## HAProxy

Features:

- High-performance TCP/HTTP balancing
- Health checks
- Advanced routing

---

## Envoy Proxy

Features:

- Service mesh
- Dynamic configuration
- Observability

---

## AWS Elastic Load Balancer

Types:

- Application Load Balancer
- Network Load Balancer
- Gateway Load Balancer

---

# 32. Interview Questions

## Q1. Layer 4 vs Layer 7 Load Balancer?

|Layer 4|Layer 7|
|-|-|
|TCP/UDP|HTTP|
|Fast|More intelligent|
|IP-based routing|Content routing|
|Less CPU|More CPU|

---

## Q2. How does a load balancer detect failures?

Through:

- Health checks
- Connection failures
- Latency monitoring

---

## Q3. How do you avoid LB becoming a bottleneck?

Use:

- Multiple instances
- Anycast
- Horizontal scaling
- Hardware acceleration

---

## Q4. How do you maintain sessions?

Options:

- Sticky sessions
- External session storage

---

## Q5. How does consistent hashing help?

It minimizes reassignment when servers are added or removed.

---

# 33. Best Practices

- Use health checks.
- Deploy multiple load balancers.
- Prefer stateless applications.
- Use external session storage.
- Monitor latency and errors.
- Configure proper timeouts.
- Use TLS everywhere.
- Automate backend registration.
- Plan multi-region failover.
- Protect against DDoS attacks.

---

# 34. Summary

A load balancer is a critical distributed system component that improves availability, scalability, and reliability by distributing traffic across healthy backend servers. Modern load balancers combine Layer 4 performance with Layer 7 intelligence, supporting health checks, service discovery, TLS termination, global routing, and automatic failover. Systems such as NGINX, HAProxy, Envoy, and cloud load balancers form the foundation of modern internet-scale architectures.

---

**Next: 29_URL_Shortener_Design.md**

Topics:
- URL generation
- Hashing strategies
- Base62 encoding
- Database design
- Cache layer
- Redirect flow
- Scaling billions of URLs
- Expiration
- Analytics
- Abuse prevention
- Distributed ID generation
