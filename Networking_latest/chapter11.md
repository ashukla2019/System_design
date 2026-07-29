# Chapter 11 – Network Debugging & Packet Analysis
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Every senior networking engineer is expected to debug network issues quickly. Arista interviews often present debugging scenarios instead of asking only theoretical questions. This chapter teaches the minimum set of Linux tools and debugging approaches you need.

---

# Debugging Methodology

Never randomly run commands.

Always debug layer by layer.

```
Application

↓

Socket

↓

TCP/UDP

↓

IP

↓

Routing

↓

ARP

↓

Ethernet

↓

NIC

↓

Wire
```

Interview Tip

Always explain your thought process while debugging.

---

# Step 1 – Is the Interface Up?

Check interfaces.

```bash
ip link
```

Example

```
eth0: UP

eth1: DOWN
```

If the interface is DOWN,

Nothing else will work.

---

# Step 2 – Check IP Address

```bash
ip addr
```

Example

```
eth0

192.168.1.100/24
```

Questions to ask

- Correct IP?
- Correct subnet?
- Duplicate IP?

---

# Step 3 – Check Routing Table

```bash
ip route
```

Example

```
default via 192.168.1.1

192.168.1.0/24 dev eth0
```

Check

- Default route
- Missing routes
- Wrong gateway

---

# Step 4 – Check Neighbor Table (ARP)

```bash
ip neigh
```

Example

```
192.168.1.1

aa:bb:cc:dd:ee:ff
```

If ARP fails,

Communication cannot continue.

---

# Step 5 – Test Connectivity

## Ping

```bash
ping 192.168.1.1
```

Tests

- Reachability
- Latency
- Packet loss

Remember

Ping uses

```
ICMP
```

not TCP.

---

# Step 6 – Trace the Route

```bash
traceroute google.com
```

Example

```
Laptop

↓

Router

↓

ISP

↓

Google
```

Useful for locating where packets stop.

---

# Step 7 – Check TCP Connections

Modern command

```bash
ss -tulnp
```

Example

```
LISTEN

0.0.0.0:80
```

Older command

```bash
netstat
```

Interview Tip

Prefer **ss** over **netstat** on modern Linux.

---

# Step 8 – Capture Packets

Most important command.

```bash
tcpdump -i eth0
```

Capture only TCP

```bash
tcpdump tcp
```

Capture only port 80

```bash
tcpdump port 80
```

Capture only DNS

```bash
tcpdump port 53
```

Save packets

```bash
tcpdump -w capture.pcap
```

Open the `.pcap` file in Wireshark for detailed analysis.

---

# Wireshark

Industry-standard packet analyzer.

You can inspect

- Ethernet
- IP
- TCP
- UDP
- DNS
- HTTP
- TLS

Follow an entire TCP conversation using **Follow TCP Stream**.

---

# Reading a TCP Handshake

In Wireshark

```
Client

↓

SYN

↓

Server

↓

SYN + ACK

↓

Client

↓

ACK
```

If SYN appears repeatedly,

The server may be unreachable or a firewall may be blocking traffic.

---

# Reading a TCP Reset

```
Client

↓

SYN

↓

RST
```

Usually indicates

- Service not running
- Wrong port
- Connection refused

---

# Reading Retransmissions

Example

```
Packet 10

↓

Packet 11

↓

Packet 11 (Retransmission)
```

Possible reasons

- Packet loss
- Congestion
- Receiver not responding

---

# DNS Debugging

Lookup

```bash
dig google.com
```

Short output

```bash
dig +short google.com
```

Check

- DNS server reachable?
- Correct IP returned?
- High lookup latency?

---

# ARP Debugging

Symptoms

```
Ping Fails

↓

No ARP Entry
```

Check

```bash
ip neigh
```

Possible causes

- Wrong VLAN
- Wrong subnet
- Switch issue

---

# Interface Statistics

```bash
ip -s link
```

Look for

- RX Errors
- TX Errors
- Dropped Packets

---

# NIC Statistics

```bash
ethtool -S eth0
```

Useful counters

- CRC Errors
- Drops
- Missed Packets
- Buffer Errors

---

# Socket Debugging

Show listening ports

```bash
ss -l
```

Show established connections

```bash
ss -t
```

Show process owning a socket

```bash
ss -tulpn
```

---

# Common Linux Network Tools

| Tool | Purpose |
|------|---------|
| ip | Network Configuration |
| ss | Socket Information |
| ping | Connectivity |
| traceroute | Path Discovery |
| tcpdump | Packet Capture |
| Wireshark | Packet Analysis |
| dig | DNS Lookup |
| ip neigh | ARP Cache |
| ethtool | NIC Information |

---

# Debugging Scenario 1

## Problem

Cannot access website.

Approach

```
Interface UP?

↓

IP Assigned?

↓

Gateway Correct?

↓

DNS Working?

↓

Ping Gateway?

↓

Ping Server?

↓

TCP Handshake?

↓

HTTP Response?
```

---

# Debugging Scenario 2

## Problem

TCP Connection Times Out

Possible reasons

- Firewall
- Wrong Route
- Server Down
- Packet Drops
- MTU Issue

Check

```
tcpdump

↓

SYN Sent?

↓

SYN+ACK Returned?
```

---

# Debugging Scenario 3

## Problem

Application is Slow

Possible reasons

- Packet loss
- High latency
- DNS delay
- Small receive window
- Congestion

Investigate using

- `ss`
- `tcpdump`
- Wireshark

---

# Debugging Scenario 4

## Problem

Ping Works

SSH Fails

Likely causes

- SSH service not running
- Firewall blocking port 22
- Incorrect SSH configuration

---

# Debugging Scenario 5

## Problem

Packets Reach NIC

Application Receives Nothing

Possible causes

```
NIC

↓

Driver

↓

Firewall

↓

Socket

↓

Application Bug
```

Capture packets and determine where they stop.

---

# Interview Questions

## Q1 My server cannot be reached. What do you check first?

1. Interface status
2. IP address
3. Routing
4. ARP
5. Firewall
6. Packet capture

---

## Q2 Why use tcpdump?

To observe the actual packets on the wire and determine where communication fails.

---

## Q3 Why use Wireshark if tcpdump exists?

`tcpdump` captures packets.

Wireshark provides powerful graphical decoding and protocol analysis.

---

## Q4 Ping works but HTTP doesn't. Why?

Possible reasons

- Web server not running
- Port blocked
- Firewall
- Application issue

---

## Q5 Why does traceroute work?

It sends packets with increasing TTL values and observes ICMP Time Exceeded responses from routers.

---

## Q6 What does "Connection Refused" usually mean?

The destination host is reachable, but no application is accepting connections on that port (or a reset is returned).

---

## Q7 What does a TCP retransmission indicate?

Usually packet loss, congestion, or delayed acknowledgments.

---

# Common Mistakes

❌ Starting with Wireshark immediately.

✔ First verify interface, IP, routing, and ARP.

---

❌ Assuming ping guarantees the application works.

✔ Ping only verifies ICMP connectivity.

---

❌ Ignoring routing.

✔ Many connectivity issues are caused by incorrect routes.

---

❌ Assuming DNS is always the problem.

✔ Verify each network layer systematically.

---

# Complete Troubleshooting Flow

```
Application

↓

Socket

↓

TCP

↓

IP

↓

Route

↓

ARP

↓

Ethernet

↓

NIC

↓

Switch

↓

Router

↓

Destination
```

---

# Quick Revision

```
ip link

↓

ip addr

↓

ip route

↓

ip neigh

↓

ping

↓

traceroute

↓

ss

↓

tcpdump

↓

Wireshark

↓

ethtool
```

---

# Interview Cheat Sheet

| Problem | Tool |
|----------|------|
| Interface Down | ip link |
| Wrong IP | ip addr |
| Route Missing | ip route |
| ARP Issue | ip neigh |
| Connectivity | ping |
| Path Issue | traceroute |
| Socket State | ss |
| Packet Capture | tcpdump |
| Protocol Analysis | Wireshark |
| NIC Errors | ethtool |

---

# Chapter Summary

After completing this chapter, you should be able to:

- Follow a structured debugging methodology
- Use essential Linux networking commands
- Capture and analyze packets with `tcpdump`
- Read TCP handshakes, resets, and retransmissions
- Diagnose DNS, ARP, routing, and socket issues
- Explain your debugging process clearly in interviews

---

## What's Next?

Only **three networking chapters** remain to complete this handbook:

1. **Network Security** (TLS, SSL, HTTPS, Firewalls, VPN, IPSec, ACLs)
2. **High Availability & Load Balancing** (LACP, VRRP, ECMP, Anycast, HAProxy, Load Balancers)
3. **Senior Networking Interview Revision** (50+ real interview questions, packet-flow diagrams, debugging scenarios, and one-page cheat sheets)

These final chapters will make the handbook essentially complete for **10–15 years of experience** networking interviews.