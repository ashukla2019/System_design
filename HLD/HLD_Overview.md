# System Design

## 1. Requirements

### Functional Requirements
- What the system should do (features, user actions, workflows)

### Non-Functional Requirements (SCALD)
- **Scaling** → Handle growing users/traffic  
- **Consistency** → Same data visible across nodes  
- **Availability** → System uptime and accessibility  
- **Latency** → Low response time  
- **Durability** → Data persists even after failures  

---

## 2. Architecture

### Monolithic
- Single tightly coupled application  
- **Use when:** Small apps, MVPs, simple logic  

### Microservices
- Independent services communicating via APIs  
- **Use when:** Large, complex systems, independent scaling  

### Event-Driven
- Communication via events (pub-sub)  
- **Use when:** Real-time systems, async processing  

### Serverless
- Cloud-managed infrastructure, runs on demand  
- **Use when:** Variable or low traffic  

### Stateful
- Stores session/state locally  
- **Use when:** Sessions required (cart, gaming)  

### Stateless
- Each request independent  
- **Use when:** Cloud-native scalable apps  

---

## 3. Communication & Networking

### Networking Fundamentals

- **DNS**
  - Converts domain names → IP addresses
  - Example:
    ```text
    google.com → 142.250.x.x
    ```

- **TCP**
  - Reliable, connection-oriented communication
  - Guarantees delivery and order
  - **Use:** APIs, databases, web applications

- **UDP**
  - Fast, connectionless communication
  - No guarantee of delivery
  - **Use:** Video streaming, gaming, VoIP

- **IP Addressing**
  - Unique identifier for devices in a network
  - IPv4 / IPv6

- **VPC (Virtual Private Cloud)**
  - Isolated cloud network
  - Controls routing and security

- **Subnets**
  - Divide VPC into smaller networks
  - Public subnet → internet accessible
  - Private subnet → internal only

---

# Communication Patterns

Communication patterns define how services/components communicate.

They are mainly:
1. Synchronous
2. Asynchronous
3. Hybrid (Both Sync + Async)

---

## Synchronous Communication

- Client sends request and waits for response
- Blocking communication
- Simpler but tightly coupled

### Flow
```text
Client → Server → Response
```

### Best For
- Immediate responses
- CRUD operations
- User-facing APIs

---

### REST

- HTTP-based architectural style
- Uses:
  - GET
  - POST
  - PUT
  - DELETE

### Example
```http
GET /users/1
```

### Characteristics
- Stateless
- JSON-based
- Easy to integrate
- Human-readable

### Advantages
- Simple
- Widely used
- Browser/mobile friendly

### Disadvantages
- Over-fetching/under-fetching
- Multiple API calls may be needed

### Use Cases
- Public APIs
- Web/mobile backends
- CRUD services

---

### SOAP

- XML-based messaging protocol
- Strict standards and contracts (WSDL)

### Characteristics
- Highly secure
- Reliable
- Enterprise-focused

### Advantages
- Strong security
- Transaction support
- Standardized

### Disadvantages
- Heavy XML payloads
- Slower and more complex

### Use Cases
- Banking systems
- Government systems
- Enterprise integrations

---

## Both (Sync + Async)

Some technologies support both request-response and event-driven communication.

---

### GraphQL

- Query language for APIs
- Single endpoint:
  ```text
  /graphql
  ```

### Key Idea
Client requests only required data.

### Example
```graphql
{
  user(id: 1) {
    name
    email
  }
}
```

### Advantages
- Avoids over-fetching
- Flexible frontend queries
- Reduces API calls

### Disadvantages
- Complex caching
- Harder backend implementation

### Supports
- Synchronous queries
- Asynchronous subscriptions

### Use Cases
- Complex frontend UIs
- Mobile apps
- Dashboards

---

### gRPC

- High-performance RPC framework by Google
- Uses:
  - HTTP/2
  - Protocol Buffers (binary serialization)

### Characteristics
- Very fast
- Strongly typed
- Supports streaming

### Advantages
- Low latency
- Efficient binary communication
- Excellent for internal services

### Disadvantages
- Harder browser support
- Less human-readable

### Use Cases
- Microservices
- Real-time internal communication
- Distributed systems

---

## Asynchronous Communication

- Sender does not wait for immediate response
- Non-blocking communication
- Highly scalable and decoupled

### Flow
```text
Producer → Broker → Consumer
```

### Best For
- Background processing
- Event-driven systems
- Real-time pipelines

---

### WebSocket

- Persistent two-way communication channel
- Full-duplex connection

### Difference from HTTP
HTTP:
```text
Request → Response → Connection closes
```

WebSocket:
```text
Connection stays open
```

### Advantages
- Real-time communication
- Low latency updates

### Disadvantages
- Persistent connection management
- More resource usage

### Use Cases
- Chat applications
- Live dashboards
- Multiplayer games
- Stock trading apps

---

## Message Queues / Streams

Used for asynchronous service-to-service communication.

---

### RabbitMQ

- Queue-based message broker

### Flow
```text
Producer → Queue → Consumer
```

### Characteristics
- Messages removed after consumption
- Reliable delivery
- Supports retries

### Advantages
- Decouples services
- Good for task distribution
- Easy retry mechanisms

### Disadvantages
- Not ideal for large event streams

### Use Cases
- Background jobs
- Email processing
- Payment processing
- Task queues

---

### Kafka

- Distributed event streaming platform
- Uses append-only logs called topics

### Flow
```text
Producer → Kafka Topic → Consumers
```

### Characteristics
- Messages retained for replay
- High throughput
- Distributed and scalable

### Advantages
- Event replay support
- Real-time analytics
- Massive scalability

### Disadvantages
- More operational complexity

### Use Cases
- Event streaming
- Analytics pipelines
- Log aggregation
- Fraud detection
- Real-time monitoring

---

# Quick Comparison

| Technology | Type | Best For |
|---|---|---|
| REST | Sync | Public APIs |
| SOAP | Sync | Enterprise systems |
| GraphQL | Sync + Async | Complex frontend |
| gRPC | Sync + Async | Microservices |
| WebSocket | Async | Real-time apps |
| RabbitMQ | Async | Background jobs |
| Kafka | Async | Event streaming |
---

### Infrastructure

- **API Gateway**
  - Entry point for requests  
  - Handles auth, rate limiting, routing  
  - Example: AWS API Gateway, NGINX  

- **Forward Proxy**
  - Hides client identity  
  - Used for caching, bypassing restrictions  

- **Reverse Proxy**
  - Sits in front of servers  
  - Load balancing, SSL termination  
  - Example: NGINX, HAProxy  

---

### Traffic Control
- **Rate Limiting**
  - Restrict number of requests to prevent abuse  

---

## 4. Data Management

### Databases

#### SQL (ACID)
- **Atomicity** → All or nothing  
- **Consistency** → Valid state  
- **Isolation** → No interference  
- **Durability** → Permanent data  

#### NoSQL (BASE)
- **Basically Available**  
- **Soft State**  
- **Eventual Consistency**  

---

### Data Modeling
- **Normalization** → Reduce redundancy  
- **Denormalization** → Improve performance  

---

### Data Distribution
- **Replication** → Copies for availability  
- **Sharding** → Split data for scalability  
- **CAP Theorem** → Trade-off: Consistency, Availability, Partition tolerance  

---

## 5. Storage

- **Block Storage**
  - Raw disk blocks  
  - **Use:** OS, databases, VMs  

- **Object Storage**
  - Stores objects with metadata  
  - **Use:** Images, backups, logs  

- **File Storage**
  - Shared file system  
  - **Use:** Team files, CMS  

- **Backup & Disaster Recovery**
  - Data recovery strategies  

---

## 6. Fault Tolerance

# Core Concepts

- High availability → system accessible always (achieved via redundency)
- Fault tolerance → system continues despite failures (replication + failover)
- Reliability → system rarely fails
- Consensus → nodes agree on a leader or value

---

# Failure Handling

- Health Checks → Detect failed/unhealthy nodes
- Failover → Switch to backup automatically
- Retry + Backoff → Retry with delay (1s → 2s → 4s)
- Circuit Breaker → Stop calls to failing service temporarily
---

## 7. Scaling

- **Horizontal Scaling**
  - Add more servers  

- **Vertical Scaling**
  - Increase CPU/RAM  

- **Auto Scaling**
  - Scale automatically based on load  

---

## 8. Security

### Cybersecurity Principles
- CIA Triad
- Threat Modeling
- Zero Trust

### Network Security
- Firewall
- WAF
- Security Groups

### Authentication (AuthN)
- API Key
- Basic Auth
- Session-Based Auth
- Bearer Token
- JWT
- OAuth 2.0
- SSO / OpenID Connect

### Authorization (AuthZ)
- RBAC
- ABAC
- Scopes & Permissions

### Encryption
- SSL/TLS
- Data Encryption
- Hashing (bcrypt, Argon2)
---

### Network Security
- **Firewall** → Traffic filtering  
- **WAF** → Protects web apps (SQLi, XSS)  
- **Security Groups** → Cloud-level firewall  

---

### Auth
- **Authentication (AuthN)** → Verify identity  
- **Authorization (AuthZ)** → Access control  

---

### Encryption
- **SSL/TLS** → Secure communication  
- **Data Encryption** → Protect stored data  

---

## 9. Monitoring

- **Logging** → Record events/errors  
- **Metrics** → CPU, latency, throughput  
- **Alerting** → Notify on issues  

---

## 10. Deployment

- **Cloud Deployment**
  - AWS, Azure, GCP  

- **CI/CD**
  - Automated build/test/deploy  

- **Containerization**
  - Package apps (Docker)  

- **Infrastructure as Code (IaC)**
  - Terraform, CloudFormation  
