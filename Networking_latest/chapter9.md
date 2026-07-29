# Chapter 9 – Linux Networking Internals
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** This is one of the most important chapters for Arista, Cisco, NVIDIA, Broadcom, Qualcomm, and Linux kernel/system software interviews. Interviewers expect you to understand **how a packet travels inside Linux**, not just how TCP/IP works.

---

# Big Picture

When an application sends data:

```
Application

↓

Socket API

↓

TCP / UDP

↓

IP

↓

ARP

↓

Ethernet

↓

NIC Driver

↓

NIC (Network Card)

↓

Wire
```

When receiving data:

```
Wire

↓

NIC

↓

NIC Driver

↓

NAPI

↓

Ethernet

↓

IP

↓

TCP / UDP

↓

Socket Buffer

↓

Application
```

---

# Linux Networking Stack

```
+---------------------------+
| User Application          |
+---------------------------+
| Socket API                |
+---------------------------+
| TCP / UDP                |
+---------------------------+
| IPv4 / IPv6              |
+---------------------------+
| ARP                      |
+---------------------------+
| Ethernet                 |
+---------------------------+
| NIC Driver               |
+---------------------------+
| Hardware (NIC)           |
+---------------------------+
```

Everything below the Socket API runs inside the Linux kernel.

---

# Socket

A socket is the interface between an application and the kernel networking stack.

Think of it as:

```
Application

↓

Socket

↓

Network
```

Applications never directly manipulate Ethernet frames.

They use sockets.

---

# Socket Types

## TCP Socket

```
SOCK_STREAM
```

Reliable communication.

Examples

- HTTPS
- SSH
- Database

---

## UDP Socket

```
SOCK_DGRAM
```

Fast communication.

Examples

- DNS
- DHCP
- Video Streaming

---

# Socket Lifecycle (Server)

```
socket()

↓

bind()

↓

listen()

↓

accept()

↓

send()

↓

recv()

↓

close()
```

Know this sequence by heart.

---

# socket()

Creates a socket.

```c
socket(AF_INET, SOCK_STREAM, 0);
```

Arguments

```
AF_INET

IPv4

SOCK_STREAM

TCP

Protocol

0 (default)
```

Returns

```
File Descriptor
```

---

# bind()

Associates a socket with an IP address and port.

Example

```
192.168.1.20

Port 8080
```

Without bind(),

the kernel chooses an ephemeral port automatically (typical for client sockets).

---

# listen()

Marks the socket as a passive (server) socket.

```
Client

↓

Server waits
```

The server starts accepting connection requests.

---

# accept()

Accepts one incoming TCP connection.

Important

`accept()` returns a **new socket descriptor**.

The listening socket remains open for future clients.

```
Listening Socket

↓

accept()

↓

Connected Socket
```

This is a favorite interview question.

---

# connect()

Client initiates the TCP three-way handshake.

```
Client

↓

connect()

↓

SYN

↓

Server
```

Usually blocks until the connection succeeds or fails.

---

# send()

Copies data from user space into the kernel's socket send buffer.

```
Application

↓

send()

↓

Socket Buffer

↓

TCP
```

The call returning does **not** necessarily mean the peer has received the data.

---

# recv()

Copies received data from the kernel's socket receive buffer into user space.

```
NIC

↓

Kernel Buffer

↓

recv()

↓

Application
```

---

# Socket Buffers

Every TCP socket has buffers.

```
Application

↓

Send Buffer

↓

TCP

↓

Network

↓

Receive Buffer

↓

Application
```

Benefits

- Smooth communication
- Better performance
- Flow control

---

# Blocking Socket

Default behavior.

```
recv()

↓

Wait

↓

Packet Arrives

↓

Return
```

The thread sleeps until data becomes available.

---

# Non-Blocking Socket

```
recv()

↓

No Data

↓

Immediately Returns
```

Useful for

- High-performance servers
- Event-driven applications

---

# select()

Old I/O multiplexing API.

Can monitor multiple file descriptors.

```
Socket1

Socket2

Socket3

↓

select()

↓

Ready Socket
```

Limitation

Performance decreases with many sockets because it scans the descriptor set.

---

# poll()

Improvement over select().

Removes descriptor number limits.

Still scans every descriptor.

---

# epoll()

One of the most important Linux interview topics.

Used by

- Nginx
- HAProxy
- Redis
- Many high-performance servers

Instead of scanning every socket,

the kernel tells your application **which sockets are ready**.

```
Thousands of Sockets

↓

epoll_wait()

↓

Ready Sockets Only
```

Benefits

- Scales to very large numbers of connections
- Low CPU usage
- Event-driven

---

# Why epoll is Faster

```
select()

↓

Checks Every Socket

-------------------------

epoll()

↓

Returns Only Ready Sockets
```

Time complexity (simplified)

```
select()

O(n)

epoll()

Approximately O(number of ready events)
```

---

# sk_buff (Socket Buffer)

One of the most important Linux networking structures.

Almost every packet inside the Linux kernel is represented by an

```
struct sk_buff
```

```
Packet

↓

sk_buff

↓

Linux Networking Stack
```

It contains

- Packet data
- Headers
- Metadata
- Interface information
- Protocol information

---

# Network Interface Card (NIC)

The NIC is responsible for

- Sending frames
- Receiving frames
- DMA transfers
- Interrupt generation
- Checksum offload (if supported)

---

# DMA (Direct Memory Access)

Without DMA

```
NIC

↓

CPU

↓

Memory
```

CPU copies every byte.

With DMA

```
NIC

↓

Memory
```

CPU involvement is greatly reduced.

DMA improves throughput and lowers CPU utilization.

---

# Interrupts

When a packet arrives,

the NIC generates an interrupt.

```
Packet

↓

NIC

↓

Interrupt

↓

Kernel
```

Too many interrupts can overload the CPU under heavy traffic.

---

# NAPI (New API)

Modern Linux avoids interrupt storms.

Flow

```
Packet Arrives

↓

Interrupt

↓

Interrupt Disabled

↓

Kernel Polls NIC

↓

Process Multiple Packets

↓

Interrupt Enabled Again
```

Benefits

- Higher throughput
- Lower interrupt overhead
- Better scalability

---

# Packet Receive Flow

```
Wire

↓

NIC

↓

DMA

↓

NIC Driver

↓

NAPI

↓

sk_buff

↓

Ethernet

↓

IP

↓

TCP

↓

Socket Buffer

↓

recv()

↓

Application
```

Know this diagram well—it is frequently discussed in networking interviews.

---

# Packet Transmit Flow

```
Application

↓

send()

↓

Socket Buffer

↓

TCP

↓

IP

↓

ARP

↓

Ethernet

↓

NIC Driver

↓

DMA

↓

NIC

↓

Wire
```

---

# Common Interview Questions

## Q1 What is a socket?

A socket is the interface between an application and the Linux networking stack.

---

## Q2 Why does `accept()` return a new socket?

The listening socket continues accepting future clients, while the new socket is dedicated to the established connection.

---

## Q3 Difference between `bind()` and `connect()`?

`bind()` associates a local IP address and port with a socket.

`connect()` establishes a connection to a remote endpoint.

---

## Q4 Why is `epoll()` faster than `select()`?

Because `epoll()` reports only sockets with ready events instead of scanning all sockets.

---

## Q5 What is `sk_buff`?

The primary kernel data structure representing a network packet inside the Linux networking stack.

---

## Q6 Why is DMA important?

It allows the NIC to transfer packet data directly to memory with minimal CPU involvement.

---

## Q7 Why is NAPI needed?

To reduce interrupt overhead under heavy network load by switching from interrupt-driven processing to polling.

---

## Q8 Does `send()` guarantee that the receiver has received the data?

No.

It only indicates that the kernel has accepted the data into the socket send buffer (subject to the socket's semantics).

---

## Q9 Which system calls are used for TCP servers?

```
socket()

↓

bind()

↓

listen()

↓

accept()

↓

send()/recv()

↓

close()
```

---

# Common Mistakes

❌ Thinking `send()` means the data has reached the remote application.

✔ It usually means the kernel accepted the data for transmission.

---

❌ Thinking `accept()` creates another listening socket.

✔ It creates a new connected socket.

---

❌ Thinking `epoll()` is a networking protocol.

✔ It is a Linux I/O event notification mechanism.

---

❌ Thinking `sk_buff` exists only for TCP.

✔ It is used throughout the Linux networking stack for many protocols.

---

# Quick Revision

```
Application

↓

Socket

↓

send()/recv()

↓

TCP / UDP

↓

IP

↓

ARP

↓

Ethernet

↓

NIC Driver

↓

DMA

↓

NIC

↓

Wire

↓

Interrupt

↓

NAPI

↓

sk_buff

↓

Application
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Socket | Application ↔ Kernel Interface |
| socket() | Create Socket |
| bind() | Assign Local IP & Port |
| listen() | Server Waits |
| accept() | Returns New Connected Socket |
| connect() | Client Starts Connection |
| send()/recv() | Data Transfer |
| select() | Older Multiplexing |
| poll() | Improved select() |
| epoll() | High-performance Event API |
| sk_buff | Kernel Packet Structure |
| DMA | NIC → Memory |
| NAPI | Polling Under High Load |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Linux networking stack
- Socket API
- TCP server lifecycle
- Blocking vs non-blocking sockets
- `select()`, `poll()`, and `epoll()`
- Socket buffers
- `sk_buff`
- DMA
- NIC drivers
- Interrupt handling
- NAPI
- Complete packet transmit and receive paths

---

**Next Chapter:** **Network Debugging & Packet Analysis** – `tcpdump`, Wireshark, `ss`, `ip`, `netstat`, `ping`, `traceroute`, `mtr`, common packet captures, and real interview debugging scenarios.