# 07. Read Write Lock

## 1. Problem Statement

In system design, multiple threads, processes, or services often access shared data structures concurrently.

Examples:

- Metadata service managing file information
- Database index handling queries
- Cache storing frequently accessed objects
- Storage engine managing in-memory pages

Most production workloads are read-heavy:

```
90% Read Operations
10% Write Operations
```

A normal mutex allows only one operation at a time:

```
Reader 1 → Lock → Read → Unlock
Reader 2 → Lock → Read → Unlock
Reader 3 → Lock → Read → Unlock
```

This creates unnecessary blocking because multiple readers can safely access the same data.

A Read Write Lock improves concurrency by allowing:

- Multiple readers simultaneously
- Only one writer exclusively

---

# 2. Read Write Lock Concept

A Read Write Lock has two modes.

## Read Lock

Used when a thread only reads shared data.

Multiple readers can execute together.

Example:

```
              Shared Data

Reader A  ─────┐
Reader B  ─────┼── Read Lock
Reader C  ─────┘
```

Readers do not modify the data, so concurrent access is safe.

---

## Write Lock

Used when data needs modification.

Only one writer can execute.

Example:

```
              Shared Data

Writer A ─────── Write Lock

Readers blocked
Other writers blocked
```

A writer requires exclusive access to maintain consistency.

---

# 3. Why RWLock Is Important in System Design

RWLocks are common in high-performance systems.

Examples:

## Metadata Service

A distributed file system may have:

```
Client
  |
  |
Metadata Server
  |
  +── File information
  +── Directory tree
  +── Permissions
```

Read operations:

```
getFileMetadata()
listDirectory()
checkPermission()
```

Write operations:

```
createFile()
deleteFile()
renameFile()
```

Since reads are much more frequent, RWLock improves throughput.

---

# 4. RWLock Internal State

A basic RWLock maintains:

```
RWLock

+----------------+
| readers = 10   |
| writer = false |
| waiting = 2    |
+----------------+
```

Internal variables:

```
readers_count
writer_active
waiting_writers
mutex
condition_variable
```

---

# 5. Read Lock Algorithm

When a reader arrives:

```
Acquire mutex

If writer_active:
    wait

Else:
    readers_count++

Release mutex
```

Multiple readers can execute:

```
Reader 1
Reader 2
Reader 3

       |
       v

 Shared Data
```

After reading:

```
Acquire mutex

readers_count--

If readers_count == 0:
    notify writers

Release mutex
```

---

# 6. Write Lock Algorithm

When a writer arrives:

```
Acquire mutex

waiting_writers++

Wait until:

readers_count == 0
AND
writer_active == false

writer_active = true

Release mutex
```

After writing:

```
Acquire mutex

writer_active = false

Notify waiting threads

Release mutex
```

---

# 7. Reader Preference

Reader preference gives priority to readers.

Example:

```
Reader
Reader
Reader
Writer
Reader
Reader
```

Advantages:

- Maximum read throughput
- Good for read-heavy workloads

Problem:

## Writer Starvation

Continuous readers may prevent writers from executing.

Example:

```
Readers keep arriving:

R1
R2
R3
R4
R5

Writer waits forever
```

---

# 8. Writer Preference

Writer preference gives priority to writers.

Example:

```
Readers active

Writer arrives

New readers blocked

Writer executes

Readers continue
```

Advantages:

- Prevents writer starvation

Disadvantages:

- Readers may experience higher latency

---

# 9. Fair RWLock

Production systems often use fair scheduling.

Requests execute based on arrival order.

Example:

```
Request Queue:

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
```

Benefits:

- Prevents starvation
- Predictable latency

---

# 10. Lock Granularity

A major system design decision is choosing lock scope.

## Coarse-Grained Lock

One lock protects a large structure.

Example:

```
Database

     RWLock

        |
        |
    Entire Index
```

Advantages:

- Simple implementation
- Easy correctness

Disadvantages:

- Lower concurrency

---

## Fine-Grained Lock

Multiple smaller locks protect different parts.

Example:

```
B+ Tree

Node A → Lock A

Node B → Lock B

Node C → Lock C
```

Advantages:

- Higher parallelism

Disadvantages:

- More complexity
- Higher deadlock risk

---

# 11. RWLock Usage in Storage Systems

## B+ Tree

Read operation:

```
Search Key

Acquire Read Lock

Traverse Nodes

Return Result
```

Multiple searches can execute together.

Write operation:

```
Insert Key

Acquire Write Lock

Split Node

Update Parent
```

---

## Key Value Store

Read:

```
GET user:100

Read Lock

Return Value
```

Write:

```
PUT user:100

Write Lock

Update Value
```

---

## Cache System

Example:

```
Cache Entry

{
 key,
 value,
 expiry
}
```

Many requests read cache entries.

Updates require exclusive access.

---

# 12. RWLock vs Mutex

| Feature | Mutex | RWLock |
|---|---|---|
| Readers | One | Multiple |
| Writers | One | One |
| Complexity | Simple | Higher |
| Read-heavy workload | Poor | Good |
| Write-heavy workload | Good | Similar |

---

# 13. RWLock vs Lock-Free Design

RWLock:

```
Thread waits

Acquire lock

Execute
```

Lock-free:

```
Thread retries

No blocking
```

RWLock:

- Easier correctness
- Suitable for complex structures

Lock-free:

- Higher performance potential
- More difficult implementation

---

# 14. Common Problems

## Deadlock

Example:

```
Thread A:

Read Lock A
Waiting for Write Lock B


Thread B:

Read Lock B
Waiting for Write Lock A
```

Solutions:

- Define lock ordering
- Avoid nested locks
- Use timeout mechanisms

---

## Lock Upgrade Problem

Scenario:

```
Reader holds Read Lock

Needs Write Lock
```

Two readers upgrading can deadlock:

```
Reader A → waiting for Write Lock

Reader B → waiting for Write Lock
```

Neither releases the read lock.

---

# 15. When To Use RWLock

Use RWLock when:

- Reads dominate writes
- Shared data is expensive to copy
- Data consistency is required

Avoid RWLock when:

- Writes are frequent
- Critical sections are very small
- Lock contention is already high

---

# 16. Real System Examples

RWLocks are used in:

- Database buffer managers
- File system metadata
- Storage engine indexes
- Cache systems
- Configuration management systems

---

# 17. Interview Questions

## Q1. Why use RWLock instead of Mutex?

Because multiple readers can execute concurrently, improving throughput for read-heavy workloads.

---

## Q2. How does writer starvation happen?

Continuous readers keep acquiring the read lock, preventing writers from obtaining exclusive access.

---

## Q3. How do you design a fair RWLock?

Maintain a waiting queue and process requests based on arrival order.

---

## Q4. Where would you use RWLock in a distributed storage system?

Examples:

- Metadata service
- B+ tree index
- Cache metadata
- Namespace management

---

# Summary

A Read Write Lock is a synchronization primitive used in high-performance systems where many operations read shared data.

Key properties:

- Multiple readers allowed
- Single writer allowed
- Writers get exclusive access
- Fairness policy controls latency and throughput

RWLocks are important building blocks for databases, storage engines, caches, and distributed file systems.
