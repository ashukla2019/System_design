# 25. Distributed Database Design (Part 1)
## Fundamentals, Architecture, Replication, and Sharding

> Designing a globally distributed database similar to Google Spanner, Amazon DynamoDB, CockroachDB, Cassandra, YugabyteDB, or TiDB.

---

# Table of Contents

1. Introduction
2. Why Distributed Databases?
3. Functional Requirements
4. Non-Functional Requirements
5. High-Level Architecture
6. Core Components
7. Data Partitioning (Sharding)
8. Replication
9. Consistency Models
10. CAP Theorem
11. Quorum Reads & Writes
12. Read and Write Paths
13. Rebalancing
14. Failure Handling
15. Monitoring
16. Best Practices
17. Summary

---

# 1. Introduction

A **Distributed Database** stores data across multiple machines (nodes) while presenting a single logical database to applications.

Instead of:

```
One Database Server

↓

1 TB Storage
```

We distribute data across many servers:

```
Client

↓

Distributed Database

↓

+-------+-------+-------+
|Node A |Node B |Node C |
+-------+-------+-------+
```

Benefits:

- Horizontal scalability
- High availability
- Fault tolerance
- Geographic distribution
- Increased throughput

---

# 2. Why Distributed Databases?

A single server eventually reaches limits:

- CPU
- Memory
- Disk
- Network bandwidth

Scaling vertically becomes expensive.

Distributed systems scale horizontally:

```
10 Nodes

↓

100 Nodes

↓

1000 Nodes
```

Applications continue to grow without redesigning storage.

---

# 3. Functional Requirements

The system should support:

- CRUD operations
- SQL or NoSQL queries
- Transactions
- Replication
- Automatic failover
- Data partitioning
- Backups
- Schema evolution
- Multi-region deployment

---

# 4. Non-Functional Requirements

Availability

99.99%+

Durability

99.999999999%

Latency

Low single-digit milliseconds (regional)

Scalability

Petabytes

Millions of TPS

Fault tolerance

Automatic recovery

---

# 5. High-Level Architecture

```
                  Client
                     │
              Load Balancer
                     │
          +----------+----------+
          |                     |
      Query Router         Metadata Service
          |                     |
          +----------+----------+
                     │
          +----------+----------+
          |          |          |
      Node A     Node B     Node C
```

---

# 6. Core Components

## Query Router

Responsibilities:

- Parse request
- Locate shard
- Forward request
- Merge distributed results

---

## Metadata Service

Maintains:

- Shard map
- Replica locations
- Cluster membership
- Leader information
- Health status

---

## Storage Nodes

Each node stores:

- Data
- WAL
- Indexes
- Replicas

Nodes can act as:

- Leaders
- Followers
- Read replicas

---

# 7. Sharding

A **shard** is a subset of data.

Example:

```
Users

↓

Shard 1

IDs 1–1M

↓

Shard 2

IDs 1M–2M

↓

Shard 3

IDs 2M–3M
```

Each shard resides on a different node.

---

# 8. Horizontal vs Vertical Partitioning

## Horizontal Partitioning

Split rows.

```
User 1

User 2

User 3
```

across multiple servers.

Most distributed databases use horizontal partitioning.

---

## Vertical Partitioning

Split columns.

```
UserID

↓

Profile

↓

Preferences
```

Useful for microservices but less common as a sharding strategy.

---

# 9. Sharding Strategies

## Range-Based Sharding

```
1–1000

↓

Node A

1001–2000

↓

Node B
```

Advantages:

- Efficient range scans

Disadvantages:

- Hotspots if inserts are sequential

---

## Hash-Based Sharding

```
Hash(UserID)

↓

Shard
```

Advantages:

- Even distribution

Disadvantages:

- Poor range queries

---

## Consistent Hashing

```
          Node A
        /         \
Node D             Node B
        \         /
          Node C
```

Keys are mapped onto a hash ring.

Benefits:

- Minimal data movement
- Easy node addition/removal

Widely used in Dynamo-inspired systems.

---

# 10. Replication

Replication creates multiple copies of data.

```
Leader

↓

Follower 1

↓

Follower 2
```

Advantages:

- Durability
- High availability
- Faster reads
- Disaster recovery

---

# 11. Replication Models

## Single Leader

```
Writes

↓

Leader

↓

Followers
```

Simple and widely used.

---

## Multi-Leader

```
Region A

Leader

↓

Region B

Leader
```

Useful for geo-distributed writes.

Requires conflict resolution.

---

## Leaderless

```
Client

↓

Replica A

Replica B

Replica C
```

Popularized by Amazon Dynamo.

Uses quorum protocols.

---

# 12. Synchronous Replication

```
Write

↓

Leader

↓

Followers

↓

ACK
```

Advantages:

- Strong consistency

Disadvantages:

- Higher latency

---

# 13. Asynchronous Replication

```
Leader

↓

ACK Client

↓

Replicate Later
```

Advantages:

- Fast writes

Disadvantages:

- Possible recent data loss during failures

---

# 14. Consistency Models

## Strong Consistency

Every read returns the latest committed value.

```
Write

↓

Read

↓

Latest Value
```

Examples:

- Google Spanner
- CockroachDB

---

## Eventual Consistency

Updates propagate over time.

```
Write

↓

Replica A Updated

↓

Replica B Updated Later
```

Temporary stale reads are possible.

Examples:

- Cassandra
- DynamoDB (eventual mode)

---

## Causal Consistency

Ensures causally related operations are observed in order.

Useful for collaborative applications.

---

## Read-Your-Writes Consistency

A client always sees its own writes.

Improves user experience without requiring global strong consistency.

---

# 15. CAP Theorem

A distributed system cannot simultaneously guarantee all three:

- Consistency (C)
- Availability (A)
- Partition Tolerance (P)

During a network partition, a system must choose between:

```
Consistency

or

Availability
```

---

## CP Systems

Choose:

- Consistency
- Partition Tolerance

May reject requests during partitions.

Examples:

- Google Spanner
- ZooKeeper
- etcd

---

## AP Systems

Choose:

- Availability
- Partition Tolerance

May return stale data.

Examples:

- Cassandra
- DynamoDB (eventual)
- Riak

---

# 16. Quorum Reads and Writes

Suppose:

```
Replication Factor (N) = 3
```

Write quorum:

```
W = 2
```

Read quorum:

```
R = 2
```

Condition:

```
R + W > N
```

Ensures at least one replica overlaps between reads and writes.

---

Example:

```
Replicas

A

B

C
```

Write:

```
A

B

ACK
```

Read:

```
B

C

Latest Version Found
```

---

# 17. Read Path

```
Client

↓

Query Router

↓

Metadata Lookup

↓

Replica Selection

↓

Read Data

↓

Return Result
```

Read replicas can reduce latency for read-heavy workloads.

---

# 18. Write Path

```
Client

↓

Router

↓

Leader

↓

WAL

↓

Replicas

↓

Commit

↓

ACK
```

Leader ensures ordering before replication.

---

# 19. Rebalancing

When a new node joins:

```
Node Added

↓

Move Some Shards

↓

Update Metadata

↓

Resume Normal Operations
```

Goals:

- Even storage utilization
- Minimal data movement
- Minimal downtime

---

# 20. Failure Handling

## Node Failure

```
Node Down

↓

Replica Promoted

↓

Metadata Updated
```

---

## Disk Failure

Replica serves requests.

Background repair rebuilds redundancy.

---

## Network Partition

Behavior depends on consistency model:

- CP systems reject some writes
- AP systems continue serving requests

---

# 21. Monitoring

Important metrics:

- Replication lag
- Leader elections
- Read latency
- Write latency
- Replica health
- Shard size
- Hot partitions
- Disk usage
- Network throughput
- Failed requests
- Recovery time

---

# 22. Best Practices

- Choose shard keys carefully.
- Avoid hot partitions.
- Replicate across failure domains.
- Monitor replication lag continuously.
- Use quorum reads/writes when appropriate.
- Automate shard rebalancing.
- Separate metadata from data storage.
- Test failover regularly.

---

# 23. Summary

Distributed databases achieve scalability and fault tolerance by partitioning data across multiple nodes and replicating it for durability. Core design decisions include choosing a sharding strategy, replication model, and consistency guarantees. Understanding these trade-offs is essential for building reliable, globally distributed storage systems.

---

**Next (Part 2):**
- Distributed Transactions
- Two-Phase Commit (2PC)
- Three-Phase Commit (3PC)
- Saga Pattern
- Consensus (Raft & Paxos)
- Leader Election
- Split Brain
- Distributed Locking
- Clock Synchronization
- Google Spanner (TrueTime)
- Real-world Database Architectures

-----------------------------------------------------------
# 25. Distributed Database Design (Part 2)
## Distributed Transactions, Consensus, Leader Election & Global Database Architectures

> This chapter covers how distributed databases maintain consistency across multiple nodes using distributed transactions, consensus algorithms, and fault-tolerant coordination.

---

# Table of Contents

1. Distributed Transactions
2. Challenges
3. Two-Phase Commit (2PC)
4. Three-Phase Commit (3PC)
5. Saga Pattern
6. Consensus
7. Paxos
8. Raft
9. Leader Election
10. Split Brain
11. Distributed Locking
12. Clock Synchronization
13. TrueTime
14. Multi-Region Replication
15. Global Read/Write Routing
16. Real-World Architectures
17. Best Practices
18. Interview Questions
19. Summary

---

# 1. Distributed Transactions

A distributed transaction spans **multiple database nodes**.

Example:

```
Transfer Money

↓

Account A (Shard 1)

↓

Account B (Shard 5)
```

Both updates must either succeed or fail together.

---

# 2. Why Are Distributed Transactions Difficult?

Problems include:

- Network failures
- Node crashes
- Partial commits
- High latency
- Clock skew
- Coordinator failure

Example:

```
Shard A Updated

↓

Network Failure

↓

Shard B Not Updated
```

Without coordination, the database becomes inconsistent.

---

# 3. Two-Phase Commit (2PC)

2PC is the classic protocol for distributed commits.

Participants:

- Coordinator
- Multiple Participants

---

## Phase 1 — Prepare

```
Coordinator

↓

Prepare?

↓

Participant A

Participant B

Participant C
```

Each participant:

- Executes locally
- Writes undo/redo logs
- Replies:

```
YES

or

NO
```

---

## Phase 2 — Commit

If everyone replies YES:

```
Coordinator

↓

COMMIT

↓

All Participants Commit
```

Otherwise:

```
ROLLBACK
```

---

### Advantages

- Atomic commits
- Simple protocol
- Widely implemented

---

### Disadvantages

- Blocking
- Coordinator failure delays progress
- High latency
- Poor scalability

---

# 4. Three-Phase Commit (3PC)

Adds an intermediate phase.

```
Prepare

↓

Pre-Commit

↓

Commit
```

Advantages:

- Reduces blocking

Disadvantages:

- More messages
- Rarely used
- Complex implementation

---

# 5. Saga Pattern

Instead of one large transaction:

```
Transaction A

↓

Transaction B

↓

Transaction C
```

Each transaction commits independently.

If one fails:

```
Execute Compensating Transactions
```

Example:

```
Reserve Hotel

↓

Book Flight

↓

Payment Fails

↓

Cancel Flight

↓

Release Hotel
```

Ideal for:

- Microservices
- Long-running workflows

---

# 6. Consensus

Consensus ensures all nodes agree on:

- Leader
- Log order
- Cluster membership

Requirements:

- Safety
- Liveness
- Fault tolerance

---

# 7. Paxos

One of the earliest consensus algorithms.

Roles:

- Proposer
- Acceptor
- Learner

Workflow (simplified):

```
Prepare

↓

Promise

↓

Accept

↓

Accepted
```

Advantages:

- Proven correctness

Disadvantages:

- Difficult to understand
- Complex implementation

---

# 8. Raft

Raft simplifies consensus while providing similar guarantees.

Node states:

```
Follower

↓

Candidate

↓

Leader
```

---

## Leader Election

Followers wait for heartbeats.

If timeout occurs:

```
Follower

↓

Candidate

↓

Request Votes
```

If majority votes:

```
Leader
```

---

## Log Replication

Client writes:

```
Client

↓

Leader

↓

Followers

↓

Majority ACK

↓

Commit
```

Followers apply entries in the same order.

---

### Advantages

- Easier than Paxos
- Strong consistency
- Deterministic log ordering

Used in:

- etcd
- Consul
- TiKV
- CockroachDB (for some internal components)

---

# 9. Leader Election

A leader coordinates writes.

Example:

```
Cluster

↓

Leader

↓

Followers
```

Leader responsibilities:

- Accept writes
- Replicate logs
- Handle membership changes

If leader fails:

```
Election

↓

New Leader
```

---

# 10. Split Brain

Occurs when two nodes both believe they are leaders.

```
Network Partition

↓

Leader A

Leader B
```

Danger:

Conflicting writes.

Solutions:

- Majority quorum
- Fencing tokens
- Consensus algorithms

---

# 11. Distributed Locking

Used when multiple clients coordinate access.

Example:

```
Worker A

↓

Acquire Lock

↓

Critical Section

↓

Release Lock
```

Requirements:

- Mutual exclusion
- Automatic expiry
- Fault tolerance

Implementations:

- ZooKeeper
- etcd
- Consul

---

# 12. Clock Synchronization

Distributed systems cannot assume perfectly synchronized clocks.

Problems:

- Different hardware clocks
- Network delays
- Drift

Clock skew can break transaction ordering.

---

# 13. Logical Clocks

## Lamport Clock

Tracks event ordering.

```
Event A

↓

Timestamp 10

↓

Event B

↓

Timestamp 11
```

Guarantees:

If A happened before B:

```
Time(A) < Time(B)
```

---

## Vector Clock

Maintains one counter per node.

Example:

```
Node A

[5,2,1]

Node B

[5,3,1]
```

Can detect concurrent updates.

Used in Dynamo-inspired databases.

---

# 14. TrueTime

Google Spanner uses **TrueTime**.

Instead of:

```
Current Time
```

Returns:

```
[now - ε , now + ε]
```

where ε is the clock uncertainty.

Transactions wait until uncertainty expires.

Benefits:

- External consistency
- Globally ordered commits

---

# 15. Multi-Region Replication

Example:

```
US-East

↓

Europe

↓

Asia
```

Benefits:

- Disaster recovery
- Low-latency regional reads
- Regulatory compliance

Challenges:

- High write latency
- Conflict resolution
- Network partitions

---

# 16. Global Read Routing

Clients are routed to the nearest replica.

```
India

↓

Singapore Replica

----------------

Germany

↓

Frankfurt Replica
```

Improves read latency.

---

# 17. Global Write Routing

Strongly consistent systems often route writes to a leader.

```
Client

↓

Global Load Balancer

↓

Leader Region
```

Alternative:

Multi-leader replication for lower latency but higher conflict complexity.

---

# 18. Conflict Resolution

In multi-leader systems:

Example:

```
User edits document in US

↓

Another edit in Europe
```

Resolution strategies:

- Last Write Wins (LWW)
- Version vectors
- Application-defined merge
- Conflict-free Replicated Data Types (CRDTs)

---

# 19. Real-World Architectures

## Google Spanner

Features:

- TrueTime
- Synchronous replication
- Distributed SQL
- Strong consistency
- Automatic sharding

Best for:

Global transactional systems.

---

## CockroachDB

Features:

- Raft consensus
- MVCC
- Automatic rebalancing
- Distributed SQL
- Serializable isolation

---

## Cassandra

Features:

- Leaderless architecture
- Consistent hashing
- Tunable consistency
- LSM Tree
- High availability

Excellent for write-heavy workloads.

---

## Amazon DynamoDB

Features:

- Automatic partitioning
- Multi-AZ replication
- Optional strong consistency
- Global Tables
- Fully managed

---

## YugabyteDB

Features:

- PostgreSQL-compatible SQL
- Raft replication
- Automatic sharding
- Distributed transactions

---

# 20. Monitoring Metrics

Monitor:

### Replication

- Lag
- Sync status
- Replica health

### Consensus

- Election frequency
- Leader changes
- Commit latency

### Sharding

- Hot partitions
- Rebalancing time
- Data distribution

### Transactions

- Commit latency
- Rollbacks
- Deadlocks
- Lock waits

### Infrastructure

- Disk usage
- CPU
- Memory
- Network throughput

---

# 21. Best Practices

- Keep transactions local when possible.
- Design shard keys carefully.
- Avoid cross-shard joins.
- Prefer asynchronous replication for read-heavy workloads where eventual consistency is acceptable.
- Use consensus for metadata and leadership.
- Monitor election storms.
- Automate shard balancing.
- Test regional failover regularly.
- Minimize clock skew.
- Understand consistency requirements before choosing AP vs CP.

---

# 22. Common Interview Questions

### Q1. Why are distributed transactions difficult?

Because failures can occur after only part of the transaction has completed, requiring coordination across unreliable networks.

---

### Q2. 2PC vs Saga?

| 2PC | Saga |
|------|------|
|Strong atomicity|Eventual consistency|
|Blocking|Non-blocking|
|Distributed databases|Microservices|
|Rollback|Compensating actions|

---

### Q3. Raft vs Paxos?

| Raft | Paxos |
|------|--------|
|Simpler|More complex|
|Leader-based|Multiple variants|
|Easy to implement|Mathematically elegant|
|Widely adopted|Foundation for many systems|

---

### Q4. Why use quorum reads/writes?

To ensure overlapping replicas participate in reads and writes, improving consistency while maintaining availability.

---

### Q5. What causes split brain?

Network partitions that allow multiple nodes to believe they are leaders simultaneously.

Consensus protocols and majority quorums prevent this.

---

# 23. Summary

Distributed databases extend traditional database systems by partitioning data, replicating it across nodes, and coordinating updates using consensus algorithms. Techniques such as Raft, Paxos, quorum protocols, and distributed transactions allow systems to remain available and fault tolerant while preserving consistency. Choosing between strong consistency, eventual consistency, single-leader, multi-leader, or leaderless architectures depends on application requirements, latency constraints, and operational complexity.

---

# Complete Chapter Recap

This chapter covered:

1. **Architecture**
   - Sharding
   - Replication
   - Query Routing
   - Metadata Services

2. **Consistency**
   - CAP Theorem
   - Quorums
   - Strong vs Eventual Consistency

3. **Distributed Coordination**
   - Two-Phase Commit (2PC)
   - Three-Phase Commit (3PC)
   - Saga Pattern
   - Raft
   - Paxos
   - Leader Election

4. **Global Systems**
   - Multi-region replication
   - Distributed locking
   - Clock synchronization
   - TrueTime
   - Real-world database architectures

Together, these concepts form the foundation for designing highly available, fault-tolerant distributed databases that can scale across data centers while maintaining correctness and performance.
