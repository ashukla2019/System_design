# 22. Object Storage Design

> Designing a massively scalable Object Storage System similar to Amazon S3, Google Cloud Storage, or Azure Blob Storage.

---

# Table of Contents

1. Introduction
2. What is Object Storage?
3. Requirements
4. High-Level Architecture
5. APIs
6. Object Model
7. Metadata Service
8. Storage Nodes
9. Upload Workflow
10. Download Workflow
11. Object Replication
12. Consistency Model
13. Versioning
14. Multipart Upload
15. Storage Classes
16. Lifecycle Management
17. Data Integrity
18. Erasure Coding
19. Security
20. Scalability
21. Failure Handling
22. Monitoring
23. Trade-offs
24. Real-world Systems
25. Interview Tips

---

# 1. Introduction

Object storage stores data as **objects** rather than blocks or files.

Each object consists of:

- Data
- Metadata
- Unique Identifier (Key)

Unlike file systems, there are no hierarchical folders.

Instead:

```
photos/2025/img1.jpg
photos/2025/img2.jpg
```

are simply keys.

Object storage excels at:

- Infinite scalability
- High durability
- Cheap storage
- Large objects

Typical use cases:

- Images
- Videos
- Backups
- ML datasets
- Static websites
- Archives

---

# 2. Functional Requirements

## Users can

- Upload object
- Download object
- Delete object
- List objects
- Update metadata
- Version objects
- Share objects

---

## Non-functional

Availability:

99.99%

Durability:

99.999999999%

Scalability:

Millions of requests/sec

Storage:

Exabytes

Latency:

<100ms metadata lookup

---

# 3. High-Level Architecture

```
               Client
                  │
             API Gateway
                  │
        ┌─────────┴─────────┐
        │                   │
 Metadata Service      Auth Service
        │
        │
   Metadata Database
        │
        │
 Storage Coordinator
        │
 ┌──────┼─────────────┐
 │      │             │
Node1 Node2        Node3
 │      │             │
Disks  Disks        Disks
```

---

# 4. Components

## API Gateway

Responsibilities:

- Authentication
- Authorization
- Rate limiting
- Request routing

---

## Metadata Service

Stores:

- Object name
- Size
- Bucket
- Checksum
- Creation time
- Version
- Replica locations

Metadata is tiny compared to objects.

---

## Storage Nodes

Actually store object bytes.

Each node owns:

```
Object A
Object B
Object C
```

Data stored on local disks.

---

# 5. Object Model

Each object

```
{
  Key:
      photos/image.jpg

  Size:
      20 MB

  Owner:
      user123

  Content-Type:
      image/jpeg

  Version:
      5

  Checksum:
      SHA256

  Replicas:
      Node2
      Node5
      Node9
}
```

---

# 6. Buckets

Buckets organize objects.

Example:

```
Bucket

photos

Objects

summer/img1.jpg

winter/img2.jpg

videos/movie.mp4
```

Bucket policies define:

- Permissions
- Lifecycle
- Versioning
- Encryption

---

# 7. Object Upload Workflow

Client uploads

```
PUT /bucket/object
```

Flow

```
Client

↓

Gateway

↓

Metadata Service

↓

Storage Coordinator

↓

Choose storage nodes

↓

Upload chunks

↓

Verify checksum

↓

Commit metadata

↓

Success
```

---

# 8. Object Download Workflow

```
Client

↓

Gateway

↓

Metadata lookup

↓

Find replicas

↓

Nearest storage node

↓

Read object

↓

Return bytes
```

---

# 9. Metadata Database

Metadata stored separately.

Reasons:

Objects are huge.

Metadata is tiny.

Example:

```
Object ID

Bucket

Owner

Checksum

Location

Replication

Version

Storage Class
```

Common databases:

- Cassandra
- DynamoDB
- Spanner
- FoundationDB

---

# 10. Object Placement

Storage coordinator chooses nodes.

Example:

```
Node1

80% full

Node2

55%

Node3

40%

Node4

65%
```

Algorithm

Choose least loaded nodes.

Also consider

- Rack awareness
- Region
- Disk health
- Latency

---

# 11. Replication

Store multiple copies.

Example

Replication Factor = 3

```
Replica1 → Rack A

Replica2 → Rack B

Replica3 → Rack C
```

Benefits

- Durability
- Availability
- Fast reads

---

# 12. Read Path

Metadata

```
Object → Node2 Node5 Node8
```

Nearest replica chosen.

```
Client

↓

Node2
```

Lower latency.

---

# 13. Write Path

```
Client

↓

Coordinator

↓

Primary Node

↓

Replica Nodes

↓

ACK
```

Policies

### Strong

Wait for all replicas.

### Eventual

Wait for primary only.

---

# 14. Consistency

Options

## Strong

Latest write immediately visible.

Pros

Simple

Cons

Higher latency

---

## Eventual

Writes propagate later.

Pros

Fast

Cons

Temporary stale reads.

S3 originally used eventual consistency; modern S3 provides strong read-after-write consistency.

---

# 15. Versioning

Every overwrite creates new object.

```
img.jpg

Version1

Version2

Version3
```

Delete marker added instead of physical delete.

Benefits

- Recovery
- Rollback
- Auditing

---

# 16. Multipart Upload

Large file

```
100 GB
```

Split into

```
Part1

Part2

Part3

...

Part1000
```

Advantages

- Parallel upload
- Retry only failed parts
- Resume upload

Workflow

```
Create Upload

↓

Upload Parts

↓

Complete Upload

↓

Merge Metadata
```

---

# 17. Checksums

Every upload computes

```
SHA256

MD5

CRC32
```

On download

```
Recompute checksum

Compare

Return
```

Protects against corruption.

---

# 18. Erasure Coding

Alternative to replication.

Instead of

```
3 copies
```

Store

```
6 data blocks

3 parity blocks
```

Recover from failures using parity.

Example

```
A B C D E F

+

P1 P2 P3
```

Storage overhead

Replication

300%

Erasure Coding

150%

Huge savings.

---

# 19. Storage Classes

Hot Storage

SSD

Fast

Expensive

---

Warm

HDD

Moderate latency

---

Cold

Archive

Cheap

Hours retrieval

---

Deep Archive

Tape

Very cheap

Days retrieval

---

# 20. Lifecycle Rules

Automatically move data.

Example

```
30 days

↓

Warm

90 days

↓

Cold

365 days

↓

Delete
```

Reduces costs.

---

# 21. Compression

Compress before storing.

Algorithms

- Gzip
- Snappy
- Zstd

Pros

Less storage

Cons

CPU overhead

---

# 22. Encryption

At Rest

AES-256

Per-object key

---

In Transit

TLS

HTTPS

---

Key Management

KMS

Envelope encryption

---

# 23. Authentication

Common methods

- OAuth
- IAM
- API Keys
- Signed URLs

Signed URL example

```
GET

Expires

Signature
```

Temporary access without exposing credentials.

---

# 24. Access Control

Permissions

```
Read

Write

Delete

List
```

Implemented through

- Bucket policies
- ACLs
- IAM roles

---

# 25. Garbage Collection

Deleted objects

↓

Marked deleted

↓

Retention period

↓

Cleanup workers

↓

Physical deletion

Prevents accidental data loss.

---

# 26. Scalability

Horizontal scaling

```
Storage Nodes

10

↓

100

↓

1000

↓

10000
```

No downtime.

---

Metadata sharding

```
Hash(ObjectID)

↓

Shard
```

Allows billions of objects.

---

# 27. Failure Handling

Disk failure

↓

Replica serves data

↓

Background replication restores redundancy

---

Node failure

↓

Coordinator reroutes traffic

↓

New replica created

---

Region failure

↓

Cross-region replication

↓

Traffic redirected

---

# 28. Monitoring

Metrics

Storage

Used capacity

Request latency

PUT/sec

GET/sec

Replication lag

Disk failures

Checksum failures

Node health

Network throughput

Error rates

---

# 29. Cost Optimization

Techniques

- Deduplication
- Compression
- Lifecycle rules
- Erasure coding
- Cold storage
- Intelligent tiering

---

# 30. Capacity Planning

Example

Users

100 Million

Average objects/user

1,000

Total objects

100 Billion

Average size

5 MB

Raw storage

500 PB

Replication factor

3

Total storage

1.5 EB

Metadata/object

1 KB

Metadata storage

100 TB

---

# 31. Bottlenecks

Metadata hotspot

Solution

Metadata sharding

---

Slow uploads

Solution

Multipart upload

---

Storage imbalance

Solution

Rebalancer

---

Network saturation

Solution

CDN + regional replicas

---

Replica lag

Solution

Background replication workers

---

# 32. Trade-offs

| Choice | Pros | Cons |
|----------|------|------|
| Replication | Simple | High storage cost |
| Erasure Coding | Cheap | Complex recovery |
| Strong Consistency | Correctness | Higher latency |
| Eventual Consistency | Fast | Stale reads |
| SSD | Low latency | Expensive |
| HDD | Cheap | Slower |

---

# 33. Real-world Systems

## Amazon S3

- Virtually unlimited storage
- Strong consistency
- Versioning
- Lifecycle policies
- Cross-region replication
- Multipart upload
- Intelligent tiering

---

## Google Cloud Storage

- Multi-region buckets
- Object versioning
- IAM integration
- Nearline/Coldline storage
- Automatic integrity checks

---

## Azure Blob Storage

- Hot/Cool/Archive tiers
- Snapshots
- Geo-redundancy
- Immutable storage
- Shared Access Signatures (SAS)

---

## MinIO

- S3-compatible API
- Self-hosted
- Erasure coding
- Distributed deployment
- Kubernetes-friendly

---

# 34. Interview Discussion

### Common Questions

**Q1: Why separate metadata from object data?**

- Faster lookups
- Independent scaling
- Smaller database
- Efficient indexing

---

**Q2: Replication vs Erasure Coding?**

Replication:
- Faster reads
- Simpler implementation
- Higher storage overhead

Erasure Coding:
- Lower storage cost
- Better for cold data
- More CPU-intensive reconstruction

---

**Q3: Why multipart upload?**

- Upload files larger than a single request limit
- Parallelism
- Resume interrupted uploads
- Retry individual parts

---

**Q4: How is durability achieved?**

- Multiple replicas
- Cross-rack placement
- Cross-region replication
- Background repair
- Regular checksum validation

---

**Q5: How do you avoid hotspots?**

- Consistent hashing
- Randomized object placement
- Metadata sharding
- Load-aware placement algorithms

---

# 35. Best Practices

- Keep metadata lightweight
- Replicate across failure domains
- Use multipart uploads for large files
- Validate checksums on write and read
- Encrypt data at rest and in transit
- Enable versioning for critical buckets
- Automate lifecycle transitions
- Monitor replication lag and disk health
- Rebalance storage periodically
- Use erasure coding for archival data

---

# 36. Summary

A production-grade object storage system separates metadata from object data, distributes objects across many storage nodes, and ensures durability through replication or erasure coding. It scales horizontally to billions of objects while providing high availability, strong or eventual consistency (depending on design goals), robust security, lifecycle management, and automated recovery from failures. Modern implementations such as Amazon S3, Google Cloud Storage, Azure Blob Storage, and MinIO demonstrate these principles at exabyte scale.
