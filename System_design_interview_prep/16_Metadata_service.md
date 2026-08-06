# Metadata Service System Design

## 1. Overview

A Metadata Service manages information **about data**, not the actual data itself.

Metadata describes:

- Location
- Ownership
- Structure
- Permissions
- Version information
- Relationships

Example:

Actual data:

```
File Content:

Hello World

```

Metadata:

```
File Name: hello.txt
Size: 11 bytes
Owner: User1
Location: Node5
Created: 2026-01-01

```

Metadata services are critical components in:

- Distributed File Systems
- Object Storage
- Databases
- Cloud Storage Platforms

---

# 2. Goals

A metadata service should provide:

- Fast metadata lookup
- High availability
- Strong consistency
- Scalability
- Low latency
- Fault tolerance

---

# 3. Functional Requirements

## Create Metadata

Example:

```
CREATE_FILE(file_id, metadata)

```

---

## Read Metadata

Example:

```
GET_METADATA(file_id)

```

Returns:

```
{
 name:"data.csv",
 location:"Node10",
 size:"100MB"
}

```

---

## Update Metadata

Example:

```
UPDATE_METADATA(file_id)

```

---

## Delete Metadata

Example:

```
DELETE_METADATA(file_id)

```

---

# 4. Non Functional Requirements

## Availability

Metadata must remain available because:

```
No Metadata

=

No Data Access

```

---

## Performance

Support:

- Millions of lookups per second
- Low latency requests

---

## Scalability

Handle:

- Billions of objects
- Large namespace

---

# 5. High Level Architecture

```
                 Client

                   |

            Metadata API

                   |

          Metadata Service

                   |

       -----------------------

       |          |          |

    Storage    Cache    Replication

     Layer

```

Components:

1. API Layer
2. Metadata Manager
3. Metadata Database
4. Cache Layer
5. Replication Manager

---

# 6. Metadata Data Model

Example:

```
Object Metadata

Object ID

File Name

Owner

Permissions

Size

Creation Time

Storage Location

Version

```

---

# 7. Namespace Management

Metadata service manages hierarchy.

Example:

```
/

├── users

│    └── alice

│          └── file.txt

│

└── logs

     └── app.log

```

Operations:

- Create directory
- Rename file
- Move file
- Delete file

---

# 8. Metadata Storage

Possible storage models:

## Relational Database

Example:

```
File Table

ID | Name | Owner

```

Advantages:

- Strong consistency
- Transactions


---

## Key Value Store

Example:

```
File ID

   |

Metadata Object

```

Advantages:

- High scalability

---

## Distributed Database

Used for:

- Large scale systems

---

# 9. Metadata Read Flow

```
Client

 |

Metadata Request

 |

Metadata Server

 |

Check Cache

 |

Fetch Database

 |

Return Metadata

```

---

# 10. Metadata Write Flow

```
Client

 |

Create/Update Request

 |

Metadata Leader

 |

Write Database

 |

Replicate

 |

Return Success

```

---

# 11. Metadata Caching

Metadata is frequently accessed.

Architecture:

```
Client

 |

Cache

 |

Metadata Service

 |

Database

```

Benefits:

- Lower latency
- Reduced database load

---

# 12. Consistency Model

Metadata usually requires strong consistency.

Example:

File rename:

Before:

```
/old.txt

```

After:

```
/new.txt

```

All clients should see the same name.

---

# 13. Metadata Replication

Metadata must be replicated.

Example:

```
             Leader

               |

      ------------------

      |        |        |

   Replica Replica Replica

```

Benefits:

- Fault tolerance
- Availability

---

# 14. Partitioning Metadata

Large systems partition metadata.

Example:

Hash based:

```
hash(file_id)

        |

Partition

```

---

Directory based:

```
/users

   -> Server A


/logs

   -> Server B

```

---

# 15. Leader Election

Metadata systems often use consensus.

Algorithms:

- Raft
- Paxos

Example:

```
Node A

Node B

Node C


Vote


Node B becomes leader

```

---

# 16. Failure Handling

## Metadata Server Failure

Solution:

```
Leader Failure

        |

Election

        |

New Leader

```

---

## Database Failure

Solution:

- Replicas
- Backups
- Recovery logs

---

# 17. Recovery Process

```
Restart Metadata Node

        |

Load Database

        |

Replay Logs

        |

Sync With Leader

        |

Become Available

```

---

# 18. Write Ahead Log Integration

Metadata changes are recorded first.

Example:

```
WAL:

CREATE file1

UPDATE file1

DELETE file2

```

Benefits:

- Crash recovery
- Durability

---

# 19. Performance Optimization

Techniques:

- Metadata caching
- Batch updates
- Partitioning
- Compression
- Indexing

---

# 20. Security

Implement:

- Authentication
- Authorization
- Access control
- Encryption
- Audit logs

---

# 21. Real World Architecture

```
                 Client

                   |

             Metadata API

                   |

          Metadata Cluster


        ----------------------

        |         |          |

     Leader   Replica   Replica


                   |

            Storage Metadata DB

```

---

# 22. Trade-offs

| Design Choice | Benefit | Cost |
|---|---|---|
| Central Metadata | Simple | Bottleneck |
| Distributed Metadata | Scalable | Complex |
| Strong Consistency | Correctness | Higher latency |
| Heavy Caching | Faster reads | Cache invalidation |
| Replication | Reliable | Storage overhead |

---

# 23. Interview Questions

1. Why is metadata important?
2. How do you scale metadata storage?
3. How do you prevent metadata bottlenecks?
4. How do you recover metadata after failure?
5. Why does metadata require strong consistency?
6. How does metadata caching work?
7. How do you partition namespace?
8. How does leader election work?

---

# Summary

A Metadata Service provides the control layer of distributed storage by managing:

- File information
- Object locations
- Namespace structure
- Permissions
- Versions

Core design principle:

**Keep metadata fast, consistent, and highly available because every data operation depends on it.**
