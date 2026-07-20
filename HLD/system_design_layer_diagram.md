# System Design - Complete Layer Diagram

```text
                                      USER
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. REQUIREMENTS                                             │
│-------------------------------------------------------------│
│ • Functional Requirements                                   │
│ • Non-Functional Requirements                               │
│   (Latency, Availability, Scalability, Security, etc.)      │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Need a way to locate the application
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. DNS RESOLUTION                                           │
│-------------------------------------------------------------│
│ Converts Domain Name → IP Address                           │
│ Example: google.com → 142.xxx.xxx.xxx                       │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Millions of users now know the IP
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. TRAFFIC LAYER                                            │
│-------------------------------------------------------------│
│ CDN                                                         │
│ WAF                                                         │
│ Rate Limiter                                                │
│ Load Balancer                                               │
│ API Gateway                                                 │
│ Reverse Proxy                                               │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Request reaches the cloud/datacenter
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. NETWORK LAYER                                            │
│-------------------------------------------------------------│
│ Internet                                                    │
│ Router                                                      │
│ Firewall                                                    │
│ VPC                                                         │
│ Subnet                                                      │
│ Private Network                                             │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Data must travel securely
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. SECURITY LAYER                                           │
│-------------------------------------------------------------│
│ TLS / SSL                                                   │
│ Authentication                                               │
│ Authorization                                                │
│ OAuth                                                        │
│ JWT                                                          │
│ RBAC / ABAC                                                  │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Trusted request is ready to execute
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. COMPUTE LAYER                                            │
│-------------------------------------------------------------│
│ Physical Server                                              │
│ Hypervisor                                                   │
│ Virtual Machine                                              │
│ Container (Docker)                                           │
│ Kubernetes                                                   │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Application is running
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 7. ARCHITECTURE LAYER                                       │
│-------------------------------------------------------------│
│ Monolith                                                     │
│ Microservices                                                │
│ Event Driven                                                 │
│ Stateless / Stateful                                         │
│ Serverless                                                   │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Services must communicate
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 8. COMMUNICATION LAYER                                      │
│-------------------------------------------------------------│
│ REST                                                         │
│ gRPC                                                         │
│ GraphQL                                                      │
│ WebSocket                                                    │
│ Kafka                                                        │
│ RabbitMQ                                                     │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Execute application rules
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 9. BUSINESS LOGIC LAYER                                     │
│-------------------------------------------------------------│
│ Validation                                                   │
│ Payment Processing                                           │
│ Inventory                                                    │
│ Fraud Detection                                              │
│ Order Processing                                             │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Frequently requested data?
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 10. CACHE LAYER                                             │
│-------------------------------------------------------------│
│ Browser Cache                                                │
│ CDN Cache                                                    │
│ Redis                                                        │
│ Memcached                                                    │
└─────────────────────────────────────────────────────────────┘
          │                           │
      Cache Hit                  Cache Miss
          │                           │
          ▼                           ▼
    Return Response          Data Access Layer
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────┐
│ 11. DATA ACCESS LAYER                                       │
│-------------------------------------------------------------│
│ ORM                                                         │
│ Repository Pattern                                          │
│ DAO                                                         │
│ Transactions                                                │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Read / Write data
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 12. DATA LAYER                                              │
│-------------------------------------------------------------│
│ SQL                                                         │
│ NoSQL                                                       │
│ Replication                                                 │
│ Sharding                                                    │
│ CAP Theorem                                                 │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Data must persist
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 13. STORAGE LAYER                                           │
│-------------------------------------------------------------│
│ Block Storage                                               │
│ File Storage                                                │
│ Object Storage                                              │
│ Backup                                                      │
│ Disaster Recovery                                           │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Failures can happen
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 14. RELIABILITY LAYER                                       │
│-------------------------------------------------------------│
│ Retry                                                       │
│ Backoff                                                     │
│ Circuit Breaker                                             │
│ Failover                                                    │
│ Health Check                                                │
│ High Availability                                           │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Observe system health
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 15. MONITORING LAYER                                        │
│-------------------------------------------------------------│
│ Logs                                                        │
│ Metrics                                                     │
│ Traces                                                      │
│ Alerts                                                      │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Traffic keeps increasing
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 16. SCALING LAYER                                           │
│-------------------------------------------------------------│
│ Horizontal Scaling                                          │
│ Vertical Scaling                                            │
│ Auto Scaling                                                │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Release changes safely
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 17. DEPLOYMENT LAYER                                        │
│-------------------------------------------------------------│
│ CI/CD                                                       │
│ Containers                                                  │
│ Infrastructure as Code                                      │
│ Blue-Green Deployment                                       │
│ Canary Deployment                                           │
└─────────────────────────────────────────────────────────────┘
                     │
                     ▼
               RESPONSE TO USER
```

## Easy Memory

```
Requirements
      ↓
Find Server
      ↓
Handle Traffic
      ↓
Move Packets
      ↓
Secure Request
      ↓
Run Application
      ↓
Organize Code
      ↓
Communicate
      ↓
Execute Business Rules
      ↓
Cache
      ↓
Access Database
      ↓
Store Data
      ↓
Store Files
      ↓
Handle Failures
      ↓
Monitor
      ↓
Scale
      ↓
Deploy
      ↓
Return Response
```