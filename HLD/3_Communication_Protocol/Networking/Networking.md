# Senior Embedded Networking Interview Notes

## Target Companies

This document is designed for Senior Embedded Networking interviews at:

- Cisco
- Juniper Networks
- Arista Networks
- Broadcom
- NVIDIA Networking
- Qualcomm
- Intel
- Marvell
- Nokia
- Ericsson
- AWS Networking
- Google Networking
- Microsoft Azure Networking

---

# Table of Contents

1. Networking Fundamentals
2. OSI Model
3. TCP/IP Model
4. Ethernet Fundamentals
5. MAC and PHY
6. Packet Flow
7. DMA in Networking
8. Interrupt vs Polling
9. ARP
10. IPv4
11. IPv6
12. Subnetting
13. ICMP
14. TCP
15. UDP
16. Socket Programming
17. DNS
18. DHCP
19. NAT
20. Routing
21. Switching
22. VLAN
23. STP
24. Routing Protocols
25. OSPF
26. BGP
27. Linux Networking Stack
28. Network Drivers
29. Packet Processing
30. DPDK
31. eBPF
32. Network Debugging
33. Wireshark
34. Embedded Networking Design
35. IoT Networking
36. Network Security
37. TLS
38. Performance Optimization
39. Interview Questions
40. System Design Questions


---

# 1. Networking Fundamentals

## What is Computer Networking?

Computer networking is the communication between multiple devices to exchange data.

Example:

```
Sensor Device

      |
      |
 Ethernet / Wi-Fi

      |
      |

Gateway

      |
      |

Cloud Server
```

Embedded networking examples:

- IoT devices
- Routers
- Switches
- Automotive ECUs
- Industrial controllers
- Network appliances


---

# 2. Network Components


## End Device

A device that generates or consumes data.

Examples:

- Embedded controller
- Laptop
- Server
- IoT sensor


---

## NIC (Network Interface Card)

Hardware interface that connects a device to a network.

Examples:

- Ethernet controller
- Wi-Fi chipset
- Network adapter


Architecture:

```
Application

      |

Network Stack

      |

Driver

      |

NIC Hardware

      |

Physical Medium
```


---

# Router

A router connects different networks.

Example:

```
LAN

192.168.1.0/24

        |
        |
      Router

        |
        |

Internet
```

Works at:

```
Layer 3 - Network Layer
```

Responsibilities:

- IP forwarding
- Routing decisions
- Packet filtering


---

# Switch

Connects devices inside the same network.

Example:

```
Device A
    |
    |
 Switch
    |
    |
Device B
```

Works at:

```
Layer 2 - Data Link Layer
```

Uses:

- MAC addresses
- MAC address table


---

# 3. Packet Concept


Application data:

```
Temperature = 25.5
```

is converted into:

```
+----------------+
| Ethernet Header|
+----------------+
| IP Header      |
+----------------+
| TCP Header     |
+----------------+
| Application    |
| Data           |
+----------------+
```


Each layer adds its own header.

This process is:

```
Encapsulation
```


Receiver removes headers:

```
Decapsulation
```


---

# 4. Bandwidth vs Latency


## Bandwidth

Maximum amount of data transferred per second.

Example:

```
1 Gbps Ethernet
```


## Latency

Time taken for data to travel.

Example:

```
Sensor

 |

5 ms

 |

Server
```


Important for:

- Automotive systems
- Industrial control
- Real-time applications


---

# 5. Throughput


Actual useful data transferred.

Example:

```
Bandwidth = 1 Gbps

Actual throughput = 800 Mbps
```

Reasons:

- Protocol overhead
- Packet processing
- Retransmission


---

# 6. Packet Loss


Packets can be lost because of:

- Network congestion
- Hardware errors
- Signal problems
- Buffer overflow


TCP handles loss:

```
Packet lost

      |

Retransmission

      |

Data recovered
```


UDP:

```
Packet lost

      |

No recovery
```


---

# 7. OSI Model


The OSI model has 7 layers.


```
Layer 7  Application

Layer 6  Presentation

Layer 5  Session

Layer 4  Transport

Layer 3  Network

Layer 2  Data Link

Layer 1  Physical
```


---

# Layer 1: Physical Layer


Responsible for:

- Bit transmission
- Electrical signals
- Optical signals
- Radio communication


Examples:

- Ethernet PHY
- Fiber
- Wi-Fi radio


Data unit:

```
Bits
```


---

# Layer 2: Data Link Layer


Responsibilities:

- MAC addressing
- Frame creation
- Error detection


Protocols:

- Ethernet
- Wi-Fi MAC


Data unit:

```
Frame
```


---

# Layer 3: Network Layer


Responsibilities:

- IP addressing
- Routing
- Packet forwarding


Protocols:

- IPv4
- IPv6
- ICMP


Data unit:

```
Packet
```


---

# Layer 4: Transport Layer


Responsibilities:

- End-to-end communication
- Reliability
- Flow control
- Congestion control


Protocols:

- TCP
- UDP


Data unit:

```
Segment
```


---

# Layer 5-7


## Session Layer

Maintains communication sessions.


## Presentation Layer

Handles:

- Encryption
- Compression
- Data formatting


## Application Layer

Protocols:

- HTTP
- DNS
- DHCP
- MQTT
- FTP


---

# 8. TCP/IP Model


Practical Internet model:


```
Application Layer

Transport Layer

Internet Layer

Network Access Layer
```


Mapping:


```
OSI                 TCP/IP


Application     ->  Application


Transport       ->  Transport


Network         ->  Internet


Data Link       |
                |
Physical        -> Network Access
```


---

# 9. Ethernet Fundamentals


Ethernet is the most common wired networking technology.


Standard:

```
IEEE 802.3
```


Used in:

- Servers
- Routers
- Switches
- Embedded devices


---

# 10. Ethernet Frame


Structure:


```
+----------------+
| Preamble       |
+----------------+
| Destination MAC|
+----------------+
| Source MAC     |
+----------------+
| EtherType      |
+----------------+
| Payload        |
+----------------+
| CRC            |
+----------------+
```


---

# 11. MAC Address


MAC:

Media Access Control address


Size:

```
48 bits
```


Example:

```
00:1A:2B:3C:4D:5E
```


Used for:

- Local network communication
- Switch forwarding


---

# 12. MAC vs PHY


## MAC


Responsible for:

- Ethernet frame creation
- Address handling
- CRC
- DMA interface


## PHY


Responsible for:

- Signal conversion
- Electrical communication
- Auto negotiation


Architecture:

```
CPU

 |

MAC

 |

PHY

 |

Cable
```


---

# 13. Embedded Ethernet Architecture


Typical embedded flow:


```
Application

      |

TCP/IP Stack

      |

Ethernet Driver

      |

DMA Engine

      |

MAC Controller

      |

PHY

      |

Ethernet Cable
```


---

# 14. DMA in Networking


Without DMA:


```
NIC

 |

CPU copies data

 |

Memory
```


Problem:

- CPU overhead


With DMA:


```
NIC

 |

DMA

 |

Memory
```


Benefits:

- Higher throughput
- Lower CPU utilization


---

# 15. Interrupt vs Polling


## Interrupt Based


Flow:

```
Packet arrives

      |

Hardware Interrupt

      |

CPU processes packet
```


Advantages:

- Low CPU usage


---

## Polling


Flow:

```
while(1)
{
 check_packet();
}
```


Advantages:

- Predictable latency
- Used in high-performance networking


---

# Common Interview Questions


## Q1. Explain packet flow in an embedded Ethernet device.

Answer:

```
Application

↓

Socket Layer

↓

TCP/IP Stack

↓

Network Driver

↓

DMA

↓

MAC

↓

PHY

↓

Ethernet Cable
```


---

## Q2. Difference between MAC and PHY?

MAC:

- Handles Ethernet frames
- Performs addressing
- Interfaces with software


PHY:

- Converts digital signals into electrical signals


---

## Q3. Why use DMA in networking?

Answer:

DMA allows the network controller to transfer packets directly to memory without CPU copying, improving throughput and reducing CPU load.


---

## Q4. Interrupt vs Polling?

Interrupt:

- Event-driven
- Efficient CPU usage


Polling:

- Continuous checking
- Better deterministic latency


---
# Part 2: ARP, IP, IPv4, IPv6, Subnetting, ICMP, TCP, UDP, Socket Programming

---

# 16. ARP (Address Resolution Protocol)

## What is ARP?

ARP maps:

```
IP Address  →  MAC Address
```

It is used inside a local network.

Example:

Device wants to send data to:

```
Destination IP:

192.168.1.20
```

But Ethernet requires:

```
Destination MAC Address
```

ARP finds the MAC address.

---

# ARP Working


Network:

```
Device A

IP:
192.168.1.10

MAC:
AA-AA-AA-AA-AA-AA


Device B

IP:
192.168.1.20

MAC:
BB-BB-BB-BB-BB-BB
```


Device A sends ARP Request:

```
Who has 192.168.1.20?

Tell 192.168.1.10
```


Broadcast:

```
Destination MAC:

FF:FF:FF:FF:FF:FF
```


Device B replies:

```
192.168.1.20

is

BB-BB-BB-BB-BB-BB
```


Device A stores:

```
ARP Cache

192.168.1.20
      |
      |
BB-BB-BB-BB-BB-BB
```

---

# ARP Cache

Devices maintain an ARP table.

Linux command:

```bash
arp -a
```

or:

```bash
ip neigh
```

Example:

```
192.168.1.20
    |
    |
AA:BB:CC:DD:EE:FF
```

---

# ARP Problems

## ARP Spoofing

Attacker sends fake ARP messages.

Example:

```
192.168.1.1

belongs to

Attacker MAC
```

Result:

Traffic redirected.

Protection:

- Static ARP
- Dynamic ARP Inspection
- Encryption


---

# 17. IP Protocol

IP works at:

```
Layer 3
```

Responsibilities:

- Addressing
- Routing
- Packet forwarding


IP is:

- Connectionless
- Best effort delivery


Meaning:

IP does not guarantee:

- Delivery
- Ordering
- Error recovery


---

# IP Packet Structure


```
+----------------+
| Version        |
+----------------+
| Header Length  |
+----------------+
| Source IP      |
+----------------+
| Destination IP |
+----------------+
| Payload        |
+----------------+
```


---

# 18. IPv4


IPv4 address size:

```
32 bits
```


Example:

```
192.168.1.10
```


Binary:

```
11000000.10101000.00000001.00001010
```


---

# IPv4 Address Classes

Traditional classes:


## Class A

Large networks.

Range:

```
1.x.x.x
-
126.x.x.x
```


## Class B

Medium networks.

Range:

```
128.x.x.x
-
191.x.x.x
```


## Class C

Small networks.

Range:

```
192.x.x.x
-
223.x.x.x
```


Modern networks use:

```
CIDR
```

instead of classes.

---

# Private IPv4 Addresses


Used inside local networks.

## Class A

```
10.0.0.0/8
```


## Class B

```
172.16.0.0/12
```


## Class C

```
192.168.0.0/16
```


Example:

Home router:

```
192.168.1.1
```

---

# Public vs Private IP


## Public IP

Internet reachable.

Example:

```
8.8.8.8
```


## Private IP

Internal network only.

Example:

```
192.168.1.10
```

Uses NAT to access Internet.

---

# 19. IPv6


IPv6 was created because IPv4 addresses were exhausted.


IPv6 size:

```
128 bits
```


Example:

```
2001:0db8:85a3::8a2e:0370:7334
```


---

# IPv6 Advantages


## Huge Address Space

IPv4:

```
2^32 addresses
```


IPv6:

```
2^128 addresses
```


---

## No Broadcast

IPv6 uses:

```
Multicast
```


---

## Better Auto Configuration

Uses:

- SLAAC
- DHCPv6


---

# IPv4 vs IPv6


| IPv4 | IPv6 |
|-|-|
|32-bit address|128-bit address|
|Broadcast supported|No broadcast|
|Manual configuration common|Auto configuration|
|NAT commonly used|Less need for NAT|


---

# 20. Subnetting


Subnetting divides a network into smaller networks.


Example:


Network:

```
192.168.1.0/24
```


Means:

```
First 24 bits = Network

Last 8 bits = Host
```


---

# CIDR Notation


CIDR:

Classless Inter-Domain Routing


Example:

```
192.168.1.0/24
```


Meaning:

```
Network bits = 24

Host bits = 8
```


Hosts:

```
2^8 - 2

= 254 usable hosts
```


---

# Common CIDR Examples


## /24


```
255.255.255.0
```


Hosts:

```
254
```


---

## /16


```
255.255.0.0
```


Hosts:

```
65534
```


---

## /30


Used for point-to-point links.


Hosts:

```
2
```


---

# Interview Question

## How many hosts in /26?


Calculation:

```
Host bits:

32 - 26 = 6
```


Hosts:

```
2^6 - 2

= 62
```


---

# 21. ICMP


ICMP:

Internet Control Message Protocol


Used for:

- Error reporting
- Network diagnostics


Works with IP.


---

# ICMP Examples


## Ping


Command:

```bash
ping google.com
```


Uses:

```
ICMP Echo Request

ICMP Echo Reply
```


---

## Traceroute


Shows path packets take.


Example:

```
Device

 |

Router 1

 |

Router 2

 |

Server
```


Uses:

- ICMP
- TTL expiration


---

# 22. TCP Protocol


TCP:

Transmission Control Protocol


Provides:

- Reliable communication
- Ordered delivery
- Error recovery
- Flow control
- Congestion control


Used by:

- HTTP
- HTTPS
- SSH
- FTP


---

# TCP Connection


TCP uses:

```
Three Way Handshake
```


Flow:


Client:

```
SYN
```

↓

Server:

```
SYN + ACK
```

↓

Client:

```
ACK
```


Connection established.


---

# TCP Header


Contains:


```
Source Port

Destination Port

Sequence Number

Acknowledgment Number

Flags

Window Size
```


---

# TCP Reliability


## Sequence Number


Tracks packet order.


Example:


Packet 1:

```
Seq=100
```


Packet 2:

```
Seq=200
```


---

## Acknowledgement


Receiver confirms:


```
ACK=300
```


Meaning:

"I received data until byte 299"


---

# TCP Retransmission


If packet lost:


```
Sender

 |

Packet

X

Lost


Receiver does not ACK


Sender retransmits
```


---

# TCP Flow Control


Prevents receiver overload.


Uses:

```
Receive Window
```


Example:

Receiver says:

```
I can accept 10KB
```

Sender adjusts transmission.

---

# TCP Congestion Control


Prevents network congestion.


Techniques:

- Slow Start
- Congestion Avoidance
- Fast Retransmit


---

# TCP States


Important states:


```
CLOSED

LISTEN

SYN_SENT

SYN_RECEIVED

ESTABLISHED

FIN_WAIT

TIME_WAIT
```


---

# 23. UDP Protocol


UDP:

User Datagram Protocol


Provides:

- Fast communication
- Low overhead


No:

- Reliability
- Ordering
- Retransmission


---

# UDP Header


Small header:


```
Source Port

Destination Port

Length

Checksum
```


---

# TCP vs UDP


| TCP | UDP |
|-|-|
|Reliable|Best effort|
|Connection oriented|Connectionless|
|Higher overhead|Low overhead|
|Ordered data|No ordering|
|Slower|Faster|


---

# UDP Use Cases


- Video streaming
- Gaming
- DNS
- Voice communication
- IoT telemetry


---

# Embedded Example


Sensor:

```
Temperature update every 100ms
```


UDP may be preferred because:

- Latest data matters
- Old packets are useless


---

# 24. Socket Programming


Socket is an API for network communication.


Architecture:


```
Application

     |

Socket API

     |

TCP/UDP

     |

IP

     |

Network Driver

     |

Hardware
```


---

# TCP Socket Flow


Server:


```
socket()

bind()

listen()

accept()

recv()

send()

close()
```


Client:


```
socket()

connect()

send()

recv()

close()
```


---

# UDP Socket Flow


Server:


```
socket()

bind()

recvfrom()

sendto()
```


Client:


```
socket()

sendto()

recvfrom()
```


---

# Important Socket Concepts


## Port Number


Identifies application.


Examples:


HTTP:

```
80
```


HTTPS:

```
443
```


SSH:

```
22
```


---

## IP + Port


Creates endpoint:


Example:


```
192.168.1.10:5000
```


Called:

```
Socket Address
```


---

# Embedded Networking Interview Questions


## Q1. Difference between TCP and UDP?


Answer:


TCP provides reliable ordered communication using acknowledgements and retransmissions.

UDP provides faster communication with lower overhead but no reliability.


---

## Q2. Explain TCP handshake.


Answer:


Client sends SYN.

Server replies SYN-ACK.

Client sends ACK.

Connection established.


---

## Q3. What happens when an IP packet reaches a device?


Flow:


```
Ethernet Frame Received

↓

MAC checks destination

↓

IP layer checks destination IP

↓

TCP/UDP processes packet

↓

Application receives data
```


---

## Q4. Difference between MAC and IP?


MAC:

- Layer 2 address
- Local network communication


IP:

- Layer 3 address
- Routing between networks


---

# Part 3: DNS, DHCP, NAT, Routing, Switching, VLAN, STP, OSPF, BGP

---

# 25. DNS (Domain Name System)

## What is DNS?

DNS converts human-readable names into IP addresses.

Example:

```
www.google.com

        |

        ↓

142.250.x.x
```

DNS works at:

```
Application Layer
```

Protocol:

```
UDP Port 53

TCP Port 53
```

---

# DNS Working


User enters:

```
www.example.com
```

Flow:


```
Application

     |

DNS Resolver

     |

Root DNS Server

     |

TLD Server

(.com)

     |

Authoritative DNS Server

     |

IP Address Returned
```


Example:


```
example.com

↓

93.184.216.34
```


---

# DNS Record Types


## A Record

Maps domain to IPv4.


Example:

```
example.com

A

192.168.1.10
```


---

## AAAA Record

Maps domain to IPv6.


Example:

```
example.com

AAAA

2001:db8::1
```


---

## CNAME

Alias for another domain.


Example:


```
www.example.com

↓

example.com
```


---

## MX Record

Mail server information.


---

## TXT Record

Stores text information.


Used for:

- SPF
- Domain verification


---

# DNS Cache


DNS responses are cached to improve speed.


Cache locations:


```
Browser Cache

      |

OS Cache

      |

Router Cache

      |

DNS Resolver Cache
```


Benefits:

- Faster lookup
- Reduced DNS traffic


---

# DNS Interview Question

## What happens when you type google.com in browser?


Answer:


```
Browser checks DNS cache

↓

OS checks DNS cache

↓

DNS query sent

↓

IP address received

↓

TCP connection established

↓

TLS handshake

↓

HTTP request sent

↓

Response received
```


---

# 26. DHCP

DHCP:

Dynamic Host Configuration Protocol


Purpose:

Automatically assigns:


- IP address
- Subnet mask
- Gateway
- DNS server


Protocol:

```
UDP Port 67
Server

UDP Port 68
Client
```


---

# DHCP Process

Called:

```
DORA
```


## 1. Discover


Client broadcasts:


```
I need an IP address
```


---

## 2. Offer


Server replies:


```
You can use:

192.168.1.20
```


---

## 3. Request


Client accepts:


```
I want 192.168.1.20
```


---

## 4. ACK


Server confirms:


```
IP assigned
```


---

# DHCP Flow


```
Client

 |

DHCP Discover

 |

Server

 |

DHCP Offer

 |

Client

 |

DHCP Request

 |

Server

 |

DHCP ACK
```


---

# Embedded DHCP Example


IoT device boots:


```
Power ON

↓

DHCP Request

↓

Gets IP Address

↓

Connects to Cloud
```


---

# 27. NAT


NAT:

Network Address Translation


Purpose:

Convert private IP addresses into public IP addresses.


Example:


Private network:


```
Device

192.168.1.10
```


Router converts:


```
192.168.1.10

        |

        ↓

Public IP

45.x.x.x
```


---

# Why NAT is Needed?


IPv4 addresses are limited.


Without NAT:

Every device needs public IP.


With NAT:


```
100 devices

     |

One public IP
```


---

# NAT Types


## Static NAT


One private IP maps to one public IP.


```
192.168.1.10

↓

50.10.10.10
```


---

## Dynamic NAT


Uses a pool of public addresses.


---

## PAT (Port Address Translation)


Most common.


Multiple devices share one public IP using ports.


Example:


```
Device A

192.168.1.10:5000


Device B

192.168.1.11:6000


        |

        |

Router


        |

45.1.1.1
```


Router maintains:


```
IP + Port Mapping Table
```


---

# NAT Interview Question

## Difference between NAT and Router?


Router:

- Moves packets between networks


NAT:

- Modifies IP addresses


---

# 28. Routing Fundamentals


## What is Routing?


Routing is selecting the best path for packets to reach destination.


Example:


```
Computer

 |

Router

 |

Internet

 |

Server
```


---

# Router Components


A router contains:


```
Routing Table

        |

Routing Protocol

        |

Forwarding Engine

        |

Network Interfaces
```


---

# Routing Table


Contains:


```
Destination Network

Next Hop

Interface

Metric
```


Example:


```
Destination:

10.0.0.0/24


Next Hop:

192.168.1.1
```


---

# Packet Forwarding


Packet arrives:


```
Destination IP:

10.0.0.5
```


Router checks:


```
Routing Table
```


Finds:


```
10.0.0.0/24

↓

Interface eth1
```


Packet forwarded.


---

# Longest Prefix Match


Routers select the most specific route.


Example:


Routes:


```
10.0.0.0/8

10.1.0.0/16
```


Destination:


```
10.1.2.5
```


Selected:

```
10.1.0.0/16
```


because it is more specific.


---

# Static Routing


Routes manually configured.


Example:


```
Destination:

192.168.2.0/24


Next Hop:

192.168.1.1
```


Advantages:

- Simple
- Predictable


Disadvantages:

- Not scalable


---

# Dynamic Routing


Routers automatically exchange routes.


Protocols:

- OSPF
- BGP
- RIP


Advantages:

- Automatic recovery
- Scalable


---

# 29. Switching


Switch works at:


```
Layer 2
```


Uses:

```
MAC Address Table
```


---

# Switch Learning


Initially:


```
Empty MAC Table
```


Frame arrives:


```
Source MAC:

AA-AA-AA
```


Switch learns:


```
AA-AA-AA

Port 1
```


---

# Switch Forwarding


Destination MAC:


```
BB-BB-BB
```


Switch checks table:


```
BB-BB-BB

Port 5
```


Forward only to Port 5.


---

# Unknown Destination


If MAC unknown:


Switch floods:


```
All ports except source
```


---

# 30. VLAN


VLAN:

Virtual Local Area Network


Purpose:

Create logical networks inside one physical switch.


Example:


Physical switch:


```
Port 1
Port 2
Port 3
Port 4
```


Create:


```
VLAN 10

Engineering


VLAN 20

Finance
```


Devices are isolated.


---

# VLAN Benefits


- Security
- Network segmentation
- Reduced broadcast traffic


---

# VLAN Tagging


Standard:


```
IEEE 802.1Q
```


Adds VLAN tag:


```
Ethernet Frame

+

VLAN ID
```


---

# Access Port


Carries one VLAN.


Example:


```
PC

 |

Access Port

 |

VLAN 10
```


---

# Trunk Port


Carries multiple VLANs.


Example:


```
Switch A

 |

Trunk Link

 |

Switch B
```


Carries:


```
VLAN 10

VLAN 20

VLAN 30
```


---

# 31. STP (Spanning Tree Protocol)


Problem:

Network loops.


Example:


```
Switch A

   |

Switch B

   |

Switch C

   |

Switch A
```


Creates loop.


---

# STP Purpose


Prevents Layer 2 loops.


Standard:


```
IEEE 802.1D
```


---

# STP Working


Selects:


## Root Bridge


The central switch.


---

## Blocking Ports


Unused paths are blocked.


Example:


```
Active Path


Switch A

 |

Switch B



Backup Path

Switch C

(Blocked)
```


---

# 32. OSPF


OSPF:

Open Shortest Path First


Type:

```
Link State Routing Protocol
```


Used inside:

```
Enterprise Networks
```


---

# OSPF Features


- Fast convergence
- Scalable
- Uses cost metric


---

# OSPF Working


Routers exchange:


```
Link State Advertisements

(LSA)
```


Each router builds:


```
Network Map
```


Runs:


```
Shortest Path First Algorithm

(Dijkstra)
```


---

# OSPF Metric


Uses:

```
Cost
```


Usually based on:

```
Bandwidth
```


---

# OSPF Areas


Large networks divided into:


```
Area 0

Backbone Area
```


Other areas connect to Area 0.


---

# 33. BGP


BGP:

Border Gateway Protocol


Used between:

```
Autonomous Systems
```


Example:


```
ISP A

      |

     BGP

      |

ISP B
```


---

# BGP Type


```
Path Vector Protocol
```


---

# BGP Uses


Internet routing.


Examples:

- ISPs
- Cloud providers
- Large enterprises


---

# BGP Attributes


Important:


## AS Path

Path through autonomous systems.


## Next Hop

Next router.


## Local Preference

Preferred exit path.


---

# OSPF vs BGP


| OSPF | BGP |
|-|-|
|Inside organization|Between organizations|
|Link state|Path vector|
|Fast convergence|Internet scale|
|Uses cost|Uses policies|


---

# Senior Interview Questions


## Q1. Explain complete packet journey.


Answer:


```
Application

↓

DNS Lookup

↓

TCP Connection

↓

IP Packet Creation

↓

Router Lookup

↓

Switch Forwarding

↓

Destination NIC

↓

Application Receives Data
```


---

## Q2. Difference between Switch and Router?


Switch:

- Layer 2
- Uses MAC address
- Same network communication


Router:

- Layer 3
- Uses IP address
- Connects networks


---

## Q3. Explain VLAN.


Answer:

VLAN creates multiple logical networks on the same physical switch by tagging Ethernet frames using IEEE 802.1Q.


---

## Q4. OSPF vs BGP?


OSPF:

- Internal routing
- Enterprise networks


BGP:

- Internet routing
- Autonomous systems


---
# Part 4: Network Device Internals, Packet Processing, Linux Networking Stack, Drivers, DMA, DPDK, eBPF

---

# 34. Network Device Architecture

Networking devices like routers and switches are high-performance embedded systems.

Examples:

- Cisco routers
- Juniper routers
- Arista switches
- Data center switches
- Network processors


A simplified architecture:


```
                Control Plane

                    |
                    |

            CPU / Embedded Processor

                    |
                    |

              Network Operating System

                    |
                    |

              Forwarding Plane

                    |
                    |

              ASIC / NPU

                    |
                    |

             Ethernet Interfaces

                    |
                    |

                  PHY
```


---

# 35. Control Plane vs Data Plane


## Control Plane


Responsible for decisions.


Examples:

- Routing protocols
- Configuration
- Management


Runs:

- OSPF
- BGP
- STP


Example:

```
Where should packet go?
```


---

## Data Plane


Responsible for forwarding packets.


Example:


```
Packet arrives

↓

Lookup destination

↓

Forward packet
```


Implemented using:

- ASIC
- FPGA
- Network Processor


---

# Control Plane vs Data Plane


| Control Plane | Data Plane |
|-|-|
|Makes decisions|Executes decisions|
|Slow path|Fast path|
|Runs routing protocols|Forwards packets|
|CPU based|ASIC/NPU based|


---

# 36. Router Internal Architecture


A router contains:


```
                CPU

                 |

          Routing Software

                 |

          Routing Table

                 |

        Forwarding Information Base

                 |

              ASIC

                 |

          Network Interfaces
```


---

# 37. Routing Table vs FIB


## Routing Table


Contains routes learned from:


- Static configuration
- OSPF
- BGP


Example:


```
10.0.0.0/24

via

192.168.1.1
```


---

## FIB (Forwarding Information Base)


Optimized table used for packet forwarding.


Purpose:

Fast lookup.


Example:


```
Destination IP

        |

Longest Prefix Match

        |

Output Interface
```


---

# 38. Packet Forwarding Pipeline


High-performance switches process packets in stages.


Example:


```
Packet Arrival

      |

Ingress Interface

      |

Packet Parsing

      |

Header Lookup

      |

ACL Check

      |

Routing Lookup

      |

QoS Processing

      |

Queueing

      |

Egress Interface

      |

Packet Transmission
```


---

# 39. Packet Processing Steps


## Step 1: Packet Reception


PHY receives electrical signal.


```
Cable

 |

PHY

 |

MAC
```


---

## Step 2: Frame Validation


MAC checks:


- Destination MAC
- CRC
- Frame size


---

## Step 3: Packet Parsing


Hardware extracts:


```
Ethernet Header

IP Header

TCP/UDP Header
```


---

## Step 4: Lookup


Router checks:


```
Destination IP
```


Search:

```
FIB Table
```


---

## Step 5: Forwarding


Packet sent to:


```
Output Port
```


---

# 40. ASIC in Networking


ASIC:

Application Specific Integrated Circuit


Used for:

- Packet forwarding
- Switching
- Encryption


Advantages:

- Extremely fast
- Low latency
- Low power


---

# CPU vs ASIC


| CPU | ASIC |
|-|-|
|General purpose|Specialized|
|Flexible|Fixed function|
|Slower|Very fast|
|Software controlled|Hardware pipeline|


---

# 41. Network Processor Unit (NPU)


NPU is programmable hardware optimized for networking.


Used for:


- Packet processing
- Routing
- Security


Architecture:


```
CPU

 |

NPU

 |

Ethernet Ports
```


---

# 42. Switch Architecture


A switch contains:


```
Ports

 |

MAC Learning Engine

 |

Switch Fabric

 |

Forwarding Table

 |

Output Ports
```


---

# Switch Fabric


Responsible for moving packets between ports.


Technologies:


- Shared bus
- Crossbar
- Packet switching fabric


---

# 43. Buffer Management


Network devices use buffers because:


Input speed != Output speed


Example:


```
10Gbps input

      |

Router

      |

1Gbps output
```


Packets wait in buffers.


---

# Buffer Overflow


When buffer is full:


```
New packets dropped
```


Called:

```
Packet Loss
```


---

# 44. QoS (Quality of Service)


Purpose:

Prioritize important traffic.


Example:


Voice traffic:

High priority


File download:

Low priority


---

# QoS Techniques


## Classification


Identify traffic.


Example:


```
Voice

Video

Data
```


---

## Queuing


Store packets separately.


Example:


```
High Priority Queue

Low Priority Queue
```


---

## Scheduling


Decide which queue sends first.


Algorithms:

- FIFO
- Priority Queue
- Weighted Fair Queue


---

# 45. Linux Networking Architecture


Linux networking stack:


```
Application

      |

Socket Layer

      |

TCP/UDP Layer

      |

IP Layer

      |

Network Interface Layer

      |

Driver

      |

Hardware
```


---

# 46. Linux Socket Layer


Applications communicate using sockets.


Example:


```
Browser

 |

Socket API

 |

TCP

 |

IP

 |

Ethernet Driver
```


---

# 47. Linux Network Stack Flow


Incoming packet:


```
NIC

 |

DMA

 |

Driver

 |

Kernel Network Stack

 |

TCP/IP

 |

Socket Buffer

 |

Application
```


---

# 48. sk_buff (Socket Buffer)


Linux represents packets using:


```
struct sk_buff
```


It contains:


- Packet data
- Headers
- Metadata


Example:


```
Ethernet Header

IP Header

TCP Header

Payload
```


---

# 49. Network Driver


Network driver connects:

```
Hardware

      |

Linux Kernel
```


Responsibilities:


- Initialize NIC
- Handle interrupts
- Allocate buffers
- Send packets
- Receive packets


---

# 50. Network Driver Receive Path


Example:


```
Packet arrives

      |

NIC DMA writes memory

      |

Interrupt generated

      |

Driver executes

      |

Create sk_buff

      |

Pass to kernel stack

      |

Application receives data
```


---

# 51. Network Driver Transmit Path


Application sends data:


```
Application

      |

Socket

      |

TCP/IP

      |

Driver

      |

DMA

      |

NIC

      |

Network
```


---

# 52. DMA Ring Buffer


High-performance NICs use ring buffers.


Example:


```
RX Ring


[Packet]

[Packet]

[Empty]

[Packet]



TX Ring


[Packet]

[Empty]

[Packet]
```


Benefits:


- Zero copy
- High throughput


---

# 53. Interrupt Handling in NIC


Packet arrives:


```
NIC

 |

Interrupt

 |

CPU

 |

Driver Handler

 |

Process Packet
```


Problem:

Too many interrupts reduce performance.


Solution:

```
Interrupt Coalescing
```


---

# 54. Interrupt Coalescing


Instead of:


```
Packet

Interrupt

Packet

Interrupt
```


Generate:


```
Multiple packets

      |

One interrupt
```


Benefits:

- Lower CPU usage


---

# 55. Polling Mode


Used in high-performance networking.


Example:


```
CPU continuously checks RX queue
```


Advantages:

- Low latency
- Predictable performance


Used by:

- DPDK


---

# 56. DPDK


DPDK:

Data Plane Development Kit


Purpose:

High-speed packet processing in user space.


Traditional path:


```
Application

 |

Kernel

 |

Driver

 |

NIC
```


DPDK path:


```
Application

 |

DPDK

 |

NIC
```


---

# DPDK Advantages


- Avoid kernel overhead
- Zero-copy
- Polling based
- Huge packet rate


Used in:

- Telecom
- Data centers
- Network appliances


---

# 57. eBPF


eBPF:

Extended Berkeley Packet Filter


Allows programs to run inside Linux kernel safely.


Uses:

- Packet filtering
- Monitoring
- Performance analysis


---

# eBPF Example


Packet arrives:


```
Network Interface

      |

eBPF Program

      |

Kernel
```


---

# eBPF Benefits


- No kernel modification
- Dynamic loading
- High performance


---

# 58. XDP


XDP:

eXpress Data Path


Runs eBPF programs very early in packet processing.


Location:


```
NIC Driver Level
```


Flow:


```
NIC

 |

XDP

 |

Kernel Network Stack
```


---

# XDP Uses


- DDoS protection
- Packet filtering
- Load balancing


---

# 59. Zero Copy Networking


Problem:


Copying data consumes CPU.


Traditional:


```
NIC

 |

Kernel Buffer

 |

Application Buffer
```


Two copies.


---

Zero Copy:


```
NIC

 |

Application Memory
```


Benefits:

- Higher throughput
- Lower CPU usage


---

# 60. Interview Questions


## Q1. Difference between Control Plane and Data Plane?


Control Plane:

- Makes routing decisions
- Runs protocols


Data Plane:

- Performs packet forwarding


---

## Q2. Explain packet forwarding in a router.


Answer:


```
Packet arrives

↓

Parse headers

↓

Lookup FIB

↓

Apply ACL/QoS

↓

Select output port

↓

Transmit packet
```


---

## Q3. Why use ASIC instead of CPU?


ASIC provides:

- Faster packet processing
- Lower latency
- Better power efficiency


---

## Q4. Explain Linux packet receive path.


Answer:


```
NIC

↓

DMA

↓

Interrupt

↓

Driver

↓

sk_buff

↓

TCP/IP Stack

↓

Socket

↓

Application
```


---

## Q5. Why is DPDK faster than normal networking?


Because:

- Runs in user space
- Avoids kernel overhead
- Uses polling
- Uses zero-copy buffers


---
# Part 5: Linux Networking Internals, Device Drivers, Wireless, IoT Protocols, Security, Debugging

---

# 61. Linux Kernel Networking Internals

Linux networking is implemented as a layered stack inside the kernel.


Architecture:


```
User Application

        |

Socket API

        |

Transport Layer

(TCP / UDP)

        |

Network Layer

(IP)

        |

Link Layer

(Ethernet)

        |

Network Driver

        |

NIC Hardware
```


---

# 62. Linux Socket Buffer (sk_buff)


Linux represents every network packet using:

```
struct sk_buff
```


It contains:


- Packet data
- Protocol headers
- Packet length
- Interface information
- Metadata


Example:


```
+----------------+
| Ethernet Header|
+----------------+
| IP Header      |
+----------------+
| TCP Header     |
+----------------+
| Payload        |
+----------------+
```


---

# 63. Linux Packet Receive Path


Detailed flow:


```
Packet arrives from network

        |

NIC receives frame

        |

DMA transfers packet to RAM

        |

NIC generates interrupt

        |

Driver interrupt handler runs

        |

Driver creates sk_buff

        |

Packet enters kernel network stack

        |

IP layer processes packet

        |

TCP/UDP layer processes packet

        |

Socket buffer

        |

Application reads data
```


---

# 64. Linux Packet Transmit Path


Application sends data:


```
Application

        |

Socket API

        |

TCP/UDP Layer

        |

IP Layer

        |

Network Queue

        |

Driver

        |

DMA

        |

NIC

        |

Network
```


---

# 65. Network Driver Architecture


A network driver connects:

```
Operating System

        |

Driver

        |

Hardware
```


Responsibilities:


- Hardware initialization
- Register configuration
- DMA setup
- Interrupt handling
- Packet transmit
- Packet receive
- Error handling


---

# 66. Network Driver Initialization


Typical sequence:


```
Driver Loaded

        |

Detect Device

        |

Allocate Memory

        |

Initialize Registers

        |

Setup DMA Rings

        |

Register Interrupt Handler

        |

Enable Network Interface
```


---

# 67. RX and TX Descriptor Rings


Modern NICs use descriptor rings.


RX:


```
Hardware writes packets

        |

RX Descriptor Ring

        |

Driver processes packets
```


TX:


```
Driver places packet

        |

TX Descriptor Ring

        |

Hardware transmits packet
```


---

# 68. Interrupt Handling


Traditional approach:


```
Packet Arrives

        |

Interrupt

        |

CPU Executes Handler

        |

Process Packet
```


Problem:

High packet rates create too many interrupts.


---

# 69. NAPI (New API)


Linux uses NAPI for high-performance networking.


Combination of:

- Interrupts
- Polling


Working:


```
First packet

        |

Interrupt


        |

Disable interrupts


        |

Poll packets


        |

Re-enable interrupts
```


Benefits:


- Reduced CPU overhead
- Better throughput


---

# 70. Memory Management in Networking


Important concepts:


## DMA Memory


Memory accessible by hardware.


Used for:


- Packet buffers
- Descriptor rings


---

## Buffer Allocation


Problems:


- Fragmentation
- Memory exhaustion


Solutions:


- Buffer pools
- Page allocation
- Huge pages


---

# 71. Wireless Networking Basics


Wireless communication uses radio waves.


Examples:


- Wi-Fi
- Bluetooth
- Zigbee
- Cellular


---

# 72. Wi-Fi Architecture


Basic flow:


```
Client Device

        |

Wireless Link

        |

Access Point

        |

Router

        |

Internet
```


---

# 73. Wi-Fi Standards


| Standard | Frequency | Speed |
|-|-|-|
|802.11b|2.4 GHz|11 Mbps|
|802.11g|2.4 GHz|54 Mbps|
|802.11n|2.4/5 GHz|600 Mbps|
|802.11ac|5 GHz|Several Gbps|
|802.11ax|2.4/5 GHz|Higher efficiency|


---

# 74. Wi-Fi Layers


Wi-Fi has:


```
Physical Layer

        |

MAC Layer

        |

IP Layer

        |

TCP/UDP

        |

Application
```


---

# 75. Wi-Fi Authentication


Common methods:


## WPA2


Uses:

```
AES Encryption
```


---

## WPA3


Improved:

- Security
- Authentication


---

# 76. Bluetooth / BLE


Bluetooth Low Energy is used for:


- Sensors
- Wearables
- IoT devices


Advantages:


- Low power
- Short range


---

# BLE Architecture


```
Application

        |

GATT

        |

ATT

        |

L2CAP

        |

Controller

        |

Radio
```


---

# 77. IoT Networking


IoT requirements:


- Low power
- Low bandwidth
- Secure communication
- Large device count


Protocols:


- MQTT
- CoAP
- HTTP
- LoRaWAN
- Zigbee


---

# 78. MQTT


MQTT:

Message Queuing Telemetry Transport


Designed for:


- IoT
- Sensors
- Low bandwidth networks


Architecture:


```
Publisher

        |

        |

 MQTT Broker

        |

        |

Subscriber
```


---

# MQTT Components


## Publisher


Sends messages.


Example:


```
Temperature Sensor

publishes:

temperature=25
```


---

## Broker


Receives and forwards messages.


Examples:

- Mosquitto
- Cloud MQTT services


---

## Subscriber


Receives messages.


Example:


```
Cloud Dashboard
```


---

# MQTT Topics


Example:


```
home/device1/temperature
```


Subscriber subscribes:


```
home/device1/#
```


---

# MQTT QoS


## QoS 0


At most once.


No guarantee.


---

## QoS 1


At least once.


Message may duplicate.


---

## QoS 2


Exactly once.


Highest overhead.


---

# 79. CoAP


CoAP:

Constrained Application Protocol


Used for:


- Small IoT devices
- Low power networks


Uses:


```
UDP
```


Similar to:


```
HTTP
```


---

# CoAP Methods


Similar to HTTP:


```
GET

POST

PUT

DELETE
```


---

# MQTT vs CoAP


| MQTT | CoAP |
|-|-|
|Publish/Subscribe|Request/Response|
|TCP|UDP|
|Broker based|Direct communication|
|Cloud IoT|Device IoT|


---

# 80. TLS/SSL


TLS provides:


- Encryption
- Authentication
- Data integrity


Used in:


- HTTPS
- Secure MQTT
- Secure APIs


---

# TLS Handshake


Flow:


```
Client

        |

Client Hello

        |

Server Hello

        |

Certificate Exchange

        |

Key Exchange

        |

Encrypted Communication
```


---

# TLS Components


## Encryption


Protects data.


Example:


```
Plain Text

      |

Encryption

      |

Cipher Text
```


---

## Authentication


Verifies server identity.


Uses:

```
Certificates
```


---

## Integrity


Ensures data is not modified.


Uses:

```
MAC / Hash
```


---

# 81. VPN


VPN:

Virtual Private Network


Purpose:

Create secure communication over public networks.


Example:


```
Remote User

        |

Encrypted Tunnel

        |

Company Network
```


---

# VPN Types


## Site-to-Site VPN


Connects two networks.


Example:


```
Office A

|

VPN Tunnel

|

Office B
```


---

## Remote Access VPN


User connects remotely.


---

# 82. Firewall


Firewall controls network traffic.


Works using rules:


Example:


Allow:


```
TCP Port 443
```


Block:


```
Unknown Traffic
```


---

# Firewall Types


## Packet Filter Firewall


Checks:


- IP
- Port
- Protocol


---

## Stateful Firewall


Tracks connections.


Example:


Allows return traffic for established TCP sessions.


---

## Application Firewall


Understands application protocols.


Example:


- HTTP filtering
- SQL injection blocking


---

# 83. Network Security Attacks


## DoS Attack


Goal:

Make service unavailable.


---

## DDoS


Distributed denial of service.


Multiple systems attack together.


---

## Man-in-the-Middle Attack


Attacker intercepts communication.


Protection:


- TLS
- Certificate validation


---

## SQL Injection


Attacker injects SQL commands.


Example:


Unsafe:


```
SELECT *
FROM users
WHERE name='input'
```


Protection:


- Prepared statements
- Input validation


---

# 84. Network Debugging Tools


Important tools for interviews:


---

# ping


Tests connectivity.


Example:


```bash
ping 8.8.8.8
```


Uses:

ICMP


---

# traceroute


Shows network path.


Example:


```bash
traceroute google.com
```


---

# ip command


View interfaces:


```bash
ip addr
```


View routes:


```bash
ip route
```


---

# netstat


Shows connections:


```bash
netstat -an
```


---

# ss


Modern replacement:


```bash
ss -tulnp
```


---

# tcpdump


Packet capture tool.


Example:


```bash
tcpdump -i eth0
```


---

# Wireshark


GUI packet analyzer.


Used for:


- Protocol debugging
- TCP analysis
- Packet inspection


---

# 85. Packet Debugging Approach


Problem:

Device cannot connect.


Debug:


## Step 1

Check physical link.


```
Cable

PHY

Link status
```


---

## Step 2

Check IP.


```
ip addr
```


---

## Step 3

Check route.


```
ip route
```


---

## Step 4

Check DNS.


```
nslookup
```


---

## Step 5

Capture packets.


```
tcpdump
```


---

# Senior Interview Questions


## Q1. Explain Linux packet receive path.


Answer:


```
NIC

↓

DMA

↓

Interrupt/NAPI

↓

Driver

↓

sk_buff

↓

IP Layer

↓

TCP Layer

↓

Socket

↓

Application
```


---

## Q2. Difference between MQTT and HTTP?


MQTT:

- Lightweight
- Publish/subscribe
- IoT focused


HTTP:

- Request/response
- Higher overhead


---

## Q3. Explain TLS handshake.


Answer:


```
Client Hello

↓

Server Certificate

↓

Key Exchange

↓

Session Key Created

↓

Encrypted Data Transfer
```


---

## Q4. How do you debug packet loss?


Approach:


```
Check Link

↓

Check Interface Errors

↓

Check Driver Logs

↓

Capture Packets

↓

Check TCP Retransmissions

↓

Check Buffer Overflow
```


---


