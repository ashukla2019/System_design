# TCP/IP Model

TCP/IP is the practical networking model used by the Internet.

Unlike OSI (7 layers), TCP/IP has 4 layers.

TCP/IP Layers

Application
Transport
Internet
Network Access

Every protocol on the Internet belongs to one of these layers.

---

# Why TCP/IP Exists

OSI was created as a theoretical reference model.

TCP/IP was created as a practical implementation.

Today:

Internet = TCP/IP

Not OSI.

OSI is still useful for learning and troubleshooting.

---

# TCP/IP vs OSI

OSI                    TCP/IP

Application ┐
Presentation├─────► Application
Session     ┘

Transport   ─────► Transport

Network     ─────► Internet

Data Link ┐
Physical  ┘─────► Network Access

---

# Layer 4 - Application

Combines:

OSI Layer 7
OSI Layer 6
OSI Layer 5

Protocols:

HTTP
HTTPS
FTP
SMTP
POP3
IMAP
DNS
DHCP
SSH

Responsibilities:

- User interaction
- Data formatting
- Encryption
- Session handling

Examples:

Browser
Email Client
SSH Client

Data Unit:

Data

---

# Layer 3 - Transport

Responsible for:

- Reliability
- Segmentation
- Port Numbers

Protocols:

TCP
UDP

Data Unit:

Segment

---

# TCP

Connection Oriented

Reliable

Ordered Delivery

Acknowledgements

Retransmission

Example:

HTTPS
SSH
FTP

Flow:

SYN
SYN-ACK
ACK

Connection established.

---

# UDP

Connectionless

No Reliability

No Ordering

Fast

Examples:

DNS
VoIP
Gaming
Streaming

---

# Ports

Transport layer uses ports.

IP identifies machine.

Port identifies application.

Example:

192.168.1.10:443

IP:
Machine

Port:
Application

---

Common Ports

20 FTP Data
21 FTP Control
22 SSH
23 Telnet
25 SMTP
53 DNS
67 DHCP Server
68 DHCP Client
80 HTTP
110 POP3
143 IMAP
443 HTTPS
3306 MySQL
5432 PostgreSQL

---

# Layer 2 - Internet Layer

Equivalent to OSI Network Layer.

Responsible for:

- Logical Addressing
- Routing

Protocols:

IPv4
IPv6
ICMP
IGMP

Data Unit:

Packet

---

# IPv4

Example:

192.168.1.10

32 bits

4 octets

Example:

11000000.10101000.00000001.00001010

---

# IPv6

128 bits

Example:

2001:db8::1

Created because IPv4 addresses are running out.

---

# ICMP

Internet Control Message Protocol

Used for diagnostics.

Examples:

ping
traceroute

Messages:

Echo Request
Echo Reply
Destination Unreachable
Time Exceeded

---

# Layer 1 - Network Access

Combines:

OSI Layer 1
OSI Layer 2

Responsibilities:

- MAC Addressing
- Framing
- Physical Transmission

Protocols:

Ethernet
WiFi
PPP

Data Unit:

Frame

---

# Encapsulation in TCP/IP

Application Data
       ↓
TCP Header
       ↓
Segment
       ↓
IP Header
       ↓
Packet
       ↓
Ethernet Header
       ↓
Frame
       ↓
Bits

Sent on wire.

---

# Example: Visiting Google

Step 1

Browser creates HTTP request.

Application Layer.

---

Step 2

TCP adds:

Source Port
Destination Port

Transport Layer.

---

Step 3

IP adds:

Source IP
Destination IP

Internet Layer.

---

Step 4

Ethernet adds:

Source MAC
Destination MAC

Network Access Layer.

---

Step 5

Bits transmitted.

---

# Interview Questions

Q1. Difference between OSI and TCP/IP?

OSI:
7 Layers

TCP/IP:
4 Layers

---

Q2. Which model is actually used?

TCP/IP

---

Q3. Which layer handles routing?

Internet Layer

---

Q4. Which layer uses ports?

Transport Layer

---

Q5. Which protocol is used by ping?

ICMP