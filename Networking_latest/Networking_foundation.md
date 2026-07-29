# Chapter 1 – Networking Foundations
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Build a strong understanding of networking fundamentals that are frequently asked in interviews at Arista, Cisco, Juniper, NVIDIA, Broadcom, Qualcomm, Intel, and AMD.

---

# 1. Why Do We Need Networking?

Imagine two computers.

```
+-----------+             +-----------+
| Computer A|             | Computer B|
+-----------+             +-----------+
```

Without networking:

- Cannot share files
- Cannot browse websites
- Cannot connect to cloud services
- Cannot access databases
- Cannot communicate with remote systems
- Cannot play online games

Networking defines **how devices communicate using standardized protocols**.

---

## Interview Definition

> **Networking** is the exchange of data between two or more devices using standardized communication protocols over wired or wireless media.

---

# 2. What Happens When You Open www.google.com?

One of the most frequently asked networking interview questions.

```
Browser
   │
   ▼
DNS Lookup
   │
   ▼
IP Address Found
   │
   ▼
TCP Connection
   │
   ▼
TLS Handshake
   │
   ▼
HTTP Request
   │
   ▼
Internet
   │
   ▼
Google Server
   │
   ▼
HTTP Response
   │
   ▼
Browser Displays Page
```

### Step-by-Step Flow

### Step 1

User enters:

```
www.google.com
```

---

### Step 2

Browser asks DNS server:

```
What is the IP address of www.google.com?
```

DNS replies:

```
142.xxx.xxx.xxx
```

---

### Step 3

Browser creates a TCP connection.

```
SYN
SYN + ACK
ACK
```

Connection established.

---

### Step 4

HTTPS performs a TLS handshake.

Encryption keys are exchanged.

---

### Step 5

Browser sends an HTTP request.

```
GET /
Host: www.google.com
```

---

### Step 6

Routers and switches forward packets across the Internet.

---

### Step 7

Google server processes the request.

---

### Step 8

Server sends an HTTP response.

```
HTTP/1.1 200 OK
```

---

### Step 9

Browser renders the webpage.

---

## Interview Tip

Whenever asked this question, explain the **sequence** clearly.

Interviewers care about your reasoning more than memorizing every protocol detail.

---

# 3. Data Encapsulation

Applications do **not** send raw data directly to the network.

Every networking layer adds its own header.

```
Application Data
        │
        ▼
+----------------------+
| Application Payload  |
+----------------------+
        │
        ▼
+----------------------+
| TCP Header           |
| Application Payload  |
+----------------------+
        │
        ▼
+----------------------+
| IP Header            |
| TCP Header           |
| Payload              |
+----------------------+
        │
        ▼
+----------------------+
| Ethernet Header      |
| IP Header            |
| TCP Header           |
| Payload              |
| Ethernet CRC         |
+----------------------+
```

Every layer wraps the previous layer.

This process is called:

**Encapsulation**

At the receiver:

Headers are removed one by one.

This is called:

**Decapsulation**

---

# 4. Frame vs Packet vs Segment

This is a very common interview question.

| Name | OSI Layer | Contains |
|-------|-----------|----------|
| Frame | Layer 2 | MAC Header + IP Packet |
| Packet | Layer 3 | IP Header + TCP/UDP Segment |
| Segment | Layer 4 (TCP) | TCP Header + Application Data |
| Datagram | Layer 4 (UDP) | UDP Header + Application Data |

Relationship:

```
Frame
 └── Packet
      └── Segment
           └── Application Data
```

### Easy Way to Remember

Frame → Local Network

Packet → Internet

Segment → Transport Layer

---

# 5. Client and Server

Example:

```
Laptop -----------------> Google Server

 Client                   Server
```

## Client

Initiates communication.

Examples:

- Browser
- SSH Client
- Mobile App

---

## Server

Waits for requests.

Processes requests.

Returns responses.

Examples:

- Web Server
- Database Server
- DNS Server

---

# 6. IP Address vs MAC Address

One of the most asked networking interview questions.

| IP Address | MAC Address |
|------------|-------------|
| Logical Address | Physical Address |
| Layer 3 | Layer 2 |
| Used for Routing | Used inside Local Network |
| Can Change | Usually Fixed for NIC |

Example:

```
Laptop

IP  = 192.168.1.20

MAC = A4:5E:60:12:34:56
```

### Simple Analogy

Imagine sending a courier.

IP Address

> Which city should the package go to?

MAC Address

> Which exact house should receive it?

---

# 7. Ports

A computer can run many applications simultaneously.

How does the operating system know which application should receive incoming data?

Using **port numbers**.

Example:

```
Port 22  → SSH

Port 80  → HTTP

Port 443 → HTTPS

Port 53  → DNS

Port 25  → SMTP
```

A TCP connection is uniquely identified by:

```
Source IP

Destination IP

Source Port

Destination Port

Protocol (TCP/UDP)
```

This is called the **5-Tuple**.

Network devices and operating systems use this information to identify every connection.

---

# 8. Interview Corner

## Q1. What is Networking?

Networking is the communication of data between devices using standardized communication protocols.

---

## Q2. Explain what happens when opening www.google.com.

1. DNS lookup
2. TCP handshake
3. TLS handshake
4. HTTP request
5. Packet routing
6. Server processing
7. HTTP response
8. Browser rendering

---

## Q3. What is Encapsulation?

Adding protocol headers while moving down the networking stack.

---

## Q4. What is Decapsulation?

Removing protocol headers while moving up the networking stack.

---

## Q5. Difference between Frame, Packet and Segment?

Frame

Layer 2

Packet

Layer 3

Segment

Layer 4 (TCP)

---

## Q6. Why are both IP and MAC addresses needed?

IP determines **where** data should travel across networks.

MAC identifies the destination interface on the local network.

---

## Q7. What uniquely identifies a TCP connection?

The **5-Tuple**:

- Source IP
- Destination IP
- Source Port
- Destination Port
- Protocol

---

# Common Interview Mistakes

❌ Saying a packet and frame are the same.

✔ They belong to different layers.

---

❌ Saying MAC addresses are used for Internet routing.

✔ Routers route using IP addresses.

---

❌ Saying applications communicate using IP addresses.

✔ Applications communicate using **ports**. IP identifies the host.

---

❌ Forgetting DNS lookup before TCP connection.

DNS generally happens first (unless the IP is already cached).

---

# Quick Revision

```
Networking
│
├── Devices communicate using protocols
│
├── DNS → Finds IP Address
│
├── TCP → Reliable Communication
│
├── TLS → Secure Communication
│
├── HTTP → Application Protocol
│
├── IP → Routing
│
├── Ethernet → Local Delivery
│
├── Frame
│     └── Packet
│          └── Segment
│
├── Client ↔ Server
│
├── IP Address → Network Identity
│
├── MAC Address → Local Interface Identity
│
└── Port → Application Identification
```

---

# Chapter Summary

After completing this chapter, you should be able to answer:

- What is networking?
- What happens when opening a website?
- What is encapsulation?
- Difference between frame, packet, segment, and datagram.
- Difference between IP and MAC addresses.
- What is a port?
- What is the 5-Tuple?
- Client vs Server communication.

---

**Next Chapter:** OSI Model & TCP/IP Model (Interview-Oriented)