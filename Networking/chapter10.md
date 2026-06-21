# Routing

Routing is the process of moving packets
from one network to another.

Without routing:

- Internet cannot exist
- AWS VPC cannot exist
- Cloud cannot exist

Router's primary job:

Find best path for packet delivery.

---

# Why Routing Needed

Example:

PC1

IP:
192.168.1.10

Network:
192.168.1.0/24

Destination:

10.0.0.20

Network:
10.0.0.0/24

Different networks.

Switch cannot help.

Need Router.

---

# Router Decision

Router receives packet.

Checks:

Destination IP

Example:

10.0.0.20

Looks into:

Routing Table

Chooses best path.

Forwards packet.

---

# Routing Table

Example:

Destination       Next Hop

10.0.0.0/24       Interface A
172.16.0.0/16     Interface B
0.0.0.0/0         ISP

Router compares destination.

Finds matching route.

Forwards packet.

---

# Directly Connected Route

Router automatically learns networks connected to it.

Example:

Router

Interface1:
192.168.1.1/24

Interface2:
10.0.0.1/24

Routing Table:

192.168.1.0/24
10.0.0.0/24

No configuration needed.

---

# Static Routing

Administrator manually adds route.

Example:

ip route add

Advantages:

- Simple
- Predictable

Disadvantages:

- Not scalable

---

# Dynamic Routing

Routers exchange routes automatically.

Protocols:

RIP
OSPF
EIGRP
BGP

Advantages:

- Automatic updates

Disadvantages:

- Complexity

---

# Default Route

Known as:

Gateway of Last Resort

Route:

0.0.0.0/0

Meaning:

"If nothing matches,
send packet here."

Usually points to ISP.

---

# Longest Prefix Match

Most important routing rule.

Example:

Routes:

10.0.0.0/8
10.1.0.0/16
10.1.1.0/24

Destination:

10.1.1.50

Router chooses:

10.1.1.0/24

Because it is most specific.

---

# Packet Journey Example

PC:

192.168.1.10

Gateway:

192.168.1.1

Google:

142.250.x.x

Flow:

PC
 ↓
Router
 ↓
ISP
 ↓
Internet
 ↓
Google

---

# Routing vs Switching

Switch

Uses:
MAC Address

Works:
Layer 2

Inside LAN

---

Router

Uses:
IP Address

Works:
Layer 3

Between Networks

---

# Routing Protocols

---

# RIP

Routing Information Protocol

Metric:

Hop Count

Maximum:

15 hops

Slow

Old protocol

---

# OSPF

Open Shortest Path First

Metric:

Cost

Uses:

Dijkstra Algorithm

Fast

Enterprise standard

---

# EIGRP

Cisco protocol

Metric:

Bandwidth
Delay

Very efficient

---

# BGP

Border Gateway Protocol

Most important routing protocol.

Runs Internet.

Example:

Google
AWS
Azure
Cloudflare

exchange routes using BGP.

---

# Interview Questions

Q1. What is routing?

Forwarding packets between networks.

---

Q2. Which device performs routing?

Router

---

Q3. What is default route?

0.0.0.0/0

---

Q4. What is longest prefix match?

Most specific route wins.

---

Q5. Which protocol powers Internet?

BGP