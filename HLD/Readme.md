High-level design or HLD is an initial step in the development of applications where the overall structure of a system is planned.

Focuses mainly on how different components of the system work together without getting to know about internal coding and implementation.
Helps everyone involved in the project to understand the goals and ensures good communication during development.
Crucial for developers, architects, and product managers because it allows them to make sure that all stakeholders are aligned with the project objectives. That's why it is also known as macro-level design.

1. Define Requirements
   Functional
   What the system does (features, workflows)
   
   Non-Functional
   Latency: response time
   Throughput: requests/sec
   Availability: uptime (99.9%)
   Consistency: same data for all users
   Reliability: failure frequency
   Maintainability: ease of changes
   Durability: data never lost
   Scalability choice: horizontal preferred
   Cost: infra + maintenance
---------------------------------------------------------------------------------------------------
2. Choose an Architecture
   Architectural Styles
   Monolith: simple, hard to scale
   Microservices: scalable, complex
   Event-Driven: async, loosely coupled
   Serverless: no infra mgmt, cold starts
   Stateful: stores session (hard scale)
   Stateless: no session (easy scale)
   Pub/Sub: event broadcasting

   Patterns
   Client-Server: common, simple
   Peer-to-Peer: decentralized, complex
----------------------------------------------------------------------------------------------------
3. Communication Protocols
   Synchronous
   HTTP/REST: simple, stateless
   gRPC: fast, binary
   WebSockets: real-time, persistent

   Asynchronous
   Message Queues: decoupling, resilience
   Pub/Sub: event distribution

   Infra
   API Gateway: auth, routing, rate limit
   Forward Proxy: client protection
   Reverse Proxy: server protection
---------------------------------------------------------------------------------------
4. Data Management
   Databases
   SQL: strong consistency
   NoSQL: scalability, flexibility
   Redis: caching, sessions

   Modeling
   Normalization: reduce redundancy
   Denormalization: faster reads
   Query optimization: indexes, joins

   Distribution
   Replication: availability
   Sharding: scalability
   CAP: choose 2 (C/A/P)
   Consistency: strong vs eventual

   Traffic Control
   Rate limiting: prevent abuse
   Algorithms: token bucket, leaky bucket
---------------------------------------------------------------------------------------
 5. Storage

   Block: low latency (DBs)
   Object: scalable (media)
   File: shared storage
   Backup & DR: RPO, RTO
---------------------------------------------------------------------------------------
6. Fault Tolerance & Reliability
   High availability: no single point of failure
   Fault tolerance: survive failures
   Reliability: fewer failures over time
   Consensus: leader election (Raft)

   Failure Handling
   Health checks
   Failover
   Retry + backoff
   Circuit breakers
---------------------------------------------------------------------------------------------
7. Scalability
   Scaling
   Horizontal: add nodes
   Vertical: bigger machine
   Bottlenecks: CPU, DB, network

   Load Distribution
   Load balancer
   Algorithms: round-robin, least-conn
   Consistent hashing

   Performance
   Caching: reduce DB load
   CDN: global low latency
   Concurrency ≠ Parallelism
------------------------------------------------------------------------------------------
8. Security
   AuthN: who you are
   AuthZ: what you can access
   SSL/TLS: encrypt in transit
   mTLS: service-to-service trust
   SSDLC: security in all phases
---------------------------------------------------------------------------------------------------
9. Monitoring & Observability
   Logs: debugging
   Metrics: latency, errors, QPS
   Tracing: request path
   Optimization: profiling, load tests
----------------------------------------------------------------------------------------------
10. Deployment & Management
  CI/CD: automated build & deploy
  Runtime
  Docker: consistent environment
  Kubernetes: scaling, self-healing
