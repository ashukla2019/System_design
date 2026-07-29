# Chapter 5 – IPv4 & IPv6
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand how IP enables communication across different networks. This chapter covers only the interview-important concepts for senior networking and systems roles.

---

# Why Do We Need IP?

MAC addresses work only inside a local network.

Example:

```
Laptop A
192.168.1.10

      │
   Switch
      │
Router
      │
Internet
      │
Google Server
142.250.xxx.xxx
```

A switch cannot deliver packets to another network.

We need **IP (Internet Protocol)**.

IP provides:

- Logical Addressing
- Routing
- Network-to-Network Communication

---

# IPv4 Address

Example

```
192.168.1.10
```

IPv4 consists of

```
32 bits

4 Bytes

4 Octets
```

Example

```
192 .168 .1 .10
```

Each number ranges from

```
0 - 255
```

---

# Public vs Private IP

## Private IP

Used inside organizations.

Ranges:

```
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

These are **not routable** on the Internet.

---

## Public IP

Assigned by ISPs.

Example

```
142.250.xxx.xxx
```

Public IPs are globally unique.

---

# IPv4 Header

Interviewers don't expect every field, but you should know the important ones.

```
+-----------------------------------+
| Version                           |
+-----------------------------------+
| Header Length                     |
+-----------------------------------+
| Total Length                      |
+-----------------------------------+
| Identification                    |
+-----------------------------------+
| Flags                             |
+-----------------------------------+
| Fragment Offset                   |
+-----------------------------------+
| TTL                               |
+-----------------------------------+
| Protocol                          |
+-----------------------------------+
| Header Checksum                   |
+-----------------------------------+
| Source IP                         |
+-----------------------------------+
| Destination IP                    |
+-----------------------------------+
```

Important fields:

| Field | Purpose |
|--------|----------|
| Source IP | Sender |
| Destination IP | Receiver |
| TTL | Prevent loops |
| Protocol | TCP, UDP, ICMP |
| Total Length | Packet size |

---

# TTL (Time To Live)

Very common interview question.

Suppose a routing loop exists.

```
Router A

↓

Router B

↓

Router C

↓

Router A
```

Without TTL,

The packet loops forever.

Instead,

Every router decreases TTL.

Example

```
TTL = 64

↓

Router

63

↓

Router

62

↓

Router

61
```

When TTL becomes

```
0
```

The router drops the packet and sends an ICMP Time Exceeded message.

---

# Routing

Routers forward packets based on the destination IP address.

Example

```
Laptop

↓

Router

↓

ISP

↓

Internet

↓

Google
```

Routers never look at:

- TCP Payload
- HTTP Data

They mainly inspect the destination IP.

---

# Routing Table

Every router maintains a routing table.

Example

```
Destination        Next Hop

10.0.0.0/8         Router A

172.16.0.0/16      Router B

0.0.0.0/0          ISP
```

When a packet arrives,

The router searches this table.

---

# Longest Prefix Match (LPM)

One of the most important routing interview topics.

Example:

```
10.0.0.0/8

10.1.0.0/16

10.1.2.0/24
```

Destination

```
10.1.2.50
```

Which route is chosen?

```
10.1.2.0/24
```

Because it is the **most specific** (longest prefix).

Interviewers often ask:

**How is Longest Prefix Match implemented efficiently?**

Answer:

Typically using **Trie/Patricia Trie/TCAM**, depending on software or hardware.

---

# Default Route

```
0.0.0.0/0
```

Means

"If nothing else matches, send the packet here."

Usually points to:

```
Default Gateway
```

---

# CIDR

CIDR = Classless Inter-Domain Routing

Example

```
192.168.1.0/24
```

Meaning

```
24 bits = Network

8 bits = Host
```

Common prefixes

| Prefix | Hosts |
|---------|------:|
| /24 | 254 |
| /25 | 126 |
| /26 | 62 |
| /27 | 30 |
| /28 | 14 |

For interviews, remember the common subnet sizes rather than memorizing every possibility.

---

# Fragmentation

Suppose

Packet Size

```
3000 Bytes
```

Network MTU

```
1500 Bytes
```

The packet must be split.

```
Packet

↓

Fragment 1

Fragment 2
```

The receiver reassembles the fragments.

Problems with fragmentation:

- Performance overhead
- Loss of one fragment requires retransmission of the whole packet (with TCP)
- Additional processing

Modern systems try to avoid fragmentation by using **Path MTU Discovery**.

---

# IPv6

IPv4 addresses are limited.

IPv6 solves address exhaustion.

Example

```
2001:0db8:85a3::8a2e:0370:7334
```

Properties

- 128-bit addresses
- Huge address space
- Simpler header
- Better support for auto-configuration
- No broadcast (uses multicast instead)

---

# IPv4 vs IPv6

| IPv4 | IPv6 |
|------|------|
| 32-bit | 128-bit |
| Broadcast | No Broadcast |
| Limited addresses | Massive address space |
| NAT commonly used | NAT usually unnecessary |
| Widely deployed | Increasing adoption |

---

# Packet Flow

Suppose

```
Browser

↓

HTTP

↓

TCP

↓

IP

Destination

142.250.xxx.xxx

↓

Routing Table

↓

Next Hop

↓

Ethernet

↓

NIC

↓

Wire
```

IP decides **where** the packet should go.

Ethernet decides **how** to send it on the local network.

---

# Linux Commands

Display IP address

```bash
ip addr
```

Display routing table

```bash
ip route
```

Example

```
default via 192.168.1.1 dev eth0

192.168.1.0/24 dev eth0
```

Show packet path

```bash
traceroute google.com
```

---

# Common Interview Questions

## Q1 Why do we need IP if MAC addresses already exist?

MAC addresses work only inside a local network.

IP enables communication across different networks.

---

## Q2 What is TTL?

TTL limits a packet's lifetime and prevents routing loops.

---

## Q3 Which device decrements TTL?

Every router that forwards the packet.

---

## Q4 What happens when TTL reaches zero?

The router drops the packet and sends an ICMP Time Exceeded message.

---

## Q5 What is CIDR?

CIDR represents the network prefix using slash notation (for example, `/24`).

---

## Q6 What is the default route?

```
0.0.0.0/0
```

Used when no more specific route exists.

---

## Q7 What is Longest Prefix Match?

The router selects the most specific matching route in its routing table.

---

## Q8 Why is Longest Prefix Match important?

It allows overlapping routes while ensuring the best route is chosen.

---

## Q9 Why was IPv6 introduced?

To overcome IPv4 address exhaustion and improve scalability.

---

## Q10 Why do routers look only at the IP header?

Because routing decisions are based on the destination IP address, not application data.

---

# Common Mistakes

❌ Thinking switches perform routing.

✔ Switches forward Ethernet frames.

Routers forward IP packets.

---

❌ Thinking TTL is measured in seconds.

✔ TTL is a hop count, not time.

---

❌ Thinking routers use MAC addresses for routing.

✔ Routers use destination IP addresses.

---

❌ Thinking IPv6 is just a bigger IPv4.

✔ IPv6 also changes addressing, neighbor discovery, multicast behavior, and header design.

---

# Quick Revision

```
IPv4

↓

32 Bits

↓

Logical Address

↓

Routing

↓

Routing Table

↓

Longest Prefix Match

↓

TTL

↓

Default Route

↓

CIDR

↓

Fragmentation

↓

IPv6
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| IPv4 | 32-bit |
| IPv6 | 128-bit |
| Router Uses | Destination IP |
| TTL | Prevents loops |
| Default Route | 0.0.0.0/0 |
| Routing Decision | Longest Prefix Match |
| Local Delivery | MAC Address |
| Network Delivery | IP Address |
| Fragmentation | Avoid when possible |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Why IP is needed.
- IPv4 addressing.
- Public vs Private IP.
- Important IPv4 header fields.
- TTL and routing loops.
- Routing tables.
- Longest Prefix Match.
- CIDR notation.
- Fragmentation.
- IPv6 fundamentals.
- Basic Linux networking commands.

---

**Next Chapter:** TCP & UDP – Connection establishment, reliability, flow control, congestion control, retransmissions, sockets, and interview-focused internals (the most important chapter in the handbook).