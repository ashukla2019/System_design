# Key Value Store System Design

## 1. Overview

A Key Value Store is a database system that stores data as a collection of key-value pairs.

Example:

```
Key                 Value
--------------------------------
user:1001           {"name":"John","age":30}
session:abc123      {"userId":1001}
product:5001        {"name":"Laptop"}
```

The key is a unique identifier used to quickly locate the associated value.

Examples:
- Redis
- DynamoDB
- Riak
- Cassandra (similar distributed storage model)

---

# 2. Goals

A large-scale Key Value Store should provide:

- Fast read/write operations
- Horizontal scalability
- High availability
- Fault tolerance
- Data durability
- Low latency

---

# 3. Functional Requirements

## Basic Operations

### Put

Store a value.

```
PUT(key, value)
```

Example:

```
PUT(user:1001, {"name":"Alice"})
```

---

### Get

Retrieve value by key.

```
GET(key)
```

Example:

```
GET(user:1001)

Returns:

{"name":"Alice"}
```

---

### Delete

Remove a key.

```
DELETE(key)
```

---

### Update

Replace existing value.

```
UPDATE(key,value)
```

---

# 4. Non Functional Requirements

## Scalability

System should support:

- Billions of keys
- Petabytes of data
- Millions of requests per second


## Availability

Service should continue working even when:

- Servers fail
- Network failures occur
- Disks fail


## Performance

Target:

- Millisecond latency
- High throughput

---

# 5. High Level Architecture

```
                 Client

                   |

             Load Balancer

                   |

             API Servers

                   |

          Partition Manager

                   |

        ---------------------

        |        |          |

      Node1    Node2      Node3

      Data     Data       Data

```

Components:

1. Client
2. API Layer
3. Partitioning Layer
4. Storage Nodes
5. Replication Manager
6. Monitoring System

---

# 6. Data Model

Basic model:

```
Key --> Value
```

Example:

```
"user:1001"

        |

        v

{
 name:"Bob",
 age:25
}

```

Keys should be:

- Unique
- Hashable
- Evenly distributed

---

# 7. Data Partitioning

A single machine cannot store all data.

Data is distributed across multiple servers.

## Hash Partitioning

Formula:

```
server = hash(key) % number_of_servers
```

Example:

```
hash(user:1001) % 4

= Server 2

```

Problem:

Adding servers changes many mappings.

Solution:

## Consistent Hashing

---

# 8. Consistent Hashing

Servers and keys are placed on a hash ring.

```
              Node A

          Key1

    Node C          Node B

          Key2

```

Benefits:

- Minimal data movement
- Easy scaling
- Better load balancing

---

# 9. Virtual Nodes

One physical server owns multiple positions.

Example:

```
Server A

VNode1
VNode2
VNode3

```

Advantages:

- Better distribution
- Easier balancing
- Handles uneven loads

---

# 10. Replication Design

To prevent data loss, store multiple copies.

Example:

Replication factor = 3


```
             Primary

                |

       -----------------

       |       |       |

   Replica Replica Replica

```

Benefits:

- Fault tolerance
- High availability
- Faster reads

---

# 11. Write Flow

Example:

Client writes data.


```
Client

 |

API Server

 |

Find Partition

 |

Primary Node

 |

Replicate Data

 |

Replica Nodes

 |

Success Response

```

Steps:

1. Receive request
2. Calculate partition
3. Find storage node
4. Write data
5. Replicate
6. Return acknowledgement

---

# 12. Read Flow

```
Client

 |

API Server

 |

Find Partition

 |

Storage Node

 |

Return Value

```

Optimization:

Read from replicas to improve performance.

---

# 13. Consistency Models

## Strong Consistency

Every read receives latest value.

Example:

```
Write A=10

Immediately Read

Returns A=10

```

Advantages:

- Correct data

Disadvantages:

- Higher latency


---

## Eventual Consistency

Updates propagate over time.

Example:

```
Node1: A=20

Node2: A=10

After sync:

All nodes A=20

```

Advantages:

- High availability
- Better performance

---

# 14. CAP Theorem

Distributed systems cannot guarantee all three:

```
Consistency
Availability
Partition Tolerance

```

A Key Value Store usually chooses:

## AP Systems

Example:

- DynamoDB style

Prioritize:

- Availability
- Partition tolerance


## CP Systems

Prioritize:

- Consistency
- Partition tolerance

---

# 15. Storage Engine

## In-Memory Storage

Example:

Hash Table


```
Key

 |

Memory Address

 |

Value

```

Advantages:

- Extremely fast

Disadvantages:

- Limited capacity


---

## Disk Based Storage

Common designs:

### LSM Tree

```
Write

 |

MemTable

 |

SSTable

 |

Disk

```

Advantages:

- High write performance
- Good for large data

---

# 16. Indexing

Index helps locate data quickly.

Example:

```
Key Index


user:1001 ---> Disk Location 500

```

Without index:

Full disk scan required.

---

# 17. Failure Handling

## Server Failure

Detection:

- Heartbeats
- Health checks


Example:

```
Node A Failed

      |

Replica becomes Primary

      |

Traffic Redirected

```

---

# 18. Data Recovery

Process:

```
Failure Detected

        |

Find Replica

        |

Copy Missing Data

        |

Restore Node

```

---

# 19. Hot Key Problem

A popular key receives too much traffic.

Example:

```
product:iphone

Millions of requests

```

Solutions:

- Cache hot keys
- Replicate popular keys
- Request throttling

---

# 20. Caching Layer

Architecture:

```
Client

 |

Cache

 |

Key Value Store

```

Strategies:

## LRU

Least Recently Used data removed first.

## TTL

Expire data after time.

---

# 21. Monitoring

Important metrics:

- Request latency
- Throughput
- Error rate
- Disk usage
- Replication lag
- Node health

---

# 22. Scaling Strategy

## Adding New Nodes

Process:

```
New Node Added

        |

Move Partitions

        |

Update Routing Table

```

---

## Auto Scaling

Based on:

- CPU usage
- Memory
- Request rate
- Storage capacity

---

# 23. Security

Implement:

- Authentication
- Authorization
- Encryption
- Audit logging

---

# 24. Real World Architecture

```
                 Users

                   |

              API Gateway

                   |

          Key Value Service

                   |

        Consistent Hash Ring

                   |

 ---------------------------------

 |              |                |

Shard 1       Shard 2         Shard 3


 |              |                |

Replica       Replica          Replica

```

---

# 25. Trade-offs

| Decision | Benefit | Cost |
|---|---|---|
| Replication | High availability | More storage |
| Strong consistency | Correct data | Higher latency |
| Eventual consistency | Faster | Temporary stale data |
| Partitioning | Scalability | Complexity |
| Caching | Faster reads | Consistency issues |

---

# 26. Interview Questions

1. How would you design a Key Value Store like DynamoDB?
2. How do you partition billions of keys?
3. Explain consistent hashing.
4. How do you handle node failures?
5. How do you maintain consistency?
6. How do you avoid hot keys?
7. How do you rebalance data?
8. How does replication work?
9. How do you recover corrupted data?
10. How would you scale from millions to billions of users?

---

# Summary

A distributed Key Value Store uses:

- Partitioning for scalability
- Replication for availability
- Consistent hashing for distribution
- Storage engines for persistence
- Caching for performance
- Failure detection for reliability

The core design goal is:

**Store and retrieve massive amounts of data with low latency while surviving failures.**
