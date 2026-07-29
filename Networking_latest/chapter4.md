# Chapter 4 – ARP (Address Resolution Protocol)
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand how an IP address is translated into a MAC address. ARP is one of the most frequently asked networking interview topics because it connects Layer 2 (Ethernet) with Layer 3 (IP).

---

# Why Do We Need ARP?

Suppose:

```
Laptop A

IP  = 192.168.1.10
MAC = AA:AA:AA:AA:AA:AA

        │
        │
     Switch
        │
        │

Laptop B

IP  = 192.168.1.20
MAC = BB:BB:BB:BB:BB:BB
```

Laptop A knows:

```
Destination IP

192.168.1.20
```

But Ethernet needs:

```
Destination MAC
```

Question:

**How does Laptop A know Laptop B's MAC address?**

Answer:

**ARP (Address Resolution Protocol)**

---

# What is ARP?

ARP maps

```
IP Address

↓

MAC Address
```

Without ARP:

- IP communication inside a LAN is impossible.
- Ethernet cannot deliver frames.

---

# ARP Packet Format

```
+----------------------+
| Sender IP            |
+----------------------+
| Sender MAC           |
+----------------------+
| Target IP            |
+----------------------+
| Target MAC           |
+----------------------+
```

The Target MAC is unknown during an ARP Request.

---

# ARP Request

Suppose Laptop A wants to send data to:

```
192.168.1.20
```

It first checks its ARP cache.

If not found:

It sends a broadcast.

```
Who has

192.168.1.20 ?

Tell

192.168.1.10
```

Destination MAC

```
FF:FF:FF:FF:FF:FF
```

Every device receives this frame.

---

# ARP Reply

Only Laptop B owns

```
192.168.1.20
```

Laptop B replies

```
192.168.1.20

is

BB:BB:BB:BB:BB:BB
```

This reply is **Unicast**.

Only Laptop A receives it.

---

# Complete ARP Flow

```
Laptop A

Needs

192.168.1.20

↓

ARP Cache

↓

Found?

No

↓

Broadcast ARP Request

↓

Switch Floods

↓

All Devices Receive

↓

Laptop B Replies

↓

ARP Cache Updated

↓

Ethernet Frame Sent
```

---

# ARP Cache

Every operating system maintains an ARP cache.

Example

```
IP Address         MAC Address

192.168.1.1   →   00:11:22:33:44:55

192.168.1.20  →   BB:BB:BB:BB:BB:BB
```

Benefits

- Faster communication
- Fewer ARP broadcasts
- Reduced network traffic

Entries expire after some time.

---

# Linux Commands

Display ARP cache:

```bash
arp -a
```

or

```bash
ip neigh
```

Example:

```
192.168.1.20 dev eth0 lladdr BB:BB:BB:BB:BB:BB REACHABLE
```

Common states:

- REACHABLE
- STALE
- DELAY
- FAILED

---

# Gratuitous ARP

A device sends an ARP announcement for **its own IP address**.

Purpose:

- Update other devices' ARP caches.
- Detect duplicate IP addresses.
- High Availability (VRRP/Keepalived).

Example

```
I am

192.168.1.20

My MAC has changed.
```

---

# Proxy ARP

A router answers an ARP request **on behalf of another device**.

Example

```
Laptop A

↓

Router

↓

Remote Network
```

Laptop A believes the router owns the destination IP.

The router forwards the packet.

---

# ARP and Routers

A common misconception:

ARP **does not work across routers**.

Example

```
LAN 1

Laptop A

↓

Router

↓

LAN 2

Laptop B
```

Laptop A never learns Laptop B's MAC.

Instead:

Laptop A learns **the router's MAC**.

The router then performs another ARP lookup on LAN 2.

---

# ARP in Packet Flow

Suppose:

```
ping 192.168.1.20
```

Flow:

```
Application

↓

ICMP

↓

IP

↓

Need Destination MAC?

↓

ARP Lookup

↓

MAC Found?

↓

Yes

↓

Ethernet Frame

↓

NIC

↓

Switch

↓

Laptop B
```

---

# Linux Networking Stack

```
Application

↓

Socket

↓

IP Layer

↓

ARP

↓

Ethernet

↓

NIC Driver

↓

Wire
```

ARP sits between IP and Ethernet.

---

# Common Interview Questions

## Q1 Why do we need ARP?

Because Ethernet requires a destination MAC address, while applications communicate using IP addresses.

---

## Q2 Is ARP Layer 2 or Layer 3?

ARP bridges Layer 2 and Layer 3.

It translates IP addresses into MAC addresses.

---

## Q3 Why is ARP Request broadcast?

Because the sender does not know the destination MAC address.

---

## Q4 Why is ARP Reply unicast?

Because the requester is already known.

There is no need to broadcast the reply.

---

## Q5 Does ARP work across routers?

No.

ARP works only within the local broadcast domain.

---

## Q6 What happens if ARP cache already contains the MAC?

No ARP Request is sent.

Communication starts immediately.

---

## Q7 What happens if the destination IP does not exist?

ARP Requests are retried.

Eventually, ARP resolution fails and the packet is dropped.

---

## Q8 What is Gratuitous ARP?

A host announces its own IP-to-MAC mapping without being asked.

---

## Q9 What is Proxy ARP?

A router responds to an ARP request on behalf of another device.

---

# Common Mistakes

❌ Thinking ARP finds IP addresses.

✔ ARP finds MAC addresses from IP addresses.

---

❌ Thinking ARP works on the Internet.

✔ ARP works only within a local Layer-2 network.

---

❌ Thinking ARP Reply is broadcast.

✔ ARP Reply is normally unicast.

---

❌ Thinking routers forward ARP requests.

✔ Routers do not forward Layer-2 broadcasts.

---

# Quick Revision

```
Need Destination IP

↓

Need Destination MAC

↓

ARP Cache

↓

Found?

Yes → Send Ethernet Frame

↓

No

↓

Broadcast ARP Request

↓

Target Replies

↓

Update ARP Cache

↓

Send Frame
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Full Form | Address Resolution Protocol |
| Purpose | IP → MAC |
| ARP Request | Broadcast |
| ARP Reply | Unicast |
| Works Across Router? | No |
| Cache | Yes |
| Linux Command | `ip neigh` |
| Broadcast MAC | FF:FF:FF:FF:FF:FF |
| Special Types | Gratuitous ARP, Proxy ARP |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Why ARP is required.
- How ARP Request and Reply work.
- ARP cache and its benefits.
- Gratuitous ARP.
- Proxy ARP.
- Why ARP does not cross routers.
- How ARP fits into the Linux networking stack.
- How to inspect ARP entries on Linux.

---

**Next Chapter:** IPv4 & IPv6 – IP Header, Routing, CIDR, Subnetting, TTL, and Fragmentation.