# Chapter 13 – High Availability & Load Balancing
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** High Availability (HA) and Load Balancing are core topics for senior networking interviews. Arista interviewers frequently ask how large-scale data centers continue operating when switches, links, or servers fail.

---

# Why High Availability?

Imagine a single server.

```
        Users

          │

          ▼

     +-----------+
     | Server A  |
     +-----------+
```

If Server A crashes,

```
Service = DOWN
```

High Availability eliminates this single point of failure.

---

# High Availability (HA)

HA means

> **Keep the service running even if hardware, software, or network components fail.**

Goals

- No single point of failure
- Automatic failover
- Fast recovery
- Minimal downtime

---

# Redundancy

Instead of one server,

deploy multiple.

```
         Users

           │

    +------+------+

    │             │

+---------+   +---------+

|Server A |   |Server B |

+---------+   +---------+
```

If Server A fails,

Traffic moves to Server B.

---

# Failover

Normal Operation

```
Primary

↓

Handles Traffic
```

Failure

```
Primary

↓

Fails

↓

Backup Takes Over
```

Failover can be

- Active-Passive
- Active-Active

---

# Active-Passive

```
Primary

↓

Handles Requests

Backup

↓

Waiting
```

Only one node actively serves traffic.

Advantages

- Simple
- Predictable

Disadvantage

- Backup resources remain mostly unused.

---

# Active-Active

```
Server A

↓

Traffic

Server B

↓

Traffic
```

Both servers handle requests simultaneously.

Advantages

- Better utilization
- Higher throughput

---

# Health Checks

How does a load balancer know a server is healthy?

It periodically checks.

Example

```
GET /health

↓

200 OK
```

If the check fails,

Traffic stops going to that server.

---

# Load Balancer

A load balancer distributes requests across servers.

```
           Users

             │

      +--------------+

      | Load Balancer|

      +--------------+

        │    │    │

        ▼    ▼    ▼

      S1    S2    S3
```

Benefits

- Better performance
- High availability
- Scalability

---

# Layer 4 Load Balancer

Operates using

- IP Address
- TCP Port

It does **not** inspect HTTP content.

Example

```
TCP Port 443

↓

Forward
```

Examples

- Linux IPVS
- AWS Network Load Balancer

---

# Layer 7 Load Balancer

Operates at the application layer.

Can inspect

- URL
- Headers
- Cookies
- HTTP Method

Example

```
/images

↓

Server A

------------------

/api

↓

Server B
```

Examples

- HAProxy
- NGINX
- Envoy

---

# L4 vs L7

| Layer 4 | Layer 7 |
|----------|----------|
| TCP/UDP | HTTP/HTTPS |
| Faster | Smarter |
| No Content Inspection | URL/Header Based Routing |
| Lower CPU | Higher CPU |

---

# Load Balancing Algorithms

## Round Robin

Requests rotate equally.

```
Req1 → S1

Req2 → S2

Req3 → S3

Req4 → S1
```

---

## Least Connections

Traffic goes to the server with the fewest active connections.

Useful when requests have different durations.

---

## Hash Based

```
Client IP

↓

Hash

↓

Server
```

Keeps a client on the same server.

Useful for session affinity.

---

# Session Persistence (Sticky Sessions)

Sometimes a user must always reach the same server.

Example

```
User

↓

Server A

↓

Future Requests

↓

Server A
```

Methods

- Cookie
- Source IP Hash

---

# Link Aggregation (LACP)

Interview Favorite.

Suppose one network link is insufficient.

Instead of upgrading,

combine multiple links.

```
Switch

 || ||

 || ||

Server
```

LACP

```
Link1

+

Link2

+

Link3

+

Link4
```

Benefits

- Higher bandwidth
- Redundancy

Standard

```
IEEE 802.3ad
```

(now maintained as IEEE 802.1AX)

---

# ECMP (Equal Cost Multi Path)

Previously introduced,

but important here.

```
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

Both paths are used.

Benefits

- Load sharing
- Redundancy

---

# VRRP (Virtual Router Redundancy Protocol)

Another favorite interview topic.

Problem

```
Clients

↓

One Gateway

↓

Router Failure
```

Network becomes unreachable.

VRRP solves this.

```
Virtual Gateway

↓

Router A (Master)

↓

Router B (Backup)
```

If Router A fails,

Router B automatically becomes the master.

Clients continue using the same virtual gateway address.

---

# Anycast

Same IP address advertised from multiple locations.

```
User A

↓

Nearest Server

----------------

User B

↓

Nearest Server
```

Benefits

- Lower latency
- High availability
- Automatic traffic distribution

Commonly used by

- DNS providers
- CDNs

---

# BFD (Bidirectional Forwarding Detection)

Detects network failures very quickly.

```
Router A

↔

Router B

↓

Heartbeat

↓

Failure

↓

Fast Detection
```

Often used with routing protocols like OSPF and BGP.

---

# Data Center Redundancy

Typical topology

```
              Internet

                 │

          +--------------+

          | Load Balancer|

          +--------------+

           │          │

     +---------+  +---------+

     |Server A |  |Server B |

     +---------+  +---------+

           │          │

      +------------------+

      | Shared Database  |

      +------------------+
```

Multiple redundant paths reduce downtime.

---

# Split Brain

Possible in Active-Active clusters.

```
Node A

↓

"I am Primary"

---------------

Node B

↓

"I am Primary"
```

This can cause data corruption.

Solutions

- Quorum
- Witness Node
- Distributed consensus

---

# Linux High Availability Tools

Check interfaces

```bash
ip link
```

Check routing

```bash
ip route
```

Check connections

```bash
ss -t
```

Load balancer examples

- HAProxy
- NGINX
- Keepalived (commonly used with VRRP)

---

# Common Interview Questions

## Q1 Difference between High Availability and Load Balancing?

High Availability focuses on keeping services available during failures.

Load Balancing distributes traffic across healthy servers.

---

## Q2 Difference between Active-Active and Active-Passive?

Active-Active uses all nodes simultaneously.

Active-Passive keeps backup nodes idle until failover.

---

## Q3 Difference between Layer 4 and Layer 7 Load Balancers?

Layer 4 forwards based on IP addresses and ports.

Layer 7 can inspect HTTP requests and make content-aware routing decisions.

---

## Q4 What is LACP?

A protocol that combines multiple physical links into one logical link for higher bandwidth and redundancy.

---

## Q5 Why use VRRP?

To provide a redundant default gateway.

---

## Q6 Difference between ECMP and LACP?

ECMP distributes traffic across multiple equal-cost Layer-3 paths.

LACP aggregates multiple physical Layer-2 links into one logical link.

---

## Q7 What are Sticky Sessions?

A mechanism that keeps a client's requests directed to the same backend server.

---

## Q8 Why are health checks important?

They prevent traffic from being sent to failed or unhealthy servers.

---

# Common Mistakes

❌ Thinking Load Balancing automatically provides High Availability.

✔ Without health checks and redundancy, a load balancer alone cannot guarantee availability.

---

❌ Confusing ECMP with LACP.

✔ ECMP works at Layer 3.

✔ LACP works at Layer 2.

---

❌ Thinking VRRP balances traffic.

✔ VRRP provides gateway redundancy, not load balancing.

---

❌ Assuming Anycast always sends traffic to the geographically closest server.

✔ It generally routes to the "best" destination according to network routing, which is often—but not always—the nearest geographically.

---

# Quick Revision

```
Redundancy

↓

Failover

↓

Health Checks

↓

Load Balancer

↓

L4

↓

L7

↓

Round Robin

↓

Least Connections

↓

Sticky Sessions

↓

LACP

↓

VRRP

↓

ECMP

↓

Anycast

↓

BFD
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| High Availability | Minimize Downtime |
| Active-Active | All Nodes Serve Traffic |
| Active-Passive | Standby Node |
| Health Check | Detect Failed Servers |
| L4 LB | IP + Port |
| L7 LB | HTTP Aware |
| Round Robin | Equal Distribution |
| Least Connections | Fewest Active Sessions |
| Sticky Sessions | Same Client → Same Server |
| LACP | Link Aggregation |
| ECMP | Multiple Layer-3 Paths |
| VRRP | Redundant Gateway |
| Anycast | Same IP at Multiple Locations |
| BFD | Fast Failure Detection |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- High Availability principles
- Redundancy and failover
- Active-Active vs Active-Passive
- Health checks
- Layer 4 vs Layer 7 load balancers
- Load balancing algorithms
- Sticky sessions
- LACP
- ECMP
- VRRP
- Anycast
- BFD
- Split brain

---

## Final Chapter Next

**Chapter 14 – Senior Networking Interview Master Revision**

This final chapter will include:

- **100+ real interview questions** (Arista/Cisco/NVIDIA/Broadcom style)
- Complete packet-flow diagrams
- Linux networking cheat sheets
- TCP/IP one-page revision
- Common debugging scenarios
- Top networking mistakes candidates make
- 10-minute and 1-hour revision guides

This chapter will serve as your **last-minute revision before interviews**.