# Chapter 19 – Ultimate Arista Interview Revision & 150+ Questions
**Senior C/C++ Linux Networking Handbook**

> **Goal**
>
> This chapter is your **final interview preparation guide**. Read it 1–2 days before the interview. It contains the most common questions asked in **Arista, Cisco, NVIDIA, Broadcom, Juniper, Qualcomm**, and other senior networking interviews.

---

# Part 1 – Complete Networking Flow (30 Seconds)

If an interviewer asks:

> **"Explain how a packet travels from one machine to another."**

Draw this:

```
Application

↓

Socket

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

Switch ASIC

↓

Router

↓

Internet

↓

Router

↓

Switch ASIC

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

IP

↓

TCP

↓

Socket

↓

Application
```

If you can explain this confidently, you've covered half of the networking interview.

---

# Part 2 – 40 Must-Know Networking Questions

## TCP/IP

1. TCP vs UDP
2. Why Three-Way Handshake?
3. Why not Two-Way Handshake?
4. Why Four-Way Close?
5. Why TIME_WAIT?
6. Why CLOSE_WAIT?
7. What is MSS?
8. What is MTU?
9. MSS vs MTU?
10. Flow Control vs Congestion Control?

---

## Routing

11. Longest Prefix Match
12. CIDR
13. TTL
14. ARP
15. Gratuitous ARP
16. Static vs Dynamic Routing
17. OSPF vs BGP
18. ECMP
19. Anycast
20. VRRP

---

## Switching

21. MAC Learning
22. CAM vs TCAM
23. VLAN
24. Trunk Port
25. Access Port
26. STP
27. LACP
28. MLAG
29. Store-and-Forward vs Cut-Through
30. HOL Blocking

---

## Data Center

31. Spine-Leaf
32. Underlay vs Overlay
33. VXLAN
34. VTEP
35. EVPN
36. VNI
37. BGP EVPN
38. East-West Traffic
39. North-South Traffic
40. Anycast Gateway

---

# Part 3 – 30 Linux Networking Questions

1. socket()
2. bind()
3. listen()
4. accept()
5. connect()
6. send()
7. recv()
8. shutdown() vs close()
9. Blocking Socket
10. Non-blocking Socket
11. select()
12. poll()
13. epoll()
14. LT vs ET
15. io_uring
16. NAPI
17. SoftIRQ
18. sk_buff
19. netif_receive_skb()
20. ip_rcv()
21. tcp_v4_rcv()
22. dev_queue_xmit()
23. XDP
24. DPDK
25. GRO
26. GSO
27. TSO
28. Checksum Offload
29. RSS
30. Netfilter

---

# Part 4 – 25 C/C++ Questions Often Combined with Networking

1. Smart pointers
2. Move semantics
3. Rule of Five
4. RAII
5. Virtual functions
6. vtable
7. Templates
8. STL containers
9. std::thread
10. std::mutex
11. std::condition_variable
12. std::atomic
13. Memory ordering
14. Lock-free basics
15. Producer-Consumer
16. Thread Pool
17. LRU Cache
18. Custom Allocator
19. Object Lifetime
20. Lambda expressions
21. std::future
22. std::promise
23. std::async
24. Shared memory issues
25. Race condition debugging

---

# Part 5 – 20 Linux Debugging Questions

| Problem | First Things to Check |
|----------|-----------------------|
| High CPU | top, perf |
| Packet Loss | tcpdump, ethtool |
| Slow Network | ss, netstat, ip route |
| High Latency | ping, traceroute |
| DNS Failure | dig |
| Connection Refused | Service + Port |
| Retransmissions | tcpdump |
| MTU Issue | ip link |
| Interface Down | ip link show |
| RX Drops | ethtool -S |
| TX Drops | ethtool -S |
| Firewall Issue | nftables/iptables |
| ARP Failure | ip neigh |
| Socket Leak | lsof |
| Port Busy | ss -lntp |
| Memory Leak | valgrind (dev), ASan |
| Crash | gdb |
| Kernel Panic | dmesg |
| NIC Driver | dmesg, ethtool |
| Routing Issue | ip route |

---

# Part 6 – Whiteboard Design Questions

You may be asked to design:

- Chat server
- Logging server
- DNS server
- Load balancer
- HTTP proxy
- Layer-4 load balancer
- Rate limiter
- Thread pool
- Packet capture tool
- Network monitoring service

Always explain:

```
Requirements

↓

High-Level Design

↓

Data Structures

↓

Algorithms

↓

Scalability

↓

Failure Handling
```

---

# Part 7 – Packet Debugging Questions

Example questions:

### Packet reaches NIC but application never receives it.

Possible causes

- Firewall drop
- Wrong routing
- Socket not bound
- Port mismatch
- Checksum error
- Application not reading socket

---

### TCP connection established but data not received.

Check

- recv() loop
- epoll logic
- Socket buffer full
- Flow control
- Firewall
- Application bug

---

### High packet drops

Check

- Buffer overflow
- MTU mismatch
- NIC statistics
- Congestion
- Driver issues

---

# Part 8 – Performance Optimization Questions

Interviewers may ask:

How would you improve throughput?

Possible answers

- Enable RSS
- Increase socket buffers
- Tune TCP window sizes
- Use epoll
- Reduce copies
- Use sendfile()
- Use io_uring (where appropriate)
- Enable GRO/GSO/TSO
- Use multiple receive queues
- Improve thread affinity

---

# Part 9 – Senior Behavioral Questions

Typical questions

- Most difficult production bug?
- Biggest design decision?
- A production outage you handled?
- How do you debug kernel issues?
- How do you mentor juniors?
- Biggest technical mistake?
- A disagreement with teammates?
- How do you prioritize production incidents?

Use the **STAR** method:

```
Situation

↓

Task

↓

Action

↓

Result
```

---

# Part 10 – Common Coding Questions

Frequently asked topics

- LRU Cache
- LFU Cache
- Trie
- Binary Tree
- BST Iterator
- Graph BFS/DFS
- Topological Sort
- Producer-Consumer
- Thread-safe Queue
- Circular Buffer
- Ring Buffer
- Consistent Hashing
- Merge Intervals
- Sliding Window
- Binary Search
- Linked List Cycle
- Design HashMap

---

# Part 11 – Interview Flow

### Round 1

- Coding
- Debugging
- Data Structures

---

### Round 2

- Networking
- Linux
- C++
- Projects

---

### Round 3

- Design
- Architecture
- Debugging
- Behavioral

---

# Part 12 – 30-Minute Revision

Review these topics in order:

```
TCP

↓

UDP

↓

ARP

↓

DNS

↓

DHCP

↓

Routing

↓

Switching

↓

Socket API

↓

epoll

↓

NAPI

↓

sk_buff

↓

Netfilter

↓

XDP

↓

DPDK

↓

ASIC

↓

CAM

↓

TCAM

↓

Spine-Leaf

↓

VXLAN

↓

EVPN

↓

MLAG

↓

HA
```

---

# Part 13 – 10-Minute Revision

Remember these keywords:

```
SYN

ACK

FIN

TIME_WAIT

ARP

MAC

CAM

TCAM

VLAN

TCP

UDP

Socket

epoll

NAPI

SoftIRQ

sk_buff

XDP

DPDK

VXLAN

EVPN

MLAG

LACP

ECMP

VRRP
```

---

# Part 14 – What Arista Interviewers Look For

They are not only checking whether your answer is correct.

They evaluate:

- Clear communication
- Structured thinking
- Debugging approach
- Understanding of trade-offs
- Linux internals knowledge
- Networking fundamentals
- Ability to simplify complex systems
- Real production experience

A strong answer usually follows this structure:

```
Problem

↓

Root Cause

↓

Design

↓

Implementation

↓

Trade-offs

↓

Optimization
```

---

# Part 15 – Final Checklist

Before the interview, ensure you can explain:

### Networking

- ✅ TCP/IP
- ✅ UDP
- ✅ ARP
- ✅ DNS
- ✅ DHCP
- ✅ Routing
- ✅ VLAN
- ✅ Switching
- ✅ LACP
- ✅ ECMP
- ✅ VXLAN
- ✅ EVPN
- ✅ MLAG
- ✅ Anycast

### Linux

- ✅ Socket APIs
- ✅ epoll
- ✅ sk_buff
- ✅ NAPI
- ✅ Netfilter
- ✅ XDP
- ✅ DPDK
- ✅ io_uring

### System Design

- ✅ Load Balancer
- ✅ Cache
- ✅ Message Queue
- ✅ Database
- ✅ Thread Pool
- ✅ Scalability
- ✅ High Availability

### C++

- ✅ RAII
- ✅ Smart Pointers
- ✅ Move Semantics
- ✅ Templates
- ✅ Multithreading
- ✅ Atomics
- ✅ Memory Model

---

# Final Advice

When answering technical questions:

1. Clarify assumptions.
2. Draw a diagram.
3. Explain the packet/data flow.
4. Mention trade-offs.
5. Discuss failure scenarios.
6. Suggest optimizations.

Senior interviewers usually value **how you think** as much as **what you know**.

---

# Congratulations!

You now have a complete networking handbook covering:

- Networking fundamentals
- Linux networking internals
- Switch ASICs
- Data center networking
- Kernel packet flow
- Advanced network programming
- High availability
- Security
- Debugging
- Interview revision

For **Arista (10–15 YOE)**, these notes provide an excellent foundation. The next step is to practice **coding problems, Linux debugging scenarios, and mock interviews**, because those skills are what convert knowledge into interview performance.