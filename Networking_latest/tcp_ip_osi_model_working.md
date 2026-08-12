# OSI and TCP/IP Models

## 1. Network Models

Network communication has multiple responsibilities, so they are divided into layers.

The two common models are:

- **OSI** — 7 layers
- **TCP/IP** — 4 layers

---

## 2. OSI Model

```text
7. Application    → HTTP, DNS, SSH
6. Presentation   → Encoding, encryption, compression
5. Session        → Session management
4. Transport      → TCP, UDP, ports
3. Network        → IP, routing
2. Data Link      → Ethernet, Wi-Fi, MAC
1. Physical       → Cables, fiber, radio, signals
```

### Layer 7 — Application

Provides network services to applications.

Examples:

```text
HTTP
HTTPS
DNS
SSH
FTP
SMTP
```

### Layer 6 — Presentation

Deals with data representation.

```text
Encoding
Encryption
Compression
Data conversion
```

In modern TCP/IP, these responsibilities are usually handled by applications/protocols rather than a separate layer.

### Layer 5 — Session

Manages communication sessions.

```text
Start session
     ↓
Exchange data
     ↓
Maintain session
     ↓
End session
```

### Layer 4 — Transport

Provides process-to-process communication.

Main protocols:

```text
TCP
UDP
```

Uses **port numbers**.

Examples:

```text
HTTP  → TCP 80
HTTPS → TCP 443
SSH   → TCP 22
DNS   → UDP/TCP 53
```

TCP provides:

- Reliable delivery
- Ordering
- Acknowledgements
- Retransmission
- Flow control
- Congestion control

UDP provides lower overhead but does not provide TCP's reliability mechanisms.

### Layer 3 — Network

Responsible for logical addressing and routing.

Main protocol:

```text
IP
```

Examples:

```text
IPv4
IPv6
```

Example:

```text
192.168.1.10
```

Routers primarily operate at this layer.

### Layer 2 — Data Link

Handles communication over the local network.

Examples:

```text
Ethernet
Wi-Fi
```

Uses:

```text
MAC addresses
Frames
```

Example MAC:

```text
00:1A:2B:3C:4D:5E
```

Switches primarily operate at this layer.

### Layer 1 — Physical

Transmits raw bits.

Examples:

```text
Copper
Fiber
Radio
Electrical signals
Optical signals
```

```text
101101001011
      ↓
Electrical / Optical / Radio Signals
```

---

## 3. TCP/IP Model

A common 4-layer representation:

```text
+-----------------------+
| Application           |
+-----------------------+
| Transport             |
+-----------------------+
| Internet              |
+-----------------------+
| Link                  |
+-----------------------+
```

### OSI → TCP/IP Mapping

```text
OSI                         TCP/IP

Application       ┐
Presentation      ├──────→ Application
Session           ┘

Transport         ───────→ Transport

Network           ───────→ Internet

Data Link         ┐
Physical          ┘──────→ Link
```

So:

```text
OSI      → 7 layers
TCP/IP   → 4 layers
```

---

## 4. How Data Travels

Suppose a browser accesses:

```text
https://example.com
```

Simplified stack:

```text
Application
     ↓
    HTTP
     ↓
    TLS
     ↓
    TCP
     ↓
     IP
     ↓
Ethernet/Wi-Fi
     ↓
Physical Network
```

The receiver processes it in reverse:

```text
Physical
    ↓
Ethernet/Wi-Fi
    ↓
IP
    ↓
TCP
    ↓
TLS
    ↓
HTTP
    ↓
Application
```

---

## 5. Encapsulation

When data moves **down** the network stack, each layer adds information.

Start with:

```text
Hello
```

Transport adds a TCP header:

```text
+----------------+
| TCP Header     |
+----------------+
| Hello          |
+----------------+
```

This is a **TCP segment**.

IP adds an IP header:

```text
+----------------+
| IP Header      |
+----------------+
| TCP Header     |
+----------------+
| Hello          |
+----------------+
```

This is an **IP packet**.

Ethernet/Wi-Fi adds link-layer information:

```text
+----------------+
| Link Header    |
+----------------+
| IP Header      |
+----------------+
| TCP Header     |
+----------------+
| Hello          |
+----------------+
| Link Trailer   |
+----------------+
```

This is a **frame**.

Finally:

```text
Frame
  ↓
Bits / Signals
```

This process is called **encapsulation**.

---

## 6. Decapsulation

The receiver performs the reverse:

```text
Bits / Signals
      ↓
    Frame
      ↓
  IP Packet
      ↓
 TCP Segment
      ↓
Application Data
```

This process is called **decapsulation**.

---

## 7. Important Terminology

```text
Application → Data

TCP         → Segment
UDP         → Datagram
IP          → Packet
Ethernet    → Frame
Physical    → Bits
```

Simple flow:

```text
Data
 ↓
Segment / Datagram
 ↓
Packet
 ↓
Frame
 ↓
Bits
```

---

## 8. TCP vs UDP

### TCP

```text
Application
     ↓
    TCP
     ↓
     IP
```

TCP provides:

- Reliable delivery
- Ordering
- Acknowledgements
- Retransmission
- Flow control
- Congestion control

Example:

```text
Client                         Server

Segment 1 -------------------->
             <---------------- ACK

Segment 2 -------------------->
             <---------------- ACK
```

### UDP

```text
Application
     ↓
    UDP
     ↓
     IP
```

UDP has less overhead and does not provide TCP's reliability mechanisms.

---

## 9. IP and Routing

Suppose:

```text
PC A
192.168.1.10
     |
     ↓
  Router
     |
     ↓
PC B
192.168.2.20
```

The router examines the destination IP and decides where to forward the packet.

```text
Source IP      → 192.168.1.10
Destination IP → 192.168.2.20
```

The IP packet travels across networks.

The Layer-2 frame can change at every network link.

---

## 10. Switch vs Router

### Switch

Primarily Layer 2:

```text
MAC Address
     ↓
Forward Frame
```

Example:

```text
PC A
 |
 ↓
Switch
 ├──→ PC B
 └──→ PC C
```

### Router

Primarily Layer 3:

```text
IP Address
     ↓
Choose Route
     ↓
Forward Packet
```

Simplified:

```text
PC
 ↓
Switch
 ↓
Router
 ↓
Network
 ↓
Router
 ↓
Switch
 ↓
Server
```

---

## 11. TLS

TLS sits conceptually between application protocols and the transport layer.

HTTPS:

```text
HTTP
 ↓
TLS
 ↓
TCP
 ↓
IP
 ↓
Ethernet/Wi-Fi
```

TLS provides:

```text
Encryption
Authentication
Integrity
```

---

## 12. DNS

DNS is an Application-layer protocol.

Example:

```text
Browser
   |
   | "What is the IP of example.com?"
   ↓
  DNS
   |
   ↓
IP Address
```

Simplified stack:

```text
DNS
 ↓
UDP/TCP
 ↓
IP
 ↓
Ethernet/Wi-Fi
```

---

## 13. Troubleshooting by Layer

Think from the bottom upward:

```text
Layer 1 → Is there a physical connection?

Layer 2 → Can I communicate on the local network?

Layer 3 → Can I reach the destination IP?

Layer 4 → Can I reach the required port?

Layer 7 → Is the application working?
```

For HTTPS:

```text
Cable / Wi-Fi
      ↓
Ethernet
      ↓
IP Routing
      ↓
TCP Port 443
      ↓
TLS
      ↓
HTTP
      ↓
Web Application
```

---

## 14. Complete Picture

### Sender

```text
Application Data
       ↓
    TCP/UDP
       ↓
       IP
       ↓
Ethernet/Wi-Fi
       ↓
Bits / Signals
       ↓
    Network
```

### Receiver

```text
Bits / Signals
       ↓
Ethernet/Wi-Fi
       ↓
       IP
       ↓
    TCP/UDP
       ↓
Application Data
```

The sender performs:

```text
ENCAPSULATION
```

The receiver performs:

```text
DECAPSULATION
```

---

## 15. Quick Reference

| OSI | TCP/IP | Main Responsibility | Examples |
|---|---|---|---|
| Application | Application | Network services | HTTP, DNS, SSH |
| Presentation | Application | Data representation | Encoding, encryption |
| Session | Application | Sessions | Session management |
| Transport | Transport | Process communication | TCP, UDP |
| Network | Internet | Routing/addressing | IP, ICMP |
| Data Link | Link | Local delivery | Ethernet, Wi-Fi |
| Physical | Link | Bit transmission | Cable, fiber, radio |

---

## 16. One-Line Mental Model

```text
Application → What data?
Transport   → Which process/port?
Internet    → Where should it go?
Link        → How do I reach the next device?
Physical    → How are the bits transmitted?
```

The complete idea:

```text
Application
     ↓
Transport
     ↓
Internet
     ↓
Link
     ↓
Physical
```

And on the receiving side:

```text
Physical
     ↓
Link
     ↓
Internet
     ↓
Transport
     ↓
Application
```
