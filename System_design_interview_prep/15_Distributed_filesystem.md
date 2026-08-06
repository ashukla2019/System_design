# Distributed File System Design

## 1. Overview

A Distributed File System (DFS) stores and manages files across multiple machines while providing a single unified file system view to users.

Instead of storing files on one server:

```
Single Server

+----------------+
| File Storage   |
+----------------+

```

A distributed system stores files across many nodes:

```
              Client

                 |

          Distributed File System

                 |

    --------------------------------

    |              |               |

 Data Node 1   Data Node 2    Data Node 3

```

Examples:

- Google File System (GFS)
- Hadoop Distributed File System (HDFS)
- CephFS

---

# 2. Goals

A distributed file system should provide:

- Large-scale storage
- High availability
- Fault tolerance
- High throughput
- Data durability
- Parallel access

---

# 3. Functional Requirements

## File Operations

Support:

```
CREATE(file)

READ(file)

WRITE(file)

DELETE(file)

LIST(directory)

```

---

## Large File Support

Handle:

- Gigabyte files
- Terabyte files
- Petabyte datasets

---

## Data Sharing

Multiple clients can access files simultaneously.

---

# 4. Non Functional Requirements

## Scalability

Support:

- Millions of files
- Thousands of storage nodes

---

## Reliability

Survive:

- Machine failures
- Network failures
- Disk failures

---

## Performance

Optimize:

- Sequential reads
- Large writes
- Parallel processing

---

# 5. High Level Architecture

```
                  Client

                    |

             Metadata Service

                    |

        ----------------------------

        |            |             |

    Data Node    Data Node    Data Node


```

Main components:

1. Client
2. Metadata Server
3. Data Nodes
4. Replication Manager
5. Monitoring Service

---

# 6. Architecture Components

## Metadata Server

Stores information about:

- File names
- Directory structure
- File permissions
- Block locations


Example:

```
File:

/video/movie.mp4


Metadata:

Block1 -> Node A

Block2 -> Node B

Block3 -> Node C

```

---

## Data Nodes

Store actual file content.

Example:

```
Block1

101010101010


```

---

# 7. File Storage Model

Large files are divided into blocks.

Example:

```
File:

A B C D E F


Split:


Block1:
A B


Block2:
C D


Block3:
E F

```

Benefits:

- Parallel access
- Easy replication
- Better scalability

---

# 8. Metadata Design

Metadata contains:

```
File ID

File Name

Size

Permissions

Block List

Replication Info

```

Example:

```
File:

data.csv


Blocks:

B1
B2
B3


Locations:

Node1
Node2
Node3

```

---

# 9. Write Flow

Client writes a file.

```
Client

 |

Request Metadata Server

 |

Get Data Node Locations

 |

Write Blocks

 |

Replicate Blocks

 |

Confirm Completion

```

Steps:

1. Client contacts metadata server
2. Metadata server selects storage nodes
3. Client writes data blocks
4. Blocks are replicated
5. Metadata updated

---

# 10. Read Flow

```
Client

 |

Ask Metadata Server

 |

Get Block Locations

 |

Read From Data Nodes

 |

Combine Blocks

 |

Return File

```

---

# 11. Data Replication

Each block has multiple copies.

Example:

Replication factor = 3

```
Block A

 |

-----------------

|       |        |

Node1  Node2   Node3

```

Benefits:

- Fault tolerance
- Faster reads

---

# 12. Data Placement

Factors:

- Disk capacity
- Network distance
- Failure domains


Example:

Avoid storing all replicas:

```
Same Machine

X

Same Rack

X

Same Data Center

X

```

Better:

```
Replica 1 -> Rack A

Replica 2 -> Rack B

Replica 3 -> Rack C

```

---

# 13. Failure Handling

## Data Node Failure

Detection:

- Heartbeats
- Health checks


Flow:

```
Node Failure

      |

Metadata Updated

      |

Replica Selected

      |

New Replica Created

```

---

# 14. Metadata Server Failure

Problem:

Metadata is critical.

Solutions:

## Metadata Replication

```
Primary Metadata Server

          |

 Replica Metadata Server

```

---

## Leader Election

Use:

- Raft
- Paxos

---

# 15. Data Recovery

Process:

```
Detect Missing Block

        |

Find Healthy Replica

        |

Copy Data

        |

Create New Replica

```

---

# 16. Consistency Model

## Strong Consistency

All clients see latest data.

Good for:

- Databases

---

## Eventual Consistency

Updates propagate over time.

Good for:

- Large distributed storage

---

# 17. Caching

Clients may cache:

- Metadata
- File blocks


Benefits:

- Faster reads

Challenges:

- Cache invalidation

---

# 18. Load Balancing

Problem:

Some nodes become overloaded.

Solutions:

- Rebalance blocks
- Move data
- Add storage nodes

---

# 19. Garbage Collection

Remove:

- Deleted files
- Unused blocks
- Old versions


Process:

```
Find Unused Blocks

       |

Delete Safely

```

---

# 20. Security

Implement:

- Authentication
- Authorization
- Encryption
- Access control
- Audit logs

---

# 21. Scaling Design

Adding nodes:

```
New Data Node Added

        |

Move Blocks

        |

Update Metadata

        |

Node Becomes Active

```

---

# 22. Real World Architecture

```
                 Users

                   |

              File Client

                   |

            Metadata Cluster

                   |

       --------------------------------

       |              |               |

    Storage1      Storage2       Storage3


                   |

              Replication Layer

```

---

# 23. Trade-offs

| Design Choice | Benefit | Cost |
|---|---|---|
| Large Blocks | Better throughput | Less random access |
| Replication | High availability | More storage |
| Central Metadata | Simple lookup | Metadata bottleneck |
| Distributed Metadata | Scalable | Complex |
| Strong Consistency | Correctness | Higher latency |

---

# 24. Interview Questions

1. How would you design HDFS?
2. Why separate metadata and data storage?
3. How are large files stored?
4. How does replication work?
5. What happens when a data node fails?
6. How do you scale metadata?
7. How do you rebalance storage?
8. How do you maintain consistency?

---

# Summary

A distributed file system provides scalable storage by:

- Splitting files into blocks
- Storing blocks across nodes
- Maintaining metadata separately
- Replicating data
- Recovering from failures

Core design principle:

**Store massive files across many machines while providing a simple file system interface.**
