# Network Devices

Before learning OSI, TCP, IP, and Routing, you must understand the devices through which packets travel.

Real Flow:

Laptop
  ↓
Switch
  ↓
Router
  ↓
ISP
  ↓
Internet
  ↓
Router
  ↓
Switch
  ↓
Server

Every device has a specific responsibility.

---

# 1. NIC (Network Interface Card)

A NIC is hardware that allows a device to connect to a network.

Examples:

- Ethernet Port
- WiFi Adapter

Every NIC has:

- MAC Address
- Transmitter
- Receiver

Example:

Laptop MAC:
00:1A:2B:3C:4D:5E

Responsibilities:

- Send Frames
- Receive Frames

OSI Layer:

Layer 1
Layer 2

---

# 2. Repeater

Problem:

Signal weakens over long distance.

Solution:

Repeater

Flow:

Signal
   ↓
Repeater
   ↓
Amplified Signal

Responsibilities:

- Regenerate signal
- Extend distance

OSI Layer:

Layer 1

No intelligence.

Does not understand:

- MAC
- IP
- TCP

---

# 3. Hub

A Hub is a multi-port repeater.

Example:

PC1
 \
  Hub
 /
PC2

When Hub receives data:

It broadcasts to ALL ports.

Example:

PC1 sends data to PC2

Hub sends:

PC1 → PC2
PC1 → PC3
PC1 → PC4

Everyone receives.

Only PC2 accepts.

Others discard.

Problems:

- Wastes bandwidth
- Security issues
- Collisions

OSI Layer:

Layer 1

Rarely used today.

---

# 4. Bridge

Bridge connects two LAN segments.

Example:

LAN-A
  |
Bridge
  |
LAN-B

Bridge learns MAC addresses.

Advantages:

- Reduces collisions
- Better than Hub

OSI Layer:

Layer 2

Today replaced by switches.

---

# 5. Switch

Most important LAN device.

Example:

PC1
PC2
PC3
  |
Switch

Switch forwards frame only to destination port.

Unlike Hub.

---

# How Switch Works

Suppose:

PC1 = MAC A
PC2 = MAC B

Frame arrives:

Source MAC = A
Destination MAC = B

Switch learns:

A → Port 1

Stored in MAC Table.

Example:

MAC Table

A → Port1
B → Port2
C → Port3

Switch sends only to Port2.

---

# MAC Address Table

Switch builds table automatically.

Example:

MAC         PORT

AA:AA       1
BB:BB       2
CC:CC       3

When destination known:

Unicast

When destination unknown:

Flood

---

# Switch Benefits

Compared to Hub:

- Faster
- Secure
- Less collisions
- Intelligent forwarding

OSI Layer:

Layer 2

---

# Collision Domain

Collision:

Two devices transmit simultaneously.

Hub:

One collision domain

Switch:

One collision domain per port

Example:

Hub

PC1 -----
         |
PC2 ----- HUB

Collisions common.

Switch

PC1 -----
         |
PC2 -- SWITCH

No collisions.

---

# Broadcast Domain

Broadcast reaches all devices.

Example:

ARP Request

"Who owns 192.168.1.20?"

Everyone receives.

Switch forwards broadcasts.

Routers stop broadcasts.

Important Interview Question:

Switch separates collision domains.

Router separates broadcast domains.

---

# 6. Router

Most important Layer 3 device.

Purpose:

Connect different networks.

Example:

192.168.1.0/24
      |
    Router
      |
10.0.0.0/24

Without Router:

Networks cannot communicate.

---

# Router Uses IP Address

Switch uses:

MAC Address

Router uses:

IP Address

Example:

Destination:

8.8.8.8

Router checks:

Routing Table

Chooses best path.

Forwards packet.

---

# Routing Table

Example:

Destination      Next Hop

0.0.0.0          ISP
192.168.1.0      Local

Router checks:

Longest Prefix Match

Most specific route wins.

---

# Default Gateway

Question:

How does PC reach internet?

Example:

PC:
192.168.1.10

Google:
142.250.x.x

Different network.

PC sends packet to:

Default Gateway

Usually:

192.168.1.1

Router handles rest.

---

# Home Network Example

Laptop
    |
Switch/WiFi
    |
Router
    |
ISP
    |
Internet

Router responsibilities:

- Routing
- NAT
- DHCP
- Firewall

---

# 7. Gateway

Gateway translates between different systems.

Example:

IPv4 ↔ IPv6

Protocol A ↔ Protocol B

Think:

Translator

OSI:

Any layer

Depends on implementation.

---

# 8. Modem

Modem = Modulator + Demodulator

Purpose:

Convert digital signals to ISP-compatible signals.

Flow:

Laptop
  ↓
Router
  ↓
Modem
  ↓
ISP

Without modem:

Internet connection impossible.

---

# 9. Access Point (AP)

Provides WiFi.

Example:

Phone
Laptop
Tablet
   |
 Access Point

Responsibilities:

- Wireless communication
- Bridge WiFi to Ethernet

OSI Layer:

Layer 2

---

# 10. Firewall

Firewall filters traffic.

Example Rules:

Allow:
HTTPS 443

Block:
Telnet 23

Flow:

Traffic
   ↓
Firewall
   ↓
Allow / Deny

Types:

- Stateless
- Stateful
- Next Generation Firewall

---

# 11. Load Balancer

Distributes traffic.

Without LB:

10000 Users
      ↓
   Server

Server overloaded.

With LB:

          LB
        /    \
   Server1  Server2

Traffic distributed.

Benefits:

- Scalability
- High Availability

---

# 12. Proxy

Proxy sits between client and server.

Client
  ↓
Proxy
  ↓
Internet

---

Forward Proxy

Users → Proxy → Internet

Used for:

- Security
- Filtering

---

Reverse Proxy

Users → Reverse Proxy → Servers

Used for:

- Load balancing
- SSL termination
- Caching

Example:

Nginx

HAProxy

---

# Device Summary

Device          Layer

NIC             1,2
Repeater        1
Hub             1
Bridge          2
Switch          2
Router          3
Firewall        3-7
Load Balancer   4-7
Proxy           7

---

# Interview Questions

Q1. Difference between Hub and Switch?

Hub:
Broadcasts everything.

Switch:
Uses MAC table.

---

Q2. Difference between Switch and Router?

Switch:
MAC Address

Router:
IP Address

---

Q3. What is default gateway?

Router IP used to reach external networks.

---

Q4. Which device breaks broadcast domains?

Router

---

Q5. Which device breaks collision domains?

Switch

---

Q6. Why is Switch better than Hub?

- Faster
- Intelligent
- Secure
- Less collisions