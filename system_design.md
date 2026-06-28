# System Design Request Flow

```text
User
 │
 ▼
Requirements
 │
 ▼
DNS Resolution
 │
 ▼
Traffic Layer
 │
 ▼
Network Layer
 │
 ▼
Security Layer
 │
 ▼
Compute Layer
 │
 ▼
Architecture Layer
 │
 ▼
Communication Layer
 │
 ▼
Business Logic Layer
 │
 ▼
Cache Layer
 │
 ▼
Data Access Layer
 │
 ▼
Data Layer
 │
 ▼
Storage Layer
 │
 ▼
Reliability Layer
 │
 ▼
Monitoring Layer
 │
 ▼
Scaling
 │
 ▼
Deployment
 │
 ▼
Response Returned
```

---

# 1. Requirements

### Problem
Need to understand what the system should do and how well it should perform.

### Solution

#### Functional Requirements
- Define features and user workflows.

#### Non-Functional Requirements

- Scaling
- Consistency
- Availability
- Latency
- Durability
- Reliability
- Security

### Next Problem
Users need a simple way to reach the application.

### Next Layer
DNS Resolution

---

# 2. DNS Resolution Layer

### Problem
Users remember domain names, not IP addresses.

### Solution

#### DNS
- Converts domain names into IP addresses.

#### IP Addressing
- Provides a unique network identity using IPv4 or IPv6.

### Flow

```text
User
 ↓
google.com
 ↓
DNS Lookup
 ↓
IP Address
```

### Next Problem
Now that we know the server IP, how do we handle millions of incoming users?

### Next Layer
Traffic Layer

---

# 3. Traffic Layer

## Problem
Millions of users can overload servers, malicious traffic can reach applications, and requests must be routed efficiently to the correct backend services.

## Solution

### 1. CDN (Content Delivery Network)

#### Purpose
Bring content closer to users.

#### What Problem It Solves
- High latency
- Global users
- Origin server overload

#### How It Works
User → CDN Edge Server → Origin Server

If content is cached:
- Served directly from CDN

If not cached:
- CDN fetches from origin and stores copy

#### Common Use Cases
- Images
- Videos
- CSS/JS files
- Downloads
- Static websites

---

### 2. WAF (Web Application Firewall)

#### Purpose
Protect web applications from attacks.

#### What Problem It Solves
Attackers send malicious requests such as:
- SQL Injection
- XSS
- CSRF
- Path Traversal
- Bot Attacks

#### How It Works

User Request
↓
WAF
↓
Application

WAF inspects HTTP requests before they reach servers.

#### Common Use Cases
- Internet-facing applications
- Banking systems
- E-commerce websites

---

### 3. Rate Limiting

#### Purpose
Control request volume.

#### What Problem It Solves
- API abuse
- DDoS amplification
- Cost explosion
- Resource starvation

#### How It Works

User
↓
Rate Limiter
↓
Application

Example:
- 100 requests/minute/user
- Extra requests return 429 Too Many Requests

#### Common Algorithms
- Token Bucket
- Leaky Bucket
- Fixed Window
- Sliding Window

#### Common Use Cases
- Login APIs
- Public APIs
- Payment APIs

---

### 4. API Gateway

#### Purpose
Single entry point for APIs and microservices.

#### What Problem It Solves

Without API Gateway:

Client
├── User Service
├── Order Service
├── Payment Service
├── Inventory Service

Client must know:
- All service locations
- Authentication methods
- API versions

Complex and difficult to maintain.

#### How It Works

Client
↓
API Gateway
├── User Service
├── Order Service
├── Payment Service
└── Inventory Service

Gateway handles:
- Authentication
- Authorization
- Rate limiting
- Request validation
- API versioning
- Logging
- Monitoring
- Request aggregation
- Routing

#### Example

Client requests:

GET /dashboard

Gateway internally calls:

User Service
Order Service
Payment Service

Combines responses and returns one response.

#### Common Use Cases
- Microservices
- Mobile applications
- Public APIs
- SaaS platforms

#### Examples
- :contentReference[oaicite:0]{index=0}
- :contentReference[oaicite:1]{index=1}
- :contentReference[oaicite:2]{index=2}

---

### 5. Reverse Proxy

#### Purpose
Acts on behalf of backend servers.

#### What Problem It Solves

Without Reverse Proxy:

Client
↓
Application Server

Application server exposed directly.

Problems:
- Security risk
- SSL overhead
- No caching
- Difficult routing

#### How It Works

Client
↓
Reverse Proxy
↓
Backend Servers

Client never directly sees backend servers.

#### Responsibilities

##### SSL Termination

Client
↓ HTTPS
Reverse Proxy
↓ HTTP
Backend

Backend servers avoid encryption overhead.

##### Routing

/api → API Servers

/static → Static Servers

/admin → Admin Servers

##### Caching

Stores frequently requested content.

##### Compression

Compresses responses before sending.

##### Security

Hides internal infrastructure.

#### Common Use Cases
- Web applications
- Internal services
- SSL offloading

#### Examples
- :contentReference[oaicite:3]{index=3}
- :contentReference[oaicite:4]{index=4}
- :contentReference[oaicite:5]{index=5}

---

### 6. Load Balancer

#### Purpose
Distribute traffic across multiple servers.

#### What Problem It Solves

Without Load Balancer:

Users
↓
Server A

Server A overloaded while others idle.

Single point of failure.

#### How It Works

Users
↓
Load Balancer
├── Server A
├── Server B
├── Server C
└── Server D

Requests distributed automatically.

#### Load Balancing Algorithms

##### Round Robin

Req1 → A

Req2 → B

Req3 → C

##### Least Connections

Send request to server with fewest active connections.

##### Weighted Round Robin

More traffic sent to stronger servers.

#### Health Checks

Load Balancer continuously checks:

- CPU
- Memory
- Network
- Service availability

Failed servers are removed automatically.

#### Common Use Cases
- High availability
- Horizontal scaling
- Fault tolerance

#### Examples
- :contentReference[oaicite:6]{index=6}
- :contentReference[oaicite:7]{index=7}
- :contentReference[oaicite:8]{index=8}

---

# API Gateway vs Reverse Proxy vs Load Balancer

| Feature | API Gateway | Reverse Proxy | Load Balancer |
|----------|------------|---------------|---------------|
| Primary Goal | Manage APIs | Protect & route servers | Distribute traffic |
| Authentication | Yes | Limited | No |
| Rate Limiting | Yes | Basic | No |
| API Versioning | Yes | No | No |
| Request Aggregation | Yes | No | No |
| SSL Termination | Sometimes | Yes | Yes |
| Caching | Sometimes | Yes | Limited |
| Routing | API-based | URL-based | Server-based |
| Health Checks | Sometimes | Limited | Yes |
| Load Distribution | Sometimes | Limited | Yes |

---

# When To Use Which?

## Use API Gateway When

- Microservices architecture
- Public APIs
- Mobile applications
- Need authentication
- Need API versioning
- Need request aggregation

Flow:

Client
↓
API Gateway
↓
Microservices

---

## Use Reverse Proxy When

- Need SSL termination
- Need caching
- Need URL routing
- Want to hide backend servers

Flow:

Client
↓
Reverse Proxy
↓
Application Servers

---

## Use Load Balancer When

- Multiple server instances exist
- High availability required
- Horizontal scaling required
- Need failover support

Flow:

Users
↓
Load Balancer
├── Server A
├── Server B
└── Server C

---

# Real Production Architecture

User
↓
CDN
↓
WAF
↓
Rate Limiter
↓
Load Balancer
↓
API Gateway
↓
Reverse Proxy (optional)
↓
Microservices

OR

User
↓
CDN
↓
WAF
↓
Reverse Proxy (NGINX)
↓
Load Balancer
↓
Application Servers

The key distinction:

- **Load Balancer decides "Which server?"**
- **Reverse Proxy decides "Where should this request go?"**
- **API Gateway decides "How should this API request be handled?"**

### Next Problem
Traffic has reached the datacenter. How does it travel reliably between machines?

### Next Layer
Network Layer

---

# 4. Network Layer

### Problem
Data must travel reliably across networks despite failures and packet loss.

### Solution

#### TCP
- Reliable and ordered communication.

#### UDP
- Fast connectionless communication.

#### VPC
- Private isolated cloud network.

#### Subnets
- Separate public and private resources.

#### Routers
- Route packets between networks.

#### Firewalls
- Filter network traffic.

### Flow

```text
Internet
 ↓
Router
 ↓
Firewall
 ↓
VPC
 ↓
Subnet
 ↓
Server
```

### Next Problem
Traffic reached the server, but anyone can intercept or modify it.

### Next Layer
Security Layer

---

# 5. Security Layer

### Problem
Attackers can intercept traffic or impersonate users.

### Solution

#### TLS / SSL
- Encrypts communication between client and server.

##### Working

```text
Client Hello
 ↓
Server Hello
 ↓
Certificate Exchange
 ↓
Key Exchange
 ↓
Encrypted Communication
```

#### Authentication
- Verifies identity.

##### Working

```text
Credentials
 ↓
Auth Service
 ↓
Validation
 ↓
Token / Session
```

#### Authorization
- Determines what actions are allowed.

##### Working

```text
Authenticated User
 ↓
Role / Policy Check
 ↓
Allow or Deny
```

#### JWT
- Signed token carrying user identity and permissions.

##### Working

```text
Login
 ↓
JWT Generated
 ↓
Stored By Client
 ↓
Sent With Request
 ↓
Validated By Server
```

#### OAuth
- Delegated authorization without sharing passwords.

##### Working

```text
User
 ↓
Google/GitHub
 ↓
Access Token
 ↓
Application Access
```

#### RBAC
- Access based on roles.

```text
Admin → Read/Write/Delete
User  → Read
```

#### ABAC
- Access based on attributes such as role, device, location and time.

#### Zero Trust
- Never trust by default.

##### Working

```text
Verify Identity
 ↓
Verify Device
 ↓
Verify Context
 ↓
Grant Access

---------------------
Secure communication?
    → TLS/SSL

Who is the user?
    → Authentication

What can the user do?
    → Authorization

Need stateless auth?
    → JWT

Need Google/GitHub login?
    → OAuth

Permissions based on roles?
    → RBAC

Permissions based on context?
    → ABAC

Need maximum security?
    → Zero Trust
```

### Next Problem
The request is secure. Where should the application run?

### Next Layer
Compute Layer

---

# 6. Compute Layer

### Problem
Applications need CPU, memory, storage and runtime environments.

### Solution

#### Physical Server
- Actual hardware.

#### Virtual Machine
- Virtualized operating system.

#### Container
- Lightweight isolated runtime.

#### Kubernetes
- Container orchestration platform.

### Flow

```text
Physical Server
 ↓
Virtual Machine
 ↓
Container
 ↓
Application
```

### Next Problem
How should application components be organized?

### Next Layer
Architecture Layer

---

# 7. Architecture Layer

### Problem
Applications become difficult to maintain and scale.

### Solution

#### Monolithic
- Entire application deployed together.

#### Microservices
- Independent deployable services.

#### Event Driven
- Components communicate through events.

#### Stateful
- Stores session state locally.

#### Stateless
- Each request is independent.

#### Serverless
- Infrastructure managed by cloud provider.

### Flow

```text
Request
 ↓
User Service
 ↓
Order Service
 ↓
Payment Service
```

### Next Problem
Services need a way to communicate.

### Next Layer
Communication Layer

---

# 8. Communication Layer

### Problem
Services must exchange data and coordinate work.

### Solution

#### REST
- HTTP-based resource communication.

##### Working

```text
Client
 ↓
HTTP Request
 ↓
Server
 ↓
JSON Response
```

#### SOAP
- XML-based enterprise protocol.

##### Working

```text
SOAP Request
 ↓
XML Envelope
 ↓
Server
 ↓
SOAP Response
```

#### GraphQL
- Client requests exactly the required data.

##### Working

```text
Query
 ↓
GraphQL Resolver
 ↓
Database / Services
 ↓
Requested Data Returned
```

#### gRPC
- High-performance RPC using Protocol Buffers and HTTP/2.

##### Working

```text
Service A
 ↓
Protocol Buffer
 ↓
HTTP/2
 ↓
Service B
```

#### WebSocket
- Persistent bidirectional communication.

##### Working

```text
Handshake
 ↓
Persistent Connection
 ↓
Client ↔ Server
```

#### RabbitMQ
- Message queue for asynchronous processing.

##### Working

```text
Producer
 ↓
Queue
 ↓
Consumer
```

#### Kafka
- Distributed event streaming platform.

##### Working

```text
Producer
 ↓
Topic
 ↓
Partition
 ↓
Consumer Group
```

#### Communication Patterns

##### Synchronous
- Caller waits for response.

Examples:
- REST
- SOAP
- gRPC

##### Asynchronous
- Caller continues without waiting.

Examples:
- Kafka
- RabbitMQ

##### Hybrid
- Combines synchronous and asynchronous communication.

Examples:
- REST + Kafka
- gRPC + Kafka

### Next Problem
Business rules must now be executed.

### Next Layer
Business Logic Layer

---

# 9. Business Logic Layer

### Problem
Requests must follow application rules.

### Solution

- User Validation
- Payment Validation
- Inventory Check
- Fraud Detection
- Order Processing

### Flow

```text
Request
 ↓
Business Rules
 ↓
Validated Request
```

### Next Problem
Repeated database access is expensive.

### Next Layer
Cache Layer

---

# 10. Cache Layer

### Problem
Database queries are slow and expensive.

### Solution

#### Browser Cache
- Stores resources locally.

#### CDN Cache
- Stores content at edge locations.

#### Application Cache
- Stores frequently used data.

#### Redis / Memcached
- Distributed in-memory cache.

### Flow

```text
Request
 ↓
Cache
 ├─ Hit  → Return Data
 └─ Miss → Database
```

### Next Problem
Cache miss requires database access.

### Next Layer
Data Access Layer

---

# 11. Data Access Layer

### Problem
Applications need a structured way to interact with databases.

### Solution

#### ORM
- Maps objects to database tables.

#### Repository
- Abstracts data access.

#### DAO
- Encapsulates database operations.

#### Transactions
- Ensure all operations succeed or fail together.

### Flow

```text
Controller
 ↓
Service
 ↓
Repository
 ↓
Database
```

### Next Problem
Where should data be stored?

### Next Layer
Data Layer

---

# 12. Data Layer

### Problem
Applications need durable and scalable data storage.

### Solution

#### SQL
- Structured relational databases with ACID guarantees.

#### NoSQL
- Flexible databases optimized for scale.

#### Replication
- Copies data across nodes.

#### Sharding
- Splits data across multiple nodes.

#### Normalization
- Removes redundancy.

#### Denormalization
- Improves read performance.

#### CAP Theorem
- Tradeoff between Consistency, Availability and Partition Tolerance.

### Next Problem
Where is data physically stored?

### Next Layer
Storage Layer

---

# 13. Storage Layer

### Problem
Data must persist even after application restarts or failures.

### Solution

#### Block Storage
- Used by databases and VMs.

#### File Storage
- Shared hierarchical storage.

#### Object Storage
- Stores images, videos, logs and backups.

#### Backup & Disaster Recovery
- Recovers from failures and disasters.

### Next Problem
Systems and hardware eventually fail.

### Next Layer
Reliability Layer

---

# 14. Reliability Layer

### Problem
Failures are inevitable in distributed systems.

### Solution

#### Health Checks
- Detect unhealthy services.

#### Failover
- Switch to backup resources.

#### Retry
- Reattempt failed operations.

#### Backoff
- Increase retry intervals gradually.

```text
1s → 2s → 4s → 8s → 16s
```

#### Circuit Breaker
- Stops requests to failing services.

#### High Availability
- Keeps services accessible.

#### Consensus
- Ensures distributed nodes agree on state.

### Next Problem
Failures must be detected and investigated.

### Next Layer
Monitoring Layer

---

# 15. Monitoring Layer

### Problem
Teams need visibility into system behavior.

### Solution

#### Logging
- Records events and errors.

#### Metrics
- Measures CPU, memory, latency and throughput.

#### Alerting
- Notifies operators when thresholds are exceeded.

#### Tracing
- Tracks request path across services.

### Flow

```text
Gateway
 ↓
Order Service
 ↓
Payment Service
 ↓
Database
```

### Next Problem
Traffic continues to grow.

### Next Layer
Scaling

---

# 16. Scaling

### Problem
Increasing users and traffic exceed current capacity.

### Solution

#### Horizontal Scaling
- Add more servers.

#### Vertical Scaling
- Add more CPU, memory or storage.

#### Auto Scaling
- Dynamically adjust capacity.

### Next Problem
Changes must be released safely.

### Next Layer
Deployment

---

# 17. Deployment

### Problem
Applications must be delivered safely and consistently.

### Solution

#### Cloud Deployment
- Run workloads on AWS, Azure or GCP.

#### CI/CD
- Automate build, test and deployment.

#### Containerization
- Package applications into containers.

#### Infrastructure as Code (IaC)
- Manage infrastructure using code.

### Final Flow

```text
User Request
 ↓
Processed Through All Layers
 ↓
Business Logic Executed
 ↓
Data Retrieved / Stored
 ↓
Response Generated
 ↓
Returned To User


--------------------------------
url routing: 
Different URLs should go to different services.

Example:

/api/*
/images/*
/payments/*
/admin/*

------------------------
ssl termination:
The reverse proxy:

Receives HTTPS request
Decrypts SSL/TLS traffic
Reads HTTP request
Forwards request to backend

This process is called SSL Termination because the SSL connection "terminates" at the proxy.
```