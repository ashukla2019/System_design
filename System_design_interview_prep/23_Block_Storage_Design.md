# 23. Block Storage Design

> Designing a scalable Block Storage System similar to Amazon EBS, Google Persistent Disk, Azure Managed Disks, or Ceph RBD.

---

# Table of Contents

1. Introduction
2. What is Block Storage?
3. Requirements
4. High-Level Architecture
5. Core Components
6. Volume Lifecycle
7. Read Path
8. Write Path
9. Replication
10. Snapshots
11. Thin Provisioning
12. Caching
13. RAID Concepts
14. Failure Recovery
15. Scalability
16. Monitoring
17. Security
18. Trade-offs
19. Real-world Systems
20. Interview Tips

---

# 1. Introduction

Block storage presents storage as a collection of **fixed-size blocks**.

Applications and operating systems view these blocks as a raw disk.

Unlike object storage, block storage has:

- No filenames
- No directories
- No metadata about files

The filesystem (EXT4, XFS, NTFS, etc.) is responsible for organizing files.

Example:

```
Virtual Disk

+-------+-------+-------+-------+
|Block0 |Block1 |Block2 |Block3 |
+-------+-------+-------+-------+
```

Each block can be read or written independently.

---

# 2. What is Block Storage?

A block storage system exposes a virtual disk.

```
Application

↓

Filesystem

↓

Block Device

↓

Storage Cluster
```

The OS formats the disk.

```
mkfs.ext4 /dev/vdb
```

After formatting:

```
/photos

/documents

/videos
```

are created by the filesystem—not the storage service.

---

# 3. Functional Requirements

Users should be able to:

- Create volume
- Delete volume
- Attach volume
- Detach volume
- Read blocks
- Write blocks
- Resize volume
- Snapshot volume
- Restore volume
- Clone volume

---

## Non-functional Requirements

Availability

99.99%

Latency

<2 ms SSD

Durability

99.999%

Scalability

Millions of volumes

Throughput

GB/s

---

# 4. High-Level Architecture

```
               Client VM
                   │
         Block Device Driver
                   │
          Storage Controller
                   │
      +------------+------------+
      |                         |
 Metadata Service        Scheduler
      |                         |
      +------------+------------+
                   │
          Storage Nodes
        +-----+-----+-----+
        |Disk |Disk |Disk |
        +-----+-----+-----+
```

---

# 5. Components

## Storage Controller

Responsible for:

- Volume management
- Block mapping
- Replica placement
- Snapshot coordination
- Health monitoring

---

## Metadata Service

Stores:

```
Volume ID

Owner

Size

Replica locations

Snapshot list

Encryption key

Status
```

Metadata is small and replicated separately.

---

## Storage Nodes

Each node stores blocks.

Example

```
Node A

Block 0

Block 4

Block 7

Block 11
```

---

# 6. Volume Lifecycle

```
Create Volume

↓

Allocate Metadata

↓

Reserve Blocks

↓

Attach to VM

↓

Read/Write

↓

Snapshot

↓

Detach

↓

Delete
```

---

# 7. Block Mapping

Applications think blocks are contiguous.

Internally:

```
Logical Block

↓

Physical Block
```

Example

| Logical | Physical |
|----------|----------|
|0|Node3 Block81|
|1|Node1 Block19|
|2|Node5 Block42|

Mapping is maintained by metadata.

---

# 8. Read Workflow

```
Application

↓

Filesystem

↓

Read Block 120

↓

Storage Controller

↓

Locate Replica

↓

Nearest Storage Node

↓

Return Data
```

Reads are often served from the closest healthy replica.

---

# 9. Write Workflow

```
Application

↓

Write Block

↓

Controller

↓

Primary Replica

↓

Secondary Replicas

↓

Commit

↓

ACK
```

Write ordering is preserved to maintain filesystem consistency.

---

# 10. Replication

Replication Factor = 3

```
Volume

↓

Replica A

Replica B

Replica C
```

Replicas should be distributed across:

- Different disks
- Different servers
- Different racks
- Optionally different availability zones

---

# 11. Synchronous vs Asynchronous Replication

## Synchronous

```
Write

↓

Replica1

Replica2

Replica3

↓

ACK
```

Pros

- Zero data loss

Cons

- Higher latency

---

## Asynchronous

```
Primary

↓

ACK

↓

Replicate Later
```

Pros

- Lower latency

Cons

- Small recovery point objective (RPO)

---

# 12. Snapshots

Snapshots capture the disk state.

Instead of copying the entire volume immediately:

```
Volume

↓

Snapshot Metadata

↓

Changed Blocks Only
```

This is known as **Copy-on-Write (CoW)**.

---

Example

```
Before Snapshot

Block1

Block2

Block3
```

After modifying Block2

```
Old Block2 → Snapshot

New Block2 → Active Volume
```

Only changed blocks consume additional storage.

---

# 13. Clone Volume

```
Volume A

↓

Clone

↓

Volume B
```

Initially both share blocks.

Changed blocks become private.

This dramatically reduces cloning time.

---

# 14. Thin Provisioning

Requested:

```
1 TB
```

Actually allocated:

```
50 GB
```

Blocks are allocated only when written.

Advantages

- Better utilization
- Lower cost

Risk

Running out of physical capacity if overcommitted.

---

# 15. Thick Provisioning

Entire requested storage is reserved.

```
1 TB requested

↓

1 TB allocated immediately
```

Pros

Predictable performance.

Cons

Lower utilization.

---

# 16. Caching

## Read Cache

Frequently accessed blocks remain in memory.

```
Read

↓

Cache?

↓

Yes

↓

Return
```

---

## Write Cache

Writes accumulate briefly.

```
Write

↓

Memory

↓

Disk
```

Battery-backed cache protects against power failures.

---

# 17. RAID Concepts

## RAID 0

Striping

```
Disk1

Disk2

Disk3
```

High performance

No redundancy

---

## RAID 1

Mirroring

```
Disk A

↓

Disk B
```

High durability

50% capacity efficiency

---

## RAID 5

Distributed parity

Lower storage overhead

Can tolerate one disk failure.

---

## RAID 6

Dual parity

Survives two disk failures.

---

Modern distributed block stores often replace RAID with software replication.

---

# 18. Data Integrity

Each block has:

```
Checksum

CRC32

SHA256
```

Verification occurs during reads.

Background scrubbing periodically checks all blocks.

---

# 19. Failure Handling

Disk Failure

↓

Replica serves requests

↓

Background rebuild

---

Node Failure

↓

Failover

↓

Replica promoted

↓

New replica created

---

Rack Failure

↓

Cross-rack replicas survive

↓

Automatic recovery

---

# 20. Resize Volume

Growing

```
100 GB

↓

500 GB
```

Metadata updated.

Filesystem expands afterward.

Shrinking is generally unsupported because of data movement complexity.

---

# 21. Multi-Attach

One volume

↓

Attached to multiple VMs

```
VM1

VM2

VM3
```

Requires clustered filesystems such as:

- GFS2
- OCFS2

Otherwise data corruption can occur.

---

# 22. Performance Optimizations

- NVMe SSDs
- Parallel IO
- Request batching
- IO scheduling
- Read-ahead
- Write combining
- Compression
- Deduplication

---

# 23. Scalability

Metadata servers

```
1

↓

10

↓

100
```

Storage nodes

```
100

↓

1,000

↓

10,000
```

Volumes are distributed across many nodes using consistent hashing or placement algorithms.

---

# 24. Security

Encryption at Rest

AES-256

Encryption in Transit

TLS

Authentication

- IAM
- API keys
- RBAC

Per-volume encryption keys improve isolation.

---

# 25. Monitoring

Important metrics

- IOPS
- Read latency
- Write latency
- Queue depth
- Disk utilization
- Replica lag
- Failed writes
- Failed reads
- Node health
- Cache hit ratio
- Snapshot duration
- Rebuild time

---

# 26. Capacity Planning

Example

Volumes

2 Million

Average Size

500 GB

Raw Capacity

1 EB

Replication Factor

3

Required Storage

3 EB

Metadata

2 KB/volume

Metadata Size

≈4 GB

---

# 27. Common Bottlenecks

Metadata hotspot

Solution

Metadata sharding

---

Slow writes

Solution

Write batching

---

Disk contention

Solution

IO scheduler

---

Uneven storage usage

Solution

Automatic rebalancer

---

Network congestion

Solution

Dedicated storage network

---

# 28. Trade-offs

| Choice | Pros | Cons |
|----------|------|------|
|Replication|Simple recovery|Higher storage cost|
|Erasure Coding|Storage efficient|Higher CPU overhead|
|Thin Provisioning|Efficient utilization|Risk of oversubscription|
|Thick Provisioning|Predictable performance|Lower utilization|
|Synchronous Replication|No data loss|Higher latency|
|Asynchronous Replication|Fast writes|Possible recent data loss|

---

# 29. Real-world Systems

## Amazon EBS

- Network-attached block storage
- SSD/HDD volume types
- Incremental snapshots
- Encryption
- Elastic resizing
- High availability within an availability zone

---

## Google Persistent Disk

- Live resizing
- Snapshots
- Regional replication
- SSD and HDD options
- Automatic repair

---

## Azure Managed Disks

- Premium SSD
- Standard SSD
- Ultra Disk
- Incremental snapshots
- Availability Zone support

---

## Ceph RBD

- Distributed block storage
- Thin provisioning
- Copy-on-write snapshots
- Cloning
- Self-healing
- Open source

---

# 30. Interview Discussion

### Q1. Why use block storage?

- Low latency
- Raw disk abstraction
- Suitable for databases and virtual machines
- Supports any filesystem

---

### Q2. Block vs Object Storage?

| Block | Object |
|---------|---------|
|Low latency|Higher latency|
|Random access|Whole object access|
|Filesystem required|No filesystem|
|VM disks|Media and backups|

---

### Q3. How do snapshots work?

- Metadata is frozen
- Changed blocks are copied on first write (Copy-on-Write)
- Snapshot references unchanged blocks

---

### Q4. Why separate metadata?

- Faster lookups
- Smaller dataset
- Independent scaling
- Better fault isolation

---

### Q5. How is durability achieved?

- Multiple replicas
- Checksums
- Background scrubbing
- Automatic rebuilds
- Cross-rack or cross-zone replication

---

# 31. Best Practices

- Replicate across failure domains
- Enable encryption by default
- Use incremental snapshots
- Monitor queue depth and latency
- Avoid metadata bottlenecks
- Use SSDs for latency-sensitive workloads
- Regularly scrub data for corruption
- Automate recovery and rebalancing
- Keep storage and compute loosely coupled
- Plan capacity for replica overhead

---

# 32. Summary

A distributed block storage system provides virtual disks with low-latency random access, making it ideal for virtual machines, databases, and enterprise applications. It separates metadata from block data, distributes replicas across storage nodes, supports snapshots and cloning through copy-on-write, and ensures durability with replication, checksums, and automated recovery. Systems like Amazon EBS, Google Persistent Disk, Azure Managed Disks, and Ceph RBD demonstrate how block storage can scale to millions of volumes while delivering high availability, strong performance, and operational simplicity.
