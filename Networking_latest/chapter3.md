# Chapter 3 – Ethernet & MAC Addressing
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand how devices communicate inside the same LAN and how an Ethernet switch forwards frames. This is one of the most frequently asked topics in networking interviews.

---

# Why Do We Need Ethernet?

Suppose two computers are connected to the same switch.

```
        +----------------+
        |     Switch     |
        +----------------+
          |            |
          |            |
     +---------+  +---------+
     | LaptopA |  | LaptopB |
     +---------+  +---------+
```

How does Laptop A know where to send data?

Using **Ethernet**.

Ethernet is the most widely used Layer-2 (Data Link Layer) protocol.

Its responsibilities are:

- Local communication
- MAC addressing
- Frame delivery
- Error detection (CRC)

---

# Ethernet Frame

Every Ethernet transmission is called a **Frame**.

```
+-----------+-----------+------+-------------+------+
| Dest MAC  | Src MAC   |Type  |   Payload   | CRC  |
+-----------+-----------+------+-------------+------+
```

Fields:

| Field | Purpose |
|-------|----------|
| Destination MAC | Receiver |
| Source MAC | Sender |
| EtherType | Next protocol (IPv4, IPv6, ARP) |
| Payload | Actual Data |
| CRC | Error Detection |

---

# MAC Address

Every Network Interface Card (NIC) has a MAC address.

Example

```
A4:5E:60:12:34:56
```

Properties

- 48 bits (6 bytes)
- Written in hexadecimal
- Layer-2 address
- Used only inside the local network

Example

```
Laptop A

MAC = A4:5E:60:12:34:56

Laptop B

MAC = 08:11:22:33:44:55
```

---

# MAC Address vs IP Address

| MAC Address | IP Address |
|-------------|------------|
| Layer 2 | Layer 3 |
| Local communication | Network communication |
| Used by switches | Used by routers |
| Physical/NIC address | Logical address |

### Easy Memory Trick

MAC

> Which device in my local network?

IP

> Which network in the world?

---

# Types of MAC Addresses

## Unicast

One sender → One receiver

```
Laptop A  -------------> Laptop B
```

---

## Broadcast

One sender → Everyone

Destination MAC

```
FF:FF:FF:FF:FF:FF
```

Example

ARP Request

```
Who owns 192.168.1.20?
```

Everyone receives it.

---

## Multicast

One sender → Selected group

Common in:

- Video Streaming
- IPTV
- Routing Protocols

---

# Switch

A Layer-2 device.

Responsibilities

- Learns MAC addresses
- Builds MAC table
- Forwards frames
- Reduces unnecessary traffic

---

# MAC Address Table (CAM Table)

Every switch maintains a table.

Example

```
+----------------------+------+
| MAC Address          | Port |
+----------------------+------+
| A4:5E:60:12:34:56    | 1    |
| 08:11:22:33:44:55    | 2    |
| AA:BB:CC:DD:EE:FF    | 3    |
+----------------------+------+
```

This is called:

- CAM Table
- MAC Table
- Forwarding Table

All mean the same thing.

---

# How Does a Switch Learn?

Suppose

```
Laptop A

MAC = A

Port = 1
```

First frame arrives.

Switch reads

```
Source MAC = A
```

Switch stores

```
A → Port 1
```

This is called

**MAC Learning**

Every received frame updates the table.

---

# Frame Forwarding

Suppose

```
Laptop A wants Laptop B
```

Frame

```
Destination MAC = B
```

Switch checks MAC table.

Case 1

MAC found

```
Forward only to that port.
```

Case 2

Unknown MAC

```
Flood frame to every port except incoming port.
```

Eventually Laptop B replies.

Switch learns

```
B → Port 2
```

Next time

No flooding.

---

# Unknown Unicast Flooding

Suppose

```
Switch has never seen Laptop B.
```

Table

```
A → Port 1
```

Frame arrives

```
Destination = B
```

Switch does

```
Port2

Port3

Port4

Port5
```

Only Laptop B accepts.

Others discard.

---

# Broadcast Forwarding

Broadcast frames

```
FF:FF:FF:FF:FF:FF
```

Always sent to every port.

Example

ARP Request.

---

# Broadcast Domain

All devices receiving the same broadcast belong to one **Broadcast Domain**.

Example

```
       Switch

A

B

C

D
```

If A sends ARP

Everyone receives it.

---

# VLAN (Introduction)

Suppose one company has:

- HR
- Finance
- Engineering

Using one switch, all devices are in one broadcast domain.

Instead, create VLANs.

```
Switch

+------------------------+

VLAN 10

HR

VLAN 20

Finance

VLAN 30

Engineering
```

Benefits

- Security
- Reduced broadcasts
- Better management

(We'll cover VLANs in detail later.)

---

# CRC (Error Detection)

Ethernet uses

```
CRC
```

Receiver computes CRC again.

If different

```
Frame discarded.
```

Ethernet detects errors.

It does **not** correct them.

---

# Complete Ethernet Flow

```
Laptop A

↓

Create Ethernet Frame

↓

Destination MAC

↓

Switch

↓

Lookup MAC Table

↓

Known?

Yes → Forward

No → Flood

↓

Laptop B

↓

Reply

↓

Switch Learns MAC

↓

Future Frames Sent Directly
```

---

# Linux Perspective

When an application sends data:

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

Network Card

↓

Cable
```

The Ethernet layer adds

- Source MAC
- Destination MAC
- EtherType
- CRC

before sending the frame.

---

# Common Interview Questions

## Q1 Why do we need MAC addresses?

To uniquely identify devices on the same local network.

---

## Q2 Why can't switches use IP addresses?

Because switches operate at Layer 2.

They forward frames using MAC addresses.

Routing decisions are made by routers using IP addresses.

---

## Q3 What happens if destination MAC is unknown?

The switch floods the frame to all ports except the incoming port.

After the destination replies, the switch learns its MAC.

---

## Q4 What is a CAM Table?

A table maintained by the switch mapping:

```
MAC Address → Switch Port
```

---

## Q5 Why is ARP a broadcast?

Because the sender doesn't know the destination MAC address.

It asks every device on the local network.

---

## Q6 What is Broadcast Storm?

Too many broadcast frames consuming bandwidth and CPU.

Large Layer-2 networks are more susceptible.

VLANs help reduce broadcast domains.

---

## Q7 Can two devices have the same MAC address?

Normally no.

If they do, switches may forward traffic incorrectly, causing communication issues.

---

# Common Mistakes

❌ Thinking MAC addresses are used across the Internet.

✔ MAC addresses are only used within the local Layer-2 network.

---

❌ Thinking routers forward using MAC addresses.

✔ Routers make forwarding decisions using IP addresses.

---

❌ Thinking switches know IP addresses.

✔ Standard Layer-2 switches learn only MAC addresses.

---

❌ Confusing Broadcast and Flooding.

✔ Broadcast → Intentional frame sent to everyone.

✔ Flooding → Switch behavior when destination MAC is unknown.

---

# Quick Revision

```
Ethernet

↓

Frame

↓

Source MAC

Destination MAC

↓

Switch

↓

MAC Learning

↓

CAM Table

↓

Known MAC?

Yes → Forward

No → Flood

↓

Broadcast

↓

ARP

↓

CRC
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Ethernet | Layer 2 |
| Address | MAC |
| Device | Switch |
| Data Unit | Frame |
| Broadcast MAC | FF:FF:FF:FF:FF:FF |
| Learning | Source MAC |
| Table | CAM / MAC Table |
| Unknown Destination | Flood |
| Error Detection | CRC |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Ethernet frame format
- MAC address purpose
- Difference between MAC and IP
- How a switch learns MAC addresses
- How frames are forwarded
- Unknown unicast flooding
- Broadcast communication
- CAM table
- CRC
- Basic VLAN concept

---

**Next Chapter:** ARP (Address Resolution Protocol) – How IP Addresses Are Converted into MAC Addresses