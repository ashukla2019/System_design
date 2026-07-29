# Chapter 8 – Switching, VLANs & Routing
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Master Layer-2 switching and Layer-3 routing concepts commonly asked in interviews at Arista, Cisco, Juniper, NVIDIA, Broadcom, Qualcomm, and other networking companies.

---

# Big Picture

Understanding where switching ends and routing begins is critical.

```
            Same Network
+--------+              +--------+
| Host A | ------------ | Host B |
+--------+              +--------+
        Switch (L2)

             Different Networks

+--------+       +--------+       +--------+
| Host A | ----> | Router | ----> | Host B |
+--------+       +--------+       +--------+
```

**Rule**

- Switch → Same Network
- Router → Different Networks

---

# Layer 2 Switching

A Layer-2 switch forwards **Ethernet Frames**.

It looks only at

```
Destination MAC Address
```

It does **NOT** care about

- TCP
- UDP
- HTTP
- Application Data

---

# How a Switch Forwards Frames

```
Frame Arrives

↓

Read Destination MAC

↓

Lookup CAM Table

↓

Found?

↓

YES -----------> Forward

NO ------------> Flood
```

Switches continuously learn MAC addresses.

---

# Broadcast Domain

Suppose one switch connects four PCs.

```
        Switch

      /  |  |  \

     A   B  C   D
```

If A sends an ARP Request,

Everyone receives it.

All belong to **one broadcast domain**.

---

# Collision Domain

Modern switches create

```
One Collision Domain
Per Port
```

Old hubs had

```
One Collision Domain
For Everyone
```

Interview Question

**Why are switches faster than hubs?**

Because switches eliminate collisions using dedicated ports.

---

# VLAN (Virtual LAN)

One physical switch can behave like multiple logical switches.

Without VLAN

```
Switch

HR

Finance

Engineering

All receive broadcasts.
```

With VLAN

```
+------------------------+

VLAN 10

HR

-------------------------

VLAN 20

Finance

-------------------------

VLAN 30

Engineering

+------------------------+
```

Each VLAN is a separate broadcast domain.

---

# Why VLANs?

Benefits

- Security
- Isolation
- Reduced broadcasts
- Better scalability
- Easier administration

---

# Access Port

Connects

```
PC

Printer

Server
```

Carries traffic for

```
One VLAN Only
```

Example

```
Port 5

↓

VLAN 20
```

---

# Trunk Port

Connects

- Switch ↔ Switch
- Switch ↔ Router
- Switch ↔ Hypervisor

Carries

```
Multiple VLANs
```

using

```
802.1Q VLAN Tag
```

---

# VLAN Tagging

Normal Ethernet

```
Ethernet Header

↓

IP

↓

TCP
```

Tagged Ethernet

```
Ethernet Header

↓

802.1Q VLAN Tag

↓

IP

↓

TCP
```

Switches use this tag to determine the VLAN.

---

# Inter-VLAN Communication

Question

Can VLAN10 communicate with VLAN20?

Answer

```
NO
```

A router (or Layer-3 switch) is required.

```
VLAN10

↓

Router

↓

VLAN20
```

---

# Spanning Tree Protocol (STP)

Interview Favorite.

Suppose

```
Switch A

 /      \

B ------ C
```

There is a loop.

Broadcast packets circulate forever.

This causes

- Broadcast Storm
- High CPU
- Network Failure

---

# STP Solution

STP blocks one redundant link.

```
A

|

B     X     C
```

One path is disabled.

If the active link fails,

The blocked link becomes active.

Benefits

- No loops
- Redundancy
- Automatic recovery

---

# Router

Routers connect

```
Different Networks
```

They examine

```
Destination IP Address
```

Example

```
192.168.1.x

↓

Router

↓

10.1.1.x
```

---

# Routing Table

Every router maintains

```
Destination

↓

Next Hop

↓

Outgoing Interface
```

Example

```
Destination        Next Hop

10.0.0.0/8         R1

172.16.0.0/16      R2

0.0.0.0/0          ISP
```

---

# Longest Prefix Match

Suppose

```
10.0.0.0/8

10.1.0.0/16

10.1.2.0/24
```

Destination

```
10.1.2.50
```

Router chooses

```
10.1.2.0/24
```

Most specific route wins.

---

# Static Routing

Administrator manually configures routes.

Example

```
ip route

10.1.0.0/16

via

192.168.1.1
```

Simple but not scalable.

---

# Dynamic Routing

Routers exchange routes automatically.

Popular protocols

- OSPF
- BGP

---

# OSPF (Open Shortest Path First)

Used inside one organization.

Example

```
Office A

↓

Office B

↓

Office C
```

Features

- Interior Gateway Protocol (IGP)
- Fast convergence
- Uses SPF (Shortest Path First)
- Link-state protocol

---

# BGP (Border Gateway Protocol)

Most important routing protocol on the Internet.

Example

```
Google

↓

ISP

↓

Microsoft

↓

Cloudflare
```

BGP exchanges routes

between different Autonomous Systems (AS).

Features

- Exterior Gateway Protocol (EGP)
- Internet-scale routing
- Policy-based routing
- Path Vector Protocol

---

# OSPF vs BGP

| OSPF | BGP |
|------|------|
| Inside one organization | Between organizations |
| Fast convergence | Internet scale |
| Link State | Path Vector |
| Uses Cost | Uses AS Path & Policies |

---

# ECMP (Equal Cost Multi Path)

Interview Favorite.

Suppose

```
Destination

↓

Router

↓

Path A

↓

Destination

OR

↓

Path B

↓

Destination
```

Both paths have equal cost.

Router can use both.

Benefits

- Load balancing
- Better bandwidth utilization
- Redundancy

---

# Complete Packet Flow

```
Application

↓

TCP

↓

IP

↓

Ethernet

↓

Switch

↓

Router

↓

Another Router

↓

Destination Network

↓

Switch

↓

Destination Host
```

---

# Linux Commands

Display routing table

```bash
ip route
```

Show interfaces

```bash
ip link
```

Show neighbor table

```bash
ip neigh
```

Trace route

```bash
traceroute google.com
```

---

# Common Interview Questions

## Q1 Difference between Switch and Router?

Switch

- Layer 2
- Uses MAC addresses
- Same network

Router

- Layer 3
- Uses IP addresses
- Different networks

---

## Q2 Why do we need VLANs?

To create multiple isolated broadcast domains on the same physical switch.

---

## Q3 Difference between Access Port and Trunk Port?

Access Port

One VLAN

Trunk Port

Multiple VLANs using 802.1Q tags.

---

## Q4 Why is STP needed?

To prevent Layer-2 loops and broadcast storms.

---

## Q5 What happens if STP is disabled?

A Layer-2 loop can create broadcast storms, duplicate frames, and MAC table instability.

---

## Q6 Difference between OSPF and BGP?

OSPF works within an organization.

BGP exchanges routes between different Autonomous Systems on the Internet.

---

## Q7 What is ECMP?

Using multiple equal-cost routes simultaneously for load balancing and redundancy.

---

## Q8 What is Longest Prefix Match?

The router chooses the most specific matching route.

---

## Q9 Why don't switches perform routing?

Standard Layer-2 switches forward frames based on MAC addresses and do not make Layer-3 forwarding decisions.

---

# Common Mistakes

❌ Thinking every switch can route.

✔ Only Layer-3 switches perform routing.

---

❌ Thinking VLANs improve Internet speed.

✔ VLANs provide logical separation and reduce broadcast domains.

---

❌ Confusing Broadcast Domain and Collision Domain.

✔ VLAN separates broadcast domains.

✔ Each switch port is its own collision domain.

---

❌ Thinking BGP finds the shortest path.

✔ BGP primarily selects routes based on policies and attributes, not simply the shortest path.

---

# Quick Revision

```
Switch

↓

MAC

↓

CAM Table

↓

VLAN

↓

Access Port

↓

Trunk Port

↓

STP

↓

Router

↓

Routing Table

↓

Longest Prefix Match

↓

OSPF

↓

BGP

↓

ECMP
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Switch | Layer 2 |
| Router | Layer 3 |
| VLAN | Separate Broadcast Domain |
| Access Port | Single VLAN |
| Trunk Port | Multiple VLANs |
| STP | Prevents Loops |
| OSPF | Inside Organization |
| BGP | Internet Routing |
| ECMP | Multiple Equal-Cost Paths |
| Routing Decision | Longest Prefix Match |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Layer-2 switching
- Broadcast and collision domains
- VLANs
- Access and trunk ports
- 802.1Q VLAN tagging
- Inter-VLAN routing
- Spanning Tree Protocol (STP)
- Routing tables
- Longest Prefix Match
- Static vs Dynamic routing
- OSPF
- BGP
- ECMP

---

**Next Chapter:** **Linux Networking Internals** – Socket API, `socket()`, `bind()`, `listen()`, `accept()`, `connect()`, `send()`, `recv()`, `epoll()`, `select()`, `poll()`, `sk_buff`, NAPI, NIC drivers, interrupts, and complete Linux packet flow. This is one of the most important chapters for Arista interviews.