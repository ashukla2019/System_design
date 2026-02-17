# Networking Interview Preparation Notes

---

# 1. What is Networking?

Networking is the practice of connecting computers and devices to share resources, data, and services.

Goals:
- Communication
- Resource sharing
- Centralized management
- Scalability

---

# 2. OSI Model (7 Layers)

## 1. Physical Layer
- Transmits raw bits
- Cables, signals, voltages
- Devices: Hub, Repeater

## 2. Data Link Layer
- MAC addressing
- Framing
- Error detection
- Devices: Switch, Bridge

Protocols:
- Ethernet
- ARP

## 3. Network Layer
- Logical addressing (IP)
- Routing
- Path selection

Protocols:
- IP
- ICMP
- Routing protocols (OSPF, RIP, BGP)

Devices:
- Router

## 4. Transport Layer
- End-to-end communication
- Port numbers
- Reliability & flow control

Protocols:
- TCP
- UDP

## 5. Session Layer
- Session management
- Checkpoints

## 6. Presentation Layer
- Encryption
- Compression
- Data formatting

## 7. Application Layer
- User-facing services

Protocols:
- HTTP
- HTTPS
- FTP
- SMTP
- DNS
- SSH

---

# 3. TCP/IP Model (4 Layers)

1. Network Access
2. Internet
3. Transport
4. Application

Mapping:

OSI            | TCP/IP
---------------|--------
Application    | Application
Presentation   | Application
Session        | Application
Transport      | Transport
Network        | Internet
Data Link      | Network Access
Physical       | Network Access

---

# 4. IP Addressing

## IPv4

- 32-bit address
- Example: 192.168.1.1
- Divided into Network + Host

## IPv6

- 128-bit address
- Example: 2001:0db8::1
- Larger address space

---

## Private IP Ranges

Class A: 10.0.0.0 – 10.255.255.255  
Class B: 172.16.0.0 – 172.31.255.255  
Class C: 192.168.0.0 – 192.168.255.255  

---

# 5. Subnetting

Purpose:
- Divide network into smaller sub-networks
- Improve performance
- Improve security

Example:

192.168.1.0/24

Subnet mask:
255.255.255.0

CIDR notation:
192.168.1.0/24

---

# 6. TCP vs UDP

Feature         | TCP                | UDP
----------------|-------------------|-------
Connection      | Connection-oriented | Connectionless
Reliability     | Reliable           | Unreliable
Speed           | Slower             | Faster
Use Cases       | HTTP, HTTPS, SSH   | DNS, Streaming, VoIP

---

# 7. Three-Way Handshake (TCP)

1. SYN → Client to Server
2. SYN-ACK → Server to Client
3. ACK → Client to Server

Connection established.

---

# 8. Common Protocols

## HTTP
- Port 80
- Stateless

## HTTPS
- Port 443
- HTTP + TLS encryption

## DNS
- Port 53
- Resolves domain → IP

## SSH
- Port 22
- Secure remote login

## FTP
- Port 21
- File transfer

## SMTP
- Port 25
- Email sending

---

# 9. DNS Resolution Process

1. User enters domain name.
2. Local DNS cache checked.
3. Recursive resolver contacted.
4. Root server queried.
5. TLD server queried.
6. Authoritative server returns IP.
7. Browser connects to IP.

---

# 10. ARP (Address Resolution Protocol)

Maps:
IP Address → MAC Address

Used in local network.

---

# 11. NAT (Network Address Translation)

Converts:
Private IP → Public IP

Types:
- Static NAT
- Dynamic NAT
- PAT (Port Address Translation)

Purpose:
- Conserves IPv4 addresses
- Adds security layer

---

# 12. DHCP

Dynamic Host Configuration Protocol.

Automatically assigns:
- IP address
- Subnet mask
- Default gateway
- DNS server

Process:
1. Discover
2. Offer
3. Request
4. Acknowledge

(DORA)

---

# 13. Firewalls

Monitors and filters traffic.

Types:
- Packet filtering firewall
- Stateful firewall
- Next-generation firewall

---

# 14. Load Balancing

Distributes traffic across multiple servers.

Types:
- Round Robin
- Least Connections
- IP Hash

Improves:
- Availability
- Scalability

---

# 15. VPN (Virtual Private Network)

Creates encrypted tunnel over public network.

Types:
- Site-to-site VPN
- Remote access VPN

---

# 16. Routing Basics

Static Routing:
- Manually configured

Dynamic Routing:
- Automatically updates routes

Common Routing Protocols:
- RIP
- OSPF
- BGP

---

# 17. VLAN (Virtual LAN)

Logically segments network.

Benefits:
- Improved security
- Reduced broadcast traffic

---

# 18. Common Networking Interview Questions

1. Explain OSI model.
2. Difference between TCP and UDP.
3. What happens when you type a URL?
4. What is subnetting?
5. How DNS works?
6. What is NAT?
7. What is difference between hub, switch, and router?
8. Explain TCP handshake.
9. What is ARP?
10. What is CIDR?

---

# 19. What Happens When You Type a URL?

1. DNS resolves domain to IP.
2. TCP handshake occurs.
3. TLS handshake (if HTTPS).
4. HTTP request sent.
5. Server responds.
6. Browser renders page.

---

# 20. Hub vs Switch vs Router

Device   | Layer | Function
---------|-------|---------
Hub      | L1    | Broadcast to all
Switch   | L2    | Forwards using MAC address
Router   | L3    | Routes using IP address

---

# 21. Important Networking Concepts for Interviews

- Latency vs Bandwidth
- Throughput
- MTU (Maximum Transmission Unit)
- Packet vs Frame
- Broadcast vs Multicast vs Unicast
- Port numbers
- Ephemeral ports
- Stateful vs Stateless protocols

---

# 22. Final Interview Tip

Understand:
- How data moves from browser → server → back
- OSI layering conceptually
- TCP vs UDP deeply
- DNS resolution
- Subnetting basics
- Security basics (TLS, firewalls)

Interviewers focus on:
- Clarity of explanation
- Layer-by-layer breakdown
- Real-world examples
- Troubleshooting approach

---

# 23. TCP Working and OSI Layer Mapping

TCP is a **connection-oriented, reliable transport protocol** in the OSI model at **Layer 4 – Transport Layer**. It ensures:

- Reliable delivery
- Error detection & correction
- Flow control
- Ordered delivery

---

## 23.1 Three-Way Handshake (Connection Establishment)

Occurs at **Transport Layer (L4)**.  

1. **SYN** → Client sends synchronize request to server  
2. **SYN-ACK** → Server acknowledges and synchronizes  
3. **ACK** → Client acknowledges server  

**Diagram:**

Client Server
| SYN (seq=x) ------------------------> |
| |
| <--------------------- SYN-ACK (seq=y, ack=x+1)
| |
| ACK (ack=y+1) ----------------------> |
Connection Established!


- Ensures both sides are ready to communicate and initial sequence numbers are synced.

---

## 23.2 Data Transmission (Flow Control & Segmentation)

1. TCP segments application data into **chunks (segments)**.  
2. Each segment includes:
   - Source & Destination Ports
   - Sequence Number
   - Acknowledgment Number
   - Flags (SYN, ACK, FIN, etc.)
3. Segments are sent, **acknowledged by receiver**.

**Diagram (Simplified):**

Application Layer (HTTP/FTP/SSH)
|
v
Transport Layer (TCP) - Segmentation, sequencing, reliability
|
v
Network Layer (IP) - Packet addressing & routing
|
v
Data Link Layer (Ethernet/Wi-Fi)
|
v
Physical Layer (Cables/Wireless)


- OSI mapping ensures **layered responsibility**:
  - Transport Layer → reliability & flow control  
  - Network Layer → IP addressing and routing  
  - Data Link Layer → MAC addressing & framing  
  - Physical Layer → raw bits over medium  

---

## 23.3 Connection Termination (Four-Way Handshake)

TCP connection termination uses **FIN & ACK flags**:

1. Client → FIN  
2. Server → ACK  
3. Server → FIN  
4. Client → ACK  

**Diagram:**

Client Server
| FIN ------------------------------> |
| |
| <---------------------------- ACK |
| |
| <---------------------------- FIN |
| |
| ACK ----------------------------> |
Connection Closed


- Ensures **graceful shutdown** and all data is transmitted.

---

## 23.4 TCP and OSI Layers Summary

| TCP Function                  | OSI Layer | Role                                   |
|--------------------------------|-----------|---------------------------------------|
| Three-way handshake            | L4        | Connection setup                     |
| Segmentation & Sequencing      | L4        | Ensures ordered delivery             |
| Flow control (windowing)       | L4        | Prevents congestion                  |
| Acknowledgment & retransmission| L4        | Reliability                           |
| Encapsulation into IP packets  | L3        | Addressing and routing               |
| Frame encapsulation (MAC)      | L2        | Delivery on LAN                       |
| Physical transmission          | L1        | Electrical/optical/wireless signals  |
