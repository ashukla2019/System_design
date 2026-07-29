# Chapter 10 – Linux Kernel Networking Internals (Interview Gold)
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** This chapter covers the Linux kernel networking concepts that distinguish senior engineers in interviews at **Arista, Cisco, NVIDIA, Broadcom, Juniper, Qualcomm**, and other networking companies.

> **Interview Tip**
>
> If you can confidently explain the packet path from the NIC to the application and discuss NAPI, SoftIRQ, Netfilter, XDP, and DPDK, you'll stand out in senior networking interviews.

---

# Complete Linux Packet Receive Path

This is one of the most important diagrams in networking interviews.

```
                    USER SPACE
+---------------------------------------------+
|                 Application                 |
+---------------------------------------------+
                ▲
                │ recv()
                │
+---------------------------------------------+
|               Socket Buffer                 |
+---------------------------------------------+

================ Kernel =======================

                ▲
                │
+---------------------------------------------+
|              TCP / UDP Layer                |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|                IP Layer                     |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|          Netfilter Hooks (iptables)         |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|              Ethernet Layer                 |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|                sk_buff                      |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|                NAPI                         |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|             NIC Driver                      |
+---------------------------------------------+
                ▲
+---------------------------------------------+
|              Network Card                   |
+---------------------------------------------+
                ▲
               Wire
```

Know this flow thoroughly.

---

# SoftIRQ

One of the most frequently asked Linux networking questions.

When a packet arrives:

```
Packet

↓

NIC Interrupt

↓

Interrupt Handler

↓

SoftIRQ

↓

Network Processing
```

---

## Why SoftIRQ?

Interrupt handlers should execute quickly.

Instead of processing packets inside the interrupt,

Linux schedules

```
NET_RX_SOFTIRQ
```

Advantages

- Better performance
- Lower interrupt latency
- Higher throughput

---

# Hard Interrupt vs SoftIRQ

| Hard Interrupt | SoftIRQ |
|---------------|----------|
| Very Short | Can Process More Work |
| Cannot Sleep | Runs Later |
| Triggered by Hardware | Triggered by Kernel |

Interview Tip

Most packet processing happens in **SoftIRQ**, not in the interrupt handler.

---

# Netfilter

Netfilter is Linux's packet filtering framework.

Almost every packet passes through it.

```
Packet

↓

Netfilter

↓

Accept

Drop

Modify
```

Used by

- Firewall
- NAT
- Packet Filtering
- Connection Tracking

---

# Netfilter Hooks

Packets pass through several hook points.

```
Packet

↓

PREROUTING

↓

INPUT

↓

FORWARD

↓

OUTPUT

↓

POSTROUTING
```

---

# Meaning of Each Hook

## PREROUTING

Packet has arrived.

Routing decision not yet made.

Common use

- DNAT

---

## INPUT

Packet is for this machine.

```
SSH

HTTP Server

Database
```

---

## FORWARD

Packet is passing through the machine.

Example

Linux Router

---

## OUTPUT

Packet created locally.

Example

```
ping

curl

wget
```

---

## POSTROUTING

Packet about to leave.

Common use

- SNAT
- MASQUERADE

---

# Connection Tracking (conntrack)

Linux remembers active connections.

Example

```
Client

↓

Server

↓

Reply
```

Linux knows

```
Reply belongs to existing connection.
```

Required for

- Stateful Firewall
- NAT
- Load Balancing

---

# XDP (eXpress Data Path)

Extremely important for Arista.

Normal packet flow

```
NIC

↓

Driver

↓

Kernel

↓

TCP/IP
```

With XDP

```
NIC

↓

XDP Program

↓

Drop

Forward

Redirect

Pass
```

Packet is processed **before** entering the networking stack.

Benefits

- Very low latency
- Very high throughput
- DDoS protection
- Packet filtering

---

# eBPF

XDP uses eBPF.

eBPF allows safe programs to execute inside the Linux kernel.

Applications

- Networking
- Tracing
- Security
- Monitoring
- Performance Analysis

Interview Definition

> eBPF allows custom programs to run safely inside the kernel without modifying kernel source code.

---

# DPDK

Another favorite interview topic.

Normally

```
Application

↓

Kernel

↓

NIC
```

DPDK

```
Application

↓

NIC
```

Kernel networking stack is bypassed.

Benefits

- Millions of packets/sec
- Very low latency
- User-space packet processing

Used in

- High-frequency trading
- Routers
- Firewalls
- Virtual switches

---

# XDP vs DPDK

| XDP | DPDK |
|------|------|
| Inside Kernel | User Space |
| Uses eBPF | Poll Mode Driver |
| Keeps Kernel Stack | Bypasses Kernel Stack |
| Easy Integration | Maximum Performance |

---

# RSS (Receive Side Scaling)

Modern NICs have multiple receive queues.

Without RSS

```
CPU0

Processes Everything
```

With RSS

```
Queue0 → CPU0

Queue1 → CPU1

Queue2 → CPU2

Queue3 → CPU3
```

Benefits

- Better CPU utilization
- Higher throughput
- Parallel processing

---

# RPS (Receive Packet Steering)

Implemented in software.

If hardware RSS is unavailable,

Linux distributes packets across CPUs.

---

# RFS (Receive Flow Steering)

Improves CPU cache locality.

Packets belonging to the same application are processed on the CPU where that application is running.

Benefits

- Better cache efficiency
- Lower latency

---

# GRO (Generic Receive Offload)

Suppose 20 TCP packets arrive.

Without GRO

```
20 Packets

↓

Kernel
```

With GRO

```
20 Packets

↓

Merged

↓

1 Large Packet
```

Benefits

- Fewer packets processed
- Lower CPU usage

---

# GSO (Generic Segmentation Offload)

Application sends

```
64 KB
```

Kernel postpones segmentation until later.

Benefits

- Less CPU overhead

---

# TSO (TCP Segmentation Offload)

NIC performs segmentation.

Instead of CPU splitting packets,

NIC hardware does it.

Benefits

- Lower CPU utilization
- Higher throughput

---

# LRO (Large Receive Offload)

NIC merges received packets before handing them to the kernel.

Very similar to GRO,

but implemented in hardware.

---

# Checksum Offloading

NIC computes TCP/IP checksums.

Without Offload

```
CPU

Computes Checksum
```

With Offload

```
NIC

Computes Checksum
```

CPU load decreases.

---

# Packet Transmission Flow

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

Netfilter OUTPUT

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

# Packet Receive Flow

```
Wire

↓

NIC

↓

DMA

↓

RSS

↓

NAPI

↓

SoftIRQ

↓

sk_buff

↓

Netfilter PREROUTING

↓

IP

↓

TCP

↓

Socket

↓

recv()

↓

Application
```

---

# Common Interview Questions

## Q1 Why is NAPI better than interrupts alone?

NAPI switches to polling during heavy traffic, reducing interrupt overhead and improving throughput.

---

## Q2 What is SoftIRQ?

Deferred kernel work that performs most packet processing outside the hard interrupt context.

---

## Q3 What is Netfilter?

Linux packet filtering framework used for firewalls, NAT, and connection tracking.

---

## Q4 Difference between XDP and DPDK?

XDP processes packets early inside the kernel using eBPF.

DPDK bypasses the kernel networking stack and processes packets entirely in user space.

---

## Q5 Why do we need RSS?

To distribute incoming packets across multiple CPU cores.

---

## Q6 What is GRO?

Merges multiple received packets to reduce CPU overhead.

---

## Q7 Why is checksum offloading useful?

It lets the NIC compute checksums, reducing CPU work.

---

## Q8 What is conntrack?

A kernel subsystem that tracks active network connections for stateful filtering and NAT.

---

# Common Mistakes

❌ Thinking interrupts process every packet completely.

✔ Interrupts are brief; most packet processing happens later via NAPI and SoftIRQ.

---

❌ Thinking DPDK is faster because it uses TCP.

✔ DPDK is faster because it bypasses the kernel networking stack.

---

❌ Thinking XDP replaces TCP/IP.

✔ XDP runs before the normal networking stack and can pass packets into it or handle them differently.

---

❌ Confusing GRO and GSO.

✔ GRO merges received packets.

✔ GSO delays segmentation of outgoing packets.

---

# Quick Revision

```
NIC

↓

DMA

↓

RSS

↓

Interrupt

↓

NAPI

↓

SoftIRQ

↓

sk_buff

↓

Netfilter

↓

IP

↓

TCP

↓

Socket

↓

Application

---------------------

Advanced

XDP

eBPF

DPDK

GRO

GSO

TSO

RPS

RFS

RSS
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| SoftIRQ | Deferred Packet Processing |
| NAPI | Polling Under Load |
| Netfilter | Firewall/NAT Framework |
| conntrack | Connection Tracking |
| XDP | Early Kernel Packet Processing |
| eBPF | Safe Programs in Kernel |
| DPDK | User-space Packet Processing |
| RSS | Hardware Multi-Queue |
| RPS | Software Packet Steering |
| RFS | Flow-to-CPU Steering |
| GRO | Merge Incoming Packets |
| GSO | Delay Outgoing Segmentation |
| TSO | NIC Segmentation |
| Checksum Offload | NIC Calculates Checksums |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Complete Linux packet receive/transmit path
- Hard Interrupt vs SoftIRQ
- NAPI
- Netfilter and its hooks
- Connection Tracking (conntrack)
- XDP and eBPF
- DPDK
- RSS, RPS, RFS
- GRO, GSO, TSO, LRO
- Checksum Offloading

---

**Next Chapter:** **Network Debugging & Packet Analysis** – `tcpdump`, Wireshark, `ss`, `ip`, `ping`, `traceroute`, packet capture analysis, TCP troubleshooting, and real interview debugging scenarios.