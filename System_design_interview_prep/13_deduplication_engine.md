# Deduplication Engine System Design

## 1. Overview

Data deduplication is a storage optimization technique that removes duplicate data blocks and stores only one copy.

Instead of storing:

```
File A:

A B C D


File B:

A B C D

```

The system stores:

```
Unique Blocks:

A
B
C
D


References:

File A ---> A B C D

File B ---> A B C D

```

Benefits:

- Reduces storage usage
- Lowers backup cost
- Improves storage efficiency

---

# 2. Goals

A deduplication engine should provide:

- Duplicate detection
- Storage reduction
- Fast lookup
- Data integrity
- Scalability
- Low overhead

---

# 3. Functional Requirements

## Store Data

Input:

```
PUT(file)

```

System should:

- Split data
- Detect duplicates
- Store unique chunks


---

## Retrieve Data

Input:

```
GET(file_id)

```

System should:

- Find chunks
- Reconstruct original file

---

## Delete Data

Remove references and unused chunks.

---

## Garbage Collection

Clean orphan blocks.

---

# 4. Non Functional Requirements

## Performance

- High throughput
- Low latency


## Reliability

Protect against:

- Data corruption
- Hash collision
- Hardware failure


## Scalability

Support:

- Billions of chunks
- Petabytes of storage

---

# 5. High Level Architecture

```
              Client

                |

          Deduplication API

                |

          Chunking Engine

                |

          Hash Generator

                |

        Fingerprint Database

                |

          Storage Backend


```

Components:

1. API Layer
2. Chunking Service
3. Fingerprint Service
4. Metadata Store
5. Storage System
6. Garbage Collector

---

# 6. Data Chunking

Before deduplication, data is divided into chunks.

Example:

```
Original File:

ABCDEFGHIJKLMNOPQRSTUVWXYZ


Chunks:

ABCDEF
GHIJKL
MNOPQR
STUVWX
YZ

```

---

# 7. Chunking Strategies

## Fixed Size Chunking

Example:

```
Every 4KB

Chunk1
Chunk2
Chunk3

```

Advantages:

- Simple
- Fast

Disadvantages:

- Poor duplicate detection after data changes


---

## Content Defined Chunking (CDC)

Chunk boundaries depend on content.

Example:

```
Hash(content)

If condition matches:

Create chunk

```

Advantages:

- Better duplicate detection
- Used in backup systems

Disadvantages:

- More CPU cost

---

# 8. Hashing

Each chunk gets a fingerprint.

Example:

```
Chunk:

Hello World


Hash:

8f434346

```

Hash table:

```
Fingerprint       Location

8f434346          Block 100

7ab23c11          Block 200

```

Common algorithms:

- SHA-256
- SHA-1
- MD5

---

# 9. Deduplication Flow

```
Client Upload

       |

Split Data Into Chunks

       |

Generate Hash

       |

Check Fingerprint DB

       |

-----------------------

Existing Chunk?

       |

Yes -------- Reference Existing Data

       |

No

       |

Store New Chunk

```

---

# 10. Metadata Design

Metadata stores relationships.

Example:

```
File Metadata


file123

Chunks:

hash1

hash2

hash3

```

Chunk metadata:

```
Hash:

abc123


Reference Count:

5


Location:

Disk Block 500

```

---

# 11. Inline Deduplication

Deduplication happens during write.

Flow:

```
Incoming Data

      |

Check Duplicate

      |

Store Unique Data

```

Advantages:

- Saves storage immediately

Disadvantages:

- Higher write latency

---

# 12. Post Process Deduplication

Data is stored first.

Later:

```
Storage

   |

Scanner

   |

Find Duplicates

   |

Remove Copies

```

Advantages:

- Faster writes

Disadvantages:

- Temporary storage waste

---

# 13. Reference Counting

Multiple files can share the same block.

Example:

```
Chunk A

Referenced by:

File1
File2
File3

Reference Count = 3

```

When deleting:

```
Reference Count--

```

Delete chunk only when:

```
Reference Count = 0

```

---

# 14. Collision Handling

Problem:

Two chunks may produce same hash.

Solution:

## Verify Content

```
Hash Match

      |

Compare Actual Data

      |

Confirm Duplicate

```

---

# 15. Garbage Collection

Unused chunks must be removed.

Process:

```
Find Chunks

Reference Count = 0

        |

Delete Chunk

```

---

# 16. Scaling Design

## Distributed Fingerprint Database

Large systems partition hashes.

Example:

```
Hash Range A

        Server 1


Hash Range B

        Server 2


Hash Range C

        Server 3

```

---

## Bloom Filter Optimization

Before database lookup:

```
Hash

 |

Bloom Filter

 |

Possible Match?

```

Benefits:

- Reduces disk lookup
- Faster writes

---

# 17. Failure Handling

## Metadata Failure

Solution:

- Replicated metadata store


## Storage Failure

Solution:

- Replication
- Erasure coding


## Hash Database Failure

Solution:

- Backup
- Distributed storage

---

# 18. Compression Integration

Pipeline:

```
Data

 |

Deduplication

 |

Compression

 |

Storage

```

Order matters.

Usually:

Deduplication first, compression second.

---

# 19. Security Considerations

Implement:

- Encryption