# Chapter 15 – Ethernet Switching ASICs & Hardware Packet Pipeline
**Senior C/C++ Linux Networking Handbook**

> **Goal**
>
> This chapter explains **what actually happens inside an Ethernet switch** after a packet enters a port.
>
> This is one of the highest-value topics for **Arista, Cisco, Juniper, NVIDIA, Broadcom**, and other networking companies.

---

# Big Picture

Most engineers know

```
Packet

↓

Switch

↓

Destination
```

Interviewers want to know

> **What happens inside the switch?**

---

# Complete Packet Pipeline

```
Incoming Packet

↓

Physical Port (PHY)

↓

MAC Processing

↓

Parser

↓

VLAN Lookup

↓

ACL Lookup

↓

L2 Lookup

↓

L3 Lookup (if needed)

↓

QoS Processing

↓

Buffer

↓

Scheduler

↓

Output Port

↓

Wire
```

This entire process usually takes only **a few microseconds**.

---

# What is a Switch ASIC?

ASIC =

```
Application Specific
Integrated Circuit
```

Unlike a CPU,

an ASIC is designed for **one purpose**.

Example

CPU

```
Runs Everything
```

ASIC

```
Processes Network Packets
```

---

# Why ASIC Instead of CPU?

Imagine

```
100 Gbps

Incoming Traffic
```

A CPU cannot inspect every packet at line rate.

ASICs are designed to

- Process packets in hardware
- Perform lookups in parallel
- Maintain deterministic latency

---

# Typical Switch Architecture

```
            +----------------+
Incoming -->|  Switch ASIC   |--> Outgoing
Ports        +----------------+
      │
      │
      ▼
 Packet Buffer

      │
      ▼
 CAM / TCAM

      │
      ▼
 Scheduler
```

---

# Physical Layer (PHY)

The PHY receives electrical or optical signals.

```
Cable

↓

PHY

↓

Bits
```

Responsibilities

- Signal decoding
- Clock recovery
- Error detection

---

# MAC Processing

Ethernet frame

```
Destination MAC

Source MAC

EtherType

Payload

CRC
```

The ASIC first validates

- Frame format
- CRC
- Length

---

# Parser

The parser identifies packet headers.

Example

```
Ethernet

↓

IPv4

↓

TCP

↓

HTTP
```

It extracts important fields like

- MAC
- VLAN ID
- IP
- TCP Port

---

# VLAN Lookup

The switch determines

```
Which VLAN?

↓

Forwarding Rules
```

Example

```
Port 5

↓

VLAN 20
```

---

# MAC Learning

Every switch learns

```
Source MAC

↓

Incoming Port
```

Example

```
AA:BB:CC

↓

Port 8
```

The switch stores

```
MAC

↓

Port Mapping
```

---

# CAM Table

CAM

```
Content Addressable Memory
```

Stores

```
MAC Address

↓

Output Port
```

Example

| MAC | Port |
|------|------|
| A | 1 |
| B | 5 |
| C | 9 |

Unlike normal memory,

CAM searches all entries simultaneously.

This makes lookups extremely fast.

---

# Why CAM is Fast

Normal memory

```
Address

↓

Data
```

CAM

```
Data

↓

Address
```

Example

Search

```
AA:BB:CC
```

CAM immediately returns

```
Port 8
```

---

# Unknown Destination MAC

Suppose

```
Destination MAC

Not Found
```

The switch performs

```
Flooding
```

```
Incoming Port

↓

All Ports

Except Source
```

Once the destination replies,

the MAC address is learned.

---

# TCAM

TCAM

```
Ternary CAM
```

Supports

```
0

1

Don't Care (X)
```

Example

```
1100XXXX
```

Matches

```
11000000

11001111

11001010
```

---

# Why TCAM?

Used for

- ACLs
- Routing
- QoS
- Policy Matching

Unlike CAM,

TCAM supports wildcard matching.

---

# CAM vs TCAM

| CAM | TCAM |
|------|------|
| Exact Match | Wildcard Match |
| MAC Table | ACL |
| Faster | More Flexible |
| Lower Cost | Expensive |

Interview Favorite

> **Why is TCAM expensive?**

Because every lookup compares against many entries simultaneously and each bit stores three states (0, 1, don't care), requiring more complex hardware and consuming more power.

---

# L2 Switching

Destination MAC found

↓

Forward Packet

Example

```
MAC

↓

CAM Lookup

↓

Port 6
```

---

# L3 Routing

If the packet needs routing

```
IP Lookup

↓

Longest Prefix Match

↓

Next Hop

↓

Rewrite MAC

↓

Forward
```

Modern Layer-3 switches perform routing in hardware.

---

# ACL Processing

Packet reaches ACL stage.

Example

```
Source IP

↓

Permit?

↓

Yes

↓

Forward

----------------

No

↓

Drop
```

ACL lookups typically use TCAM.

---

# QoS Classification

Traffic is classified.

Example

```
Voice

↓

High Priority

----------------

Video

↓

Medium

----------------

File Download

↓

Low
```

---

# Packet Buffer

Sometimes

```
Outgoing Port

Busy
```

Packet waits inside

```
Buffer
```

---

# Why Buffers?

Suppose

```
100 Gbps

↓

10 Gbps
```

Incoming traffic is faster than outgoing.

Packets must wait.

---

# Buffer Overflow

When the buffer is full,

```
New Packet

↓

Dropped
```

This causes

- Packet loss
- TCP retransmissions
- Lower throughput

---

# Shared Buffer vs Dedicated Buffer

Dedicated

```
Port1

Own Buffer

Port2

Own Buffer
```

Shared

```
Common Buffer Pool

↓

All Ports Share
```

Shared buffers usually provide better utilization but require careful management.

---

# Head-of-Line (HOL) Blocking

Imagine

```
Packet A

Waiting

↓

Packet B

Ready

↓

Packet C

Ready
```

If A blocks the queue,

B and C cannot move.

This is

```
Head-of-Line Blocking
```

---

# VOQ (Virtual Output Queue)

Solution

Instead of one queue,

maintain

```
Queue → Port1

Queue → Port2

Queue → Port3
```

Packets destined for different output ports no longer block each other.

---

# Store-and-Forward Switching

Switch receives

```
Entire Packet

↓

CRC Check

↓

Forward
```

Advantages

- Error detection
- Reliable forwarding

Disadvantage

- Slightly higher latency

---

# Cut-Through Switching

Switch starts forwarding

```
After Reading Destination MAC
```

It does **not** wait for the full frame.

Advantages

- Extremely low latency

Disadvantage

- Corrupted frames may be forwarded because the full CRC has not yet been verified.

---

# Fragment-Free Switching

Compromise

```
Receive First 64 Bytes

↓

Forward
```

Historically used to reduce forwarding of collision fragments on shared Ethernet.

---

# Comparison

| Method | Latency | CRC Verified Before Forwarding |
|---------|---------|-------------------------------|
| Store-and-Forward | Higher | Yes |
| Cut-Through | Lowest | No |
| Fragment-Free | Medium | Partial Frame Only |

---

# Scheduler

Multiple output queues exist.

Scheduler decides

```
Who Goes First?
```

Algorithms

- Strict Priority
- Weighted Round Robin (WRR)
- Deficit Round Robin (DRR)

---

# Strict Priority

```
Voice

↓

First

----------------

Video

↓

Second

----------------

Best Effort

↓

Last
```

Very low latency for high-priority traffic.

---

# Weighted Round Robin (WRR)

Example

```
Voice

40%

Video

40%

Best Effort

20%
```

Provides fairness while honoring priorities.

---

# Packet Drop Policies

When buffers fill,

the switch may

```
Drop Packet
```

Methods

- Tail Drop
- RED (Random Early Detection)
- WRED (Weighted RED)

Purpose

Reduce congestion before buffers become completely full.

---

# Line Rate

Interview Favorite.

Question

> What does **line-rate forwarding** mean?

Answer

The switch can process and forward traffic at the full speed of every interface **without dropping packets due to insufficient forwarding capacity** under supported conditions.

Example

```
48 × 100 Gbps

↓

Forward All Simultaneously
```

---

# End-to-End ASIC Pipeline

```
Packet

↓

PHY

↓

MAC Validation

↓

Parser

↓

VLAN

↓

ACL (TCAM)

↓

L2 CAM Lookup

↓

L3 Lookup

↓

QoS

↓

Buffer

↓

Scheduler

↓

Output Port
```

Memorize this flow.

---

# Common Interview Questions

## Q1 Why do switches use ASICs instead of CPUs?

ASICs are specialized hardware that can process packets at very high throughput with predictable latency.

---

## Q2 Difference between CAM and TCAM?

CAM performs exact-match lookups (for example, MAC addresses).

TCAM supports wildcard matching and is commonly used for ACLs and routing.

---

## Q3 Why is TCAM expensive?

It requires more complex circuitry, stores three logic states per bit, consumes more power, and occupies more silicon area than CAM.

---

## Q4 Why are packet buffers required?

To temporarily absorb bursts of traffic when packets cannot be transmitted immediately.

---

## Q5 Difference between Store-and-Forward and Cut-Through?

Store-and-Forward waits for the complete frame and verifies the CRC.

Cut-Through begins forwarding after reading enough header information, minimizing latency.

---

## Q6 What is Head-of-Line Blocking?

Packets behind a blocked packet cannot proceed even if their output ports are free.

---

## Q7 What is VOQ?

Virtual Output Queues maintain separate queues for each output destination to reduce Head-of-Line Blocking.

---

## Q8 What is line-rate forwarding?

Forwarding packets at the maximum speed supported by the interfaces without becoming the bottleneck.

---

# Common Mistakes

❌ Thinking switches use CPUs for every packet.

✔ Modern switches use ASICs for the data plane. CPUs are mainly used for the control plane and management tasks.

---

❌ Thinking CAM stores routing tables.

✔ CAM primarily stores MAC address entries. Routing lookups are typically implemented using specialized hardware structures that support longest-prefix matching, often involving TCAM.

---

❌ Assuming Cut-Through always performs CRC verification before forwarding.

✔ It begins forwarding before the entire frame is received.

---

❌ Thinking bigger buffers are always better.

✔ Larger buffers can help absorb bursts but may also increase latency. Buffer design depends on the workload.

---

# Quick Revision

```
Packet

↓

PHY

↓

Parser

↓

VLAN

↓

CAM

↓

TCAM

↓

QoS

↓

Buffer

↓

Scheduler

↓

Output Port
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| ASIC | Hardware Packet Processing |
| CAM | Exact Match (MAC Table) |
| TCAM | Wildcard Match (ACL, Routing) |
| Parser | Extract Headers |
| Buffer | Temporary Packet Storage |
| HOL Blocking | Queue Blocking Problem |
| VOQ | One Queue Per Output |
| Store-and-Forward | Full Frame + CRC |
| Cut-Through | Lowest Latency |
| WRR | Fair Scheduling |
| RED/WRED | Congestion Avoidance |
| Line Rate | Full-Speed Forwarding |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Switch ASIC architecture
- Hardware packet pipeline
- CAM vs TCAM
- MAC learning and forwarding
- VLAN and ACL processing
- Hardware routing
- QoS classification
- Buffer management
- HOL Blocking and VOQ
- Store-and-Forward vs Cut-Through
- Scheduling algorithms
- Line-rate forwarding

---

**Next Chapter:** **Data Center Networking (Spine-Leaf, VXLAN, EVPN, BGP, MLAG, Anycast Gateway)** — the networking architecture used in modern cloud data centers and a core topic for Arista interviews.