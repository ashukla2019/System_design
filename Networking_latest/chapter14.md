# Chapter 14 – Senior Networking Interview Master Revision
**Senior C/C++ Linux Networking Handbook**

> **Goal:** This chapter is your **last-minute interview revision guide**. Read it the night before the interview or on the interview day. If you've completed the previous chapters, this chapter is enough to refresh all critical networking concepts.

---

# Part 1 – Complete Packet Journey (Most Important Diagram)

This is the single most important diagram for networking interviews.

```
Application

↓

Socket

↓

TCP

↓

IP

↓

Routing Table

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

Switch

↓

Router

↓

Internet

↓

Router

↓

Switch

↓

NIC

↓

DMA

↓

NIC Driver

↓

NAPI

↓

SoftIRQ

↓

sk_buff

↓

Ethernet

↓

IP

↓

TCP

↓

Socket

↓

Application
```

If you can explain this diagram confidently, you're already ahead of most candidates.

---

# Part 2 – OSI Model (Interview Version)

Don't memorize definitions.

Understand responsibility.

| Layer | Responsible For |
|---------|----------------|
| Application | HTTP, DNS, SSH |
| Transport | TCP, UDP |
| Network | IP, Routing |
| Data Link | Ethernet, MAC |
| Physical | Cable, Fiber |

Interview Rule

```
Switch → Layer 2

Router → Layer 3
```

---

# Part 3 – TCP Interview Revision

Know these perfectly.

### Three Way Handshake

```
Client

SYN

↓

Server

SYN + ACK

↓

Client

ACK
```

---

### Four Way Close

```
FIN

↓

ACK

↓

FIN

↓

ACK
```

---

### Why TIME_WAIT?

Two reasons

- Final ACK reliability
- Old packets expire

---

### Sliding Window

```
Send

Packet1

Packet2

Packet3

↓

ACK
```

Improves throughput.

---

### Flow Control

Protects

```
Receiver
```

---

### Congestion Control

Protects

```
Network
```

---

### Fast Retransmit

```
3 Duplicate ACKs

↓

Retransmit Immediately
```

---

# Part 4 – UDP Revision

Advantages

- Fast
- Small Header
- No Handshake

Uses

- DNS
- DHCP
- VoIP
- Gaming

---

# Part 5 – DNS Revision

```
google.com

↓

DNS

↓

IP

↓

TCP

↓

HTTPS
```

Remember

```
DNS happens before TCP.
```

---

# Part 6 – DHCP Revision

Remember

```
DORA

↓

Discover

↓

Offer

↓

Request

↓

ACK
```

---

# Part 7 – Switching

Remember

```
MAC Address

↓

CAM Table

↓

Forward
```

Unknown MAC

↓

Flood

---

# Part 8 – VLAN

Access Port

```
One VLAN
```

Trunk Port

```
Multiple VLANs
```

Inter-VLAN Communication

↓

Router

---

# Part 9 – Routing

Router checks

```
Destination IP
```

Routing Decision

```
Longest Prefix Match
```

---

# Part 10 – Linux Socket APIs

Server

```
socket()

↓

bind()

↓

listen()

↓

accept()

↓

recv()

↓

send()

↓

close()
```

Client

```
socket()

↓

connect()

↓

send()

↓

recv()

↓

close()
```

Know these in order.

---

# Part 11 – Linux Networking Stack

```
Application

↓

Socket

↓

TCP

↓

IP

↓

Ethernet

↓

NIC Driver

↓

NIC
```

---

# Part 12 – Packet Receive Path

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

Netfilter

↓

IP

↓

TCP

↓

Socket

↓

Application
```

---

# Part 13 – Linux Performance

Know these.

| Technology | Purpose |
|------------|----------|
| DMA | NIC → Memory |
| NAPI | Reduce Interrupts |
| RSS | Multi-core Receive |
| GRO | Merge Incoming Packets |
| GSO | Delay Segmentation |
| TSO | NIC Segmentation |
| Checksum Offload | NIC Computes Checksum |

---

# Part 14 – XDP vs DPDK

| XDP | DPDK |
|------|------|
| Kernel | User Space |
| eBPF | Poll Mode Driver |
| Early Packet Drop | Kernel Bypass |
| Easy Integration | Maximum Performance |

---

# Part 15 – Security Revision

Remember

```
HTTPS

↓

TLS

↓

TCP

↓

IP
```

TLS

Uses

- Asymmetric Encryption

Then

- Symmetric Encryption

---

# Part 16 – High Availability

Know

- Active-Active
- Active-Passive
- Health Checks
- VRRP
- ECMP
- LACP
- Anycast

---

# Part 17 – Linux Commands

| Command | Purpose |
|----------|----------|
| ip addr | Show IP |
| ip route | Routing Table |
| ip neigh | ARP Cache |
| ip link | Interface Status |
| ss -tulpn | Sockets |
| tcpdump | Packet Capture |
| traceroute | Packet Path |
| ping | Connectivity |
| dig | DNS |
| ethtool -S | NIC Statistics |

---

# Part 18 – 50 Frequently Asked Interview Questions

## TCP/IP

1. Why TCP over UDP?
2. Explain Three-Way Handshake.
3. Why not Two-Way Handshake?
4. Explain Four-Way Close.
5. Why TIME_WAIT?
6. What is MSS?
7. What is MTU?
8. Difference between MTU and MSS?
9. What is Sliding Window?
10. Flow Control vs Congestion Control?

---

## Routing

11. What is Longest Prefix Match?
12. What is CIDR?
13. What is Default Gateway?
14. What is TTL?
15. Why Fragmentation?
16. Static vs Dynamic Routing?
17. OSPF vs BGP?
18. What is ECMP?

---

## Switching

19. Switch vs Router?
20. VLAN?
21. Access Port?
22. Trunk Port?
23. STP?
24. Broadcast Domain?
25. Collision Domain?

---

## Linux Networking

26. What is Socket?
27. socket()?
28. bind()?
29. listen()?
30. accept()?
31. connect()?
32. send()?
33. recv()?
34. Blocking Socket?
35. Non-Blocking Socket?
36. select vs poll vs epoll?
37. Why epoll?
38. What is sk_buff?
39. What is NAPI?
40. What is SoftIRQ?

---

## Advanced

41. What is XDP?
42. What is DPDK?
43. RSS?
44. GRO?
45. GSO?
46. TSO?
47. Checksum Offload?
48. Netfilter?
49. conntrack?
50. eBPF?

---

# Part 19 – 20 Common Debugging Scenarios

| Problem | First Check |
|-----------|------------|
| No Internet | Interface + IP |
| Cannot Ping | Route + ARP |
| DNS Failure | dig |
| Connection Refused | Service Running? |
| TCP Timeout | Firewall / Route |
| Packet Loss | tcpdump |
| High CPU | Interrupts / NAPI |
| Low Throughput | Window Size / MTU |
| Server Slow | Retransmissions |
| Interface Errors | ethtool |

---

# Part 20 – Common Arista Interview Questions

### Networking

- Explain packet flow inside Linux.
- Explain packet flow inside a switch.
- Explain TCP handshake.
- Explain retransmissions.
- Explain NAPI.
- Explain epoll.
- Explain sk_buff.
- Explain XDP.
- Explain DPDK.
- Explain ECMP.

### Linux

- How does accept() work?
- Why does accept() return a new socket?
- Difference between send() and write()?
- How does recv() work?
- Difference between blocking and non-blocking sockets?

### C++

- Implement LRU Cache.
- Thread-safe Queue.
- Producer-Consumer.
- Smart Pointers.
- Move Semantics.
- Virtual Functions.
- Memory Layout.
- Lock-free Concepts.

---

# Part 21 – 10-Minute Revision

Remember only these.

```
OSI

↓

TCP

↓

UDP

↓

DNS

↓

DHCP

↓

ARP

↓

Routing

↓

Switching

↓

Socket

↓

epoll

↓

NAPI

↓

SoftIRQ

↓

sk_buff

↓

XDP

↓

DPDK

↓

TLS

↓

VRRP

↓

LACP

↓

ECMP
```

---

# Part 22 – Final Interview Tips

## During Coding

- Clarify assumptions.
- Start with brute force.
- Discuss complexity.
- Optimize.
- Handle edge cases.
- Test with examples.

---

## During Networking Questions

Always explain

```
WHY

↓

HOW

↓

EXAMPLE

↓

EDGE CASE
```

Example:

Instead of saying

> "TCP uses Sliding Window."

Say

> "TCP uses a sliding window to keep multiple packets in flight, improving throughput by avoiding idle time while waiting for acknowledgments. The sender limits outstanding data based on the receiver's advertised window and congestion control."

Senior interviewers value this style of explanation.

---

# Final Networking Roadmap

```
Ethernet

↓

ARP

↓

IP

↓

Routing

↓

TCP

↓

UDP

↓

DNS

↓

DHCP

↓

Socket API

↓

Linux Networking Stack

↓

epoll

↓

NAPI

↓

SoftIRQ

↓

sk_buff

↓

Netfilter

↓

XDP

↓

DPDK

↓

Load Balancing

↓

High Availability

↓

Security

↓

Debugging
```

---

# Congratulations!

If you've mastered these 14 chapters, you'll have a **strong interview-ready foundation** for senior networking roles.

For **Arista (10–15 YOE)**, however, there are **three advanced topics** that are still worth adding to make this handbook truly exceptional:

1. **Ethernet & Switching ASIC Internals** (MAC learning, CAM/TCAM, packet pipeline, buffer management)
2. **BGP & EVPN/VXLAN** (modern data-center networking, frequently discussed at Arista)
3. **Linux Kernel Source Walkthrough** (how a packet flows through the actual kernel functions like `netif_receive_skb()`, `ip_rcv()`, `tcp_v4_rcv()`, etc.)

These topics are what often separate a strong networking engineer from an outstanding one in senior networking interviews.