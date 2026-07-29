# Chapter 7 – DNS, DHCP & NAT
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand how devices obtain an IP address, how domain names are resolved, and how private networks communicate with the Internet. These topics are very common in Arista, Cisco, NVIDIA, Broadcom, Qualcomm, and Linux networking interviews.

---

# 1. DNS (Domain Name System)

## Why Do We Need DNS?

Humans remember names.

```
www.google.com

www.github.com

www.openai.com
```

Computers communicate using IP addresses.

```
142.250.xxx.xxx

140.82.xxx.xxx

104.xxx.xxx.xxx
```

DNS converts

```
Domain Name

↓

IP Address
```

Think of DNS as the **Internet's phone book**.

---

# DNS Resolution Flow

Suppose you enter

```
www.google.com
```

Browser performs

```
Browser

↓

Local DNS Cache

↓

OS Cache

↓

Router Cache (optional)

↓

ISP DNS

↓

Root DNS

↓

.com DNS

↓

google.com Authoritative DNS

↓

IP Address Returned

↓

Browser connects to Server
```

Once the IP is obtained,

TCP connection begins.

---

# DNS Record Types

## A Record

Maps

```
Hostname

↓

IPv4 Address
```

Example

```
www.example.com

↓

192.168.1.20
```

---

## AAAA Record

Maps

```
Hostname

↓

IPv6 Address
```

---

## CNAME

Alias.

Example

```
mail.company.com

↓

server.company.com
```

---

## MX Record

Mail Server

```
company.com

↓

mail.company.com
```

---

## NS Record

Authoritative Name Server.

---

## PTR Record

Reverse Lookup.

```
IP

↓

Hostname
```

---

# DNS Caching

Without caching,

Every website would require a complete DNS lookup.

Instead,

Results are cached.

```
Browser Cache

↓

OS Cache

↓

DNS Server Cache
```

Benefits

- Faster browsing
- Reduced DNS traffic

---

# TTL in DNS

Every DNS record has a

```
TTL
```

Example

```
300 Seconds
```

After TTL expires,

A fresh DNS lookup is required.

---

# Linux Commands

Lookup DNS

```bash
nslookup google.com
```

or

```bash
dig google.com
```

Example

```bash
dig +short google.com
```

---

# DHCP (Dynamic Host Configuration Protocol)

## Why Do We Need DHCP?

Imagine manually configuring every computer.

Need to assign:

- IP Address
- Subnet Mask
- Default Gateway
- DNS Server

For thousands of systems,

this is impractical.

DHCP automatically configures devices.

---

# DHCP Provides

- IP Address
- Subnet Mask
- Default Gateway
- DNS Server
- Lease Time

---

# DHCP DORA Process

One of the most common interview questions.

```
Client

↓

DHCP Discover

↓

Server

↓

DHCP Offer

↓

Client

↓

DHCP Request

↓

Server

↓

DHCP ACK
```

Easy way to remember

```
D

O

R

A
```

Discover

Offer

Request

ACK

---

# DHCP Packet Flow

Client boots.

```
No IP Address
```

Client broadcasts

```
DHCP Discover
```

Server replies

```
DHCP Offer

IP = 192.168.1.100
```

Client accepts

```
DHCP Request
```

Server confirms

```
DHCP ACK
```

Client starts using

```
192.168.1.100
```

---

# DHCP Lease

IP addresses are leased.

Example

```
Lease

24 Hours
```

After some time,

Client renews the lease.

---

# Linux Commands

Display assigned address

```bash
ip addr
```

Display default gateway

```bash
ip route
```

---

# NAT (Network Address Translation)

Very important interview topic.

---

# Why Do We Need NAT?

Private IP addresses cannot be routed on the Internet.

Example

```
192.168.1.20
```

Google cannot reply directly to this address.

A router translates

```
Private IP

↓

Public IP
```

---

# NAT Example

```
Laptop

192.168.1.10

↓

Router

↓

Public IP

49.xx.xx.xx

↓

Internet
```

To Google,

Traffic appears to come from

```
49.xx.xx.xx
```

---

# NAT Flow

```
Laptop

192.168.1.10

↓

Router

↓

Translate Source Address

↓

Public IP

↓

Internet

↓

Reply

↓

Router

↓

Translate Back

↓

Laptop
```

---

# Types of NAT

## Static NAT

One private IP

↓

One public IP

Always the same mapping.

---

## Dynamic NAT

Private IP

↓

Public IP selected from a pool.

---

## PAT (Port Address Translation)

Most common.

Many devices

↓

One Public IP

Different source ports distinguish connections.

Example

```
192.168.1.10:5000

↓

49.xx.xx.xx:60000

----------------

192.168.1.20:5001

↓

49.xx.xx.xx:60001
```

---

# NAT Table

Router maintains a table.

```
Private Address

↓

Public Address

↓

Port
```

Example

```
192.168.1.10:5000

↓

49.xx.xx.xx:60000
```

Replies use this table.

---

# Complete Browser Flow

Suppose

```
www.google.com
```

```
Browser

↓

DNS Lookup

↓

IP Address

↓

TCP Handshake

↓

HTTP GET

↓

Router

↓

NAT

↓

Internet

↓

Google

↓

HTTP Response

↓

Router

↓

Reverse NAT

↓

Browser
```

This is an excellent interview answer.

---

# Linux Networking Flow

```
Application

↓

Socket

↓

TCP

↓

IP

↓

Routing

↓

Ethernet

↓

NIC

↓

Switch

↓

Router

↓

NAT

↓

Internet
```

---

# Common Interview Questions

## Q1 Why do we need DNS?

Humans use names.

Computers use IP addresses.

DNS converts names into IP addresses.

---

## Q2 What happens before a TCP connection?

Normally,

DNS resolution occurs first.

---

## Q3 What is DNS TTL?

The amount of time a DNS record remains cached.

---

## Q4 What is DHCP?

A protocol that automatically assigns network configuration to devices.

---

## Q5 Explain DHCP DORA.

- Discover
- Offer
- Request
- ACK

---

## Q6 Why is DHCP Discover broadcast?

Because the client does not yet know the DHCP server's IP address.

---

## Q7 Why do we need NAT?

Private IP addresses are not routable on the Internet.

NAT enables private networks to communicate with public networks.

---

## Q8 Difference between NAT and PAT?

NAT translates IP addresses.

PAT translates both IP addresses and port numbers, allowing many hosts to share one public IP.

---

## Q9 Can two devices share one public IP?

Yes.

Using PAT.

---

## Q10 Why do home routers use NAT?

To allow multiple devices with private IP addresses to access the Internet through a single public IP address.

---

# Common Mistakes

❌ Thinking DNS establishes connections.

✔ DNS only resolves names to IP addresses.

---

❌ Thinking DHCP assigns MAC addresses.

✔ MAC addresses are assigned by the NIC manufacturer.

DHCP assigns IP configuration.

---

❌ Thinking NAT provides security.

✔ NAT hides private addresses, but it is not a replacement for a firewall.

---

❌ Confusing NAT with Routing.

✔ Routing forwards packets.

✔ NAT modifies packet addresses (and often ports).

---

# Quick Revision

```
Browser

↓

DNS

↓

IP Address

↓

TCP

↓

HTTP

↓

Router

↓

NAT

↓

Internet

↓

Server

↓

Response
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| DNS | Name → IP |
| A Record | IPv4 |
| AAAA Record | IPv6 |
| CNAME | Alias |
| MX | Mail Server |
| DHCP | Automatic IP Assignment |
| DHCP Process | DORA |
| NAT | Private IP → Public IP |
| PAT | Many Devices → One Public IP |
| DNS Tools | dig, nslookup |
| Network Tools | ip addr, ip route |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- DNS resolution process
- Common DNS record types
- DNS caching and TTL
- DHCP and the DORA process
- DHCP leases
- NAT, Static NAT, Dynamic NAT, and PAT
- The complete flow from entering a URL to receiving a webpage
- Basic Linux networking commands for DNS and IP configuration

---

**Next Chapter:** **Switching, VLANs & Routing** – VLANs, trunk ports, access ports, STP, routing tables, longest prefix match, OSPF, BGP, and ECMP (interview-focused).