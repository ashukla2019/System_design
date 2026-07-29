# Chapter 17 – Linux Kernel Networking Source Walkthrough
**Senior C/C++ Linux Networking Handbook**

> **Goal**
>
> Previous chapters explained the Linux networking stack conceptually.
>
> This chapter explains **how a packet actually flows through the Linux kernel source code**.
>
> This is one of the most valuable chapters for **Arista, NVIDIA, Cisco, Juniper, Broadcom**, and Linux kernel interviews.

---

# Why Learn Kernel Functions?

Most candidates say

```
NIC

↓

TCP

↓

Socket

↓

Application
```

Senior interviewers ask

> "Which kernel functions process the packet?"

Knowing these functions demonstrates a much deeper understanding of Linux networking.

---

# Big Picture

## Receive Path

```
Wire

↓

NIC

↓

Driver

↓

NAPI

↓

netif_receive_skb()

↓

ip_rcv()

↓

ip_local_deliver()

↓

tcp_v4_rcv()

↓

tcp_recvmsg()

↓

recv()

↓

Application
```

---

## Transmit Path

```
Application

↓

send()

↓

tcp_sendmsg()

↓

ip_queue_xmit()

↓

dev_queue_xmit()

↓

NIC Driver

↓

Wire
```

---

# Receive Packet Flow

Suppose a TCP packet arrives.

```
Ethernet Frame

↓

NIC

↓

DMA

↓

Driver

↓

NAPI

↓

Linux Networking Stack
```

---

# Step 1 – NIC Receives Packet

Hardware receives

```
Ethernet Frame
```

The NIC performs

- DMA
- Checksum offload (if enabled)
- RSS queue selection

---

# Step 2 – Driver Polls Packets

Instead of processing every interrupt,

Linux uses

```
NAPI
```

Simplified flow

```
Interrupt

↓

Disable Interrupt

↓

Poll Multiple Packets

↓

Enable Interrupt
```

The driver's `poll()` function retrieves packets from the NIC.

---

# Step 3 – Build sk_buff

The driver allocates or prepares

```
struct sk_buff
```

The packet is now represented as an skb.

```
Packet

↓

sk_buff
```

Almost every networking function receives an skb.

---

# Step 4 – netif_receive_skb()

One of the most important functions.

```
Driver

↓

netif_receive_skb()
```

Purpose

- Entry point into the Linux networking stack
- Dispatch packet to the appropriate protocol

Think of it as

```
Network Stack Entry
```

---

# Step 5 – Ethernet Processing

Linux examines

```
EtherType
```

Example

```
0x0800

↓

IPv4

---------------

0x86DD

↓

IPv6

---------------

0x0806

↓

ARP
```

The next protocol handler is selected accordingly.

---

# Step 6 – ip_rcv()

If the packet is IPv4,

Linux calls

```
ip_rcv()
```

Responsibilities

- Validate IPv4 header
- Verify checksum (depending on offload)
- Process TTL
- Routing decision
- Pass to Netfilter hooks

---

# Step 7 – Netfilter

Packets traverse Netfilter hooks.

```
PREROUTING

↓

Routing Decision

↓

INPUT

↓

Local Process
```

Firewall rules may

- Accept
- Drop
- Modify

the packet.

---

# Step 8 – ip_local_deliver()

If the destination IP belongs to this machine,

```
ip_local_deliver()
```

is invoked.

Otherwise,

the packet may be forwarded to another interface.

---

# Step 9 – TCP Processing

TCP packets reach

```
tcp_v4_rcv()
```

Responsibilities

- Validate TCP header
- Sequence number checks
- ACK processing
- Window updates
- Retransmission logic
- Socket lookup

---

# Socket Lookup

The kernel identifies the correct socket using information such as

```
Source IP

Destination IP

Source Port

Destination Port

Protocol
```

This combination uniquely identifies a TCP connection.

---

# Step 10 – Queue Packet

The packet is placed into the socket's receive queue.

```
Socket

↓

Receive Queue

↓

Waiting Process
```

---

# Step 11 – recv()

Application calls

```c
recv()
```

Kernel copies data

```
Kernel Buffer

↓

User Buffer
```

Application receives the data.

---

# Receive Flow Summary

```
NIC

↓

Driver

↓

NAPI

↓

sk_buff

↓

netif_receive_skb()

↓

ip_rcv()

↓

Netfilter

↓

ip_local_deliver()

↓

tcp_v4_rcv()

↓

Socket Queue

↓

recv()

↓

Application
```

Memorize this diagram.

---

# Transmit Packet Flow

Application wants to send data.

```
send()

↓

Kernel

↓

NIC

↓

Wire
```

---

# Step 1 – send()

Application calls

```c
send()
```

The kernel copies user-space data into the socket send buffer.

---

# Step 2 – tcp_sendmsg()

TCP prepares the packet.

Responsibilities

- Segment data if necessary
- Assign sequence numbers
- Update TCP state

---

# Step 3 – ip_queue_xmit()

IP layer

- Builds IPv4 header
- Determines next hop
- Chooses output interface

---

# Step 4 – Routing Lookup

Kernel performs

```
Longest Prefix Match
```

to determine

- Outgoing interface
- Next hop

---

# Step 5 – Neighbor Lookup (ARP)

Kernel checks

```
ARP Cache
```

If MAC address exists

↓

Continue

Otherwise

↓

Send ARP Request

↓

Wait for ARP Reply

---

# Step 6 – dev_queue_xmit()

Packet enters the network device layer.

Responsibilities

- Queue packet
- Apply traffic control (if configured)
- Hand packet to driver

---

# Step 7 – Driver

Driver

- Maps packet for DMA
- Notifies NIC
- Frees resources after transmission

---

# Step 8 – NIC

NIC transmits

```
Ethernet Frame

↓

Wire
```

Transmission complete.

---

# Transmit Flow Summary

```
Application

↓

send()

↓

tcp_sendmsg()

↓

ip_queue_xmit()

↓

Route Lookup

↓

ARP

↓

dev_queue_xmit()

↓

Driver

↓

DMA

↓

NIC

↓

Wire
```

---

# Socket Buffers

Each TCP socket contains

```
Send Queue

Receive Queue
```

```
Application

↓

Send Queue

↓

TCP

↓

Network

↓

Receive Queue

↓

Application
```

---

# Where Does epoll() Fit?

```
Packet Arrives

↓

Receive Queue

↓

epoll Notified

↓

Application Wakes Up

↓

recv()
```

The kernel notifies the application only when data is ready.

---

# Where Does XDP Fit?

XDP executes **before** the normal networking stack.

```
NIC

↓

XDP

↓

Drop

or

↓

Pass

↓

Driver

↓

Linux Networking Stack
```

---

# Where Does DPDK Fit?

DPDK bypasses most of the kernel networking stack.

```
Application

↓

DPDK

↓

NIC
```

Kernel TCP/IP processing is not used.

---

# Common Kernel Structures

| Structure | Purpose |
|-----------|----------|
| sk_buff | Represents a packet |
| socket | Socket object |
| sock | Protocol-specific socket state |
| net_device | Network interface |
| napi_struct | NAPI polling context |
| dst_entry | Routing information |

You don't need to memorize every field—understand their roles.

---

# Common Interview Questions

## Q1 What is `netif_receive_skb()`?

The primary entry point for received packets into the Linux networking stack.

---

## Q2 What is `ip_rcv()`?

Processes incoming IPv4 packets before they are delivered locally or forwarded.

---

## Q3 What does `tcp_v4_rcv()` do?

Processes incoming TCP packets, validates them, updates TCP state, and finds the correct socket.

---

## Q4 What is `dev_queue_xmit()`?

Queues an outgoing packet and passes it toward the network device driver.

---

## Q5 Why is `sk_buff` important?

It is the core packet representation used throughout the Linux networking stack.

---

## Q6 Where is routing performed?

During the IP transmit path after the IP header is prepared and before the packet is handed to the network device layer.

---

## Q7 Where does ARP occur?

Before transmission if the destination MAC address is unknown.

---

## Q8 Where does Netfilter run?

At specific hook points within the networking stack, such as PREROUTING, INPUT, OUTPUT, FORWARD, and POSTROUTING.

---

# Common Mistakes

❌ Thinking the NIC sends packets directly to TCP.

✔ Packets pass through the driver, NAPI, Ethernet, IP, and transport layers.

---

❌ Thinking `recv()` reads directly from the NIC.

✔ It copies data already queued in the socket receive buffer.

---

❌ Thinking `send()` immediately transmits data.

✔ `send()` places data into the kernel's send buffer; actual transmission is handled asynchronously by the networking stack.

---

❌ Thinking XDP executes after IP processing.

✔ XDP runs before the conventional Linux networking stack.

---

# Complete Receive Path

```
Wire

↓

NIC

↓

DMA

↓

Driver

↓

NAPI

↓

sk_buff

↓

netif_receive_skb()

↓

Ethernet

↓

ip_rcv()

↓

Netfilter

↓

ip_local_deliver()

↓

tcp_v4_rcv()

↓

Socket Queue

↓

recv()

↓

Application
```

---

# Complete Transmit Path

```
Application

↓

send()

↓

tcp_sendmsg()

↓

ip_queue_xmit()

↓

Routing

↓

ARP

↓

dev_queue_xmit()

↓

Driver

↓

DMA

↓

NIC

↓

Wire
```

---

# Interview Cheat Sheet

| Function | Purpose |
|----------|----------|
| `netif_receive_skb()` | Enter Linux Networking Stack |
| `ip_rcv()` | IPv4 Processing |
| `ip_local_deliver()` | Deliver to Local Host |
| `tcp_v4_rcv()` | TCP Receive Processing |
| `tcp_sendmsg()` | TCP Transmit Processing |
| `ip_queue_xmit()` | Build IP Packet & Route |
| `dev_queue_xmit()` | Queue Packet to Device |
| `recv()` | Copy Data to User Space |
| `send()` | Copy Data from User Space |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Complete Linux kernel receive path
- Complete Linux kernel transmit path
- Important kernel networking functions
- `sk_buff`
- Socket queues
- Driver interaction
- NAPI integration
- Where Netfilter fits
- Where XDP fits
- Where DPDK differs

---

## Next Chapter

**Chapter 18 – Advanced Network Programming**

Topics include:

- `epoll` Edge Triggered vs Level Triggered
- `io_uring`
- Zero-copy (`sendfile()`, `splice()`, `mmap()`)
- `SO_REUSEADDR` vs `SO_REUSEPORT`
- `TCP_NODELAY`
- `TCP_CORK`
- `SO_KEEPALIVE`
- High-performance server architecture
- Reactor vs Proactor patterns
- Thread pools and connection scaling