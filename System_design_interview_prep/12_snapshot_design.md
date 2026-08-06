# Snapshot System Design

## 1. Overview

A snapshot is a point-in-time copy of data that allows users to restore storage state to an earlier moment.

Snapshots are commonly used in:

- Cloud block storage
- Databases
- Virtual machines
- Backup systems
- File systems

Examples:
- AWS EBS Snapshots
- ZFS Snapshots
- Database checkpoints

---

# 2. Goals

A snapshot system should provide:

- Fast snapshot creation
- Minimal storage overhead
- Quick recovery
- Data consistency
- Incremental storage
- Fault tolerance

---

# 3. Functional Requirements

## Create Snapshot

Create a point-in-time view.

```
CREATE_SNAPSHOT(volume_id)
```

Example:

```
Volume:

A B C D E


Snapshot:

A B C D E

```

---

## Read Snapshot

Access old data state.

```
READ(snapshot_id, block_id)
```

---

## Restore Snapshot

Recover volume.

```
RESTORE(snapshot_id)

```

---

## Delete Snapshot

Remove snapshot metadata and unused data.

```
DELETE(snapshot_id)

```

---

# 4. Non Functional Requirements

## Performance

- Snapshot creation should be fast
- Minimal impact on active workload

## Reliability

Should survive:

- Disk failures
- Server failures
- Network failures

## Scalability

Support:

- Millions of snapshots
- Petabytes of data

---

# 5. High Level Architecture

```
                Client

                  |

            Snapshot API

                  |

          Snapshot Manager

                  |

        --------------------

        |                  |

 Metadata Store       Storage Layer


                            |

                     Data Blocks

```

Components:

1. Snapshot API
2. Snapshot Manager
3. Metadata Service
4. Storage Engine
5. Garbage Collector

---

# 6. Snapshot Types

## Full Snapshot

Copies all data.

Example:

```
Original Volume

A B C D E


Snapshot

A B C D E

```

Advantages:

- Simple recovery

Disadvantages:

- Large storage usage

---

## Incremental Snapshot

Stores only changed blocks.

Example:

Initial:

```
A B C D

```

Changes:

```
B changed
D changed

```

Snapshot stores:

```
B'
D'

```

Advantages:

- Saves storage
- Faster creation

---

# 7. Copy-On-Write Design

Most snapshot systems use Copy-On-Write (COW).

Before snapshot:

```
Volume

Block A
Block B
Block C

```

Create snapshot:

```
Snapshot

Block A
Block B
Block C


Volume

Block A
Block B
Block C

```

When application modifies Block B:

Old block is copied first.

```
Before Write:

Snapshot --> Block B


After Write:

Snapshot --> Old Block B

Volume --> New Block B

```

---

# 8. Snapshot Metadata

Metadata tracks:

- Snapshot ID
- Creation time
- Block mapping
- Parent snapshot
- Storage location


Example:

```
Snapshot Metadata


snapshot_001

Block 1 -> Disk A

Block 2 -> Disk B

Block 3 -> Disk C

```

---

# 9. Snapshot Creation Flow

```
Client

 |

Create Snapshot Request

 |

Snapshot Manager

 |

Freeze Metadata

 |

Create Snapshot Record

 |

Return Snapshot ID

```

Important:

Only metadata is created initially.

Actual data copying happens later.

---

# 10. Write Flow With Snapshot

Normal write:

```
Application

 |

Storage System

 |

Update Block

```

With snapshot:

```
Application

 |

Storage System

 |

Check Snapshot Reference

 |

Copy Old Block

 |

Write New Block

```

---

# 11. Restore Flow

```
User Requests Restore

        |

Find Snapshot Metadata

        |

Locate Blocks

        |

Copy Blocks Back

        |

Recover Volume

```

---

# 12. Incremental Snapshot Chain

Example:

```
Snapshot 0
   |
   |
Snapshot 1
   |
   |
Snapshot 2

```

Snapshot 2 contains:

- Original data reference
- Changes from Snapshot 1

Benefits:

- Less storage

Problem:

- Longer recovery time

Solution:

- Periodic full snapshots

---

# 13. Snapshot Storage Model

Example:

```
Metadata Layer

Snapshot ID
    |
    |
Block Map


Storage Layer

Block 1
Block 2
Block 3

```

---

# 14. Garbage Collection

When snapshots are deleted:

Unused blocks must be removed.

Example:

Before:

```
Snapshot1 --> Block A
Snapshot2 --> Block A

```

Delete Snapshot1:

```
Snapshot2 --> Block A

```

Block A cannot be deleted.

---

# 15. Consistency Handling

## Crash Consistency

Ensure snapshot is not partially written.

Methods:

- Write ordering
- Journaling
- WAL


## Application Consistency

For databases:

- Flush memory
- Pause writes
- Create snapshot

---

# 16. Scaling Design

Large systems use:

## Distributed Metadata

Metadata is partitioned.

```
Metadata Server 1

Metadata Server 2

Metadata Server 3

```

---

## Parallel Copy

Multiple workers copy blocks.

```
Worker1 -> Block Group A

Worker2 -> Block Group B

Worker3 -> Block Group C

```

---

# 17. Failure Handling

## Metadata Failure

Solution:

- Replicated metadata store


## Disk Failure

Solution:

- Replicated blocks
- Erasure coding


## Snapshot Worker Failure

Solution:

- Retry mechanism
- Task checkpointing

---

# 18. Performance Optimization

Techniques:

- Lazy copying
- Compression
- Deduplication
- Incremental snapshots
- Parallel processing

---

# 19. Security

Implement:

- Access control
- Encryption
- Audit logs
- Snapshot ownership validation

---

# 20. Real World Architecture

```
                 User

                  |

            Snapshot Service

                  |

          Metadata Service

                  |

        ------------------

        |                |

    Block Store     Garbage Collector


```

---

# 21. Trade-offs

| Design Choice | Benefit | Cost |
|---|---|---|
| Full Snapshot | Simple recovery | More storage |
| Incremental | Less storage | Complex restore |
| Copy-on-write | Fast creation | Write overhead |
| Compression | Saves space | CPU usage |
| Deduplication | Removes duplicates | Metadata overhead |

---

# 22. Interview Questions

1. How do snapshots work internally?
2. Explain Copy-on-Write.
3. Snapshot vs backup difference?
4. How do you reduce snapshot storage?
5. How do you restore a corrupted volume?
6. How do incremental snapshots work?
7. How do you handle millions of snapshots?
8. How do you maintain consistency during snapshots?

---

# Summary

A snapshot system provides point-in-time recovery using:

- Metadata tracking
- Copy-on-write techniques
- Incremental storage
- Block mapping
- Garbage collection
- Replication

The main design goal:

**Create fast, space-efficient, and reliable recovery points without affecting running workloads.**
