# Networking Interview Handbook

# Table of Contents

1. Networking Fundamentals
2. OSI and TCP/IP Models
3. Ethernet
4. MAC Addresses
5. ARP
6. IP Addressing
7. Subnetting
8. IPv4
9. IPv6
10. Routing
11. Routing Tables
12. ICMP
13. UDP
14. TCP
15. TCP Connection Establishment
16. TCP Data Transfer
17. TCP Reliability
18. TCP Flow Control
19. TCP Congestion Control
20. TCP Connection Termination
21. TCP States
22. TCP Timers
23. TCP Retransmission
24. TCP Keepalive
25. UDP vs TCP
26. Ports and Sockets
27. Linux Socket Programming
28. Blocking vs Non-Blocking Sockets
29. `select()`, `poll()`, `epoll()`
30. Socket Buffers
31. Linux Network Stack
32. Network Device Driver
33. Interrupts and NAPI
34. DMA and Networking
35. Packet Receive Path
36. Packet Transmit Path
37. DNS
38. DHCP
39. NAT
40. HTTP
41. HTTPS
42. TLS
43. Certificates
44. HTTP/1.1, HTTP/2, HTTP/3
45. QUIC
46. Proxy and Reverse Proxy
47. Load Balancer
48. CDN
49. Firewall
50. VLAN
51. MTU and Fragmentation
52. Network Performance
53. Common Network Debugging Commands
54. Network Troubleshooting
55. Senior Interview Questions
56. Final Mental Models

---

# 1. Networking Fundamentals

Networking allows computers and devices to communicate.

Basic flow:

```text
Application
    |
    v
Transport
    |
    v
Network
    |
    v
Data Link
    |
    v
Physical
```

Example:

```text
Application
    |
    v
TCP
    |
    v
IP
    |
    v
Ethernet
    |
    v
NIC
    |
    v
Network
```

---

# 2. OSI Model

The OSI model has seven layers:

```text
7. Application
6. Presentation
5. Session
4. Transport
3. Network
2. Data Link
1. Physical
```

For practical Linux networking, focus heavily on:

```text
Application
Transport
Network
Data Link
```

---

# 3. TCP/IP Model

The practical TCP/IP model is commonly represented as:

```text
Application
Transport
Internet
Link
```

Mapping:

```text
OSI                 TCP/IP

Application   ─┐
Presentation   ├── Application
Session       ─┘

Transport     ─── Transport

Network       ─── Internet

Data Link     ─┐
Physical      ─┴── Link
```

---

# 4. Encapsulation

When sending data:

```text
Application Data
      |
      v
TCP Header + Data
      |
      v
IP Header + TCP + Data
      |
      v
Ethernet Header + IP + TCP + Data
```

Conceptually:

```text
Application
    ↓
TCP segment
    ↓
IP packet
    ↓
Ethernet frame
```

At the receiver:

```text
Ethernet Frame
      ↓
IP Packet
      ↓
TCP Segment
      ↓
Application Data
```

This is called:

> Encapsulation and decapsulation.

---

# 5. Ethernet

Ethernet operates primarily at the Data Link layer.

An Ethernet frame contains:

```text
+----------------+
| Destination MAC|
+----------------+
| Source MAC     |
+----------------+
| EtherType      |
+----------------+
| Payload        |
+----------------+
| FCS            |
+----------------+
```

The MAC address identifies the network interface at Layer 2.

---

# 6. MAC Address

Typical MAC address:

```text
00:11:22:33:44:55
```

It is generally 48 bits.

Example:

```text
Source MAC
00:11:22:33:44:55

Destination MAC
AA:BB:CC:DD:EE:FF
```

Important:

> MAC addresses are Layer 2 addresses. IP addresses are Layer 3 addresses.

---

# 7. ARP

ARP means:

> Address Resolution Protocol.

IPv4 uses ARP to map:

```text
IP address → MAC address
```

Example:

```text
192.168.1.10
      |
      v
ARP
      |
      v
AA:BB:CC:DD:EE:FF
```

---

# 8. ARP Request

Suppose:

```text
Host A
IP = 192.168.1.10

Needs:
192.168.1.20
```

Host A broadcasts:

```text
Who has 192.168.1.20?
```

The destination is:

```text
FF:FF:FF:FF:FF:FF
```

Host B responds:

```text
192.168.1.20 is at
AA:BB:CC:DD:EE:FF
```

Host A stores the mapping in the ARP cache.

---

# 9. Default Gateway

If destination is outside the local subnet:

```text
Host
  |
  v
Default Gateway
  |
  v
Router
  |
  v
Remote Network
```

The host does NOT need the remote machine's MAC address.

It needs the MAC address of the next-hop router.

---

# 10. IP Addressing

IPv4 address:

```text
192.168.1.10
```

32 bits:

```text
11000000.10101000.00000001.00001010
```

IPv4 consists of:

```text
Network portion
+
Host portion
```

The subnet mask determines the split.

---

# 11. CIDR

CIDR notation:

```text
192.168.1.0/24
```

`/24` means:

```text
24 bits = network
8 bits  = host
```

Therefore:

```text
Network:
192.168.1.0

Broadcast:
192.168.1.255
```

Traditionally usable hosts:

```text
192.168.1.1
...
192.168.1.254
```

---

# 12. Common Subnets

```text
/8
/16
/24
/30
/32
```

Examples:

```text
10.0.0.0/8
172.16.0.0/16
192.168.1.0/24
```

`/32` identifies a single IPv4 address.

---

# 13. Private IPv4 Ranges

Important private ranges:

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

These are commonly used inside private networks.

---

# 14. IPv6

IPv6 uses 128-bit addresses.

Example:

```text
2001:db8::1
```

IPv6 provides a vastly larger address space than IPv4.

Important concepts:

```text
128-bit addresses
Neighbor Discovery
ICMPv6
Link-local addresses
Global addresses
```

IPv6 does not use ARP.

Neighbor Discovery is used instead.

---

# 15. Routing

Routing determines:

> Where should this packet go next?

Conceptually:

```text
Source
  |
  v
Router
  |
  +-- Network A
  +-- Network B
  +-- Network C
```

The router examines the destination IP and selects the appropriate route.

---

# 16. Routing Table

Example:

```text
Destination      Gateway       Interface

192.168.1.0/24   direct        eth0
10.0.0.0/8       192.168.1.1   eth0
0.0.0.0/0        192.168.1.1   eth0
```

The default route:

```text
0.0.0.0/0
```

matches everything not covered by a more specific route.

---

# 17. Longest Prefix Match

Suppose routes are:

```text
10.0.0.0/8
10.1.0.0/16
10.1.2.0/24
```

Destination:

```text
10.1.2.50
```

The most specific route wins:

```text
10.1.2.0/24
```

This is:

> Longest Prefix Match.

---

# 18. ICMP

ICMP is used for network control and error reporting.

Examples:

```text
Ping
Destination unreachable
TTL exceeded
```

Ping uses:

```text
ICMP Echo Request
ICMP Echo Reply
```

Example:

```bash
ping 8.8.8.8
```

---

# 19. TTL

IPv4 packets contain:

```text
TTL
```

TTL prevents packets from looping forever.

Each router decrements TTL.

```text
TTL = 64
   ↓
Router
TTL = 63
   ↓
Router
TTL = 62
```

When TTL reaches zero, the packet is discarded.

The router can send:

```text
ICMP Time Exceeded
```

This mechanism is used by `traceroute`.

---

# 20. UDP

UDP is:

```text
Connectionless
Low overhead
No guaranteed delivery
No ordering
No retransmission
```

UDP header contains:

```text
Source Port
Destination Port
Length
Checksum
```

Typical uses:

```text
DNS
Streaming
Real-time applications
DHCP
QUIC
```

---

# 21. TCP

TCP provides:

```text
Reliable delivery
Ordering
Retransmission
Flow control
Congestion control
Connection-oriented communication
```

TCP is byte-stream oriented.

Important:

> TCP does NOT preserve application message boundaries.

---

# 22. TCP Three-Way Handshake

Connection establishment:

```text
Client                  Server

   SYN -------------------->

       <---------------- SYN + ACK

   ACK -------------------->
```

Meaning:

```text
SYN
    "I want to establish a connection."

SYN + ACK
    "I received your request and agree."

ACK
    "I received your response."
```

After this:

```text
ESTABLISHED
```

---

# 23. TCP Sequence Numbers

TCP uses sequence numbers to track bytes.

Example:

```text
Sender
SEQ = 1000
DATA = 500 bytes
```

Receiver expects:

```text
ACK = 1500
```

TCP acknowledges the next byte expected.

---

# 24. TCP ACK

If receiver has received:

```text
bytes 1000–1499
```

it sends:

```text
ACK = 1500
```

Meaning:

> I have received everything before byte 1500 and expect byte 1500 next.

---

# 25. TCP Retransmission

Suppose:

```text
Sender
   |
   | DATA
   X
   | packet lost
   |
Receiver
```

Sender does not receive the expected ACK.

It can retransmit.

```text
DATA
  |
  X
  |
timeout
  |
  v
retransmit
```

TCP uses retransmission timers and duplicate ACK mechanisms to detect loss.

---

# 26. TCP Flow Control

Flow control protects the receiver.

Receiver advertises:

```text
Receive Window
```

Example:

```text
Receiver can accept:
64 KB
```

Sender should not have more unacknowledged data outstanding than the receive window allows.

---

# 27. TCP Congestion Control

Flow control:

```text
Protect receiver
```

Congestion control:

```text
Protect network
```

Important concepts:

```text
cwnd
ssthresh
Slow Start
Congestion Avoidance
Fast Retransmit
Fast Recovery
```

---

# 28. TCP Window

Effective sending limit is roughly constrained by:

```text
min(
    congestion window,
    receive window
)
```

Therefore:

```text
Sender limitation
=
network congestion
+
receiver capacity
```

---

# 29. TCP Slow Start

At the beginning:

```text
cwnd small
```

Then it grows rapidly.

Conceptually:

```text
1
2
4
8
16
...
```

The exact behavior depends on the congestion-control algorithm and current conditions.

---

# 30. TCP Congestion Avoidance

After reaching an appropriate threshold, growth becomes more conservative.

Conceptually:

```text
Slow Start
     |
     v
ssthresh
     |
     v
Congestion Avoidance
```

The exact algorithm depends on the configured TCP congestion-control implementation.

---

# 31. TCP Connection Termination

Typical graceful close:

```text
Client                  Server

FIN ---------------------->

      <---------------- ACK

      <---------------- FIN

ACK ---------------------->
```

TCP uses a four-segment exchange conceptually because each direction is closed independently.

---

# 32. TCP States

Important states:

```text
CLOSED
LISTEN
SYN-SENT
SYN-RECEIVED
ESTABLISHED
FIN-WAIT-1
FIN-WAIT-2
CLOSE-WAIT
LAST-ACK
TIME-WAIT
CLOSING
```

Most important for interviews:

```text
LISTEN
SYN-SENT
SYN-RECEIVED
ESTABLISHED
FIN-WAIT
CLOSE-WAIT
TIME-WAIT
```

---

# 33. TIME_WAIT

After actively closing a TCP connection, the endpoint may enter:

```text
TIME_WAIT
```

Purpose includes:

```text
Allow delayed old packets to expire
Ensure the final ACK can be retransmitted if necessary
```

A common misconception:

> TIME_WAIT is not simply "waiting for the server."

---

# 34. CLOSE_WAIT

`CLOSE_WAIT` means:

```text
Peer sent FIN
     |
     v
Local TCP acknowledged it
     |
     v
Application has not closed its side yet
```

Large numbers of `CLOSE_WAIT` sockets often indicate an application/resource-management problem.

---

# 35. TCP Timers

Important TCP timing concepts:

```text
Retransmission timeout
Keepalive
TIME_WAIT
Delayed ACK
```

TCP estimates retransmission timeout based on observed network behavior rather than using one fixed universal timeout.

---

# 36. TCP Keepalive

Keepalive can detect dead/idle peers.

Conceptually:

```text
Connection idle
      |
      v
Keepalive probe
      |
      +-- response → connection alive
      |
      +-- no response → eventually detect failure
```

Do not confuse:

```text
TCP keepalive
```

with:

```text
Application-level heartbeat
```

---

# 37. TCP vs UDP

| Feature             | TCP    | UDP      |
| ------------------- | ------ | -------- |
| Connection-oriented | Yes    | No       |
| Reliable            | Yes    | No       |
| Ordered             | Yes    | No       |
| Retransmission      | Yes    | No       |
| Flow control        | Yes    | No       |
| Congestion control  | Yes    | No       |
| Overhead            | Higher | Lower    |
| Byte stream         | Yes    | Datagram |

---

# 38. Ports

A port identifies an endpoint of transport-layer communication.

Example:

```text
IP = 192.168.1.10
Port = 8080
```

Together:

```text
192.168.1.10:8080
```

TCP connection is identified using a 4-tuple:

```text
Source IP
Source Port
Destination IP
Destination Port
```

---

# 39. Socket

A socket is the programming abstraction used by applications to communicate over networks.

Typical server:

```text
socket()
   |
bind()
   |
listen()
   |
accept()
   |
read/write
   |
close()
```

Typical client:

```text
socket()
   |
connect()
   |
read/write
   |
close()
```

---

# 40. Server Socket Flow

```text
socket()
   |
   v
bind()
   |
   v
listen()
   |
   v
accept()
   |
   v
Connected Socket
   |
   v
recv()/send()
   |
   v
close()
```

Important:

> `listen()` socket and the connected socket returned by `accept()` are different sockets.

---

# 41. Client Socket Flow

```text
socket()
   |
   v
connect()
   |
   v
TCP Handshake
   |
   v
Connected
   |
   v
send()/recv()
   |
   v
close()
```

---

# 42. Blocking Socket

By default, many socket operations can block.

Example:

```c
recv(fd, buffer, size, 0);
```

If no data is available:

```text
recv()
  |
  v
sleep
  |
  v
data arrives
  |
  v
wake
```

---

# 43. Non-Blocking Socket

A non-blocking socket returns instead of waiting indefinitely.

If no data is available:

```text
recv()
  |
  v
EAGAIN / EWOULDBLOCK
```

This is important for event-driven servers.

---

# 44. `select()`

`select()` waits for activity on file descriptors.

Conceptually:

```text
select()
   |
   +-- fd1
   +-- fd2
   +-- fd3
```

Limitations include:

```text
FD-set size limits
O(n) scanning
```

---

# 45. `poll()`

`poll()` is another readiness API.

```text
poll()
   |
   +-- fd1
   +-- fd2
   +-- fd3
```

It avoids some of the interface limitations of `select()`, but still requires scanning the supplied descriptors.

---

# 46. `epoll()`

Linux provides:

```text
epoll
```

for scalable event-driven I/O.

Conceptually:

```text
Thousands of sockets
        |
        v
      epoll
        |
        v
Ready sockets only
```

Important APIs:

```c
epoll_create1()
epoll_ctl()
epoll_wait()
```

---

# 47. Level Triggered vs Edge Triggered

### Level Triggered

If data remains available:

```text
event
event
event
```

The application continues to be notified while the condition remains ready.

### Edge Triggered

Notification occurs when readiness changes.

Therefore the application generally needs to drain the resource until it would block.

---

# 48. Linux Network Stack

Simplified receive path:

```text
NIC
 |
 v
DMA
 |
 v
Driver
 |
 v
NAPI
 |
 v
Network Stack
 |
 +-- Ethernet
 +-- IP
 +-- TCP/UDP
 |
 v
Socket
 |
 v
Application
```

---

# 49. Linux Network Transmit Path

```text
Application
    |
    v
Socket
    |
    v
TCP/UDP
    |
    v
IP
    |
    v
Routing
    |
    v
Network Device
    |
    v
Driver
    |
    v
DMA
    |
    v
NIC
```

This flow is extremely important for senior Linux interviews.

---

# 50. NAPI

NAPI is Linux's mechanism for efficient packet processing, combining interrupt notification with polling.

Traditional approach:

```text
Every packet
    |
    v
Interrupt
```

High packet rates can create excessive interrupts.

NAPI conceptually:

```text
Initial interrupt
       |
       v
Disable/reduce interrupt processing
       |
       v
Poll packets
       |
       v
Process batch
       |
       v
Return to interrupt-driven mode
```

This reduces interrupt overhead.

---

# 51. Interrupt + NAPI

Typical receive flow:

```text
NIC receives packet
        |
        v
DMA writes packet
        |
        v
NIC raises interrupt
        |
        v
Driver schedules NAPI
        |
        v
NAPI poll
        |
        v
Process packet batch
        |
        v
Network stack
```

---

# 52. DMA in Networking

High-performance NICs use DMA.

```text
NIC
 |
 | DMA
 v
RAM
```

Driver manages:

```text
DMA descriptors
RX rings
TX rings
Buffers
Mapping/unmapping
Completion
```

---

# 53. RX Ring

Receive queues commonly use descriptor rings.

Conceptually:

```text
RX Ring

+-----+-----+-----+-----+
| D0  | D1  | D2  | D3  |
+-----+-----+-----+-----+
   |
   v
Packet buffers
```

The NIC and driver communicate through descriptors and ownership/state information.

---

# 54. TX Ring

Transmit similarly uses descriptors:

```text
TX Ring

+-----+-----+-----+-----+
| D0  | D1  | D2  | D3  |
+-----+-----+-----+-----+
```

Driver places packet information into descriptors.

NIC processes them through DMA.

---

# 55. Network Packet Receive Path

A simplified Linux receive path:

```text
NIC
 |
 | DMA
 v
Memory
 |
 v
Interrupt
 |
 v
NAPI
 |
 v
Driver
 |
 v
skb / packet representation
 |
 v
Ethernet processing
 |
 v
IP processing
 |
 v
TCP/UDP
 |
 v
Socket receive queue
 |
 v
Application recv()
```

---

# 56. Network Packet Transmit Path

```text
Application
 |
 v
send()
 |
 v
Socket
 |
 v
TCP/UDP
 |
 v
IP
 |
 v
Routing
 |
 v
skb
 |
 v
qdisc/device layer
 |
 v
Driver
 |
 v
TX descriptor
 |
 v
DMA
 |
 v
NIC
```

The exact modern kernel path contains many additional details and optimizations, but this is the essential interview model.

---

# 57. `sk_buff`

Linux networking commonly represents packets using:

```text
struct sk_buff
```

Often called:

```text
skb
```

Conceptually:

```text
skb
 |
 +-- packet data
 +-- protocol information
 +-- length
 +-- metadata
 +-- device information
```

Understanding `skb` at a conceptual level is useful for senior Linux networking interviews.

---

# 58. DNS

DNS converts names into IP addresses.

Example:

```text
www.example.com
       |
       v
DNS
       |
       v
93.184.x.x
```

Basic hierarchy:

```text
Root
 |
 v
TLD
 |
 v
Authoritative Server
 |
 v
Domain
```

---

# 59. DNS Resolution

Typical application flow:

```text
Application
    |
    v
Resolver
    |
    v
DNS Cache
    |
    +-- hit → IP
    |
    +-- miss
          |
          v
       DNS Query
          |
          v
       DNS Server
```

---

# 60. DNS Record Types

Important records:

```text
A       → IPv4 address
AAAA    → IPv6 address
CNAME   → Alias
MX      → Mail server
NS      → Name server
TXT     → Text information
PTR     → Reverse lookup
```

---

# 61. DNS Transport

Traditional DNS commonly uses:

```text
UDP port 53
```

TCP can also be used, including for cases such as:

```text
Large responses
Zone transfers
Certain DNS protocol situations
```

Modern encrypted DNS technologies include:

```text
DoT
DoH
```

---

# 62. DHCP

DHCP dynamically provides network configuration.

Typical information:

```text
IP address
Subnet mask
Default gateway
DNS server
Lease time
```

Basic sequence:

```text
Discover
   ↓
Offer
   ↓
Request
   ↓
ACK
```

Known as:

```text
DORA
```

---

# 63. NAT

NAT means:

> Network Address Translation.

Example:

```text
Private:
192.168.1.10:50000

        NAT

Public:
203.0.113.10:40001
```

The router maintains translation state.

---

# 64. Why NAT Is Used

Common reasons:

```text
IPv4 address conservation
Private addressing
Network isolation
Internet connectivity
```

Port Address Translation allows many private hosts to share one public IP.

---

# 65. HTTP

HTTP is an application-layer protocol.

Example:

```text
Client
  |
  | HTTP Request
  v
Server
  |
  | HTTP Response
  v
Client
```

Common methods:

```text
GET
POST
PUT
PATCH
DELETE
HEAD
OPTIONS
```

---

# 66. HTTP Request

Conceptually:

```text
GET /index.html HTTP/1.1
Host: example.com
```

Response:

```text
HTTP/1.1 200 OK
Content-Type: text/html
```

Common status codes:

```text
200 → OK
201 → Created
301 → Moved Permanently
302 → Found
400 → Bad Request
401 → Unauthorized
403 → Forbidden
404 → Not Found
500 → Internal Server Error
502 → Bad Gateway
503 → Service Unavailable
```

---

# 67. HTTPS

HTTPS is essentially:

```text
HTTP
+
TLS
```

Conceptually:

```text
Application
    |
    v
HTTP
    |
    v
TLS
    |
    v
TCP
    |
    v
IP
```

Without TLS:

```text
HTTP over TCP
```

With TLS:

```text
HTTP over TLS over TCP
```

---

# 68. TLS

TLS provides:

```text
Encryption
Authentication
Integrity
```

High-level handshake:

```text
Client
   |
   | ClientHello
   v
Server
   |
   | ServerHello
   | Certificate
   | Key exchange information
   v
Client
   |
   | Certificate verification
   | Key exchange
   v
Both sides
   |
   v
Shared session keys
   |
   v
Encrypted communication
```

---

# 69. TLS Certificate

The server certificate helps establish:

```text
Server identity
```

The client verifies things such as:

```text
Certificate chain
Hostname
Validity period
Trust
Signature
```

Conceptually:

```text
Server Certificate
       |
       v
CA Signature
       |
       v
Client Trust Store
```

---

# 70. TLS vs TCP

They solve different problems.

TCP:

```text
Reliable byte transport
```

TLS:

```text
Encryption
Authentication
Integrity
```

Therefore:

```text
HTTPS
 =
HTTP
 +
TLS
 +
TCP
 +
IP
```

---

# 71. HTTP/1.1

HTTP/1.1 commonly uses persistent TCP connections.

However, multiple requests on a connection can suffer from application-level head-of-line effects.

---

# 72. HTTP/2

HTTP/2 provides:

```text
Binary framing
Multiplexed streams
Header compression
Stream prioritization concepts
```

Conceptually:

```text
One TCP connection
       |
       +-- Stream 1
       +-- Stream 2
       +-- Stream 3
       +-- Stream 4
```

---

# 73. HTTP/3

HTTP/3 uses:

```text
HTTP/3
   |
   v
QUIC
   |
   v
UDP
   |
   v
IP
```

Instead of:

```text
HTTP/2
   |
   v
TLS
   |
   v
TCP
```

---

# 74. QUIC

QUIC is a transport protocol built over UDP.

It provides mechanisms for:

```text
Reliable delivery
Streams
Congestion control
Encryption
Connection migration
```

QUIC integrates TLS closely into its protocol design.

---

# 75. TCP vs QUIC

TCP:

```text
Reliable byte stream
Connection
TLS commonly above TCP
```

QUIC:

```text
Reliable streams
Runs over UDP
TLS integrated
Supports multiple streams
Can support connection migration
```

---

# 76. Proxy

A forward proxy:

```text
Client
   |
   v
Proxy
   |
   v
Internet
```

The proxy acts on behalf of the client.

Uses include:

```text
Access control
Caching
Filtering
Anonymization
Corporate networking
```

---

# 77. Reverse Proxy

A reverse proxy sits in front of servers:

```text
Client
   |
   v
Reverse Proxy
   |
   +---- Server A
   +---- Server B
   +---- Server C
```

Common functions:

```text
TLS termination
Load balancing
Routing
Caching
Authentication
Rate limiting
```

---

# 78. Load Balancer

A load balancer distributes traffic.

```text
                Load Balancer
                 /    |    \
                /     |     \
             Server Server Server
```

Algorithms include:

```text
Round Robin
Least Connections
Weighted
Hash-based
```

---

# 79. L4 vs L7 Load Balancer

### Layer 4

Works with:

```text
IP
TCP
UDP
```

### Layer 7

Understands:

```text
HTTP
URLs
Headers
Cookies
Methods
```

Example:

```text
/api/users → Server A

/api/orders → Server B
```

---

# 80. CDN

CDN means:

> Content Delivery Network.

Conceptually:

```text
Origin
   |
   +---- Edge A
   +---- Edge B
   +---- Edge C
```

Users are served from a nearby edge when possible.

Benefits:

```text
Lower latency
Reduced origin load
Caching
Improved scalability
```

---

# 81. Firewall

A firewall controls traffic based on rules.

Possible criteria:

```text
Source IP
Destination IP
Port
Protocol
Connection state
Application information
```

Conceptually:

```text
Packet
  |
  v
Firewall
  |
  +-- Allow
  |
  +-- Drop
  |
  +-- Reject
```

---

# 82. VLAN

VLAN provides logical Layer 2 segmentation.

Conceptually:

```text
Physical Switch
      |
      +-- VLAN 10
      |
      +-- VLAN 20
```

Devices in different VLANs generally require routing to communicate.

---

# 83. MTU

MTU means:

> Maximum Transmission Unit.

Common Ethernet MTU:

```text
1500 bytes
```

If a packet is larger than the supported MTU, fragmentation or another mechanism may be required depending on protocol/version/path.

---

# 84. Path MTU Discovery

PMTUD determines the largest packet that can traverse the path without fragmentation.

A mismatch can cause:

```text
Large packets fail
Small packets work
```

This is a common real-world networking troubleshooting problem.

---

# 85. Jumbo Frames

Jumbo frames use an MTU larger than the traditional Ethernet value.

Example:

```text
MTU ≈ 9000
```

Potential benefits:

```text
Fewer packets
Lower per-packet overhead
Potentially better throughput
```

But all relevant devices/path segments must support the configuration.

---

# 86. Network Performance

Important metrics:

```text
Latency
Bandwidth
Throughput
Packet loss
Jitter
CPU utilization
Packets per second
Connection rate
```

Do not confuse:

```text
Bandwidth ≠ Throughput
```

Bandwidth is capacity.

Throughput is actual achieved data rate.

---

# 87. Latency

Latency is the time required for data to travel through the system/path.

Common components:

```text
Serialization
Propagation
Queuing
Processing
Application delay
```

For interactive systems, latency can matter more than raw bandwidth.

---

# 88. Packet Loss

Packet loss can occur because of:

```text
Congestion
Buffer overflow
Bad hardware
Network errors
Firewall rules
Routing problems
```

TCP responds to loss by adjusting transmission behavior.

---

# 89. Jitter

Jitter is variation in packet delay.

Important for:

```text
Voice
Video
Real-time systems
Trading
Industrial systems
```

A network can have:

```text
Low average latency
but high jitter
```

and still provide poor real-time performance.

---

# 90. TCP Performance Formula

A useful conceptual relationship is:

```text
Throughput ≈ Window / RTT
```

More precisely, throughput is constrained by congestion window, receive window, RTT, loss, protocol overhead, and implementation.

Important insight:

> High RTT can limit throughput even when link bandwidth is very high.

---

# 91. Bandwidth-Delay Product

BDP:

```text
Bandwidth × RTT
```

Example:

```text
10 Gbps
RTT = 100 ms
```

The amount of data required "in flight" to fully utilize the path can be large.

This matters for:

```text
High-speed networks
Long-distance links
Storage networking
Data centers
```

---

# 92. Linux Network Commands

Important commands:

```bash
ip addr
ip link
ip route
ip neigh
ss
ping
traceroute
dig
nslookup
ethtool
tcpdump
```

---

# 93. `ip addr`

Show interfaces and addresses:

```bash
ip addr
```

Useful for checking:

```text
IP addresses
Interfaces
State
IPv6
```

---

# 94. `ip route`

Show routing table:

```bash
ip route
```

Example:

```text
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0
```

---

# 95. `ip neigh`

Show neighbor/ARP information:

```bash
ip neigh
```

Example:

```text
192.168.1.1 dev eth0
lladdr aa:bb:cc:dd:ee:ff
```

---

# 96. `ss`

View sockets:

```bash
ss -tuln
```

Meaning:

```text
-t → TCP
-u → UDP
-l → listening
-n → numeric
```

Useful for:

```text
Listening ports
Established connections
Socket states
```

---

# 97. `dig`

DNS debugging:

```bash
dig example.com
```

Useful for:

```text
A records
AAAA records
CNAME
DNS server
Response details
```

---

# 98. `ethtool`

Inspect network interface:

```bash
ethtool eth0
```

Useful for:

```text
Link speed
Duplex
Driver
Features
Offloads
Statistics
```

---

# 99. `tcpdump`

Capture packets:

```bash
sudo tcpdump -i eth0
```

Examples:

```bash
sudo tcpdump -i eth0 tcp
```

```bash
sudo tcpdump -i eth0 port 443
```

This is one of the most important tools for debugging real networking problems.

---

# 100. Network Troubleshooting Method

If an application cannot connect:

```text
1. Is interface up?
        |
2. Does it have an IP?
        |
3. Is route correct?
        |
4. Is gateway reachable?
        |
5. Is DNS working?
        |
6. Is destination reachable?
        |
7. Is port listening?
        |
8. Is firewall blocking?
        |
9. Is TCP handshake successful?
        |
10. Is application protocol working?
```

Commands:

```bash
ip link
ip addr
ip route
ping
ip neigh
ss
dig
tcpdump
```

---

# 101. Debugging TCP Connection Failure

Suppose:

```text
Client cannot connect to server
```

Check:

```text
Client IP
    ↓
Routing
    ↓
Gateway
    ↓
Destination IP
    ↓
Server port
    ↓
Firewall
    ↓
SYN
    ↓
SYN-ACK
    ↓
ACK
```

If SYN leaves but SYN-ACK never returns:

```text
Possible:
Firewall
Routing
Server down
Port filtering
Return-path problem
```

---

# 102. Debugging DNS Failure

Application:

```text
example.com
    |
    X
DNS failure
```

Check:

```bash
cat /etc/resolv.conf
dig example.com
```

Then determine:

```text
Is resolver reachable?
Does DNS server respond?
Is record present?
Is there caching?
Is DNSSEC/relevant validation involved?
```

---

# 103. Debugging High TCP Latency

Check:

```text
RTT
Packet loss
Retransmissions
Congestion
Queueing
CPU load
NIC statistics
```

Useful:

```bash
ping
ss
tcpdump
ethtool
```

---

# 104. Debugging Packet Loss

Check:

```text
NIC errors
Drops
Driver statistics
Queue drops
Switch drops
Firewall
Congestion
MTU
```

Use:

```bash
ethtool -S eth0
ip -s link
tcpdump
```

---

# 105. Offloading

Modern NICs can offload work from the CPU.

Examples:

```text
Checksum offload
TSO
GSO
LRO
GRO
RSS
```

Benefits:

```text
Lower CPU overhead
Higher throughput
Better packet processing efficiency
```

But offloads can make packet captures confusing because software may see packets before/after hardware segmentation/coalescing.

---

# 106. RSS

RSS:

> Receive Side Scaling.

Allows incoming traffic to be distributed across multiple CPU cores.

Conceptually:

```text
NIC
 |
 +-- Queue 0 → CPU 0
 +-- Queue 1 → CPU 1
 +-- Queue 2 → CPU 2
 +-- Queue 3 → CPU 3
```

This is important for high-performance networking.

---

# 107. Multiqueue Networking

Modern NICs often have multiple RX/TX queues.

```text
NIC
 |
 +-- RX Queue 0
 +-- RX Queue 1
 +-- RX Queue 2
 +-- RX Queue 3
```

This enables parallel processing across CPUs.

---

# 108. Zero-Copy Concept

Traditional path:

```text
NIC
 |
 v
Kernel buffer
 |
 v
Application buffer
```

Potentially involves copies.

Zero-copy techniques try to reduce unnecessary copying.

Benefits:

```text
Lower CPU usage
Higher throughput
Lower latency
```

The exact mechanism depends on the application and subsystem.

---

# 109. Network Security

Important concepts:

```text
TLS
Certificates
Authentication
Firewall
IP filtering
Rate limiting
DDoS protection
Encryption
```

For senior interviews, understand **why** each exists rather than memorizing definitions.

---

# 110. SYN Flood

TCP requires a handshake.

An attacker can send many SYNs:

```text
Attacker
   |
   +-- SYN
   +-- SYN
   +-- SYN
   +-- SYN
        ...
        |
        v
Server
```

The server may consume resources tracking half-open connections.

Defenses can include:

```text
SYN cookies
Rate limiting
Firewall filtering
Load balancing
DDoS protection
```

---

# 111. Socket Lifecycle

Remember:

```text
socket()
   |
   v
bind()
   |
   v
listen()
   |
   v
accept()
   |
   v
recv()/send()
   |
   v
close()
```

For client:

```text
socket()
   |
   v
connect()
   |
   v
send()/recv()
   |
   v
close()
```

---

# 112. Network Stack Mental Model

Memorize:

```text
                Application
                     |
                     v
                   Socket
                     |
              +------+------+
              |             |
             TCP           UDP
              |             |
              +------+------+
                     |
                     v
                    IP
                     |
                  Routing
                     |
                     v
                  Ethernet
                     |
                     v
                 Network Driver
                     |
                 DMA / NAPI
                     |
                     v
                    NIC
                     |
                     v
                  Network
```

---

# 113. Complete HTTPS Flow

When you type:

```text
https://example.com
```

think:

```text
Application
    |
    v
DNS lookup
    |
    v
IP address
    |
    v
TCP connection
    |
    v
TLS handshake
    |
    +-- Certificate verification
    +-- Key exchange
    +-- Session keys
    |
    v
Encrypted HTTP
    |
    v
Server
```

This is one of the most important interview flows.

---

# 114. Complete TCP Connection Flow

```text
socket()
    |
connect()
    |
    v
SYN
    |
    v
SYN + ACK
    |
    v
ACK
    |
    v
ESTABLISHED
    |
    +-- DATA
    +-- ACK
    +-- DATA
    +-- ACK
    |
    v
FIN
    |
    v
ACK
    |
    v
FIN
    |
    v
ACK
    |
    v
TIME_WAIT
```

---

# 115. Complete Packet Receive Flow

```text
Network
   |
   v
NIC
   |
   v
DMA
   |
   v
RX Ring
   |
   v
Interrupt
   |
   v
NAPI
   |
   v
Driver
   |
   v
skb
   |
   v
Ethernet
   |
   v
IP
   |
   v
TCP
   |
   v
Socket Receive Queue
   |
   v
recv()
   |
   v
Application
```

---

# 116. Complete Packet Transmit Flow

```text
Application
    |
    v
send()
    |
    v
Socket
    |
    v
TCP
    |
    v
IP
    |
    v
Routing
    |
    v
skb
    |
    v
Network Device
    |
    v
Driver
    |
    v
TX Ring
    |
    v
DMA
    |
    v
NIC
    |
    v
Network
```

---

# 117. Senior Interview Questions

## Q1. Explain TCP three-way handshake.

```text
SYN
SYN + ACK
ACK
```

Purpose:

```text
Synchronize sequence numbers
Establish connection state
Confirm bidirectional reachability
```

---

## Q2. Why does TCP need sequence numbers?

For:

```text
Ordering
Duplicate detection
Acknowledgments
Retransmission
Reliable byte-stream reconstruction
```

---

## Q3. Flow control vs congestion control?

```text
Flow control
    → Protect receiver

Congestion control
    → Protect network
```

---

## Q4. Why does TIME_WAIT exist?

To:

```text
Prevent delayed old packets from interfering
Allow final ACK retransmission if necessary
```

---

## Q5. Why is CLOSE_WAIT often a problem?

Because it means:

```text
Peer closed
    ↓
Local TCP acknowledged
    ↓
Application has not closed
```

Large numbers may indicate an application bug or resource leak.

---

## Q6. Why use UDP if TCP is reliable?

UDP can be useful when the application needs:

```text
Low overhead
Datagrams
Application-controlled reliability
Real-time behavior
Multicast/broadcast support
QUIC
```

---

## Q7. What happens when you enter a URL?

```text
DNS
 ↓
TCP
 ↓
TLS
 ↓
HTTP
```

For HTTP/3:

```text
DNS
 ↓
QUIC
 ↓
TLS-integrated QUIC
 ↓
HTTP/3
```

---

## Q8. What happens when a packet arrives at Linux?

```text
NIC
 ↓
DMA
 ↓
Interrupt/NAPI
 ↓
Driver
 ↓
Network stack
 ↓
IP
 ↓
TCP/UDP
 ↓
Socket
 ↓
Application
```

---

## Q9. Why is NAPI needed?

To avoid excessive interrupt processing at high packet rates and process packets in batches.

---

## Q10. What is `epoll()`?

A Linux event-notification mechanism used to efficiently monitor many file descriptors for readiness.

---

## Q11. `select()` vs `poll()` vs `epoll()`?

```text
select
    → older interface
    → fd-set limitations
    → scanning

poll
    → more flexible fd representation
    → scanning

epoll
    → Linux-specific
    → scalable event notification
```

---

## Q12. What is ARP?

IPv4:

```text
IP → MAC
```

for communication on the local network.

---

## Q13. What happens if destination is outside the local subnet?

The host sends the frame to:

```text
Default Gateway MAC
```

The router forwards the IP packet toward the destination.

---

## Q14. What is longest prefix match?

The most specific matching routing-table entry wins.

---

## Q15. What is MTU?

Maximum packet payload size that can be carried at a particular network layer/link without exceeding that link's frame constraints.

---

## Q16. What is DNS?

A distributed naming system that maps names to information such as IP addresses.

---

## Q17. What does TLS provide?

```text
Confidentiality
Integrity
Authentication
```

---

## Q18. Why does HTTPS need certificates?

To authenticate the server identity and establish trust in the TLS handshake.

---

## Q19. TCP vs HTTP?

TCP:

```text
Transport protocol
```

HTTP:

```text
Application protocol
```

---

## Q20. TCP vs TLS?

TCP:

```text
Reliable transport
```

TLS:

```text
Security layer
```

---

# 118. Most Important Topics to Master

### Tier 1 — Must Know

```text
★★★★★ TCP
★★★★★ TCP handshake
★★★★★ TCP termination
★★★★★ TCP states
★★★★★ Sequence numbers
★★★★★ ACK
★★★★★ Retransmission
★★★★★ Flow control
★★★★★ Congestion control
★★★★★ Sockets
★★★★★ epoll
★★★★★ Linux network stack
★★★★★ DNS
★★★★★ IP routing
★★★★★ ARP
★★★★★ TLS/HTTPS
★★★★★ Packet receive/transmit path
```

### Tier 2 — Strongly Recommended

```text
★★★★☆ UDP
★★★★☆ DHCP
★★★★☆ NAT
★★★★☆ ICMP
★★★★☆ MTU
★★★★☆ NAPI
★★★★☆ DMA
★★★★☆ RSS
★★★★☆ Network queues
★★★★☆ Load balancing
★★★★☆ HTTP/2
★★★★☆ HTTP/3
★★★★☆ QUIC
★★★★☆ Firewall
★★★★☆ VLAN
```

### Tier 3 — Know Conceptually

```text
★★★☆☆ CDN
★★★☆☆ Proxy
★★★☆☆ Zero copy
★★★☆☆ Advanced TCP algorithms
★★★☆☆ Advanced NIC offloads
★★★☆☆ IPv6 internals
```

---

# 119. Final Senior-Level Mental Model

The entire networking stack can be remembered as:

```text
                    APPLICATION
                         |
                         v
                       HTTP
                         |
                         v
                  TLS / QUIC
                         |
                         v
                    TCP / UDP
                         |
                         v
                        IP
                         |
                    ROUTING
                         |
                         v
                    ETHERNET
                         |
                         v
                 NETWORK DRIVER
                         |
                +--------+--------+
                |                 |
               DMA              NAPI
                |                 |
                +--------+--------+
                         |
                         v
                        NIC
                         |
                         v
                      NETWORK
```

For an incoming packet:

```text
NETWORK
   ↓
NIC
   ↓
DMA
   ↓
Driver
   ↓
NAPI
   ↓
Ethernet
   ↓
IP
   ↓
TCP/UDP
   ↓
Socket
   ↓
Application
```

For an outgoing packet:

```text
Application
   ↓
Socket
   ↓
TCP/UDP
   ↓
IP
   ↓
Routing
   ↓
Ethernet
   ↓
Driver
   ↓
DMA
   ↓
NIC
   ↓
NETWORK
```

---

# 120. Final Interview Checklist

Before a senior Linux/networking interview, you should be able to explain without notes:

```text
[ ] OSI vs TCP/IP
[ ] Ethernet frame
[ ] MAC address
[ ] ARP
[ ] IP addressing
[ ] CIDR/subnetting
[ ] Default gateway
[ ] Routing table
[ ] Longest prefix match
[ ] ICMP
[ ] TCP vs UDP
[ ] TCP three-way handshake
[ ] TCP sequence numbers
[ ] ACK
[ ] Retransmission
[ ] Flow control
[ ] Congestion control
[ ] TCP states
[ ] TIME_WAIT
[ ] CLOSE_WAIT
[ ] TCP timers
[ ] Sockets
[ ] bind/listen/accept/connect
[ ] Blocking vs non-blocking
[ ] select/poll/epoll
[ ] Linux network stack
[ ] skb
[ ] NIC
[ ] DMA
[ ] RX/TX rings
[ ] Interrupts
[ ] NAPI
[ ] RSS
[ ] DNS
[ ] DHCP
[ ] NAT
[ ] HTTP
[ ] HTTPS
[ ] TLS handshake
[ ] Certificates
[ ] HTTP/2
[ ] HTTP/3
[ ] QUIC
[ ] MTU
[ ] Firewall
[ ] Load balancer
[ ] Network debugging
[ ] tcpdump
[ ] ss
[ ] ip
[ ] dig
[ ] ethtool
```

---

# Final Dependency Chain

The most important chain to remember is:

```text
Application
    ↓
DNS
    ↓
IP Address
    ↓
Socket
    ↓
TCP/UDP
    ↓
IP
    ↓
Routing
    ↓
ARP / Neighbor Discovery
    ↓
Ethernet
    ↓
NIC Driver
    ↓
DMA
    ↓
NIC
    ↓
Network
```

And for HTTPS:

```text
URL
 ↓
DNS
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

For HTTP/3:

```text
URL
 ↓
DNS
 ↓
IP
 ↓
QUIC
 ↓
TLS
 ↓
HTTP/3
 ↓
Application
```

**If you can explain these flows deeply and connect them to Linux system calls, sockets, interrupts, DMA, drivers, and packet processing, you have the networking foundation expected for senior Linux/C/C++ systems interviews.**
