# Networking Interview Handbook

---

# 1. Networking Fundamentals

Networking allows computers and devices to communicate.

Basic flow: 
```
1. Browser
   ↓
2. DNS → Find IP for google.com
   ↓
3. Browser establishes secure connection
   ↓
4. HTTP request is created
   ↓
5. Application
   ↓
6. Transport (TCP/QUIC)
   ↓
7. Network (IP)
   ↓
8. Data Link (Wi-Fi/Ethernet)
   ↓
9. Physical → bits/signals
   ↓
   Internet / routers
   ↓
10. Physical
   ↓
11. Data Link
   ↓
12. Network (IP)
   ↓
13. Transport
   ↓
14. TLS decrypts
   ↓
15. HTTP interprets
   ↓
16. Google's application processes request
   ↓
17. Response travels back the same way

```
Example: `Application → TCP → IP → Ethernet → NIC → Network`

---

# 2. OSI Model

The OSI model has seven layers: `7.Application 6.Presentation 5.Session 4.Transport 3.Network 2.Data Link 1.Physical`

For practical Linux networking, focus heavily on: `Application, Transport, Network, Data Link`

---

# 3. TCP/IP Model

The practical TCP/IP model is commonly represented as: `Application → Transport → Internet → Link`

Mapping: OSI {Application, Presentation, Session} → TCP/IP Application | OSI Transport → TCP/IP Transport | OSI Network → TCP/IP Internet | OSI {Data Link, Physical} → TCP/IP Link

---

# 4. Encapsulation

When sending data: `Application Data → TCP Header+Data → IP Header+TCP+Data → Ethernet Header+IP+TCP+Data`

Conceptually: `Application → TCP segment → IP packet → Ethernet frame`

At the receiver: `Ethernet Frame → IP Packet → TCP Segment → Application Data`

This is called: encapsulation and decapsulation.

---

# 5. Ethernet

Ethernet operates primarily at the Data Link layer.

An Ethernet frame contains (in order): `Destination MAC | Source MAC | EtherType | Payload | FCS`

The MAC address identifies the network interface at Layer 2.

---

# 6. MAC Address

Typical MAC address: `00:11:22:33:44:55` — generally 48 bits.

Example: Source MAC `00:11:22:33:44:55`, Destination MAC `AA:BB:CC:DD:EE:FF`

Important: MAC addresses are Layer 2 addresses. IP addresses are Layer 3 addresses.

---

# 7. ARP

ARP means: Address Resolution Protocol.

IPv4 uses ARP to map: `IP address → MAC address`

Example: `192.168.1.10 → ARP → AA:BB:CC:DD:EE:FF`

---

# 8. ARP Request

Suppose Host A has IP `192.168.1.10` and needs `192.168.1.20`.

Host A broadcasts: "Who has 192.168.1.20?" — destination is `FF:FF:FF:FF:FF:FF`

Host B responds: "192.168.1.20 is at AA:BB:CC:DD:EE:FF"

Host A stores the mapping in the ARP cache.

---

# 9. Default Gateway

If destination is outside the local subnet: `Host → Default Gateway → Router → Remote Network`

The host does NOT need the remote machine's MAC address. It needs the MAC address of the next-hop router.

---

# 10. IP Addressing

IPv4 address: `192.168.1.10` — 32 bits: `11000000.10101000.00000001.00001010`

IPv4 consists of: Network portion + Host portion. The subnet mask determines the split.

---

# 11. CIDR

CIDR notation: `192.168.1.0/24` — `/24` means 24 bits = network, 8 bits = host.

Therefore: Network = `192.168.1.0`, Broadcast = `192.168.1.255`

Traditionally usable hosts: `192.168.1.1` ... `192.168.1.254`

---

# 12. Common Subnets

Examples: `/8, /16, /24, /30, /32` → `10.0.0.0/8`, `172.16.0.0/16`, `192.168.1.0/24`

`/32` identifies a single IPv4 address.

---

# 13. Private IPv4 Ranges

Important private ranges: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` — commonly used inside private networks.

---

# 14. IPv6

IPv6 uses 128-bit addresses. Example: `2001:db8::1`

IPv6 provides a vastly larger address space than IPv4.

Important concepts: 128-bit addresses, Neighbor Discovery, ICMPv6, Link-local addresses, Global addresses.

IPv6 does not use ARP. Neighbor Discovery is used instead.

---

# 15. Routing

Routing determines: "Where should this packet go next?"

Conceptually: `Source → Router → {Network A, Network B, Network C}`

The router examines the destination IP and selects the appropriate route.

---

# 16. Routing Table

Example:

| Destination | Gateway | Interface |
|---|---|---|
| 192.168.1.0/24 | direct | eth0 |
| 10.0.0.0/8 | 192.168.1.1 | eth0 |
| 0.0.0.0/0 | 192.168.1.1 | eth0 |

The default route `0.0.0.0/0` matches everything not covered by a more specific route.

---

# 17. Longest Prefix Match

Suppose routes are `10.0.0.0/8`, `10.1.0.0/16`, `10.1.2.0/24`, and destination is `10.1.2.50`.

The most specific route wins: `10.1.2.0/24` — this is Longest Prefix Match.

---

# 18. ICMP

ICMP is used for network control and error reporting. Examples: Ping, Destination unreachable, TTL exceeded.

Ping uses: ICMP Echo Request / ICMP Echo Reply. Example: `ping 8.8.8.8`

---

# 19. TTL

IPv4 packets contain TTL, which prevents packets from looping forever. Each router decrements TTL: `TTL=64 → Router → TTL=63 → Router → TTL=62`

When TTL reaches zero, the packet is discarded. The router can send ICMP Time Exceeded. This mechanism is used by `traceroute`.

---

# 20. UDP

UDP is: connectionless, low overhead, no guaranteed delivery, no ordering, no retransmission.

UDP header contains: Source Port, Destination Port, Length, Checksum.

Typical uses: DNS, Streaming, Real-time applications, DHCP, QUIC.

---

# 21. TCP

TCP provides: reliable delivery, ordering, retransmission, flow control, congestion control, connection-oriented communication.

TCP is byte-stream oriented. Important: TCP does NOT preserve application message boundaries.

---

# 22. TCP Three-Way Handshake

Connection establishment: `Client --SYN--> Server`, `Client <--SYN+ACK-- Server`, `Client --ACK--> Server`

Meaning: SYN = "I want to establish a connection." | SYN+ACK = "I received your request and agree." | ACK = "I received your response."

After this: ESTABLISHED

---

# 23. TCP Sequence Numbers

TCP uses sequence numbers to track bytes. Example: Sender SEQ=1000, DATA=500 bytes → Receiver expects ACK=1500

TCP acknowledges the next byte expected.

---

# 24. TCP ACK

If receiver has received bytes 1000–1499, it sends ACK=1500.

Meaning: "I have received everything before byte 1500 and expect byte 1500 next."

---

# 25. TCP Retransmission

Suppose: `Sender --DATA--X (packet lost)--> Receiver`

Sender does not receive the expected ACK. It can retransmit: `DATA --X--> timeout → retransmit`

TCP uses retransmission timers and duplicate ACK mechanisms to detect loss.

---

# 26. TCP Flow Control

Flow control protects the receiver. Receiver advertises a Receive Window (e.g., receiver can accept 64 KB).

Sender should not have more unacknowledged data outstanding than the receive window allows.

---

# 27. TCP Congestion Control

Flow control → protect receiver. Congestion control → protect network.

Important concepts: cwnd, ssthresh, Slow Start, Congestion Avoidance, Fast Retransmit, Fast Recovery.

---

# 28. TCP Window

Effective sending limit is roughly constrained by: `min(congestion window, receive window)`

Therefore: Sender limitation = network congestion + receiver capacity.

---

# 29. TCP Slow Start

At the beginning, cwnd is small then grows rapidly. Conceptually: `1, 2, 4, 8, 16, ...`

The exact behavior depends on the congestion-control algorithm and current conditions.

---

# 30. TCP Congestion Avoidance

After reaching an appropriate threshold, growth becomes more conservative: `Slow Start → ssthresh → Congestion Avoidance`

The exact algorithm depends on the configured TCP congestion-control implementation.

---

# 31. TCP Connection Termination

Typical graceful close: `Client --FIN--> Server`, `Client <--ACK-- Server`, `Client <--FIN-- Server`, `Client --ACK--> Server`

TCP uses a four-segment exchange conceptually because each direction is closed independently.

---

# 32. TCP States

Important states: CLOSED, LISTEN, SYN-SENT, SYN-RECEIVED, ESTABLISHED, FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, LAST-ACK, TIME-WAIT, CLOSING

Most important for interviews: LISTEN, SYN-SENT, SYN-RECEIVED, ESTABLISHED, FIN-WAIT, CLOSE-WAIT, TIME-WAIT

---

# 33. TIME_WAIT

After actively closing a TCP connection, the endpoint may enter TIME_WAIT.

Purpose includes: allow delayed old packets to expire; ensure the final ACK can be retransmitted if necessary.

A common misconception: TIME_WAIT is not simply "waiting for the server."

---

# 34. CLOSE_WAIT

`CLOSE_WAIT` means: Peer sent FIN → Local TCP acknowledged it → Application has not closed its side yet.

Large numbers of `CLOSE_WAIT` sockets often indicate an application/resource-management problem.

---

# 35. TCP Timers

Important TCP timing concepts: Retransmission timeout, Keepalive, TIME_WAIT, Delayed ACK.

TCP estimates retransmission timeout based on observed network behavior rather than using one fixed universal timeout.

---

# 36. TCP Keepalive

Keepalive can detect dead/idle peers. Conceptually: Connection idle → Keepalive probe → (response → connection alive) or (no response → eventually detect failure)

Do not confuse TCP keepalive with application-level heartbeat.

---

# 37. TCP vs UDP

| Feature | TCP | UDP |
| --- | --- | --- |
| Connection-oriented | Yes | No |
| Reliable | Yes | No |
| Ordered | Yes | No |
| Retransmission | Yes | No |
| Flow control | Yes | No |
| Congestion control | Yes | No |
| Overhead | Higher | Lower |
| Byte stream | Yes | Datagram |

---

# 38. Ports

A port identifies an endpoint of transport-layer communication. Example: IP=`192.168.1.10`, Port=`8080` → together `192.168.1.10:8080`

TCP connection is identified using a 4-tuple: Source IP, Source Port, Destination IP, Destination Port.

---

# 39. Socket

A socket is the programming abstraction used by applications to communicate over networks.

Typical server: `socket() → bind() → listen() → accept() → read/write → close()`

Typical client: `socket() → connect() → read/write → close()`

---

# 40. Server Socket Flow

`socket() → bind() → listen() → accept() → Connected Socket → recv()/send() → close()`

Important: `listen()` socket and the connected socket returned by `accept()` are different sockets.

---

# 41. Client Socket Flow

`socket() → connect() → TCP Handshake → Connected → send()/recv() → close()`

---

# 42. Blocking Socket

By default, many socket operations can block. Example: `recv(fd, buffer, size, 0);`

If no data is available: `recv() → sleep → data arrives → wake`

---

# 43. Non-Blocking Socket

A non-blocking socket returns instead of waiting indefinitely.

If no data is available: `recv() → EAGAIN / EWOULDBLOCK`

This is important for event-driven servers.

---

# 44. `select()`

`select()` waits for activity on file descriptors: `select() → {fd1, fd2, fd3}`

Limitations include: FD-set size limits, O(n) scanning.

---

# 45. `poll()`

`poll()` is another readiness API: `poll() → {fd1, fd2, fd3}`

It avoids some of the interface limitations of `select()`, but still requires scanning the supplied descriptors.

---

# 46. `epoll()`

Linux provides epoll for scalable event-driven I/O. Conceptually: `Thousands of sockets → epoll → Ready sockets only`

Important APIs: `epoll_create1()`, `epoll_ctl()`, `epoll_wait()`

---

# 47. Level Triggered vs Edge Triggered

**Level Triggered:** If data remains available, `event, event, event` — the application continues to be notified while the condition remains ready.

**Edge Triggered:** Notification occurs when readiness changes. The application generally needs to drain the resource until it would block.

---

# 48. Linux Network Stack

Simplified receive path: `NIC → DMA → Driver → NAPI → Network Stack {Ethernet, IP, TCP/UDP} → Socket → Application`

---

# 49. Linux Network Transmit Path

`Application → Socket → TCP/UDP → IP → Routing → Network Device → Driver → DMA → NIC`

This flow is extremely important for senior Linux interviews.

---

# 50. NAPI

NAPI is Linux's mechanism for efficient packet processing, combining interrupt notification with polling.

Traditional approach: `Every packet → Interrupt`. High packet rates can create excessive interrupts.

NAPI conceptually: `Initial interrupt → Disable/reduce interrupt processing → Poll packets → Process batch → Return to interrupt-driven mode`

This reduces interrupt overhead.

---

# 51. Interrupt + NAPI

Typical receive flow: `NIC receives packet → DMA writes packet → NIC raises interrupt → Driver schedules NAPI → NAPI poll → Process packet batch → Network stack`

---

# 52. DMA in Networking

High-performance NICs use DMA: `NIC --DMA--> RAM`

Driver manages: DMA descriptors, RX rings, TX rings, Buffers, Mapping/unmapping, Completion.

---

# 53. RX Ring

Receive queues commonly use descriptor rings: `RX Ring [D0][D1][D2][D3] → Packet buffers`

The NIC and driver communicate through descriptors and ownership/state information.

---

# 54. TX Ring

Transmit similarly uses descriptors: `TX Ring [D0][D1][D2][D3]`

Driver places packet information into descriptors. NIC processes them through DMA.

---

# 55. Network Packet Receive Path

`NIC --DMA--> Memory → Interrupt → NAPI → Driver → skb/packet representation → Ethernet processing → IP processing → TCP/UDP → Socket receive queue → Application recv()`

---

# 56. Network Packet Transmit Path

`Application → send() → Socket → TCP/UDP → IP → Routing → skb → qdisc/device layer → Driver → TX descriptor → DMA → NIC`

The exact modern kernel path contains many additional details and optimizations, but this is the essential interview model.

---

# 57. `sk_buff`

Linux networking commonly represents packets using `struct sk_buff`, often called `skb`.

Conceptually skb contains: packet data, protocol information, length, metadata, device information.

Understanding `skb` at a conceptual level is useful for senior Linux networking interviews.

---

# 58. DNS

DNS converts names into IP addresses. Example: `www.example.com → DNS → 93.184.x.x`

Basic hierarchy: `Root → TLD → Authoritative Server → Domain`

---

# 59. DNS Resolution

Typical application flow: `Application → Resolver → DNS Cache → (hit → IP) or (miss → DNS Query → DNS Server)`

---

# 60. DNS Record Types

Important records: A→IPv4 address, AAAA→IPv6 address, CNAME→Alias, MX→Mail server, NS→Name server, TXT→Text information, PTR→Reverse lookup

---

# 61. DNS Transport

Traditional DNS commonly uses UDP port 53. TCP can also be used, including for: large responses, zone transfers, certain DNS protocol situations.

Modern encrypted DNS technologies include: DoT, DoH.

---

# 62. DHCP

DHCP dynamically provides network configuration: IP address, Subnet mask, Default gateway, DNS server, Lease time.

Basic sequence: `Discover → Offer → Request → ACK` — known as DORA.

---

# 63. NAT

NAT means: Network Address Translation.

Example: Private `192.168.1.10:50000` --NAT--> Public `203.0.113.10:40001`

The router maintains translation state.

---

# 64. Why NAT Is Used

Common reasons: IPv4 address conservation, Private addressing, Network isolation, Internet connectivity.

Port Address Translation allows many private hosts to share one public IP.

---

# 65. HTTP

HTTP is an application-layer protocol: `Client --HTTP Request--> Server --HTTP Response--> Client`

Common methods: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS

---

# 66. HTTP Request

Conceptually: `GET /index.html HTTP/1.1` / `Host: example.com`

Response: `HTTP/1.1 200 OK` / `Content-Type: text/html`

Common status codes: 200 OK, 201 Created, 301 Moved Permanently, 302 Found, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable

---

# 67. HTTPS

HTTPS is essentially: HTTP + TLS.

Conceptually: `Application → HTTP → TLS → TCP → IP`

Without TLS: HTTP over TCP. With TLS: HTTP over TLS over TCP.

---

# 68. TLS

TLS provides: Encryption, Authentication, Integrity.

High-level handshake: Client sends ClientHello → Server sends ServerHello, Certificate, Key exchange information → Client does Certificate verification, Key exchange → Both sides derive Shared session keys → Encrypted communication

---

# 69. TLS Certificate

The server certificate helps establish Server identity. The client verifies: Certificate chain, Hostname, Validity period, Trust, Signature.

Conceptually: `Server Certificate → CA Signature → Client Trust Store`

---

# 70. TLS vs TCP

They solve different problems. TCP: reliable byte transport. TLS: encryption, authentication, integrity.

Therefore: `HTTPS = HTTP + TLS + TCP + IP`

---

# 71. HTTP/1.1

HTTP/1.1 commonly uses persistent TCP connections. However, multiple requests on a connection can suffer from application-level head-of-line effects.

---

# 72. HTTP/2

HTTP/2 provides: Binary framing, Multiplexed streams, Header compression, Stream prioritization concepts.

Conceptually: `One TCP connection → {Stream 1, Stream 2, Stream 3, Stream 4}`

---

# 73. HTTP/3

HTTP/3 uses: `HTTP/3 → QUIC → UDP → IP` instead of `HTTP/2 → TLS → TCP`

---

# 74. QUIC

QUIC is a transport protocol built over UDP. It provides mechanisms for: Reliable delivery, Streams, Congestion control, Encryption, Connection migration.

QUIC integrates TLS closely into its protocol design.

---

# 75. TCP vs QUIC

TCP: reliable byte stream, connection, TLS commonly above TCP.

QUIC: reliable streams, runs over UDP, TLS integrated, supports multiple streams, can support connection migration.

---

# 76. Proxy

A forward proxy: `Client → Proxy → Internet` — the proxy acts on behalf of the client.

Uses include: Access control, Caching, Filtering, Anonymization, Corporate networking.

---

# 77. Reverse Proxy

A reverse proxy sits in front of servers: `Client → Reverse Proxy → {Server A, Server B, Server C}`

Common functions: TLS termination, Load balancing, Routing, Caching, Authentication, Rate limiting.

---

# 78. Load Balancer

A load balancer distributes traffic: `Load Balancer → {Server, Server, Server}`

Algorithms include: Round Robin, Least Connections, Weighted, Hash-based.

---

# 79. L4 vs L7 Load Balancer

**Layer 4** works with: IP, TCP, UDP.

**Layer 7** understands: HTTP, URLs, Headers, Cookies, Methods. Example: `/api/users → Server A`, `/api/orders → Server B`

---

# 80. CDN

CDN means: Content Delivery Network. Conceptually: `Origin → {Edge A, Edge B, Edge C}`

Users are served from a nearby edge when possible.

Benefits: Lower latency, Reduced origin load, Caching, Improved scalability.

---

# 81. Firewall

A firewall controls traffic based on rules. Possible criteria: Source IP, Destination IP, Port, Protocol, Connection state, Application information.

Conceptually: `Packet → Firewall → {Allow, Drop, Reject}`

---

# 82. VLAN

VLAN provides logical Layer 2 segmentation: `Physical Switch → {VLAN 10, VLAN 20}`

Devices in different VLANs generally require routing to communicate.

---

# 83. MTU

MTU means: Maximum Transmission Unit. Common Ethernet MTU: 1500 bytes.

If a packet is larger than the supported MTU, fragmentation or another mechanism may be required depending on protocol/version/path.

---

# 84. Path MTU Discovery

PMTUD determines the largest packet that can traverse the path without fragmentation.

A mismatch can cause: large packets fail, small packets work. This is a common real-world networking troubleshooting problem.

---

# 85. Jumbo Frames

Jumbo frames use an MTU larger than the traditional Ethernet value. Example: MTU ≈ 9000.

Potential benefits: Fewer packets, Lower per-packet overhead, Potentially better throughput.

But all relevant devices/path segments must support the configuration.

---

# 86. Network Performance

Important metrics: Latency, Bandwidth, Throughput, Packet loss, Jitter, CPU utilization, Packets per second, Connection rate.

Do not confuse: Bandwidth ≠ Throughput. Bandwidth is capacity. Throughput is actual achieved data rate.

---

# 87. Latency

Latency is the time required for data to travel through the system/path.

Common components: Serialization, Propagation, Queuing, Processing, Application delay.

For interactive systems, latency can matter more than raw bandwidth.

---

# 88. Packet Loss

Packet loss can occur because of: Congestion, Buffer overflow, Bad hardware, Network errors, Firewall rules, Routing problems.

TCP responds to loss by adjusting transmission behavior.

---

# 89. Jitter

Jitter is variation in packet delay. Important for: Voice, Video, Real-time systems, Trading, Industrial systems.

A network can have low average latency but high jitter and still provide poor real-time performance.

---

# 90. TCP Performance Formula

A useful conceptual relationship is: `Throughput ≈ Window / RTT`

More precisely, throughput is constrained by congestion window, receive window, RTT, loss, protocol overhead, and implementation.

Important insight: High RTT can limit throughput even when link bandwidth is very high.

---

# 91. Bandwidth-Delay Product

BDP: `Bandwidth × RTT`. Example: 10 Gbps, RTT = 100 ms.

The amount of data required "in flight" to fully utilize the path can be large.

This matters for: High-speed networks, Long-distance links, Storage networking, Data centers.

---

# 92. Linux Network Commands

Important commands: `ip addr`, `ip link`, `ip route`, `ip neigh`, `ss`, `ping`, `traceroute`, `dig`, `nslookup`, `ethtool`, `tcpdump`

---

# 93. `ip addr`

Show interfaces and addresses: `ip addr`

Useful for checking: IP addresses, Interfaces, State, IPv6.

---

# 94. `ip route`

Show routing table: `ip route`

Example: `default via 192.168.1.1 dev eth0` / `192.168.1.0/24 dev eth0`

---

# 95. `ip neigh`

Show neighbor/ARP information: `ip neigh`

Example: `192.168.1.1 dev eth0 lladdr aa:bb:cc:dd:ee:ff`

---

# 96. `ss`

View sockets: `ss -tuln` — meaning: `-t`→TCP, `-u`→UDP, `-l`→listening, `-n`→numeric

Useful for: Listening ports, Established connections, Socket states.

---

# 97. `dig`

DNS debugging: `dig example.com`

Useful for: A records, AAAA records, CNAME, DNS server, Response details.

---

# 98. `ethtool`

Inspect network interface: `ethtool eth0`

Useful for: Link speed, Duplex, Driver, Features, Offloads, Statistics.

---

# 99. `tcpdump`

Capture packets: `sudo tcpdump -i eth0`

Examples: `sudo tcpdump -i eth0 tcp` / `sudo tcpdump -i eth0 port 443`

This is one of the most important tools for debugging real networking problems.

---

# 100. Network Troubleshooting Method

If an application cannot connect, check in order: 1) Is interface up? 2) Does it have an IP? 3) Is route correct? 4) Is gateway reachable? 5) Is DNS working? 6) Is destination reachable? 7) Is port listening? 8) Is firewall blocking? 9) Is TCP handshake successful? 10) Is application protocol working?

Commands: `ip link`, `ip addr`, `ip route`, `ping`, `ip neigh`, `ss`, `dig`, `tcpdump`

---

# 101. Debugging TCP Connection Failure

Suppose client cannot connect to server. Check in order: Client IP → Routing → Gateway → Destination IP → Server port → Firewall → SYN → SYN-ACK → ACK

If SYN leaves but SYN-ACK never returns, possible causes: Firewall, Routing, Server down, Port filtering, Return-path problem.

---

# 102. Debugging DNS Failure

Application: `example.com → X DNS failure`

Check: `cat /etc/resolv.conf`, `dig example.com`

Then determine: Is resolver reachable? Does DNS server respond? Is record present? Is there caching? Is DNSSEC/relevant validation involved?

---

# 103. Debugging High TCP Latency

Check: RTT, Packet loss, Retransmissions, Congestion, Queueing, CPU load, NIC statistics.

Useful tools: `ping`, `ss`, `tcpdump`, `ethtool`

---

# 104. Debugging Packet Loss

Check: NIC errors, Drops, Driver statistics, Queue drops, Switch drops, Firewall, Congestion, MTU.

Use: `ethtool -S eth0`, `ip -s link`, `tcpdump`

---

# 105. Offloading

Modern NICs can offload work from the CPU. Examples: Checksum offload, TSO, GSO, LRO, GRO, RSS.

Benefits: Lower CPU overhead, Higher throughput, Better packet processing efficiency.

But offloads can make packet captures confusing because software may see packets before/after hardware segmentation/coalescing.

---

# 106. RSS

RSS: Receive Side Scaling. Allows incoming traffic to be distributed across multiple CPU cores.

Conceptually: `NIC → {Queue 0→CPU 0, Queue 1→CPU 1, Queue 2→CPU 2, Queue 3→CPU 3}`

This is important for high-performance networking.

---

# 107. Multiqueue Networking

Modern NICs often have multiple RX/TX queues: `NIC → {RX Queue 0, RX Queue 1, RX Queue 2, RX Queue 3}`

This enables parallel processing across CPUs.

---

# 108. Zero-Copy Concept

Traditional path: `NIC → Kernel buffer → Application buffer` — potentially involves copies.

Zero-copy techniques try to reduce unnecessary copying. Benefits: Lower CPU usage, Higher throughput, Lower latency.

The exact mechanism depends on the application and subsystem.

---

# 109. Network Security

Important concepts: TLS, Certificates, Authentication, Firewall, IP filtering, Rate limiting, DDoS protection, Encryption.

For senior interviews, understand **why** each exists rather than memorizing definitions.

---

# 110. SYN Flood

TCP requires a handshake. An attacker can send many SYNs: `Attacker → {SYN, SYN, SYN, SYN, ...} → Server`

The server may consume resources tracking half-open connections.

Defenses can include: SYN cookies, Rate limiting, Firewall filtering, Load balancing, DDoS protection.

---

# 111. Socket Lifecycle

Server: `socket() → bind() → listen() → accept() → recv()/send() → close()`

Client: `socket() → connect() → send()/recv() → close()`

---

# 112. Network Stack Mental Model

Memorize: `Application → Socket → {TCP, UDP} → IP → Routing → Ethernet → Network Driver → {DMA, NAPI} → NIC → Network`

---

# 113. Complete HTTPS Flow

When you type `https://example.com`, think: `Application → DNS lookup → IP address → TCP connection → TLS handshake {Certificate verification, Key exchange, Session keys} → Encrypted HTTP → Server`

This is one of the most important interview flows.

---

# 114. Complete TCP Connection Flow

`socket() → connect() → SYN → SYN+ACK → ACK → ESTABLISHED → {DATA, ACK, DATA, ACK} → FIN → ACK → FIN → ACK → TIME_WAIT`

---

# 115. Complete Packet Receive Flow

`Network → NIC → DMA → RX Ring → Interrupt → NAPI → Driver → skb → Ethernet → IP → TCP → Socket Receive Queue → recv() → Application`

---

# 116. Complete Packet Transmit Flow

`Application → send() → Socket → TCP → IP → Routing → skb → Network Device → Driver → TX Ring → DMA → NIC → Network`

---

# 117. Senior Interview Questions

**Q1. Explain TCP three-way handshake.** `SYN, SYN+ACK, ACK` — Purpose: Synchronize sequence numbers, Establish connection state, Confirm bidirectional reachability.

**Q2. Why does TCP need sequence numbers?** For: Ordering, Duplicate detection, Acknowledgments, Retransmission, Reliable byte-stream reconstruction.

**Q3. Flow control vs congestion control?** Flow control → Protect receiver. Congestion control → Protect network.

**Q4. Why does TIME_WAIT exist?** To: Prevent delayed old packets from interfering, Allow final ACK retransmission if necessary.

**Q5. Why is CLOSE_WAIT often a problem?** Because it means: Peer closed → Local TCP acknowledged → Application has not closed. Large numbers may indicate an application bug or resource leak.

**Q6. Why use UDP if TCP is reliable?** UDP can be useful when the application needs: Low overhead, Datagrams, Application-controlled reliability, Real-time behavior, Multicast/broadcast support, QUIC.

**Q7. What happens when you enter a URL?** `DNS → TCP → TLS → HTTP`. For HTTP/3: `DNS → QUIC → TLS-integrated QUIC → HTTP/3`

**Q8. What happens when a packet arrives at Linux?** `NIC → DMA → Interrupt/NAPI → Driver → Network stack → IP → TCP/UDP → Socket → Application`

**Q9. Why is NAPI needed?** To avoid excessive interrupt processing at high packet rates and process packets in batches.

**Q10. What is `epoll()`?** A Linux event-notification mechanism used to efficiently monitor many file descriptors for readiness.

**Q11. `select()` vs `poll()` vs `epoll()`?** select → older interface, fd-set limitations, scanning. poll → more flexible fd representation, scanning. epoll → Linux-specific, scalable event notification.

**Q12. What is ARP?** IPv4: `IP → MAC` for communication on the local network.

**Q13. What happens if destination is outside the local subnet?** The host sends the frame to the Default Gateway MAC. The router forwards the IP packet toward the destination.

**Q14. What is longest prefix match?** The most specific matching routing-table entry wins.

**Q15. What is MTU?** Maximum packet payload size that can be carried at a particular network layer/link without exceeding that link's frame constraints.

**Q16. What is DNS?** A distributed naming system that maps names to information such as IP addresses.

**Q17. What does TLS provide?** Confidentiality, Integrity, Authentication.

**Q18. Why does HTTPS need certificates?** To authenticate the server identity and establish trust in the TLS handshake.

**Q19. TCP vs HTTP?** TCP: Transport protocol. HTTP: Application protocol.

**Q20. TCP vs TLS?** TCP: Reliable transport. TLS: Security layer.

---

# 118. Most Important Topics to Master

**Tier 1 — Must Know:** TCP, TCP handshake, TCP termination, TCP states, Sequence numbers, ACK, Retransmission, Flow control, Congestion control, Sockets, epoll, Linux network stack, DNS, IP routing, ARP, TLS/HTTPS, Packet receive/transmit path

**Tier 2 — Strongly Recommended:** UDP, DHCP, NAT, ICMP, MTU, NAPI, DMA, RSS, Network queues, Load balancing, HTTP/2, HTTP/3, QUIC, Firewall, VLAN

**Tier 3 — Know Conceptually:** CDN, Proxy, Zero copy, Advanced TCP algorithms, Advanced NIC offloads, IPv6 internals

---

# 119. Final Senior-Level Mental Model

The entire networking stack can be remembered as: `APPLICATION → HTTP → TLS/QUIC → TCP/UDP → IP → ROUTING → ETHERNET → NETWORK DRIVER → {DMA, NAPI} → NIC → NETWORK`

For an incoming packet: `NETWORK → NIC → DMA → Driver → NAPI → Ethernet → IP → TCP/UDP → Socket → Application`

For an outgoing packet: `Application → Socket → TCP/UDP → IP → Routing → Ethernet → Driver → DMA → NIC → NETWORK`

---

# 120. Final Interview Checklist

Before a senior Linux/networking interview, you should be able to explain without notes:

OSI vs TCP/IP; Ethernet frame; MAC address; ARP; IP addressing; CIDR/subnetting; Default gateway; Routing table; Longest prefix match; ICMP; TCP vs UDP; TCP three-way handshake; TCP sequence numbers; ACK; Retransmission; Flow control; Congestion control; TCP states; TIME_WAIT; CLOSE_WAIT; TCP timers; Sockets; bind/listen/accept/connect; Blocking vs non-blocking; select/poll/epoll; Linux network stack; skb; NIC; DMA; RX/TX rings; Interrupts; NAPI; RSS; DNS; DHCP; NAT; HTTP; HTTPS; TLS handshake; Certificates; HTTP/2; HTTP/3; QUIC; MTU; Firewall; Load balancer; Network debugging; tcpdump; ss; ip; dig; ethtool

---

# Final Dependency Chain

The most important chain to remember is: `Application → DNS → IP Address → Socket → TCP/UDP → IP → Routing → ARP/Neighbor Discovery → Ethernet → NIC Driver → DMA → NIC → Network`

For HTTPS: `URL → DNS → IP → TCP → TLS → HTTP → Application`

For HTTP/3: `URL → DNS → IP → QUIC → TLS → HTTP/3 → Application`

**If you can explain these flows deeply and connect them to Linux system calls, sockets, interrupts, DMA, drivers, and packet processing, you have the networking foundation expected for senior Linux/C/C++ systems interviews.**
