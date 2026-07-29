# Chapter 16 – Data Center Networking (Spine-Leaf, VXLAN, EVPN & MLAG)
**Senior C/C++ Linux Networking Handbook**

> **Goal**
>
> Modern Arista switches are primarily deployed in **cloud and enterprise data centers**. Understanding Spine-Leaf, VXLAN, EVPN, MLAG, and BGP is essential for senior networking interviews.

---

# Why Traditional Networks Don't Scale

Traditional enterprise networks used a three-tier design.

```
             Core
              │
      +-------+-------+
      │               │
   Aggregation    Aggregation
      │               │
   +--+--+         +--+--+
   │     │         │     │
 Access Access   Access Access
```

Problems

- More hops
- Higher latency
- Oversubscription
- Difficult to scale horizontally

---

# Modern Data Center

Today's data centers use **Spine-Leaf**.

```
          Spine1      Spine2
             │  \    /  │
             │   \  /   │
             │    \/    │
             │    /\    │
             │   /  \   │
         Leaf1    Leaf2
          │ │      │ │
         S S      S S

S = Server
```

Every Leaf connects to **every Spine**.

---

# Why Spine-Leaf?

Benefits

- Predictable latency
- High bandwidth
- Easy expansion
- Multiple equal-cost paths
- Excellent ECMP utilization

---

# Packet Flow

Server A

```
↓

Leaf

↓

Spine

↓

Leaf

↓

Server B
```

Maximum

```
Leaf

↓

Spine

↓

Leaf
```

Only two network hops.

---

# Underlay vs Overlay

Interview Favorite.

---

## Underlay Network

The physical IP network.

```
Leaf

↓

Spine

↓

Leaf
```

Responsibilities

- IP connectivity
- Routing
- ECMP

Common protocols

- OSPF
- IS-IS
- BGP

---

## Overlay Network

Built on top of the underlay.

```
Virtual Network

↓

VXLAN

↓

Physical Network
```

Provides logical connectivity independent of the physical topology.

---

# Why Do We Need VXLAN?

Problem

VLAN IDs

```
12 Bits

↓

4096 VLANs Maximum
```

Large cloud data centers need far more than 4096 isolated networks.

---

# VXLAN

VXLAN

```
Virtual eXtensible LAN
```

Creates

```
Layer-2

Over

Layer-3
```

Allows virtual machines on different racks to appear as if they are on the same Ethernet network.

---

# VXLAN Packet

Original Packet

```
Ethernet

↓

IP

↓

TCP
```

VXLAN adds another header.

```
Outer Ethernet

↓

Outer IP

↓

UDP

↓

VXLAN Header

↓

Original Ethernet Frame
```

This process is called **encapsulation**.

---

# VXLAN Network Identifier (VNI)

Instead of VLAN IDs,

VXLAN uses

```
24 Bits
```

Maximum

```
16 Million+

Virtual Networks
```

Far larger than traditional VLANs.

---

# VTEP

Interview Favorite.

VTEP

```
VXLAN Tunnel End Point
```

Usually implemented on the Leaf switch.

Responsibilities

- Encapsulate packets into VXLAN
- Decapsulate received VXLAN packets

---

# VXLAN Flow

```
Server

↓

Leaf (VTEP)

↓

Encapsulation

↓

IP Network

↓

Leaf (VTEP)

↓

Decapsulation

↓

Destination Server
```

---

# Encapsulation Example

Original

```
VM1

↓

Ethernet

↓

IP
```

After VXLAN

```
Outer Ethernet

↓

Outer IP

↓

UDP

↓

VXLAN

↓

Original Ethernet

↓

Original IP
```

---

# Why UDP?

VXLAN uses

```
UDP

Port 4789
```

Advantages

- Easy routing
- ECMP support
- Transport across IP networks

---

# EVPN

EVPN

```
Ethernet VPN
```

Control plane for VXLAN.

Without EVPN,

switches would rely heavily on flooding.

EVPN distributes

- MAC addresses
- IP addresses
- Reachability information

using BGP.

---

# Why EVPN?

Without EVPN

```
Unknown MAC

↓

Flood
```

With EVPN

```
Learn

↓

Advertise

↓

No Flooding
```

Benefits

- Less broadcast traffic
- Faster convergence
- Better scalability

---

# BGP in Data Centers

Many modern data centers use

```
BGP

↓

Leaf

↓

Spine
```

Instead of only OSPF.

Reasons

- Scalable
- Mature
- Policy-based routing
- Works well with EVPN

---

# MP-BGP

MP

```
Multi-Protocol
```

BGP can carry

- IPv4
- IPv6
- EVPN routes

---

# EVPN Route Types (High Level)

For interviews, remember

| Route Type | Purpose |
|------------|----------|
| Type 2 | MAC/IP Advertisement |
| Type 3 | Inclusive Multicast / Broadcast Information |
| Type 5 | IP Prefix Advertisement |

You do **not** need to memorize all route types for most interviews.

---

# ECMP in Spine-Leaf

Suppose

```
Leaf

↓

Spine1

↓

Leaf

OR

↓

Spine2

↓

Leaf
```

Both paths have equal cost.

Traffic can use both.

Benefits

- Better bandwidth
- Redundancy
- High throughput

---

# MLAG

Interview Favorite.

Problem

Server connected to only one switch.

```
Server

↓

Leaf1
```

If Leaf1 fails,

server loses connectivity.

---

# MLAG Solution

```
          Leaf1
          ║
Server ====╬====
          ║
          Leaf2
```

Server connects to both Leaf switches.

Both appear as a single logical switch.

Benefits

- Redundancy
- Higher bandwidth
- No Spanning Tree blocking on server-facing links

---

# MLAG vs STP

| MLAG | STP |
|------|-----|
| Active Links | Blocks Redundant Links |
| Better Bandwidth | Lower Utilization |
| Fast Recovery | Slower Recovery |

---

# Anycast Gateway

Traditional

```
Gateway

↓

One Switch
```

Modern

```
Leaf1

↓

Same Gateway IP

Leaf2

↓

Same Gateway IP
```

Every Leaf advertises the same default gateway.

Benefits

- Lower latency
- Simpler mobility
- Faster forwarding

---

# East-West vs North-South Traffic

## North-South

Traffic enters or leaves the data center.

```
Internet

↓

Firewall

↓

Server
```

---

## East-West

Traffic remains inside the data center.

```
Server

↓

Server
```

Modern cloud workloads generate mostly East-West traffic.

---

# Why Spine-Leaf is Better

Old Design

```
Access

↓

Aggregation

↓

Core

↓

Aggregation

↓

Access
```

Many hops.

---

Spine-Leaf

```
Leaf

↓

Spine

↓

Leaf
```

Consistent latency.

---

# Complete Data Center Flow

```
Application

↓

Server

↓

Leaf (VTEP)

↓

VXLAN Encapsulation

↓

Spine

↓

Leaf (VTEP)

↓

VXLAN Decapsulation

↓

Destination Server
```

---

# Common Interview Questions

## Q1 Why not use VLANs everywhere?

Traditional VLANs are limited to approximately 4096 VLAN IDs and do not scale well across very large Layer-2 domains.

---

## Q2 What is VXLAN?

VXLAN is a Layer-2 overlay network built on top of a Layer-3 IP network.

---

## Q3 What is a VTEP?

A VXLAN Tunnel End Point that encapsulates and decapsulates VXLAN traffic.

---

## Q4 Why does VXLAN use UDP?

UDP allows VXLAN traffic to be routed across IP networks and works well with ECMP.

---

## Q5 What is EVPN?

EVPN is a BGP-based control plane that distributes MAC/IP reachability information for VXLAN networks.

---

## Q6 Why is EVPN better than flooding?

It distributes endpoint information using control-plane advertisements, greatly reducing broadcast and unknown-unicast flooding.

---

## Q7 What is MLAG?

A technology that allows a device to connect simultaneously to two switches that behave as one logical switch.

---

## Q8 Why is ECMP important in Spine-Leaf?

It allows multiple equal-cost paths to be used simultaneously for higher throughput and redundancy.

---

## Q9 Difference between Underlay and Overlay?

Underlay is the physical routed IP network.

Overlay is the virtual network built on top of it (such as VXLAN).

---

## Q10 What is an Anycast Gateway?

The same default gateway IP and MAC are presented from multiple Leaf switches, allowing hosts to use a nearby gateway.

---

# Common Mistakes

❌ Thinking VXLAN replaces IP.

✔ VXLAN runs over an IP underlay network.

---

❌ Thinking EVPN is a tunneling protocol.

✔ VXLAN performs the tunneling. EVPN provides the control plane.

---

❌ Confusing VLAN IDs with VNIs.

✔ VLAN ID = 12 bits (~4096).

✔ VNI = 24 bits (~16 million).

---

❌ Thinking MLAG is the same as STP.

✔ MLAG enables active-active connectivity, whereas STP prevents loops by blocking redundant links.

---

# Quick Revision

```
Traditional Network

↓

Spine-Leaf

↓

Underlay

↓

Overlay

↓

VXLAN

↓

VTEP

↓

EVPN

↓

BGP

↓

ECMP

↓

MLAG

↓

Anycast Gateway
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Spine-Leaf | Two-Hop Data Center Fabric |
| Underlay | Physical IP Network |
| Overlay | Virtual Network |
| VXLAN | Layer-2 over Layer-3 |
| VNI | 24-bit Network Identifier |
| UDP Port | 4789 |
| VTEP | VXLAN Tunnel Endpoint |
| EVPN | BGP Control Plane |
| MP-BGP | Multi-Protocol BGP |
| ECMP | Equal-Cost Load Sharing |
| MLAG | Dual-Connected Active Links |
| Anycast Gateway | Same Gateway on Multiple Leafs |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Traditional vs Spine-Leaf architectures
- Underlay and Overlay networks
- VXLAN and encapsulation
- VNI and VTEP
- EVPN and its role
- BGP in data centers
- ECMP
- MLAG
- Anycast Gateway
- East-West vs North-South traffic
- End-to-end packet flow in a modern data center

---

**Next Chapter:** **Linux Kernel Networking Source Walkthrough** — follow a packet through the actual Linux kernel functions (`netif_receive_skb()`, `ip_rcv()`, `tcp_v4_rcv()`, `tcp_recvmsg()`, `dev_queue_xmit()`, etc.). This is one of the strongest differentiators in senior Arista interviews.