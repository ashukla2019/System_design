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

User
 ↓ HTTPS (TLS)
Application
 ↓
Redirect to Google (OAuth)
 ↓
Google Verifies User
 ↓
Application Receives Identity
 ↓
Application Creates JWT
 ↓
JWT Sent On Future Requests.
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

---------------------


Delegated Authorization without Password Sharing is exactly what OAuth solves.

The Problem
Suppose your application wants access to a user's Google Drive.

Bad approach:

User
 ↓
Gives Google Username + Password
 ↓
Your Application
 ↓
Logs into Google
Problems:

Application sees the user's password.

If the application is compromised, the password is exposed.

User must trust every application with their credentials.

OAuth Solution
Instead of sharing the password, the user authorizes Google to grant limited access.

User
 ↓
Redirect to Google
 ↓
Login on Google
 ↓
Google asks:
"Allow this app to read your Drive?"
 ↓
User Approves
 ↓
Google issues Access Token
 ↓
Application uses Token
The application never sees the password.

Real Example: "Login with Google"
User
 ↓
Click "Login with Google"
 ↓
Google Authentication
 ↓
User Approves
 ↓
Google returns Access Token
 ↓
Application gets user information
Your application receives:

{
  "access_token": "xyz123"
}
Not:

{
  "username": "user@gmail.com",
  "password": "secret123"
}
Why It's Called "Delegated Authorization"
The user delegates specific permissions to an application.

Example:

User
 ↓
Google
 ↓
Delegates Permission:
   ✓ Read Email
   ✓ Read Profile
   ✗ Delete Account
   ✗ Change Password
The application gets only the permissions (scopes) that the user approved.

Simple Memory Trick
Authentication
=
Who are you?

Authorization
=
What can you do?

OAuth
=
Let another application do something
on your behalf without knowing your password.
Example:

Spotify accessing Google account
Slack accessing Google Calendar
GitHub login to a website
Login with Google
Login with Microsoft
Login with Facebook
All of these use OAuth's delegated authorization model: permission is delegated via tokens, not by sharing passwords.


How oauth diff from jwt in terms of reqiirement

This is one of the most commonly confused topics.

OAuth and JWT solve different problems.

Question	OAuth	JWT
Purpose	Delegated Authorization	Stateless Authentication
Problem Solved	"Can this app access my resources?"	"Who is this user?"
Used For	Third-party access	User sessions
Token Format	Usually uses access tokens (often JWT, but not required)	JWT token
Login with Google?	Yes	No
Microservice authentication?	Usually No	Yes
User session management?	No	Yes
JWT Requirement
Problem
After login, how does the server remember the user?

Traditional way:

User Login
 ↓
Session Stored in Server Memory
 ↓
Future Requests Use Session ID
Problems:

Session storage needed

Hard to scale

Sticky sessions required

Solution
Store identity inside token.

Login
 ↓
JWT Created
 ↓
Client Stores JWT
 ↓
JWT Sent With Every Request
Requirement Trigger
When interviewer says:

Millions of users
Microservices
Stateless system
REST APIs
Mobile apps
Think:

JWT
Example:

Netflix
Amazon
Swiggy
Uber
User logs in and receives JWT.

OAuth Requirement
Problem
Application needs access to another service.

Example:

Canva wants Google Drive access.
Without OAuth:

User gives Google password to Canva
Very dangerous.

Solution
Google gives Canva a limited access token.

User
 ↓
Google Login
 ↓
Approve Access
 ↓
Google Issues Token
 ↓
Canva Uses Token
Password never shared.

Requirement Trigger
When interviewer says:

Login with Google
Login with GitHub
Third-party integration
Access user data from another platform
Think:

OAuth
Real Example
JWT
User
 ↓
My Application
 ↓
Login
 ↓
JWT Generated
 ↓
JWT Used For Future Requests
JWT is between:

User ↔ My Application
OAuth
User
 ↓
Google
 ↓
Permission Granted
 ↓
Token Issued
 ↓
My Application
OAuth is between:

User ↔ Google ↔ My Application
Can OAuth and JWT Work Together?
Yes, very often.

Example:

Login with Google
Flow:

User
 ↓
Google OAuth
 ↓
Google Verifies User
 ↓
Application Receives User Info
 ↓
Application Creates JWT
 ↓
JWT Used For Future Requests
So:

OAuth
=
Initial Login

JWT
=
Subsequent Requests
This is how many modern systems work.

Interview Decision Tree
Need user login?
      ↓
JWT

Need stateless authentication?
      ↓
JWT

Need scalable session management?
      ↓
JWT

Need Login with Google/GitHub?
      ↓
OAuth

Need third-party access?
      ↓
OAuth

Need one application to access another service?
      ↓
OAuth
Easy Memory Trick
JWT
=
"I already know who you are."

OAuth
=
"Google/Microsoft will tell me who you are."
Or even shorter:

JWT
=
Maintain Login

OAuth
=
Obtain Permission
In a typical production system:

User
 ↓
OAuth (Google Login)
 ↓
Application
 ↓
JWT Issued
 ↓
Future API Requests
So OAuth is often used to establish identity, and JWT is then used to carry that identity efficiently on every request.


Wjy we need ssl/tls, jwt and oauth

Think of them as solving three completely different problems in the request flow.

TLS/SSL
   ↓
Protects Data In Transit

OAuth
   ↓
Obtains Identity / Permission

JWT
   ↓
Maintains Identity Across Requests
Example: Login with Google
A user opens your application and clicks Login with Google.

Step 1: TLS/SSL
Problem
Data travels through the internet.

Without TLS:

User
 ↓
Username
Password
Cookies
Tokens
Anyone intercepting traffic could read it.

Solution
User
 ↓ HTTPS
Application
Everything is encrypted.

Requirement:
Whenever data travels over a network.

Step 2: OAuth
Problem
Your application wants to know who the user is.

You do not want:

User gives Google password
to your application
Solution
Google authenticates the user.

User
 ↓
Google
 ↓
User Approves
 ↓
Application Receives Access
Password never reaches your application.

Requirement:
When using:

Login with Google
Login with GitHub
Login with Microsoft
Third-party integrations
Step 3: JWT
Problem
After login, every request needs user identity.

Without JWT:

Request 1
Check Database

Request 2
Check Database

Request 3
Check Database
Expensive and hard to scale.

Solution
Store identity in token.

JWT
{
  userId: 123
  role: Admin
}
Client sends JWT with every request.

Request
 ↓
JWT
 ↓
Server validates
No session lookup required.

Requirement:
When building:

REST APIs
Microservices
Mobile Apps
SPAs
Distributed Systems
Why All Three Together?
Consider:

https://myapp.com
User clicks:

Login with Google
Full flow:

User
 ↓ HTTPS (TLS)
Application
 ↓
Redirect to Google (OAuth)
 ↓
Google Verifies User
 ↓
Application Receives Identity
 ↓
Application Creates JWT
 ↓
JWT Sent On Future Requests
What Happens If One Is Missing?
No TLS
OAuth Token Stolen
JWT Stolen
Passwords Exposed
System insecure.

No OAuth
Cannot Login with Google
Cannot Use Third-Party Identity
Need your own login system.

No JWT
Server Must Store Sessions
More Database Lookups
Harder Horizontal Scaling
Interview Cheat Sheet
Requirement	Use
Encrypt network traffic	TLS/SSL
Login with Google/GitHub	OAuth
Third-party authorization	OAuth
Stateless authentication	JWT
Microservices authentication	JWT
Secure communication	TLS/SSL
Maintain user login after authentication	JWT
Easy Memory Trick
TLS
=
Protect the Message

OAuth
=
Get Permission / Identity

JWT
=
Carry Identity
Or in one line:

TLS secures the connection,
OAuth obtains the identity,
JWT carries the identity.

Explain it how it links with system design? # 6. Compute Layer

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

text
Physical Server
 ↓
Virtual Machine
 ↓
Container
 ↓
Application

This layer is important in System Design because it answers:

"Where will my application actually run?"

All the layers before this (DNS, CDN, Load Balancer, API Gateway, Security) help requests reach your application. The Compute Layer is where the application executes.

6. Compute Layer
Problem
Your application needs:

CPU
Memory (RAM)
Disk
Network
Operating System
Runtime Environment
Without compute resources:

User Request
 ↓
Application
 ❌ Cannot Run
How It Connects To System Design
Imagine designing a system like Netflix.

Users generate requests:

User
 ↓
DNS
 ↓
CDN
 ↓
Load Balancer
 ↓
Application
The question becomes:

Where is this application running?

Answer:

Physical Server
 ↓
Virtual Machine
 ↓
Container
 ↓
Application
The Compute Layer provides the execution environment.

1. Physical Server
What It Is
Real hardware.

CPU
RAM
Disk
Network Card
Motherboard
Examples:

Servers in data centers

Cloud provider hardware

Problem Solved
Need actual hardware to execute code.

System Design View
Users
 ↓
Application
 ↓
Physical Server
Everything ultimately runs on hardware.

Limitation
One application consuming all resources affects others.

App A
App B
App C
All sharing one machine.

Poor isolation.

2. Virtual Machine (VM)
Problem
Need multiple isolated environments on the same hardware.

Without VM:

Physical Server
 ├── App A
 ├── App B
 └── App C
Apps can interfere with each other.

Solution
Virtualization.

Physical Server
 ↓
Hypervisor
 ├── VM 1
 ├── VM 2
 └── VM 3
Each VM has:

Own OS
Own Memory
Own CPU Allocation
Own Storage
Example
Physical Server
 ├── Ubuntu VM
 ├── Windows VM
 └── RedHat VM
System Design Trigger
When you need:

Strong Isolation
Multiple Operating Systems
Legacy Applications
Use:

Virtual Machines
3. Containers
Problem
VMs are heavy.

Each VM contains:

Application
Operating System
Libraries
Consumes lots of memory.

Solution
Containers share the host OS.

Host OS
 ├── Container A
 ├── Container B
 └── Container C
Each container contains:

Application
Libraries
Dependencies
But not a full OS.

Why System Designers Love Containers
Portable:

Developer Laptop
 ↓
QA
 ↓
Production
Same container everywhere.

Example
User Service
Order Service
Payment Service
Each packaged separately.

Container 1
Container 2
Container 3
System Design Trigger
When interviewer says:

Microservices
Fast Deployment
Scalability
Cloud Native
Think:

Containers
4. Kubernetes
Problem
Managing hundreds or thousands of containers manually is impossible.

Imagine:

500 Containers
Across 50 Servers
Questions:

Which server runs container?
What if container crashes?
How to scale?
How to update?
Solution
Kubernetes orchestrates containers.

Kubernetes
 ├── Scheduling
 ├── Scaling
 ├── Self-Healing
 ├── Service Discovery
 └── Rolling Updates
Example
Need 10 instances:

User Service × 10
Kubernetes creates:

Pod 1
Pod 2
Pod 3
...
Pod 10
If Pod 5 crashes:

Kubernetes
 ↓
Creates New Pod
Automatically.

Scaling Example
Traffic increases:

100 Requests/sec
 ↓
10,000 Requests/sec
Kubernetes:

5 Pods
 ↓
50 Pods
Automatically.


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