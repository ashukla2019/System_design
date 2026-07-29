# Chapter 18 – Advanced Network Programming
**Senior C/C++ Linux Networking Handbook**

> **Goal**
>
> This chapter covers the advanced Linux network programming concepts that are commonly asked in senior interviews at **Arista, NVIDIA, Cisco, Juniper, Broadcom, Qualcomm**, and other systems companies.
>
> The emphasis is on **building scalable, high-performance network servers**.

---

# Big Picture

A high-performance server follows this architecture:

```
                Clients
                   │
                   │
              TCP Connections
                   │
                   ▼
              Listening Socket
                   │
                   ▼
                 epoll
                   │
        ┌──────────┴──────────┐
        │                     │
        ▼                     ▼
   Worker Thread 1      Worker Thread 2
        │                     │
        └──────────┬──────────┘
                   ▼
            Business Logic
                   │
                   ▼
          Database / Storage
```

---

# Why Traditional Servers Don't Scale

Simple server

```
accept()

↓

recv()

↓

process()

↓

send()

↓

repeat
```

Problem

One client blocks everyone else.

---

# Multi-threaded Server

```
Main Thread

↓

accept()

↓

Thread1

Thread2

Thread3
```

Advantages

- Easy to implement

Problems

- Context switching
- High memory usage
- Lock contention

---

# Thread Pool

Instead of creating a thread per client,

```
Clients

↓

Task Queue

↓

Worker Threads
```

Advantages

- Fixed number of threads
- Better CPU utilization
- Less overhead

---

# Blocking Socket

```
recv()

↓

No Data

↓

Thread Sleeps
```

Simple but inefficient for thousands of connections.

---

# Non-blocking Socket

```
recv()

↓

No Data

↓

Return EAGAIN
```

Thread continues doing other work.

---

# I/O Multiplexing

Monitor many sockets with one thread.

```
Socket1

Socket2

Socket3

↓

epoll()

↓

Ready Socket
```

---

# select()

Oldest mechanism.

```
FD Set

↓

select()

↓

Ready FD
```

Limitations

- Small FD limit (`FD_SETSIZE`)
- Scans entire set every call

Time complexity

```
O(n)
```

---

# poll()

Improvement over `select()`.

Advantages

- No fixed FD limit

Still scans all file descriptors.

```
O(n)
```

---

# epoll()

Interview Favorite.

Linux-specific scalable event notification.

```
Register Socket

↓

Kernel Waits

↓

Only Ready Sockets Returned
```

Time complexity (typical)

```
O(ready)
```

Much more efficient for large numbers of idle connections.

---

# epoll Workflow

```
epoll_create()

↓

epoll_ctl()

↓

epoll_wait()

↓

recv()/send()
```

Know this sequence.

---

# Level Triggered (LT)

Default mode.

```
Data Available

↓

epoll()

↓

Application Reads Partial Data

↓

More Data Left

↓

epoll() Again
```

Kernel continues notifying while unread data remains.

---

# Edge Triggered (ET)

Notification only when the state changes.

```
Data Arrives

↓

epoll()

↓

Read Everything

↓

No More Events
```

Must read until

```
EAGAIN
```

Otherwise data may remain unread without another notification.

---

# LT vs ET

| Level Triggered | Edge Triggered |
|-----------------|----------------|
| Easier | Faster |
| Repeated Notifications | One Notification Per State Change |
| Simpler Logic | Must Drain Socket |
| More System Calls | Fewer System Calls |

---

# Reactor Pattern

Most common interview topic.

```
epoll_wait()

↓

Event

↓

Callback

↓

Business Logic
```

The application reacts to readiness events.

Examples

- NGINX
- Redis
- HAProxy

---

# Proactor Pattern

Operation is started first.

```
Async Read

↓

Kernel Completes

↓

Completion Event

↓

Application
```

Common in Windows IOCP.

Linux `io_uring` supports a similar completion-based model.

---

# Reactor vs Proactor

| Reactor | Proactor |
|----------|-----------|
| Wait for Ready | Wait for Completion |
| Application Performs I/O | Kernel/Subsystem Performs I/O |
| epoll | io_uring (completion model) |

---

# io_uring

Modern Linux asynchronous I/O interface.

```
Application

↓

Submission Queue

↓

Kernel

↓

Completion Queue

↓

Application
```

Benefits

- Lower overhead
- Fewer system calls
- High throughput
- Better scalability

---

# Zero-Copy

Traditional copy

```
Disk

↓

Kernel

↓

User

↓

Kernel

↓

NIC
```

Multiple copies.

---

# Zero-Copy

```
Disk

↓

Kernel

↓

NIC
```

Avoids unnecessary copying between kernel and user space.

Benefits

- Lower CPU usage
- Higher throughput
- Lower latency

---

# sendfile()

Interview Favorite.

```
File

↓

sendfile()

↓

Socket
```

Data remains in kernel space.

Useful for

- Web servers
- Static file serving

---

# splice()

Moves data between file descriptors without copying into user space.

Example

```
Pipe

↓

splice()

↓

Socket
```

---

# mmap()

Maps a file into virtual memory.

```
File

↓

Memory Mapping

↓

Application
```

Useful for

- Large files
- Shared memory
- Fast file access

---

# Socket Options

Interviewers frequently ask these.

---

# SO_REUSEADDR

Allows reuse of a local address after a socket closes.

Useful when restarting servers that previously used the same port.

---

# SO_REUSEPORT

Allows multiple sockets to bind to the same port.

Benefits

- Better multicore scaling
- Load distribution across worker processes

---

# SO_KEEPALIVE

Detects dead TCP peers.

```
Idle

↓

Keepalive Probe

↓

No Response

↓

Connection Closed
```

---

# TCP_NODELAY

Disables Nagle's algorithm.

```
Small Packet

↓

Send Immediately
```

Advantages

- Lower latency

Disadvantage

- More packets

---

# Nagle's Algorithm

Instead of sending every tiny packet,

```
Small Writes

↓

Combine

↓

Larger Packet
```

Improves bandwidth efficiency.

---

# TCP_CORK

Opposite optimization strategy.

Kernel delays transmission until enough data is accumulated or the cork is removed.

Useful when constructing large responses.

---

# Connection Lifecycle

```
socket()

↓

bind()

↓

listen()

↓

accept()

↓

epoll()

↓

recv()

↓

process()

↓

send()

↓

close()
```

Know this order.

---

# High-Performance Server Architecture

```
Clients

↓

Load Balancer

↓

epoll Thread

↓

Task Queue

↓

Worker Pool

↓

Database
```

Common production design.

---

# One Thread Per Core

Modern servers often use

```
Core 0 → Worker

Core 1 → Worker

Core 2 → Worker

Core 3 → Worker
```

Each worker has its own event loop.

---

# Common Interview Questions

## Q1 Why is `epoll()` faster than `select()`?

`epoll()` reports only ready file descriptors instead of scanning every registered descriptor on each call.

---

## Q2 Difference between LT and ET?

LT repeatedly notifies while data remains.

ET notifies only when readiness changes.

---

## Q3 Why use non-blocking sockets?

To avoid blocking threads while waiting for I/O.

---

## Q4 What is Zero-Copy?

A technique that minimizes unnecessary copying of data between kernel space and user space.

---

## Q5 What does `sendfile()` do?

Transfers file data directly from the kernel to a socket without copying through user space.

---

## Q6 Difference between `SO_REUSEADDR` and `SO_REUSEPORT`?

`SO_REUSEADDR` allows reuse of a recently used local address in common restart scenarios.

`SO_REUSEPORT` allows multiple sockets to bind the same port simultaneously for improved scalability.

---

## Q7 Why disable Nagle using `TCP_NODELAY`?

For latency-sensitive applications where small packets should be transmitted immediately.

---

## Q8 What is `io_uring`?

A modern Linux interface for high-performance asynchronous I/O using submission and completion queues.

---

## Q9 Reactor vs Proactor?

Reactor waits for readiness notifications.

Proactor waits for operation completion.

---

## Q10 Why use a thread pool?

To reduce thread creation overhead and improve scalability.

---

# Common Mistakes

❌ Assuming more threads always improve performance.

✔ Excessive threads increase context switches and synchronization overhead.

---

❌ Forgetting to read until `EAGAIN` in Edge Triggered mode.

✔ ET applications should continue reading until the socket would block.

---

❌ Thinking `TCP_NODELAY` always improves performance.

✔ It reduces latency but may increase packet overhead.

---

❌ Thinking `sendfile()` works for every scenario.

✔ It is ideal for file-to-socket transfers, not arbitrary in-memory data processing.

---

# Quick Revision

```
Blocking

↓

Non-blocking

↓

select()

↓

poll()

↓

epoll()

↓

LT

↓

ET

↓

Thread Pool

↓

Reactor

↓

Proactor

↓

io_uring

↓

Zero Copy

↓

sendfile()

↓

splice()

↓

mmap()

↓

SO_REUSEADDR

↓

SO_REUSEPORT

↓

TCP_NODELAY

↓

SO_KEEPALIVE
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Blocking Socket | Thread Waits |
| Non-blocking Socket | Returns Immediately |
| select() | O(n), FD Limit |
| poll() | O(n), No FD Limit |
| epoll() | Scalable Event Notification |
| LT | Repeated Notifications |
| ET | Read Until EAGAIN |
| Thread Pool | Fixed Workers |
| Reactor | Readiness Events |
| Proactor | Completion Events |
| io_uring | Async I/O |
| Zero-Copy | Fewer Data Copies |
| sendfile() | File → Socket |
| splice() | FD → FD Transfer |
| mmap() | File Mapping |
| SO_REUSEADDR | Fast Restart |
| SO_REUSEPORT | Multi-core Scaling |
| TCP_NODELAY | Disable Nagle |
| SO_KEEPALIVE | Detect Dead Connections |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Blocking vs non-blocking sockets
- select(), poll(), and epoll()
- LT vs ET
- Reactor vs Proactor
- io_uring
- Thread pools
- Zero-copy techniques
- sendfile(), splice(), mmap()
- Common socket options
- High-performance server design

---

## Next Chapter

**Chapter 19 – Ultimate Arista Interview Revision & 150+ Questions**

This final chapter combines:

- Top networking interview questions
- Linux kernel questions
- C/C++ networking questions
- Debugging scenarios
- Packet-flow explanations
- Whiteboard design problems
- 30-minute and 10-minute revision guides
- Most common mistakes made by senior candidates
- Arista-specific interview tips