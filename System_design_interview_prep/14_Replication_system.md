# Replication System Design

## 1. Overview

Replication is the process of maintaining multiple copies of data across different machines or locations to improve:

- Availability
- Fault tolerance
- Durability
- Read scalability

Example:

Without replication:

```
Client

  |

Server

  |

Data

```

If server fails:

```
Data unavailable

```

With replication:

```
              Data

        ----------------

        |       |      |

      Node1   Node2  Node3

```

---

# 2. Goals

A replication system should provide:

- Data availability
- Failure recovery
- Low read latency
- Disaster protection
- Consistent data copies

---

# 3. Functional Requirements

## Data Replication

Copy data from primary to replicas.

```
Replicate(data)

```

---

## Read From Replica

Allow clients to read from multiple copies.

```
GET(key)

```

---

## Failover

Promote replica when primary fails.

```
Primary Failure

        |

Replica becomes Primary

```

---

## Synchronization

Keep replicas updated.

---

# 4. Non Functional Requirements

## Availability

System should continue during:

- Node failures
- Network failures
- Data center failures

## Performance

Support:

- High write throughput
- Low latency reads

## Scalability

Support:

- Thousands of nodes
- Multiple regions

---

# 5. High Level Architecture

```
                  Client

                    |

             Replication Manager

                    |

              Primary Node

                    |

        -------------------------

        |           |            |

    Replica1    Replica2    Replica3

```

Components:

1. Primary Node
2. Replica Nodes
3. Replication Manager
4. Failure Detector
5. Metadata Service

---

# 6. Replication Models

## Single Leader Replication

One primary handles writes.

```
             Client

                |

             Leader

          /     |     \

     Replica Replica Replica

```

Advantages:

- Simple writes
- Easy consistency

Disadvantages:

- Leader bottleneck

---

## Multi Leader Replication

Multiple nodes accept writes.

```
Node A <----> Node B

   \          /

     Node C

```

Advantages:

- High availability

Disadvantages:

- Conflict handling required

---

## Leaderless Replication

All nodes accept writes.

Example:

```
Client

 |

Node1
Node2
Node3

```

Used in:

- Dynamo-style systems

---

# 7. Synchronous Replication

Primary waits for replicas.

Flow:

```
Client

 |

Primary

 |

Replica1
Replica2

 |

Success

```

Advantages:

- Strong consistency
- No data loss

Disadvantages:

- Higher latency

---

# 8. Asynchronous Replication

Primary returns immediately.

Flow:

```
Client

 |

Primary

 |

Success

 |

Replicas Updated Later

```

Advantages:

- Faster writes

Disadvantages:

- Possible data loss

---

# 9. Write Replication Flow

Example:

```
Client

 |

Write Request

 |

Primary Node

 |

Generate Log Entry

 |

Send To Replicas

 |

Acknowledge

```

---

# 10. Replication Log

Changes are stored in a log.

Example:

```
Log

001 INSERT user1

002 UPDATE user1

003 DELETE user2

```

Replicas replay logs.

---

# 11. Replication Lag

Difference between primary and replica.

Example:

Primary:

```
Value = 100

```

Replica:

```
Value = 90

```

Lag:

```
10 changes behind

```

Monitoring:

- Replication delay
- Queue size
- Apply rate

---

# 12. Failure Detection

Methods:

## Heartbeats

```
Node A

heartbeat every second

```

Missing heartbeat:

```
Node considered failed

```

---

## Health Checks

Monitor:

- CPU
- Memory
- Disk
- Network

---

# 13. Failover Design

Primary failure:

```
Before:

Primary
   |
Replica1
Replica2


After:

Replica1 becomes Primary

Replica2 follows Replica1

```

Steps:

1. Detect failure
2. Select new leader
3. Update routing
4. Resume operations

---

# 14. Leader Election

Common algorithms:

- Raft
- Paxos
- ZooKeeper election


Example:

```
Nodes vote

Node A: 3 votes

Node A becomes Leader

```

---

# 15. Conflict Resolution

Required in multi-leader systems.

Example:

```
User updates name

Node A:

Name=John


Node B:

Name=Bob

```

Solutions:

## Last Write Wins

Latest timestamp wins.

## Application Merge

Custom merge logic.

## Version Vectors

Track versions.

---

# 16. Cross Region Replication

Architecture:

```
Region A

Primary

   |

Network

   |

Region B

Replica

```

Benefits:

- Disaster recovery
- Lower latency worldwide

---

# 17. Data Consistency

## Strong Consistency

All replicas show latest value.

## Eventual Consistency

Replicas converge over time.

## Causal Consistency

Maintains operation ordering.

---

# 18. Recovery Process

After failure:

```
New Replica Added

        |

Copy Existing Data

        |

Apply Logs

        |

Become Active Replica

```

---

# 19. Replication Optimization

Techniques:

- Batch replication
- Compression
- Parallel transfer
- Incremental sync
- Log shipping

---

# 20. Security

Implement:

- Encrypted replication traffic
- Authentication
- Access control
- Audit logging

---

# 21. Real World Architecture

```
                 Application

                      |

              Replication Service

                      |

              Leader Node

                      |

      --------------------------------

      |              |              |

 Replica A       Replica B      Replica C


                      |

              Backup Region

```

---

# 22. Trade-offs

| Design | Benefit | Cost |
|---|---|---|
| Synchronous | No data loss | High latency |
| Asynchronous | Fast writes | Possible loss |
| Single Leader | Simple | Leader bottleneck |
| Multi Leader | High availability | Conflicts |
| Leaderless | Flexible | Complex reads |

---

# 23. Interview Questions

1. Why do we need replication?
2. Synchronous vs asynchronous replication?
3. How does failover work?
4. How do you choose a new leader?
5. How do you handle replication lag?
6. How do you resolve conflicts?
7. How do you replicate across regions?
8. How do you prevent data loss?

---

# Summary

A replication system provides reliability by:

- Maintaining multiple data copies
- Synchronizing changes
- Detecting failures
- Performing failover
- Handling consistency challenges

Core design principle:

**Keep multiple synchronized copies so the system survives failures.**
