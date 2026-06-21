# Ethernet & MAC Address

Ethernet is the most widely used LAN technology.

When devices communicate inside a local network,
Ethernet is usually responsible.

Example:

Laptop
   |
Switch
   |
Printer

Communication uses Ethernet Frames.

---

# What is Ethernet?

Ethernet defines:

- Frame Structure
- MAC Addressing
- Local Communication Rules

OSI Layer:

Layer 2

---

# MAC Address

MAC = Media Access Control

Every NIC has a unique MAC address.

Example:

00:1A:2B:3C:4D:5E

Length:

48 bits

6 bytes

---

# Structure

Example:

00:1A:2B:3C:4D:5E

First Half:

00:1A:2B

Vendor Identifier (OUI)

Assigned by IEEE.

---

Second Half:

3C:4D:5E

Unique Device ID

---

# Example Vendors

Apple
Dell
Cisco
Intel
HP

Each gets unique OUI.

---

# Why MAC Exists

IP tells us:

Which machine?

MAC tells us:

Which network card?

Inside LAN:

Communication happens using MAC.

Not IP.

---

# Ethernet Frame

Structure:

+--------------------------------------+
| Dest MAC |
| Source MAC |
| EtherType |
| Payload |
| CRC |
+--------------------------------------+

---

# Destination MAC

Who should receive frame?

Example:

AA:BB:CC:DD:EE:FF

---

# Source MAC

Who sent frame?

Example:

11:22:33:44:55:66

---

# EtherType

Identifies payload type.

Examples:

0x0800 IPv4
0x86DD IPv6
0x0806 ARP

---

# Payload

Actual data.

Example:

IP Packet

---

# CRC

Cyclic Redundancy Check

Detects corruption.

Receiver recalculates CRC.

If mismatch:

Frame discarded.

---

# Types of MAC Addresses

---

# Unicast

One to one.

Example:

PC1 → PC2

---

# Broadcast

One to all.

MAC:

FF:FF:FF:FF:FF:FF

Everyone receives.

Example:

ARP Request

---

# Multicast

One to many.

Used by:

Video Streaming
Routing Protocols

---

# How Switch Uses MAC

Switch learns:

MAC → Port

Example:

MAC          Port

AA:AA        1
BB:BB        2
CC:CC        3

Frame destined to BB:BB

Switch forwards only to Port 2.

---

# MTU

Maximum Transmission Unit

Default Ethernet MTU:

1500 bytes

Meaning:

Largest payload allowed.

---

# Jumbo Frames

Used in Datacenters.

MTU:

9000 bytes

Benefits:

Less overhead

Higher throughput

---

# MAC vs IP

MAC

Layer 2
Physical Device

Example:

AA:BB:CC:DD:EE:FF

---

IP

Layer 3
Logical Address

Example:

192.168.1.10

---

Analogy

IP:
House Address

MAC:
Person inside house

---

# Interview Questions

Q1. MAC address length?

48 bits

---

Q2. Which layer uses MAC?

Layer 2

---

Q3. Broadcast MAC?

FF:FF:FF:FF:FF:FF

---

Q4. What is MTU?

Maximum frame payload size.

Default = 1500 bytes.

---

Q5. Why do we need MAC if IP exists?

Local delivery uses MAC.
Routing uses IP.