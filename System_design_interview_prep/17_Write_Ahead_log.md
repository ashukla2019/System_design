# Write Ahead Log (WAL) System Design

## 1. Overview

A Write Ahead Log (WAL) is a storage reliability technique where changes are written to a log **before** modifying the actual data.

The main purpose is:

- Crash recovery
- Data durability
- Transaction consistency

Basic principle:

```
Write Log First

        |

Update Actual Data

```

Used in:

- Databases
- File systems
- Metadata services
- Storage engines

Examples:

- PostgreSQL WAL
- MySQL Redo Log
- RocksDB WAL

---

# 2. Goals

A WAL system should provide:

- Durability
- Fast recovery
- Ordered writes
- Crash safety
- Minimal performance impact

---

# 3. Functional Requirements

## Append Log Entry

Store an operation.

Example:

```
INSERT user1 = Alice

```

---

## Replay Logs

Recover data after failure.

Example:

```
Read WAL

      |

Execute Operations

      |

Restore State

```

---

## Checkpoint

Save current state and reduce recovery time.

---

## Log Management

Support:

- Rotation
- Cleanup
- Compression

---

# 4. Non Functional Requirements

## Reliability

No committed data should be lost.

---

## Performance

Support:

- High write throughput
- Sequential disk writes

---

## Scalability

Handle:

- Large logs
- Millions of operations

---

# 5. High Level Architecture

```
              Application

                   |

              Storage Engine

                   |

             Write Ahead Log

                   |

              Data Files

```

Components:

1. WAL Manager
2. Log Storage
3. Recovery Engine
4. Checkpoint Manager
5. Log Cleaner

---

# 6. WAL Data Format

A log record contains:

```
Log ID

Timestamp

Transaction ID

Operation Type

Data

Checksum

```

Example:

```
001

TX100

UPDATE

user.name = Bob

```

---

# 7. Write Flow

Normal write:

```
Application

 |

Write Request

 |

Create WAL Entry

 |

Flush WAL To Disk

 |

Update Data Files

 |

Return Success

```

Order is important:

```
WAL First

Data Second

```

---

# 8. Why WAL Works

Without WAL:

```
Update Memory

        |

Crash

        |

Data Lost

```

With WAL:

```
Write Log

        |

Crash

        |

Replay Log

        |

Recover Data

```

---

# 9. Commit Process

Transaction example:

```
BEGIN

 |

Update Data

 |

Write WAL

 |

Commit Record

 |

Success

```

A transaction is considered complete after WAL is safely stored.

---

# 10. Recovery Process

After crash:

```
System Restart

       |

Read WAL

       |

Find Committed Operations

       |

Replay Changes

       |

Restore Database

```

---

# 11. Checkpoint Design

Problem:

Large WAL requires long recovery.

Solution:

Create checkpoints.

Example:

```
WAL:

1
2
3
4
5


Checkpoint


New WAL:

6
7
8

```

During recovery:

```
Load Checkpoint

       |

Replay Only New Logs

```

---

# 12. Log Rotation

Old logs are removed after checkpoint.

Example:

Before:

```
WAL1
WAL2
WAL3
WAL4

```

After cleanup:

```
WAL4

```

---

# 13. Log Storage Design

WAL uses sequential writes.

Advantages:

- Faster than random writes
- Better disk utilization

Storage:

```
Log Segment 1

Log Segment 2

Log Segment 3

```

---

# 14. Replicated WAL

For high availability:

```
Primary WAL

     |

----------------

|              |

Replica WAL  Replica WAL

```

Benefits:

- Failover
- Data protection

---

# 15. WAL and Transactions

WAL supports ACID:

## Atomicity

Incomplete transactions are rolled back.

## Consistency

Operations maintain valid state.

## Isolation

Transactions are ordered.

## Durability

Committed data survives crashes.

---

# 16. Performance Optimization

Techniques:

## Group Commit

Combine multiple writes.

```
TX1

TX2

TX3

 |

Single Disk Write

```

---

## Compression

Reduce log size.

---

## Async Replication

Improve write latency.

---

# 17. Failure Handling

## Partial Write

Problem:

Power failure during write.

Solution:

- Checksums
- Atomic append
- Recovery validation

---

## Corrupted Log

Solution:

- Backup logs
- Replication
- Integrity checks

---

# 18. Garbage Collection

Remove unnecessary logs.

Condition:

```
Checkpoint completed

AND

No active transaction needs log

```

---

# 19. WAL in Distributed Systems

Architecture:

```
Node A

WAL

 |

Replication

 |

Node B

WAL

```

Used for:

- Distributed databases
- Consensus systems

---

# 20. Security

Implement:
