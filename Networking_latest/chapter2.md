# Chapter 2 – OSI Model & TCP/IP Model
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand the networking stack from an interview perspective. Focus on how data moves through the layers rather than memorizing definitions.

---

# Why Do We Need Layers?

Imagine every application had to implement:

- Ethernet
- IP
- TCP
- Error Handling
- Routing
- Encryption

Every application would become extremely complicated.

Networking divides responsibilities into layers.

Each layer performs one specific job.

Benefits:

- Simpler design
- Independent development
- Easier debugging
- Standardization
- Interoperability

---

# OSI Model

OSI (Open Systems Interconnection) is a **7-layer reference model**.

```
+---------------------+
| 7 Application       |
+---------------------+
| 6 Presentation      |
+---------------------+
| 5 Session           |
+---------------------+
| 4 Transport         |
+---------------------+
| 3 Network           |
+---------------------+
| 2 Data Link         |
+---------------------+
| 1 Physical          |
+---------------------+
```

> **Interview Tip**
>
> OSI is mainly a teaching/reference model.
> Real-world networking primarily follows the TCP/IP model.

---

# Layer 7 – Application

Provides networking services to applications.

Examples:

- HTTP
- HTTPS
- FTP
- SSH
- SMTP
- DNS

Examples of applications:

```
Browser

curl

wget

ssh

ping
```

Responsibilities:

- User communication
- Request generation
- Response handling

---

# Layer 6 – Presentation

Responsible for:

- Encryption
- Compression
- Data Format Conversion

Examples:

```
TLS

SSL

JPEG

PNG

ASCII

UTF-8
```

Without this layer,

Computer A might send data in one format while Computer B expects another.

---

# Layer 5 – Session

Responsible for:

- Session establishment
- Session maintenance
- Session termination

Examples:

- RPC
- NetBIOS
- SMB Sessions

Modern TCP/IP implementations don't clearly separate this layer.

---

# Layer 4 – Transport

Responsible for:

- End-to-end communication
- Reliability
- Flow control
- Congestion control
- Port numbers

Protocols:

```
TCP

UDP
```

Data Unit:

```
Segment (TCP)

Datagram (UDP)
```

---

# Layer 3 – Network

Responsible for:

- Logical addressing
- Routing
- Path selection

Protocol:

```
IP
```

Devices:

```
Router
```

Address:

```
IP Address
```

Data Unit:

```
Packet
```

---

# Layer 2 – Data Link

Responsible for:

- Local communication
- MAC addressing
- Error detection
- Frame delivery

Protocols:

```
Ethernet

Wi-Fi
```

Devices:

```
Switch
```

Address:

```
MAC Address
```

Data Unit:

```
Frame
```

---

# Layer 1 – Physical

Responsible for transmitting bits.

Examples:

- Ethernet Cable
- Fiber
- Radio Signals
- Wi-Fi
- Optical Fiber

Data Unit:

```
Bits
```

---

# Complete OSI Summary

| Layer | Purpose | Example |
|--------|----------|----------|
| 7 | Application | HTTP, DNS |
| 6 | Encryption / Compression | TLS |
| 5 | Session | RPC |
| 4 | Reliable Transport | TCP, UDP |
| 3 | Routing | IP |
| 2 | Local Delivery | Ethernet |
| 1 | Electrical Signals | Cable |

---

# TCP/IP Model

Real networking uses TCP/IP.

Instead of seven layers, TCP/IP has four.

```
+----------------------+
| Application          |
+----------------------+
| Transport            |
+----------------------+
| Internet             |
+----------------------+
| Link                 |
+----------------------+
```

---

# Mapping OSI to TCP/IP

```
OSI                      TCP/IP

Application  \
Presentation  >------->  Application
Session      /

Transport ----------->   Transport

Network ------------->   Internet

Data Link   \
Physical     >------->   Link
```

This mapping is asked very frequently.

---

# Packet Flow Through Layers

Suppose Browser sends an HTTP request.

```
Application

HTTP GET

        │

        ▼

Transport

TCP Header Added

        │

        ▼

Internet

IP Header Added

        │

        ▼

Link

Ethernet Header Added

        │

        ▼

Wire
```

Receiver performs the reverse operation.

```
Wire

↓

Ethernet

↓

IP

↓

TCP

↓

HTTP

↓

Application
```

---

# Linux Networking Stack

This is important for Linux/System Software interviews.

```
Application

↓

Socket API

↓

TCP / UDP

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

Everything below the socket API is handled by the Linux kernel.

---

# Which Device Works at Which Layer?

| Device | Layer |
|---------|------|
| Hub | 1 |
| Switch | 2 |
| Router | 3 |
| Firewall | 3/4/7 |
| Load Balancer | 4/7 |

Interviewers often ask this.

---

# Data Units

| Layer | Unit |
|--------|------|
| Application | Data |
| Transport | Segment |
| Network | Packet |
| Data Link | Frame |
| Physical | Bits |

Easy memory trick:

```
Data

↓

Segment

↓

Packet

↓

Frame

↓

Bits
```

---

# Common Interview Questions

## Q1 Why do we need layers?

To separate responsibilities and simplify networking.

---

## Q2 Difference between OSI and TCP/IP?

OSI

- 7 layers
- Reference model
- Mostly theoretical

TCP/IP

- 4 layers
- Real implementation
- Used on the Internet

---

## Q3 Which layer performs routing?

Layer 3

---

## Q4 Which layer uses MAC addresses?

Layer 2

---

## Q5 Which layer uses IP addresses?

Layer 3

---

## Q6 Which layer uses port numbers?

Layer 4

---

## Q7 Why is TCP Layer 4?

Because it provides end-to-end communication independent of routing.

---

## Q8 Which layer does a switch operate on?

Layer 2

---

## Q9 Which layer does a router operate on?

Layer 3

---

## Q10 Where does TLS work?

Presentation layer in the OSI model (practically implemented within the application stack).

---

# Common Mistakes

❌ Saying routers use MAC addresses for routing.

✔ Routers route using IP addresses.

---

❌ Saying switches understand IP addresses.

✔ Basic Ethernet switches forward frames using MAC addresses.

---

❌ Confusing Packet and Frame.

✔ Packet = Layer 3

✔ Frame = Layer 2

---

❌ Saying OSI is actually implemented.

✔ TCP/IP is the practical networking stack used today.

---

# Quick Revision

```
OSI

Application
Presentation
Session
Transport
Network
Data Link
Physical

↓

TCP/IP

Application

Transport

Internet

Link

↓

Data

Segment

Packet

Frame

Bits
```

---

# Interview Cheat Sheet

| Layer | Address | Device | Protocol |
|--------|----------|---------|----------|
| Application | URL | Browser | HTTP |
| Transport | Port | OS | TCP/UDP |
| Network | IP | Router | IP |
| Data Link | MAC | Switch | Ethernet |
| Physical | None | Cable | Electrical Signal |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Why networking is layered.
- OSI model and the responsibility of each layer.
- TCP/IP model and how it maps to OSI.
- How packets move through the networking stack.
- Where switches and routers operate.
- How the Linux networking stack maps to these layers.
- The data unit at each layer (Data → Segment → Packet → Frame → Bits).

---

**Next Chapter:** Ethernet & MAC Addressing (How switches actually forward packets)