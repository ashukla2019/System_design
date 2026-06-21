# OSI Model

OSI = Open Systems Interconnection

Purpose:

Standardize communication between systems.

OSI has 7 layers.

Application
Presentation
Session
Transport
Network
Data Link
Physical

Data travels:

Top → Bottom (Sender)

Bottom → Top (Receiver)

---

Mnemonic

All
People
Seem
To
Need
Data
Processing

7 Application
6 Presentation
5 Session
4 Transport
3 Network
2 Data Link
1 Physical

---

# Layer 7 - Application

Closest to user.

Protocols:

HTTP
HTTPS
DNS
SMTP
FTP

Examples:

Browser
Email Client

Responsibilities:

- User interaction
- Network services

Data Unit:

Data

---

# Layer 6 - Presentation

Responsible for:

- Encryption
- Compression
- Translation

Examples:

ASCII
Unicode
JPEG
MP4

Encryption Example:

HTTPS

Plain Text
   ↓
Encryption
   ↓
Cipher Text

---

# Layer 5 - Session

Maintains communication session.

Responsibilities:

- Session creation
- Session maintenance
- Session termination

Example:

Video call

Session starts
Session maintained
Session ends

---

# Layer 4 - Transport

Responsible for end-to-end delivery.

Protocols:

TCP
UDP

Responsibilities:

- Reliability
- Flow Control
- Segmentation

Data Unit:

Segment

---

# TCP

Reliable

Features:

- ACK
- Retransmission
- Ordering

Used by:

HTTP
HTTPS

---

# UDP

Fast

No:

- ACK
- Ordering
- Retransmission

Used by:

Gaming
Streaming
DNS

---

# Layer 3 - Network

Responsible for routing.

Protocols:

IP
ICMP

Responsibilities:

- Logical addressing
- Routing

Data Unit:

Packet

Device:

Router

Example:

192.168.1.10

---

# Layer 2 - Data Link

Responsible for local delivery.

Uses:

MAC Address

Responsibilities:

- Framing
- Error Detection
- Local communication

Data Unit:

Frame

Device:

Switch

---

# Layer 1 - Physical

Actual transmission.

Examples:

- Copper Cable
- Fiber Cable
- Radio Waves

Data Unit:

Bits

Device:

Hub
Repeater

---

# Encapsulation

Application Data
      ↓
TCP Header Added
      ↓
Segment
      ↓
IP Header Added
      ↓
Packet
      ↓
MAC Header Added
      ↓
Frame
      ↓
Bits

Sent over wire.

---

# Decapsulation

Bits
 ↓
Frame
 ↓
Packet
 ↓
Segment
 ↓
Data

Received by destination.

---

# Example

Open browser:

https://google.com

Application:
Creates request

Transport:
Adds TCP

Network:
Adds IP

Data Link:
Adds MAC

Physical:
Transmits bits

Reverse process occurs at Google server.

---

# Device Mapping

Layer      Device

7          Proxy
6          SSL/TLS
5          Session Service
4          Load Balancer
3          Router
2          Switch
1          Hub

---

# Interview Questions

Q1. Which layer uses IP?

Layer 3

Q2. Which layer uses MAC?

Layer 2

Q3. Which layer uses TCP?

Layer 4

Q4. Which layer uses HTTP?

Layer 7

Q5. Which device works at Layer 3?

Router

Q6. Which device works at Layer 2?

Switch

Q7. What is encapsulation?

Adding headers as data moves down the OSI stack.