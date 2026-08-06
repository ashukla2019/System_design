# Cache System Design

## 1. Overview

A cache is a high-speed storage layer that keeps frequently accessed data closer to the application to reduce latency and database load.

Without cache:

```
Client

  |

Application

  |

Database

  |

Disk

```

With cache:

```
Client

  |

Application

  |

Cache

  |

Database

```

Examples:

- Redis
- Memcached
- CDN caches
- CPU caches

---

# 2. Goals

A cache system should provide:

- Low latency access
- High throughput
- Reduced backend load
- Efficient memory usage
- Scalability

---

# 3. Functional Requirements

## Store Data

```
SET(key,value)

```

Example:

```
SET user:1001 Alice

```

---

## Retrieve Data

```
GET(key)

```

Example:

```
GET user:1001

Returns:

Alice

```

---

## Remove Data

```
DELETE(key)

```

---

## Expire Data

Example:

```
SET session123 value TTL=3600

```

Data automatically expires.

---

# 4. Non Functional Requirements

## Performance

Target:

- Microsecond/millisecond latency
- High requests per second

---

## Availability

Cache should handle:

- Node failures
- Network failures

---

## Scalability

Support:

- Large datasets
- Millions of requests

---

# 5. High Level Architecture

```
                 Client

                   |

              Application

                   |

              Cache Layer

                   |

              Database


```

Components:

1. Cache Client
2. Cache Nodes
3. Cache Manager
4. Eviction Manager
5. Monitoring System

---

# 6. Cache Placement

## Client Side Cache

Cache exists on client.

Example:

```
Mobile App

 |

Local Cache

```

Advantages:

- Fast access

Disadvantages:

- Difficult invalidation


---

## Application Cache

Cache inside application servers.

```
Application

 |

Memory Cache

```

---

## Distributed Cache

Separate cache cluster.

```
Application

 |

Cache Cluster

 |

Database

```

Common for large systems.

---

# 7. Cache Read Flow

Example:

```
Client Request

      |

Check Cache

      |

----------------

|              |

Hit            Miss

|              |

Return        Query DB

Value             |

              Store Cache

```

---

# 8. Cache Write Strategies

## Write Through

Write cache and database together.

```
Application

   |

 Cache

   |

Database

```

Advantages:

- Data consistency

Disadvantages:

- Higher latency


---

## Write Back

Write only to cache first.

```
Application

 |

Cache

 |

Later Database

```

Advantages:

- Fast writes

Disadvantages:

- Risk of data loss

---

## Write Around

Write directly to database.

```
Application

 |

Database

```

Cache populated during reads.

---

# 9. Cache Eviction Policies

When cache is full, remove data.

---

## LRU (Least Recently Used)

Remove least recently accessed item.

Example:

```
A accessed recently

B unused for long time


Remove B

```

---

## LFU (Least Frequently Used)

Remove least accessed item.

---

## FIFO

Remove oldest item.

---

## TTL Based

Remove after expiration time.

---

# 10. Cache Hit and Miss

## Cache Hit

Data exists.

```
Request

 |

Cache

 |

Return Data

```

---

## Cache Miss

Data not found.

```
Request

 |

Cache

 |

Database

 |

Update Cache

```

---

# 11. Cache Consistency

Problem:

Database changes but cache has old data.

Example:

Database:

```
Price = 200

```

Cache:

```
Price = 100

```

Solutions:

---

## Cache Invalidation

Remove old value.

```
Update Database

       |

Delete Cache

```

---

## TTL Expiration

Automatically expire stale data.

---

## Versioning

Store versions.

```
user:v1

user:v2

```

---

# 12. Distributed Cache Design

Architecture:

```
             Application

                  |

          Cache Router

                  |

      -----------------------

      |          |          |

   Node1      Node2      Node3

```

---

# 13. Cache Partitioning

Use consistent hashing.

Example:

```
hash(key)

   |

Cache Node

```

Benefits:

- Even distribution
- Easy scaling

---

# 14. Cache Replication

Multiple copies:

```
        Primary Cache

              |

     ----------------

     |              |

 Replica1       Replica2

```

Benefits:

- Availability
- Faster reads

---

# 15. Hot Key Problem

A popular key overloads one cache node.

Example:

```
movie:popular

Millions of requests

```

Solutions:

- Replicate hot keys
- Local caching
- Request throttling

---

# 16. Cache Stampede

Many requests miss cache simultaneously.

Example:

```
Cache expires

      |

10000 requests hit database

```

Solutions:

- Locking
- Request coalescing
- Early refresh

---

# 17. Cache Warming

Preload frequently accessed data.

Example:

```
Application Startup

        |

Load Popular Data

        |

Cache Ready

```

---

# 18. Failure Handling

## Cache Node Failure

Solutions:

- Replica promotion
- Rebuild cache
- Consistent hashing


---

## Cache Data Loss

Usually acceptable because:

```
Cache = Temporary Storage

Database = Source of Truth

```

---

# 19. Monitoring

Track:

- Hit ratio
- Miss ratio
- Latency
- Memory usage
- Evictions
- Network traffic

---

# 20. Security

Implement:

- Authentication
- Encryption
- Access control
- Data isolation

---

# 21. Real World Architecture

```
                 Users

                   |

              API Servers

                   |

          Distributed Cache

          ----------------

          |      |       |

       Node1  Node2   Node3


                   |

              Database

```

---

# 22. Trade-offs

| Design Choice | Benefit | Cost |
|---|---|---|
| Large Cache | More hits | Higher cost |
| TTL | Simple expiry | Possible stale data |
| Write Through | Consistent | Slower writes |
| Write Back | Faster | Data loss risk |
| Replication | Available | More memory |

---

# 23. Interview Questions

1. How would you design Redis-like cache?
2. Cache vs database difference?
3. Explain LRU algorithm.
4. How do you handle cache invalidation?
5. How do you solve cache stampede?
6. How do you distribute cache nodes?
7. How do you handle hot keys?
8. When should you not use cache?

---

# Summary

A cache system improves performance using:

- Fast memory storage
- Intelligent eviction
- Partitioning
- Replication
- Expiration policies

Core design principle:

**Keep frequently accessed data close to users while maintaining acceptable consistency.**
