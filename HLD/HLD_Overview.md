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
- **DNS** → Domain → IP resolution  
- **TCP/UDP** → Reliable vs fast communication  
- **IP Addressing** → Device identification  
- **VPC/Subnets** → Isolated cloud networks  

### Communication Patterns

#### Synchronous
- Immediate response required  

- **REST**
  - HTTP-based, CRUD (GET, POST, PUT, DELETE)  
  - **Use:** Simple APIs, public services  

- **SOAP**
  - XML-based protocol  
  - **Use:** Banking, enterprise systems  

#### Both (Sync + Async)
- **GraphQL**
  - Single endpoint, fetch exact data  
  - **Use:** Complex UI  

- **gRPC**
  - HTTP/2 + Protobuf (binary)  
  - **Use:** Microservices, low latency  

#### Asynchronous
- **WebSocket**
  - Persistent full-duplex connection  
  - **Use:** Chat apps, live dashboards  

- **Message Queues / Streams**
  - **RabbitMQ**
    - Queue-based (producer → queue → consumer)  
    - **Use:** Background jobs, task queues  

  - **Kafka**
    - Log-based (topics, replay supported)  
    - **Use:** Event streaming, analytics  

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

- **Redundancy**
  - Duplicate components  

- **Failover**
  - Switch to standby system  

- **Disaster Recovery**
  - Restore after major failures  

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
- **CIA Triad**
  - Confidentiality, Integrity, Availability  

- **Threat Modeling**
  - Identify and mitigate risks  

- **Zero Trust**
  - Never trust, always verify  

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