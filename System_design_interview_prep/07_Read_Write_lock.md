07. Read Write Lock
1. Problem Statement

In large-scale systems, shared data is accessed by many concurrent operations.

Examples:

Metadata service handling file lookups.
Database index serving queries.
Cache storing frequently accessed objects.
Storage engine managing in-memory structures.

Most workloads are read-heavy:

90% Reads
10% Writes


A normal mutex allows only one operation at a time:

Reader 1 → Lock → Read → Unlock
Reader 2 → Lock → Read → Unlock
Reader 3 → Lock → Read → Unlock


This creates unnecessary blocking because readers do not modify data.

A Read Write Lock improves concurrency by separating:

Read operations
Write operations
2. Core Idea

A Read Write Lock provides two types of access:

Read Lock

Allows multiple readers simultaneously.

Example:

              Shared Data

Reader A  ─────┐
Reader B  ─────┼── Read Lock
Reader C  ─────┘


All readers see a consistent state.

Write Lock

Allows only one writer.

Example:

              Shared Data

Writer A ─────── Write Lock

Readers blocked
Other writers blocked


A writer requires exclusive access because it changes the shared state.

3. Why System Design Uses RWLocks

RWLocks appear in many infrastructure components.

Metadata Service

Example:

Distributed File System:

Client
  |
  |
Metadata Server
  |
  +── File information
  +── Directory tree
  +── Permissions


Operations:

Read:

getFileMetadata()
listDirectory()
checkPermission()


Write:

createFile()
deleteFile()
renameFile()


Most requests are reads, so RWLock improves throughput.

4. RWLock Internal Design

A simple RWLock maintains:

RWLock

+----------------+
| readers = 10   |
| writer = false |
| waiting = 2    |
+----------------+


State:

readers_count
writer_active
waiting_writers
mutex
condition_variable

5. Read Operation Flow

When a reader arrives:

Acquire lock

If writer is active:
    wait

Else:
    readers++

Release lock


Multiple readers can execute:

Reader 1
Reader 2
Reader 3

        |
        v

    Shared Data


After reading:

Acquire lock

readers--

If no readers:
    wake writers

Release lock

6. Write Operation Flow

When a writer arrives:

Acquire lock

waiting_writers++

Wait until:

readers == 0
AND
writer_active == false

writer_active = true

Release lock


After writing:

Acquire lock

writer_active = false

Notify waiting threads

Release lock

7. Reader Preference Design

In reader preference:

Reader
Reader
Reader
Writer
Reader
Reader


Readers always get priority.

Advantage:

High read throughput.

Problem:

Writer Starvation

A continuous stream of readers can prevent writers from executing.

Example:

Readers keep arriving

R1
R2
R3
R4
R5

Writer waiting forever

8. Writer Preference Design

Writer preference gives priority to writers.

Example:

Readers active

Writer arrives

New readers blocked

Writer executes

Readers continue


Advantage:

Prevents writer starvation.

Disadvantage:

Reduces read throughput.
9. Fair RWLock

A production system usually needs fairness.

Requests are handled in order:

Request Queue

R1
R2
W1
R3
W2


Execution:

R1 + R2
W1
R3
W2


Benefits:

No starvation.
Predictable latency.
10. Lock Granularity

A major system design decision is:

Coarse-Grained Lock

One lock protects everything.

Example:

Database

       RWLock

          |
          |
    Entire Index


Advantages:

Simple.
Easy correctness.

Disadvantages:

Low concurrency.
Fine-Grained Lock

Multiple smaller locks.

Example:

Database Index

Node A → Lock A

Node B → Lock B

Node C → Lock C


Advantages:

Higher parallelism.

Disadvantages:

More complexity.
Deadlock risk.
11. RWLock in Storage Systems
B+ Tree

During search:

Root Node
   |
Read Lock
   |
Traverse children


Multiple searches can happen simultaneously.

During split:

Node Full

Acquire Write Lock

Split Node

Update Parent

Key Value Store

Example:

GET user:100

Read Lock

Return Value

PUT user:100

Write Lock

Update Data

Cache System

Example:

Cache Entry

{
 key,
 value,
 expiry
}


Many requests read cache entries.

Updates require exclusive access.

12. RWLock vs Mutex
Feature	Mutex	RWLock
Readers	One	Many
Writers	One	One
Implementation	Simple	Complex
Read-heavy workload	Poor	Good
Write-heavy workload	Better	Often similar
13. RWLock vs Lock-Free Design

RWLock:

Thread waits

Acquire lock

Execute


Lock-free:

Thread retries

No blocking


RWLock:

Easier correctness.
Better for complex structures.

Lock-free:

Higher performance.
More difficult implementation.
14. Common Problems
Deadlock

Example:

Thread A:
Read Lock A
Waiting for Write Lock B


Thread B:
Read Lock B
Waiting for Write Lock A


Solution:

Lock ordering.
Timeout.
Avoid lock upgrades.
Lock Upgrade Problem

Scenario:

Reader holds Read Lock

Needs Write Lock


Two readers upgrading can deadlock:

Reader A → waiting for Write
Reader B → waiting for Write


Neither releases the read lock.

15. Design Considerations

When designing a system:

Choose RWLock when:

Reads dominate writes.
Shared state is expensive to copy.
Data consistency is required.

Avoid RWLock when:

Operations are extremely short.
Writes are frequent.
Lock contention is already high.
16. Real System Examples

RWLocks are used in:

Database buffer managers.
File system metadata.
Storage engine indexes.
Cache systems.
Configuration management systems.
17. Interview Questions
Q1. Why use RWLock instead of Mutex?

Because multiple readers can execute concurrently, improving throughput for read-heavy workloads.

Q2. How does writer starvation happen?

Continuous readers keep acquiring the read lock, preventing writers from obtaining exclusive access.

Q3. How would you design a fair RWLock?

Maintain a waiting queue and process lock requests in order.

Q4. Where would you use RWLock in a distributed storage system?

Examples:

Metadata service.
B+ tree index.
Cache metadata.
Namespace management.
Summary

A Read Write Lock is a concurrency primitive used in high-performance systems where many operations only read shared data.

Key properties:

Multiple readers allowed.
Single writer allowed.
Writers get exclusive access.
Fairness policy affects latency and throughput.

RWLocks are fundamental components in databases, storage engines, caches, and distributed file systems.