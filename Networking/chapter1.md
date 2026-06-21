# Networking Fundamentals

## What is Networking?

Networking is the process of connecting multiple devices so they can exchange data.

Examples:

- Laptop ↔ Mobile
- Laptop ↔ Printer
- Laptop ↔ Server
- Browser ↔ Website

Without networking:

- No Internet
- No Cloud
- No Email
- No Video Calls
- No Distributed Systems

---

# Basic Terminology

## Node

Any device connected to a network.

Examples:

- Laptop
- Mobile
- Server
- Router
- Switch

---

## Link

A connection between devices.

Examples:

- Ethernet Cable
- Fiber Cable
- WiFi Signal

---

## Protocol

Rules for communication.

Just like humans use language:

English
Hindi
French

Computers use:

- TCP
- UDP
- HTTP
- HTTPS
- DNS

Without protocols, devices cannot understand each other.

---

# Types of Networks

## PAN (Personal Area Network)

Smallest network.

Example:

Mobile ↔ Smart Watch

Range:

~10 meters

Technologies:

- Bluetooth
- USB

---

## LAN (Local Area Network)

Network within a building.

Example:

Office Network

Devices:

- PCs
- Printers
- Servers

Range:

Few hundred meters

Speed:

High

Examples:

Home WiFi
Office WiFi

---

## MAN (Metropolitan Area Network)

Covers a city.

Example:

Connecting multiple offices in Pune.

Range:

10-100 km

---

## WAN (Wide Area Network)

Covers countries and continents.

Example:

Internet

Range:

Unlimited

Examples:

India ↔ USA

---

# Client Server Model

Most common architecture.

Example:

Browser requests website.

Client:

Your browser

Server:

Google Server

Flow:

Client ---------> Server
Request

Client <--------- Server
Response

Example:

GET google.com

Server returns HTML.

---

# Peer To Peer (P2P)

No central server.

Every machine can act as both:

- Client
- Server

Example:

Torrent

Machine A ↔ Machine B

Advantages:

- No central dependency

Disadvantages:

- Hard to manage

---

# Network Topologies

Physical layout of a network.

---

## Bus Topology

PC1 -- PC2 -- PC3 -- PC4

Single cable shared.

Advantages:

- Cheap

Disadvantages:

- Single point of failure

Rare today.

---

## Star Topology

         Switch
       /    |    \
     PC1   PC2   PC3

Most common topology.

Advantages:

- Easy maintenance
- Easy scaling

Disadvantages:

- Switch failure affects all devices

---

## Ring Topology

PC1 → PC2 → PC3 → PC4 → PC1

Data travels in a circle.

Advantages:

- Predictable

Disadvantages:

- One break can impact network

Rare today.

---

## Mesh Topology

Every device connected to every device.

A ↔ B
A ↔ C
B ↔ C

Advantages:

- High redundancy

Disadvantages:

- Expensive

Used in:

- Datacenters
- Backbone Networks

---

# Data Transmission Modes

## Simplex

One-way communication.

Example:

TV Broadcast

Sender → Receiver

---

## Half Duplex

Two-way but not simultaneously.

Example:

Walkie Talkie

A → B

then

B → A

---

## Full Duplex

Both directions simultaneously.

Example:

Modern Ethernet

A ↔ B

---

# Network Performance Metrics

## Bandwidth

Maximum data transfer capacity.

Example:

100 Mbps

Think:

Width of a highway.

More lanes = More bandwidth.

---

## Throughput

Actual achieved speed.

Bandwidth:

100 Mbps

Actual:

80 Mbps

Throughput = 80 Mbps

---

## Latency

Time taken for data to travel.

Example:

Pune → Mumbai

10 ms

Lower latency is better.

---

## Jitter

Variation in latency.

Example:

Packet1 = 10ms
Packet2 = 20ms
Packet3 = 5ms

Bad for:

- Voice calls
- Video calls

---

## Packet Loss

Packets fail to reach destination.

Causes:

- Congestion
- Hardware failure
- Bad signal

Effects:

- Slow internet
- Video buffering

---

# How Two Computers Communicate

Suppose:

PC A = 192.168.1.10

PC B = 192.168.1.20

Step 1:
Application generates data.

Example:

"Hello"

Step 2:
Operating system creates packet.

Step 3:
Packet sent to network card.

Step 4:
Packet travels through switch.

Step 5:
Switch forwards packet.

Step 6:
Destination receives packet.

Step 7:
Application reads packet.

Result:

Hello delivered successfully.

---

# Real Internet Example

You type:

https://google.com

What actually happens?

1. Browser checks cache

2. DNS lookup happens

3. IP address found

4. ARP finds MAC address

5. TCP connection established

6. TLS handshake performed

7. HTTP request sent

8. Router forwards packets

9. Google server receives request

10. Response generated

11. Response returned

12. Browser renders webpage

All of this usually happens in less than 1 second.

---

# Interview Questions

Q1. Difference between LAN and WAN?

LAN:
- Small area
- Faster

WAN:
- Large area
- Uses routers

---

Q2. What is bandwidth?

Maximum capacity of a network link.

---

Q3. Difference between bandwidth and throughput?

Bandwidth:
Maximum possible speed

Throughput:
Actual speed

---

Q4. What is latency?

Time taken for a packet to travel.

---

Q5. What is a protocol?

A set of communication rules.

Examples:

TCP
UDP
HTTP
DNS
