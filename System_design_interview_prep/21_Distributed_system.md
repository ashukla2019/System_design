# Distributed System Fundamentals

## 1. Overview

A Distributed System is a collection of independent computers that work together and appear as a single system to users.

Examples:

- Google Search
- Amazon
- Distributed databases
- Cloud storage
- Microservices platforms

Basic architecture:

```
             Users

               |

        Distributed System

      -----------------------

      |          |          |

   Server1    Server2    Server3

```

---

# 2. Goals of Distributed Systems

A distributed system provides:

- Scalability
- Availability
- Fault tolerance
- Performance
- Resource sharing

---

# 3. Characteristics

## Multiple Nodes

System consists of many machines.

```
Node A

Node B

Node C

```

---

## Network Communication

Nodes communicate through:

- TCP/IP
- HTTP
- RPC
- Messaging systems

---

## Partial Failures

Some components may fail while others continue.

Example:

```
Server A Failed

Server B,C Running

```

---

# 4. Challenges

Distributed systems face:

- Network delays
- Machine failures
- Data consistency problems
- Synchronization issues
- Partial failures

---

# 5. CAP Theorem

CAP states that a distributed system cannot guarantee all three simultaneously:

```
C - Consistency

A - Availability

P - Partition Tolerance

```

---

# 6. Consistency

All nodes see the same data.

Example:

```
Write:

User = Alice


Read from any node:

User = Alice

```

---

# 7. Availability

System always responds.

Example:

```
Request

 |

Available Server

 |

Response

```

---

# 8. Partition Tolerance

System continues despite network failures.

Example:

```
Node A  X  Node B

Network Broken

```

---

# 9. CAP Choices

## CP System

Consistency + Partition tolerance

Example:

- Banking systems

Priority:

```
Correct Data

```

---

## AP System

Availability + Partition tolerance

Example:

- Social media feeds

Priority:

```
Always Available

```

---

# 10. Consistency Models

## Strong Consistency

Latest write always visible.

Example:

```
Write X=10

Read X

Returns 10

```

---

## Eventual Consistency

Updates propagate over time.

Example:

```
Node1: X=20

Node2: X=10


Later:

Both X=20

```

---

## Causal Consistency

Maintains operation order.

Example:

```
Create Account

      |

Deposit Money

```

Deposit cannot appear before account creation.

---

# 11. Communication Models

## Request Response

Example:

```
Client

 |

Server

 |

Response

```

---

## Message Queue

Example:

```
Producer

 |

Queue

 |

Consumer

```

Benefits:

- Async processing
- Decoupling

---

# 12. Remote Procedure Call (RPC)

Allows one machine to call another.

Example:

```
Service A

 |

RPC Request

 |

Service B

```

Examples:

- gRPC
- REST APIs

---

# 13. Time in Distributed Systems

Problem:

Each machine has different clocks.

Example:

```
Server A:

10:00:01


Server B:

10:00:03

```

---

# 14. Logical Clocks

Used to order events.

Examples:

- Lamport Clock
- Vector Clock

---

# 15. Lamport Clock

Assigns increasing numbers.

Example:

```
Event A

Clock = 1


Event B

Clock = 2

```

Used for:

- Event ordering

---

# 16. Vector Clock

Tracks multiple node histories.

Example:

```
Node A:

[2,0,0]


Node B:

[2,1,0]

```

Used for:

- Conflict detection

---

# 17. Consensus

Consensus means multiple nodes agree on a value.

Used for:

- Leader election
- Configuration management
- Distributed databases

Algorithms:

- Paxos
- Raft

---

# 18. Raft Algorithm

Components:

- Leader
- Followers
- Candidates

Flow:

```
Election

   |

Leader Selected

   |

Log Replication

```

---

# 19. Leader Election

Purpose:

Choose one node as coordinator.

Example:

```
Node A

Node B

Node C


Vote


Node B = Leader

```

---

# 20. Distributed Transactions

Problem:

Multiple services must update together.

Example:

```
Payment Service

        +

Order Service

```

---

# 21. Two Phase Commit (2PC)

Steps:

## Phase 1

Prepare:

```
Can you commit?

```

---

## Phase 2

Commit:

```
Commit transaction

```

Problem:

- Blocking

---

# 22. Saga Pattern

Break transaction into steps.

Example:

```
Create Order

      |

Charge Payment

      |

Ship Product

```

If failure:

Run compensation actions.

---

# 23. Data Partitioning

Split data across machines.

Example:

```
Users A-F

Server1


Users G-M

Server2

```

Benefits:

- Scalability
- Load distribution

---

# 24. Replication

Maintain copies.

Example:

```
Primary

 |

Replica1

 |

Replica2

```

Benefits:

- Availability
- Disaster recovery

---

# 25. Fault Tolerance

Systems should continue working despite failures.

Techniques:

- Replication
- Retry
- Failover
- Circuit breaker
- Monitoring

---

# 26. Failure Detection

Methods:

## Heartbeat

```
Node sends periodic signal

```

---

## Timeout

```
No response

=

Possible failure

```

---

# 27. Load Balancing

Distribute traffic.

Algorithms:

## Round Robin

```
A -> Server1

B -> Server2

C -> Server3

```

---

## Least Connections

Send traffic to least busy server.

---

## Consistent Hashing

Maps requests to servers.

---

# 28. Caching in Distributed Systems

Used to improve performance.

Examples:

- CDN
- Redis
- Local cache

Challenges:

- Cache invalidation
- Stale data

---

# 29. Observability

Distributed systems require:

## Logging

Track events.

## Metrics

Measure:

- Latency
- Errors
- Traffic

## Tracing

Follow requests across services.

---

# 30. Security

Important areas:

- Authentication
- Authorization
- Encryption
- Network security
- Secret management

---

# 31. Distributed System Architecture

```
                  Users

                    |

              Load Balancer

                    |

          --------------------

          |        |         |

       Service  Service  Service


          |        |         |

       Database  Cache  Message Queue


          |

       Storage Layer

```

---

# 32. Design Principles

## Design for Failure

Assume components fail.

---

## Avoid Single Point of Failure

Use:

- Replication
- Failover

---

## Keep Services Independent

Use:

- Loose coupling
- APIs

---

## Monitor Everything

Collect:

- Logs
- Metrics
- Traces

---

# 33. Trade-offs

| Decision | Benefit | Cost |
|---|---|---|
| Replication | Availability | Storage cost |
| Strong Consistency | Correctness | Latency |
| Eventual Consistency | Performance | Stale data |
| Partitioning | Scalability | Complexity |
| Caching | Speed | Consistency issues |

---

# 34. Interview Questions

1. Explain CAP theorem.
2. Strong vs eventual consistency?
3. How does Raft work?
4. How do distributed systems handle failures?
5. Explain leader election.
6. How do you design a scalable system?
7. How do you handle network partitions?
8. Explain distributed transactions.
9. How does consistent hashing work?
10. How do you monitor distributed systems?

---

# Summary

Distributed systems achieve large-scale reliability using:

- Partitioning
- Replication
- Consensus
- Fault tolerance
- Load balancing
- Observability

Core design principle:

**Build systems that continue working even when individual components fail.**
