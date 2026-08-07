# 24. Database Storage Engine Design (Part 1)
## Storage Engine Fundamentals

> Designing the core storage engine of a relational database similar to PostgreSQL, MySQL InnoDB, SQL Server, or Oracle.

---

# Table of Contents

1. Introduction
2. What is a Storage Engine?
3. Responsibilities
4. High-Level Architecture
5. Storage Hierarchy
6. Pages
7. Records
8. Slotted Page Layout
9. Heap Files
10. Free Space Management
11. Buffer Pool
12. Page Replacement
13. Write-Ahead Logging (WAL)
14. Checkpoints
15. Read Path
16. Write Path
17. Crash Recovery Basics
18. Monitoring
19. Best Practices

---

# 1. Introduction

A **Database Storage Engine** is the component responsible for storing, retrieving, updating, and deleting data on disk while providing:

- Durability
- Atomicity
- High performance
- Efficient indexing
- Recovery from crashes

The SQL parser and optimizer decide *what* data to access. The storage engine decides *how* to store and retrieve it efficiently.

---

# 2. Responsibilities

The storage engine is responsible for:

- Managing disk pages
- Reading/writing records
- Buffer management
- Logging
- Recovery
- Index management
- Space allocation
- Concurrency support

Architecture:

```
SQL Query

↓

Parser

↓

Optimizer

↓

Execution Engine

↓

Storage Engine

↓

Disk
```

---

# 3. High-Level Architecture

```
                    SQL Layer
                        │
                  Query Executor
                        │
         +--------------+--------------+
         |                             |
    Index Manager              Storage Engine
         |                             |
         +--------------+--------------+
                        │
                  Buffer Pool
                        │
             Write Ahead Log (WAL)
                        │
                    Disk Storage
```

---

# 4. Storage Hierarchy

Database storage spans multiple layers.

```
CPU Cache

↓

RAM

↓

Buffer Pool

↓

SSD

↓

HDD

↓

Archive
```

The closer data is to the CPU, the faster it is.

---

# 5. Why Pages?

Databases never read one row at a time from disk.

Instead they read **pages**.

Typical page sizes:

```
4 KB

8 KB

16 KB

32 KB
```

Example:

```
+----------------------+
| Page 0               |
+----------------------+
| Page 1               |
+----------------------+
| Page 2               |
+----------------------+
```

Reading pages minimizes disk I/O.

---

# 6. Page Structure

Each page contains:

```
+----------------------+
| Page Header          |
+----------------------+
| Record Slot Array    |
+----------------------+
| Free Space           |
+----------------------+
| Records              |
+----------------------+
```

The header stores metadata such as:

- Page ID
- LSN (Log Sequence Number)
- Free space pointer
- Checksum
- Number of records

---

# 7. Records

Each database row is stored as a record.

Example table:

```
Users

ID

Name

Age
```

Record:

```
ID = 15

Name = Alice

Age = 28
```

Binary representation:

```
+----+---------+------+
|15  |Alice    |28    |
+----+---------+------+
```

---

# 8. Fixed vs Variable Length Records

## Fixed Length

```
INT

FLOAT

DATE
```

Advantages:

- Fast lookup
- Predictable offsets

Disadvantages:

- Wasted space

---

## Variable Length

```
VARCHAR

TEXT

JSON
```

Advantages:

- Better utilization

Disadvantages:

- More metadata

---

# 9. Slotted Page Layout

Modern databases use **slotted pages**.

```
+----------------------------+
| Header                     |
+----------------------------+
| Slot 0 -> Record           |
| Slot 1 -> Record           |
| Slot 2 -> Record           |
+----------------------------+
|                            |
| Free Space                 |
|                            |
+----------------------------+
| Record C                   |
| Record B                   |
| Record A                   |
+----------------------------+
```

Records grow upward.

Slot directory grows downward.

This allows records to move without changing row identifiers.

---

# 10. Heap File

Heap files store pages without ordering.

```
Page1

↓

Page2

↓

Page3

↓

Page4
```

New records go into pages with free space.

Advantages:

- Fast inserts
- Simple implementation

Disadvantages:

- Slow range scans

---

# 11. Free Space Management

The storage engine tracks available space.

Example:

| Page | Free Space |
|------|------------|
|1|700 B|
|2|4 KB|
|3|0|
|4|2 KB|

When inserting:

```
Need 500 bytes

↓

Choose Page 1
```

Databases maintain free-space maps for efficient allocation.

---

# 12. Buffer Pool

Disk access is slow.

Frequently accessed pages are cached in RAM.

```
Disk

↓

Buffer Pool

↓

CPU
```

Instead of reading from disk every time, queries first check the buffer pool.

---

## Example

```
SELECT *

↓

Need Page 40

↓

Is page cached?

↓

Yes

↓

Return immediately
```

Cache hits dramatically reduce latency.

---

# 13. Dirty Pages

A dirty page is a modified page not yet written to disk.

```
Disk Page

↓

Loaded

↓

Modified

↓

Dirty
```

Eventually the page is flushed.

---

# 14. Page Replacement

The buffer pool has limited size.

When full:

```
Need new page

↓

Evict one page
```

Common algorithms:

- LRU
- Clock
- LRU-K
- FIFO

Clock is widely used because it approximates LRU with lower overhead.

---

# 15. Write-Ahead Logging (WAL)

A fundamental durability mechanism.

Rule:

> **The log must reach disk before the data page.**

Workflow:

```
UPDATE salary

↓

Write log record

↓

Flush WAL

↓

Modify page

↓

Flush page later
```

This guarantees recovery after crashes.

---

# 16. WAL Example

Initial value:

```
Balance = 100
```

Transaction:

```
UPDATE Balance = 150
```

WAL:

```
Before = 100

After = 150
```

If the database crashes before flushing the page:

```
Replay WAL

↓

Balance becomes 150
```

---

# 17. Log Sequence Number (LSN)

Each log record receives a unique number.

```
LSN 100

LSN 101

LSN 102

LSN 103
```

Each page stores the latest LSN applied.

Recovery compares page LSN with WAL.

---

# 18. Checkpoints

Without checkpoints:

Recovery starts from the beginning of the log.

```
10 TB WAL

↓

Hours of recovery
```

Checkpoint:

```
Flush dirty pages

↓

Record checkpoint

↓

Recovery starts here
```

Recovery becomes much faster.

---

# 19. Read Path

```
SELECT

↓

Find page ID

↓

Buffer Pool

↓

Cache Hit?

↓

Yes → Return

↓

No

↓

Read from Disk

↓

Insert into Buffer Pool

↓

Return
```

---

# 20. Write Path

```
UPDATE

↓

Find page

↓

Modify in Buffer Pool

↓

Append WAL

↓

Flush WAL

↓

Transaction Commit

↓

Background Page Flush
```

Notice that commits do **not** require immediate page writes—only WAL durability.

---

# 21. Crash Recovery Basics

Suppose:

```
Transaction committed

↓

WAL flushed

↓

Crash

↓

Page not written
```

Recovery:

```
Read WAL

↓

Redo committed changes

↓

Database restored
```

If a transaction never committed:

```
Undo changes

↓

Rollback
```

---

# 22. Monitoring Metrics

Important metrics include:

- Buffer pool hit ratio
- Dirty page count
- Page flush rate
- WAL generation rate
- WAL flush latency
- Checkpoint duration
- Disk IOPS
- Read latency
- Write latency
- Cache eviction rate
- Free page count

---

# 23. Best Practices

- Keep frequently accessed pages in memory.
- Use slotted pages for flexible record management.
- Flush WAL before data pages.
- Perform periodic checkpoints.
- Separate WAL onto fast storage.
- Batch page writes where possible.
- Monitor dirty page accumulation.
- Tune buffer pool size according to workload.

---

# 24. Summary

A database storage engine organizes data into fixed-size pages, caches them in a buffer pool, and ensures durability through Write-Ahead Logging. Slotted pages provide efficient record management, while checkpoints reduce recovery time. These mechanisms form the foundation upon which indexing, transactions, MVCC, and query execution are built.

---

**Next:** **Part 2 – Indexing**, covering:
- B+ Trees
- Clustered vs Secondary Indexes
- Hash Indexes
- LSM Trees
- SSTables
- MemTables
- Bloom Filters
- Compaction
- Index Maintenance
- Query Performance
------------------------------------------------------------------
# 24. Database Storage Engine Design (Part 2)
## Indexing, B+ Trees, LSM Trees, and Query Optimization

> This chapter covers how modern storage engines organize data for fast lookups, efficient range scans, and high write throughput.

---

# Table of Contents

1. Why Indexes?
2. Clustered vs Secondary Indexes
3. B-Tree
4. B+ Tree
5. B+ Tree Operations
6. Hash Indexes
7. Composite Indexes
8. Covering Indexes
9. LSM Trees
10. MemTable
11. WAL Integration
12. SSTables
13. Compaction
14. Bloom Filters
15. Read Path
16. Write Path
17. Choosing Between B+ Trees and LSM Trees
18. Real-world Storage Engines
19. Best Practices
20. Summary

---

# 1. Why Indexes?

Without an index, the database performs a **full table scan**.

Example:

```
Users Table

+----+--------+
| ID | Name   |
+----+--------+
| 1  | Alice  |
| 2  | Bob    |
| 3  | Carol  |
|... | ...    |
+----+--------+
```

Query:

```sql
SELECT * FROM Users WHERE ID = 3;
```

Without an index:

```
Read Row 1

↓

Read Row 2

↓

Read Row 3

↓

Found
```

Time Complexity:

```
O(n)
```

With an index:

```
Root

↓

Internal Node

↓

Leaf

↓

Found
```

Time Complexity:

```
O(log n)
```

---

# 2. Clustered vs Secondary Indexes

## Clustered Index

Data is stored **in index order**.

```
Leaf Node

↓

Actual Records
```

Example:

```
ID

1

2

3

4

5
```

Advantages:

- Fast range scans
- Fewer disk reads

Disadvantages:

- Only one clustered index per table

---

## Secondary Index

Stores pointers to records.

```
Index

↓

Record Location
```

```
Name

Alice → Page 15

Bob → Page 8

Carol → Page 22
```

Multiple secondary indexes can exist.

---

# 3. B-Tree

A B-Tree stores keys and data in every node.

Example:

```
          [40]
        /      \
   [10 20]   [50 70]
```

All nodes may contain records.

---

# 4. B+ Tree

Modern relational databases use **B+ Trees**.

Structure:

```
              [40]
          /           \
     [10 20]      [50 70]
      / |  \       / |  \
 Leaf Leaf Leaf Leaf Leaf
```

Characteristics:

- Internal nodes contain only keys.
- Leaf nodes contain records or row pointers.
- Leaves are linked.

---

Leaf linkage:

```
Leaf1 → Leaf2 → Leaf3 → Leaf4
```

This makes range scans extremely efficient.

---

# 5. Search in B+ Tree

Find key 55.

```
Root

↓

50–70

↓

Leaf

↓

55
```

Complexity:

```
O(log n)
```

---

# 6. Insert in B+ Tree

Suppose a leaf is full.

```
Before

+-------------+
|10|20|30|40|
+-------------+
```

Insert:

```
25
```

Overflow:

```
Split
```

After:

```
+--------+

10 20

+

25 30 40
```

Parent receives promoted key.

---

# 7. Delete in B+ Tree

Deletion may cause underflow.

If too few keys remain:

- Borrow from sibling
- Merge with sibling
- Update parent

Example:

```
Before

20 30

Delete 20

↓

Borrow

↓

Balanced
```

---

# 8. Range Scan

Example:

```sql
SELECT * FROM Orders
WHERE Price BETWEEN 100 AND 500;
```

B+ Tree:

```
Locate 100

↓

Walk leaf chain

↓

Stop at 500
```

No need to revisit upper levels.

---

# 9. Hash Index

Hash indexes compute:

```
Hash(Key)

↓

Bucket
```

Example:

```
Hash(100)

↓

Bucket 8
```

Advantages:

- O(1) equality lookup

Disadvantages:

- No range queries
- Poor ordering

Suitable for:

```
WHERE ID = 100
```

Not suitable for:

```
WHERE ID > 100
```

---

# 10. Composite Index

Multiple columns.

Example:

```
(Name, Age)
```

Sorted by:

```
Name

↓

Age
```

Useful for:

```sql
WHERE Name='Alice'
AND Age=30
```

---

# 11. Covering Index

Suppose:

```sql
SELECT Name
FROM Users
WHERE ID=5;
```

Index:

```
(ID, Name)
```

Everything is already inside the index.

No table lookup required.

---

# 12. LSM Tree

Log-Structured Merge Trees optimize writes.

Architecture:

```
Writes

↓

MemTable

↓

Flush

↓

SSTables

↓

Compaction
```

Used in:

- Cassandra
- RocksDB
- LevelDB
- ScyllaDB

---

# 13. MemTable

An in-memory sorted structure.

Usually implemented using:

- Skip List
- Red-Black Tree

Example:

```
10

20

40

70
```

Writes go here first.

---

# 14. WAL Before MemTable

Write sequence:

```
Insert

↓

Write WAL

↓

Insert MemTable

↓

ACK
```

Crash recovery replays the WAL.

---

# 15. SSTable

When MemTable fills:

```
Flush

↓

Immutable SSTable
```

Structure:

```
Index

↓

Blocks

↓

Data
```

SSTables are never modified.

---

# 16. Multiple SSTables

Over time:

```
SST1

SST2

SST3

SST4
```

Reads may need to check several files.

---

# 17. Compaction

Compaction merges SSTables.

Before:

```
SST1

SST2

SST3
```

After:

```
Merged SST
```

Benefits:

- Remove duplicates
- Delete tombstones
- Improve read performance

---

# 18. Bloom Filter

A Bloom Filter answers:

```
Could key exist?
```

Results:

```
Definitely No

or

Maybe Yes
```

Never returns a false negative.

May return a false positive.

Benefits:

Avoid unnecessary disk reads.

---

# 19. Read Path (LSM)

```
Query

↓

MemTable

↓

Bloom Filter

↓

SSTable Index

↓

Disk Block

↓

Record
```

---

# 20. Write Path (LSM)

```
Insert

↓

WAL

↓

MemTable

↓

Flush

↓

SSTable

↓

Background Compaction
```

---

# 21. B+ Tree vs LSM Tree

| Feature | B+ Tree | LSM Tree |
|---------|----------|-----------|
|Reads|Excellent|Good|
|Writes|Moderate|Excellent|
|Range Queries|Excellent|Good|
|Random Updates|Excellent|Requires compaction|
|Write Amplification|Low|High|
|Read Amplification|Low|Moderate|
|Space Amplification|Low|Moderate|

---

# 22. When to Use B+ Trees

Ideal for:

- Relational databases
- OLTP
- Financial systems
- ERP
- Inventory
- SQL engines

Examples:

- PostgreSQL
- MySQL InnoDB
- SQL Server
- Oracle

---

# 23. When to Use LSM Trees

Ideal for:

- High write throughput
- Time-series data
- Event logging
- IoT
- Metrics
- Distributed NoSQL

Examples:

- Cassandra
- RocksDB
- ScyllaDB
- HBase
- LevelDB

---

# 24. Query Example

Query:

```sql
SELECT *
FROM Users
WHERE Age BETWEEN 25 AND 35;
```

With B+ Tree:

```
Root

↓

Leaf 25

↓

Sequential Leaves

↓

35
```

Efficient range scan.

---

# 25. Maintenance Operations

Background tasks include:

- Split pages
- Merge pages
- Compaction
- Garbage collection
- Index rebuild
- Statistics update

These help maintain query performance over time.

---

# 26. Best Practices

- Use B+ Trees for transactional workloads.
- Use LSM Trees for write-heavy systems.
- Avoid excessive secondary indexes.
- Regularly compact LSM-based stores.
- Use Bloom Filters to reduce disk reads.
- Design composite indexes to match query patterns.
- Prefer covering indexes when possible.
- Monitor index fragmentation.

---

# 27. Summary

Indexes are the foundation of database performance. B+ Trees provide efficient point lookups and range scans, making them the dominant choice for relational databases. LSM Trees trade more complex reads and background compaction for exceptional write throughput, making them ideal for modern distributed storage systems. Understanding both structures—and when to use each—is essential for designing high-performance storage engines.

---

**Next:** **Part 3 – Transactions & Concurrency Control**, covering:
- ACID Transactions
- MVCC
- Locking (Shared, Exclusive, Intent)
- Isolation Levels
- Deadlocks
- Optimistic vs Pessimistic Concurrency
- Timestamp Ordering
- Two-Phase Locking (2PL)
- Transaction Scheduling
- Phantom Reads
- Serializable Snapshot Isolation (SSI)
------------------------------------------------------------------------
# 24. Database Storage Engine Design (Part 3)
## Transactions, Concurrency Control, and MVCC

> This chapter explains how modern database storage engines execute multiple transactions safely while maximizing concurrency and maintaining ACID guarantees.

---

# Table of Contents

1. Introduction
2. ACID Properties
3. Transaction Lifecycle
4. Transaction States
5. Concurrency Problems
6. Locking
7. Lock Granularity
8. Two-Phase Locking (2PL)
9. Deadlocks
10. Deadlock Prevention & Detection
11. Isolation Levels
12. MVCC
13. Snapshot Isolation
14. Timestamp Ordering
15. Optimistic vs Pessimistic Concurrency
16. Transaction Scheduling
17. Monitoring
18. Best Practices
19. Summary

---

# 1. Introduction

A **transaction** is a sequence of operations treated as a single logical unit of work.

Example:

```sql
BEGIN;

UPDATE Accounts
SET Balance = Balance - 100
WHERE ID = 1;

UPDATE Accounts
SET Balance = Balance + 100
WHERE ID = 2;

COMMIT;
```

Either both updates succeed, or neither does.

---

# 2. ACID Properties

## Atomicity

A transaction completes entirely or not at all.

```
Transfer Money

↓

Debit

↓

Credit

↓

Commit
```

If the system crashes after the debit but before the credit, recovery rolls back the debit.

---

## Consistency

Transactions move the database from one valid state to another.

Example:

```
Total Balance

Before = 1000

After = 1000
```

Database constraints remain valid.

---

## Isolation

Concurrent transactions should not interfere with each other.

```
T1

↓

T2

↓

Correct Result
```

---

## Durability

After commit, data survives crashes.

Achieved through:

- Write-Ahead Logging (WAL)
- Replication
- Checkpoints

---

# 3. Transaction Lifecycle

```
BEGIN

↓

Read

↓

Modify

↓

Write

↓

Commit

↓

Release Resources
```

---

# 4. Transaction States

```
Active

↓

Partially Committed

↓

Committed

↓

Terminated
```

Failure path:

```
Active

↓

Failed

↓

Rollback

↓

Terminated
```

---

# 5. Concurrency Problems

## Dirty Read

Transaction T2 reads data written by T1 before T1 commits.

```
T1

Write 500

↓

T2 Reads 500

↓

T1 Rollback
```

T2 observed invalid data.

---

## Non-Repeatable Read

```
T1 Reads Value

↓

T2 Updates

↓

T1 Reads Again
```

Different values are returned.

---

## Phantom Read

Example:

```sql
SELECT *
FROM Orders
WHERE Price > 100;
```

Another transaction inserts:

```
Price = 120
```

Repeating the query returns an extra row (a "phantom").

---

## Lost Update

```
Balance = 100
```

Transaction A:

```
+20
```

Transaction B:

```
-10
```

Without synchronization:

```
Final = 120

or

90
```

Correct answer:

```
110
```

---

# 6. Locking

Locks protect shared data.

Common lock types:

## Shared Lock (S)

Allows:

- Multiple readers

Blocks:

- Writers

```
Reader A

Reader B

✓
```

---

## Exclusive Lock (X)

Allows:

- One writer

Blocks:

- Everyone else

```
Writer

↓

Exclusive
```

---

# 7. Lock Compatibility

| Requested | Shared | Exclusive |
|------------|--------|-----------|
|Shared|✓|✗|
|Exclusive|✗|✗|

---

# 8. Lock Granularity

Locks can be placed on:

- Database
- Table
- Page
- Row

Example:

```
Database

↓

Table

↓

Page

↓

Row
```

Smaller locks improve concurrency but increase management overhead.

---

# 9. Intent Locks

Used to support hierarchical locking.

Types:

- IS (Intent Shared)
- IX (Intent Exclusive)
- SIX (Shared + Intent Exclusive)

Example:

```
Table

↓

IX

↓

Row

↓

Exclusive Lock
```

This avoids locking conflicts across different levels.

---

# 10. Two-Phase Locking (2PL)

Transactions acquire locks first, then release them.

Growing Phase:

```
Acquire

Acquire

Acquire
```

Shrinking Phase:

```
Release

Release

Release
```

No new locks may be acquired after the first release.

---

## Strict 2PL

Exclusive locks are held until commit.

Advantages:

- Prevents cascading rollbacks
- Simplifies recovery

Widely used in relational databases.

---

# 11. Deadlocks

Example:

```
T1 locks A

↓

Requests B

-----------------

T2 locks B

↓

Requests A
```

Neither transaction can proceed.

---

# 12. Deadlock Detection

The database builds a wait-for graph.

```
T1 → T2

↑     ↓

←-----
```

Cycle detected:

```
Deadlock
```

One transaction is chosen as the victim and rolled back.

---

# 13. Deadlock Prevention

Common techniques:

### Wait-Die

Older transactions wait.

Younger transactions abort.

---

### Wound-Wait

Older transactions abort younger ones.

Older transactions never wait for younger ones.

---

### Timeout

Abort transactions waiting longer than a threshold.

Simple but may abort unnecessarily.

---

# 14. Isolation Levels

## Read Uncommitted

Allows:

- Dirty reads
- Non-repeatable reads
- Phantom reads

Highest concurrency.

Lowest consistency.

---

## Read Committed

Prevents:

- Dirty reads

Allows:

- Non-repeatable reads
- Phantom reads

Used by Oracle.

---

## Repeatable Read

Prevents:

- Dirty reads
- Non-repeatable reads

May allow phantom reads depending on implementation.

Default in MySQL InnoDB.

---

## Serializable

Highest isolation.

Transactions behave as if executed sequentially.

Prevents all anomalies.

Highest overhead.

---

# 15. MVCC (Multi-Version Concurrency Control)

Instead of overwriting rows, the database creates new versions.

Example:

```
Version 1

Balance = 100

↓

Version 2

Balance = 150
```

Readers access the appropriate version based on their snapshot.

---

# 16. Row Versions

Each row stores:

```
Data

Created Txn

Deleted Txn
```

Example:

|Value|Created|Deleted|
|-----|-------|-------|
|100|T1|T3|
|150|T3|NULL|

Transactions see only versions visible to them.

---

# 17. Snapshot Isolation

At transaction start:

```
Take Snapshot

↓

Read Consistent View
```

Writers create new versions.

Readers continue using the snapshot.

Advantages:

- No reader/writer blocking
- High concurrency

---

# 18. Timestamp Ordering

Each transaction receives a timestamp.

```
T1 = 100

T2 = 101
```

Rules:

- Older transactions execute first logically.
- Conflicting younger operations may abort.

Useful for distributed databases.

---

# 19. Optimistic Concurrency Control

Assumption:

Conflicts are rare.

Workflow:

```
Read

↓

Modify

↓

Validate

↓

Commit
```

If validation fails:

```
Rollback

Retry
```

Good for low-contention workloads.

---

# 20. Pessimistic Concurrency Control

Assumption:

Conflicts are common.

Workflow:

```
Acquire Lock

↓

Modify

↓

Commit

↓

Release Lock
```

Common in OLTP systems.

---

# 21. Transaction Scheduling

Goal:

Ensure schedules are **serializable**.

Example:

```
T1 Read

↓

T2 Read

↓

T1 Write

↓

T2 Write
```

Scheduler determines whether execution is safe.

---

# 22. Read vs Write Behavior under MVCC

```
Reader

↓

Old Version

(No Lock)

------------------

Writer

↓

Creates New Version
```

Readers and writers rarely block each other.

This is a major advantage over lock-based read systems.

---

# 23. Monitoring Metrics

Track:

- Active transactions
- Lock wait time
- Deadlock count
- Rollback rate
- Commit latency
- Long-running transactions
- MVCC version count
- Snapshot age
- Lock contention
- Transaction throughput

---

# 24. Best Practices

- Keep transactions short.
- Avoid user interaction inside transactions.
- Use the lowest acceptable isolation level.
- Create indexes to reduce lock duration.
- Monitor deadlocks regularly.
- Avoid full-table locks.
- Prefer MVCC for read-heavy workloads.
- Retry aborted optimistic transactions.

---

# 25. Summary

Transactions provide atomicity, consistency, isolation, and durability. Concurrency control mechanisms such as locking, Two-Phase Locking (2PL), and MVCC ensure multiple users can safely access the database simultaneously. MVCC significantly improves read scalability by maintaining multiple row versions, while appropriate isolation levels balance correctness with performance. Understanding these mechanisms is essential for designing reliable, high-performance database systems.

---

**Next:** **Part 4 – Recovery, ARIES, Checkpointing, Compaction, Compression, Storage Optimizations, and Real-World Storage Engines**, which completes the `24_Database_Storage_Engine.md` document.
--------------------------------------------------------------------------------------
# 24. Database Storage Engine Design (Part 4)
## Recovery, Checkpointing, Compaction, Compression & Storage Optimizations

> This chapter completes the storage engine by covering crash recovery, ARIES, checkpoints, background maintenance, compression, and real-world storage engine implementations.

---

# Table of Contents

1. Crash Recovery
2. Recovery Goals
3. Write-Ahead Logging Recap
4. ARIES Recovery Algorithm
5. Analysis Phase
6. Redo Phase
7. Undo Phase
8. Checkpointing
9. Fuzzy Checkpoints
10. Background Writer
11. Dirty Page Flushing
12. Log Archiving
13. Storage Compression
14. Data Deduplication
15. Garbage Collection
16. Vacuuming
17. Fragmentation
18. Storage Optimization
19. Read & Write Amplification
20. Real-world Storage Engines
21. Monitoring
22. Best Practices
23. Interview Questions
24. Summary

---

# 1. Crash Recovery

Failures are inevitable:

- Power loss
- Kernel panic
- Process crash
- Disk failure
- Memory corruption

The storage engine must recover to a **consistent state** without losing committed transactions.

```
Transaction

↓

Commit

↓

Crash

↓

Recovery

↓

Database Restored
```

---

# 2. Recovery Goals

Recovery must guarantee:

- No committed transaction is lost
- Uncommitted changes are removed
- Data consistency
- Minimal downtime

---

# 3. Write-Ahead Logging (Recap)

Rule:

> **Always write the log before writing the modified page.**

```
Update Row

↓

Append WAL

↓

Flush WAL

↓

Modify Buffer Page

↓

Flush Page Later
```

Because the log is durable, changes can be replayed after a crash.

---

# 4. ARIES Recovery Algorithm

Most enterprise databases use **ARIES (Algorithms for Recovery and Isolation Exploiting Semantics)**.

Recovery has three phases:

```
Analysis

↓

Redo

↓

Undo
```

---

# 5. Analysis Phase

Purpose:

Determine:

- Active transactions
- Dirty pages
- Last checkpoint

Example:

```
Checkpoint

↓

T1 Active

T2 Committed

T3 Active
```

Recovery builds internal tables describing the system state at the time of failure.

---

# 6. Redo Phase

Redo reapplies committed changes that may not have reached disk.

```
Log Record

↓

Page LSN

↓

Needs Redo?

↓

Yes

↓

Apply
```

If the page already contains the change (based on the LSN), redo is skipped.

---

# 7. Undo Phase

Transactions that were active during the crash must be rolled back.

Example:

```
T5

↓

Update A

↓

Update B

↓

Crash
```

Undo restores:

```
Old A

Old B
```

The database behaves as if T5 never happened.

---

# 8. Checkpointing

Without checkpoints:

```
10 Million WAL Records

↓

Replay Everything
```

With checkpoints:

```
Checkpoint

↓

Replay Only Recent Logs
```

Recovery time becomes predictable.

---

# 9. Fuzzy Checkpoints

Modern databases avoid stopping all writes.

Instead:

```
Transactions Continue

↓

Checkpoint Records Metadata

↓

Dirty Pages Flush Gradually
```

Advantages:

- No long pause
- Better throughput
- Faster recovery

---

# 10. Background Writer

A dedicated process periodically flushes dirty pages.

```
Dirty Page

↓

Background Writer

↓

Disk
```

Benefits:

- Smaller recovery window
- Stable latency
- Prevents bursty writes

---

# 11. Dirty Page Flushing

Flushing policies include:

### Periodic

Every few seconds.

---

### Threshold-Based

Flush when dirty pages exceed a limit.

---

### LRU-Based

Flush least recently used dirty pages.

---

# 12. Log Archiving

Old WAL files can be archived.

```
Current WAL

↓

Archive Storage

↓

Disaster Recovery
```

Uses:

- Point-in-time recovery (PITR)
- Replication
- Auditing

---

# 13. Point-in-Time Recovery (PITR)

Restore the database to an exact moment.

Workflow:

```
Backup

↓

Replay WAL Until

10:42:15 AM

↓

Stop
```

Common in PostgreSQL and Oracle.

---

# 14. Compression

Compression reduces storage requirements.

Common algorithms:

- LZ4
- Snappy
- Zstandard (Zstd)
- Gzip

Trade-off:

| Benefit | Cost |
|----------|------|
|Lower disk usage|Higher CPU usage|
|More cache efficiency|Compression latency|

---

# 15. Dictionary Compression

Repeated values are stored once.

Example:

```
California

California

California
```

Becomes:

```
Dictionary

1 → California

Rows

1

1

1
```

Very effective for analytical workloads.

---

# 16. Prefix Compression

Keys with common prefixes share storage.

Instead of:

```
customer_1001

customer_1002

customer_1003
```

Store:

```
customer_

1001

1002

1003
```

Frequently used in B+ Tree indexes.

---

# 17. Data Deduplication

Duplicate blocks are stored once.

Example:

```
Backup A

↓

Same Block

↓

Backup B
```

Storage:

```
One Physical Copy

↓

Reference Count = 2
```

Useful for:

- Backups
- Snapshots
- Virtual machines

---

# 18. Garbage Collection

MVCC creates obsolete row versions.

```
Version 1

↓

Version 2

↓

Version 3
```

Old versions must eventually be removed.

Garbage collection frees space without affecting active transactions.

---

# 19. Vacuuming

PostgreSQL uses **VACUUM** to:

- Remove dead tuples
- Reclaim space
- Update statistics
- Prevent transaction ID wraparound

```
Dead Rows

↓

VACUUM

↓

Reusable Space
```

---

# 20. Fragmentation

Over time:

- Deletes
- Updates
- Page splits

cause fragmentation.

Example:

```
Page

Row

Free

Row

Free

Row
```

Fragmentation reduces cache efficiency and increases disk I/O.

Solutions:

- Online rebuild
- Defragmentation
- Compaction

---

# 21. Read Amplification

One logical read may require multiple physical reads.

Example (LSM Tree):

```
Query

↓

MemTable

↓

SSTable 1

↓

SSTable 2

↓

SSTable 3
```

Compaction reduces read amplification.

---

# 22. Write Amplification

A single logical write may be written multiple times.

Example:

```
MemTable

↓

SSTable

↓

Compaction

↓

Merged SSTable
```

Storage engines balance write amplification against read performance.

---

# 23. Space Amplification

Extra storage consumed beyond user data.

Sources:

- Replication
- WAL
- Old MVCC versions
- Compaction
- Snapshots

Monitoring space amplification is essential for capacity planning.

---

# 24. Background Maintenance Tasks

Typical background workers:

- Checkpointer
- WAL Archiver
- Vacuum
- Compaction Worker
- Statistics Collector
- Index Rebuilder
- Garbage Collector

These tasks run asynchronously to minimize user-facing latency.

---

# 25. Real-World Storage Engines

## PostgreSQL

Features:

- MVCC
- WAL
- B+ Tree indexes
- VACUUM
- TOAST for large values
- Point-in-Time Recovery

Best for:

- General-purpose OLTP
- Complex SQL

---

## MySQL InnoDB

Features:

- Clustered indexes
- MVCC
- Undo logs
- Redo logs
- Adaptive hash index
- Doublewrite buffer

Best for:

- Transactional systems
- Web applications

---

## RocksDB

Features:

- LSM Tree
- MemTable
- SSTables
- Bloom Filters
- Background compaction
- High write throughput

Best for:

- Embedded databases
- Key-value stores

---

## LevelDB

Features:

- LSM Tree
- WAL
- Compaction
- Ordered key-value storage

Best for:

- Embedded storage

---

## WiredTiger (MongoDB)

Features:

- Document storage
- Compression
- MVCC
- Checkpointing
- Cache management

Best for:

- Document databases

---

# 26. Monitoring Metrics

Critical metrics include:

### Storage

- Disk utilization
- Free space
- Compression ratio
- WAL size

### Performance

- Read latency
- Write latency
- IOPS
- Throughput

### Memory

- Buffer pool hit ratio
- Cache eviction rate

### Recovery

- Checkpoint duration
- Recovery time
- WAL generation rate

### Concurrency

- Lock waits
- Deadlocks
- Active transactions

---

# 27. Best Practices

- Place WAL on low-latency storage.
- Size the buffer pool appropriately.
- Schedule regular checkpoints.
- Enable compression where beneficial.
- Monitor write amplification in LSM-based engines.
- Vacuum or compact regularly.
- Keep transactions short.
- Archive WAL files for disaster recovery.
- Monitor index fragmentation.
- Test crash recovery procedures periodically.

---

# 28. Common Interview Questions

### Q1. Why is WAL necessary?

To ensure durability by guaranteeing that committed changes can be replayed even if data pages were never written to disk.

---

### Q2. Why are checkpoints important?

They reduce recovery time by limiting how much of the WAL must be replayed after a crash.

---

### Q3. Difference between Undo and Redo?

| Undo | Redo |
|------|------|
|Removes uncommitted changes|Reapplies committed changes|
|Restores old values|Restores new values|

---

### Q4. Why does MVCC require garbage collection?

Because old row versions remain after updates and deletes until they are no longer visible to active transactions.

---

### Q5. Why do LSM Trees suffer write amplification?

Because data is rewritten during flushes and background compaction.

---

# 29. Summary

A modern database storage engine combines durable logging, efficient page management, indexing, concurrency control, and crash recovery to provide reliable, high-performance data storage. Techniques such as Write-Ahead Logging, ARIES recovery, checkpoints, MVCC, background maintenance, and compression enable databases like PostgreSQL, MySQL InnoDB, RocksDB, and WiredTiger to support demanding transactional and analytical workloads while maintaining correctness and scalability.

---

# Complete Chapter Recap

The **Database Storage Engine** chapter covered:

1. **Storage Fundamentals**
   - Pages
   - Records
   - Buffer Pool
   - WAL
   - Slotted Pages
   - Heap Files

2. **Indexing**
   - B+ Trees
   - Hash Indexes
   - LSM Trees
   - SSTables
   - Bloom Filters
   - Compaction

3. **Transactions & Concurrency**
   - ACID
   - MVCC
   - Locking
   - Isolation Levels
   - Deadlocks
   - Two-Phase Locking

4. **Recovery & Optimization**
   - ARIES
   - Checkpointing
   - Compression
   - Vacuuming
   - Garbage Collection
   - Real-world Storage Engines

Together, these concepts form the foundation of how modern relational and NoSQL databases reliably store, retrieve, and protect data at scale.
