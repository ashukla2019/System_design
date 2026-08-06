# RAID Design System Design

## 1. Overview

RAID (Redundant Array of Independent Disks) is a storage technology that combines multiple physical disks into a single logical storage system.

The goals of RAID are:

- Improve storage performance
- Provide fault tolerance
- Increase availability
- Protect against disk failures

Example:

Without RAID:

```
Application

     |
     
   Disk

```

If disk fails:

```
Data Lost
```

With RAID:

```
             RAID Controller

                    |

        -------------------------

        |          |            |

      Disk1      Disk2       Disk3

```

A disk failure can be handled without stopping the system.

---

# 2. Requirements

## Functional Requirements

The RAID system should:

- Combine multiple disks
- Distribute data efficiently
- Detect disk failures
- Recover lost data
- Rebuild failed disks
- Maintain data integrity


## Non Functional Requirements

- High availability
- Fault tolerance
- High throughput
- Low latency
- Data durability

---

# 3. RAID Architecture

```
                Application

                     |

              File System

                     |

              RAID Controller

                     |

       --------------------------------

       |              |               |

     Disk 1         Disk 2          Disk 3

```

Components:

## RAID Controller

Responsible for:

- Data placement
- Striping
- Mirroring
- Parity calculation
- Failure detection


## Physical Disks

Storage devices:

- HDD
- SSD
- NVMe drives

---

# 4. RAID Concepts

## Striping

Data is divided into blocks and distributed across disks.

Example:

Original data:

```
A B C D E F
```

After striping:

```
Disk 1:

A C E


Disk 2:

B D F

```

Benefits:

- Parallel reads
- Higher throughput


---

## Mirroring

Same data is stored on multiple disks.

Example:

```
Disk 1

A B C D


Disk 2

A B C D

```

Benefits:

- High reliability

---

## Parity

Extra calculated information used for recovery.

Example:

```
Data Blocks

A + B = Parity

```

If one block is lost:

```
Missing Data = Parity - Existing Data

```

---

# 5. RAID Levels

## RAID 0 - Striping

Architecture:

```
        RAID 0


Disk 1        Disk 2

A C E         B D F

```

Characteristics:

- No redundancy
- Maximum performance


Advantages:

- Very fast reads
- Very fast writes
- 100% storage utilization


Disadvantages:

- No fault tolerance


Failure:

```
Disk 1 fails

All data unavailable

```

Use cases:

- Temporary data
- High performance workloads

---

# 6. RAID 1 - Mirroring

Architecture:

```
        RAID 1


Disk 1        Disk 2

A B C D       A B C D

```

Characteristics:

- Duplicate copy of data


Advantages:

- Excellent reliability
- Fast recovery
- Simple design


Disadvantages:

- 50% storage efficiency


Example:

Two 4TB disks:

```
Available capacity = 4TB

```

---

# 7. RAID 5 - Striping With Single Parity

Architecture:

```
Disk1      Disk2      Disk3

Data       Data       Parity

A          B          P1

C          P2         D

P3         E          F

```

Can survive:

```
One disk failure

```

Advantages:

- Good balance
- Efficient storage


Disadvantages:

- Slow writes
- Rebuild complexity


Capacity:

```
(N - 1) × Disk Size

```

Example:

```
4 disks × 2TB

Capacity = 6TB

```

---

# 8. RAID 6 - Double Parity

Architecture:

```
Disk1 Disk2 Disk3 Disk4

A     B     P1    Q1

C     P2    D     Q2

```

Can survive:

```
Two disk failures

```

Advantages:

- Higher reliability
- Suitable for large arrays


Disadvantages:

- More parity overhead
- Slower writes


Capacity:

```
(N - 2) × Disk Size

```

---

# 9. RAID 10 (RAID 1+0)

Combination:

```
RAID 1 + RAID 0

```

Architecture:

```
        RAID 10


     Stripe Layer


 ------------------

 Mirror      Mirror


Disk1       Disk3
Disk2       Disk4

```

Advantages:

- Very high performance
- High availability
- Fast rebuild


Disadvantages:

- Expensive
- Requires more disks


Common usage:

- Databases
- Enterprise storage

---

# 10. RAID Write Flow

Example: RAID 5 small write


```
Application

      |

RAID Controller

      |

Read Old Data

      |

Read Old Parity

      |

Calculate New Parity

      |

Write Data

      |

Write Parity

```

This is called:

```
Read-Modify-Write Cycle

```

---

# 11. RAID Read Flow

```
Application

     |

RAID Controller

     |

Locate Blocks

     |

Read From Multiple Disks

     |

Return Data

```

RAID 0 and RAID 10 provide high read performance.

---

# 12. Disk Failure Handling

Failure detection:

```
Disk Monitoring

      |

Error Detected

      |

Disk Marked Failed

      |

Recovery Started

```

Methods:

- SMART monitoring
- Disk health checks
- Error counters

---

# 13. Rebuild Process

Example:

RAID 5 disk failure:

Before:

```
Disk1 Disk2 Disk3

 A     B     P

```

Disk2 fails:

```
Disk1 Disk2 Disk3

 A     X     P

```

New disk added:

```
New Disk

       |

Calculate Missing Data

       |

Copy Recovered Data

       |

Array Restored

```

Problems:

- Slow rebuild
- Performance impact
- Risk of another failure

---

# 14. Hot Spare

A standby disk automatically replaces failed disks.

Architecture:

```
Disk1
Disk2
Disk3

     +

Hot Spare

```

Failure:

```
Disk Failure

      |

Hot Spare Activated

      |

Automatic Rebuild

```

---

# 15. RAID Controller Cache

A RAID controller may use cache memory.

Benefits:

- Faster writes
- Write batching
- Reduced latency


Safety:

Use:

- Battery backed cache
- Flash backed cache

---

# 16. RAID Monitoring

Monitor:

## Disk Health

- SMART status
- Temperature
- Bad sectors


## RAID Health

- Array status
- Rebuild percentage
- Failed disks


## Performance

- IOPS
- Throughput
- Latency

---

# 17. RAID vs Replication

| RAID | Replication |
|-|-|
| Inside storage system | Across machines |
| Protects disk failures | Protects node failures |
| Usually local | Distributed |
| Faster recovery | Better availability |

Modern systems often combine:

```
Replication

+

RAID

+

Erasure Coding

```

---

# 18. Capacity Planning

Factors:

- Number of disks
- Disk size
- RAID level
- Expected failures
- Performance requirements


Example:

10 disks × 10TB

RAID 6:

```
(10-2) × 10TB

= 80TB usable

```

---

# 19. Trade-offs

| RAID Level | Performance | Reliability | Capacity |
|-|-|-|-|
| RAID 0 | Excellent | None | 100% |
| RAID 1 | Good | High | 50% |
| RAID 5 | Good | Medium | N-1 |
| RAID 6 | Medium | Very High | N-2 |
| RAID 10 | Excellent | High | 50% |

---

# 20. Interview Questions

1. Why do we need RAID?
2. Difference between RAID 5 and RAID 6?
3. How does parity recovery work?
4. Why is RAID 5 write performance slow?
5. Explain RAID rebuild process.
6. RAID vs