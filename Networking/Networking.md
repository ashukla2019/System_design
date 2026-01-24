# 📘 Networking Fundamentals for System Design Interviews

This document consolidates **networking basics + system design expectations** into a single, structured reference.

---

## 1. What is Networking?
Networking is the practice of connecting two or more devices to exchange data.

### Why Networking is Needed
- Messaging (WhatsApp, Email)
- Internet browsing
- File & printer sharing
- Accessing servers & databases
- Cloud services (AWS, Azure, GCP)

---

## 2. Types of Networks

| Type | Description | Examples |
|---|---|---|
| PAN | Personal, very short range | Bluetooth, Smartwatch |
| LAN | Limited area, high speed | Home Wi-Fi, Office |
| MAN | City-wide | ISP city network |
| WAN | Large geographical area | Internet |

---

## 3. Network Topologies

| Topology | Description |
|---|---|
| Bus | Single backbone cable |
| Star | Central hub/switch |
| Ring | Circular data path |
| Mesh | Multiple redundant paths |
| Hybrid | Combination of topologies |

---

## 4. OSI Model (7 Layers)

| Layer | Name | Purpose | Examples |
|---|---|---|---|
| 7 | Application | User-facing services | HTTP, FTP, DNS |
| 6 | Presentation | Encryption & formatting | TLS/SSL |
| 5 | Session | Session management | RPC |
| 4 | Transport | Reliable delivery | TCP, UDP |
| 3 | Network | Routing & IP | IP, ICMP |
| 2 | Data Link | MAC & framing | Ethernet, ARP |
| 1 | Physical | Signals & media | Cables, Wi-Fi |

> Interview tip: L7 = app issue, L4 = TCP issue, L3 = routing issue

---

## 5. TCP/IP Model

| TCP/IP Layer | OSI Mapping |
|---|---|
| Application | OSI 7,6,5 |
| Transport | OSI 4 |
| Internet | OSI 3 |
| Network Access | OSI 2,1 |

---

## 6. Encapsulation & Decapsulation

### Sender Side
Application Data
→ Segment (TCP/UDP)
→ Packet (IP)
→ Frame (MAC)
→ Bits


### Receiver Side
Bits → Frame → Packet → Segment → Data


---
## 7. Networking Devices

| Device | OSI Layer | Function |
|------|----------|----------|
| **Hub** | L1 (Physical) | Broadcasts incoming data to **all ports** without filtering. No MAC awareness, causes collisions. Largely obsolete. |
| **Repeater** | L1 (Physical) | **Regenerates and amplifies** weak signals to extend transmission distance. Does not understand data. |
| **Switch** | L2 (Data Link) | Forwards frames using a **MAC address table**. Creates separate collision domains per port. Faster and more efficient than hubs. |
| **Bridge** | L2 (Data Link) | Connects **two LAN segments** and filters traffic using MAC addresses. Logical predecessor of switches. |
| **Router** | L3 (Network) | Routes packets using **IP addresses and routing tables**. Connects different networks and separates broadcast domains. |
| **Gateway** | L5–L7 (Session–Application) | Performs **protocol translation** (e.g., HTTP ↔ FTP, IPv4 ↔ IPv6). Entry/exit point between dissimilar networks. |
| **Access Point (AP)** | L2 (Data Link) | Connects **wireless clients to a wired LAN**. Acts like a switch for Wi-Fi devices. |
| **Firewall** | L3 / L4 (sometimes L7) | Filters traffic using **IP, port, protocol** (and content at L7). Enforces network security rules. |

### Quick Memory Notes
- **Hub** → Broadcasts everything  
- **Switch** → MAC-based forwarding  
- **Router** → IP-based routing  
- **Gateway** → Protocol translator  
- **Firewall** → Security filter


---

## 8. IP Addressing Basics

### IPv4
- 32-bit (e.g. `192.168.1.10`)
- Network ID + Host ID

### IPv6
- 128-bit hexadecimal
- Network Prefix + Interface ID
- Supports `::` compression

---

## 9. IP Address Classes (Legacy)

| Class | Range | Usage |
|---|---|---|
| A | 1.0.0.0 – 126.255.255.255 | Large networks |
| B | 128.0.0.0 – 191.255.255.255 | Medium |
| C | 192.0.0.0 – 223.255.255.255 | Small |
| D | 224.0.0.0 – 239.255.255.255 | Multicast |
| E | 240.0.0.0 – 255.255.255.255 | Experimental |

### Private IP Ranges
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

---

## 10. Subnetting & CIDR

Subnetting divides a network into smaller logical networks.

### CIDR
- `/24`, `/16`, `/30`
- Efficient IP allocation

### Host Formula
Hosts = 2^(host bits) – 2


IPv6 commonly uses `/64`.

Ex:192.168.1.0/24

- `/24` → 24 bits for network
- Remaining bits → host bits

---
## Common CIDR Blocks (IPv4)

| CIDR | Total IPs | Usable Hosts | Usage |
|-----|----------|--------------|-------|
| /30 | 4 | 2 | Point-to-point links |
| /29 | 8 | 6 | Small subnets |
| /24 | 256 | 254 | LAN / VPC subnet |
| /16 | 65,536 | 65,534 | Large private networks |

**Usable Hosts = Total IPs − 2**  
(Network ID + Broadcast address)

---

## Host Formula (IPv4)

---

### Special CIDR
- `/32` → Single IP (host route)
- `/31` → Point-to-point, no broadcast

---

### IPv6 Subnetting
- Standard subnet: `/64`
- No broadcast
- Host calculation not required

---

### IPv4 vs IPv6

| Feature | IPv4 | IPv6 |
|----|----|----|
| Address size | 32-bit | 128-bit |
| Typical subnet | /24 | /64 |
| Broadcast | Yes | No |

---

### Key Interview Points
- Subnetting improves IP utilization
- CIDR allows flexible subnet sizing
- IPv4 hosts = `2^(host bits) − 2`
- IPv6 commonly uses `/64`

---

## 11. Ports & Common Protocols

| Protocol | Port |
|---|---|
| HTTP | 80 |
| HTTPS | 443 |
| DNS | 53 |
| DHCP | 67 / 68 |
| SSH | 22 |
| FTP | 20 / 21 |

---

## 12. Address Resolution
- **ARP**: IP → MAC (local network)
- **DNS**: Domain → IP

---

## 13. TCP vs UDP

### TCP
- Reliable, ordered
- Connection-based
- Used for HTTP, APIs, databases

### UDP
- Fast, connectionless
- No delivery guarantee
- Used for streaming, DNS

---

## 14. TCP Connection Lifecycle

### 3-Way Handshake
SYN → SYN-ACK → ACK


### 4-Way Termination
FIN → ACK → FIN → ACK

--

## 15. Network Services

| Service | Purpose |
|---|---|
| NAT | Private → Public IP |
| DHCP | Automatic IP assignment |
| VPN | Secure tunnel |
| Load Balancer | Traffic distribution |

### NAT Types
- Static NAT
- Dynamic NAT
- PAT (NAT Overload)

---

## 16. Switching & Routing

### Switching
- Learns MAC addresses
- Floods unknown destinations

### Routing
- Static routing
- Dynamic routing (RIP, OSPF, BGP)
- Default routes

---

## 17. VLAN, STP & MTU
- **VLAN**: Logical network segmentation
- **STP**: Prevents switching loops
- **MTU**: Max packet size
- IPv4 allows router fragmentation
- IPv6 does not

---

## 18. Traffic Types

| Type | Description |
|---|---|
| Unicast | One-to-one |
| Broadcast | One-to-all |
| Multicast | One-to-many |

---

## 19. HTTP & HTTPS (System Design)
- HTTP is stateless
- HTTPS = HTTP + TLS
- TLS provides encryption, authentication, integrity
- REST vs RPC (high-level)
- Idempotency (GET vs POST)

---

## 20. Proxies & CDN

### Reverse Proxy
- SSL termination
- Load balancing
- Request routing
- Examples: Nginx, Envoy

### CDN
- Edge caching
- Faster content delivery
- Cache invalidation

---

## 21. Cloud Networking Basics
- VPC (Virtual Private Cloud)
- Public vs Private Subnets
- Route Tables
- Internet Gateway
- NAT Gateway

---

## 22. Network Security Basics
- Firewalls
- Security Groups (stateful)
- NACLs (stateless)
- IDS / IPS
- Encryption

---

## 23. End-to-End Request Flow (Interview Favorite)
User
→ DNS lookup
→ TCP handshake
→ HTTP request
→ Router / Firewall
→ Load Balancer
→ Application Server
→ Database
→ Response back
