Computer Networking
│
├── Part I – Networking Fundamentals
│
├── 1. Introduction to Networking
│   │
│   ├── Computer Networking
│   │   → Interconnection of computers and devices to share resources and data
│   │   → Enables communication across local and global systems
│   │   → Foundation of the internet
│   │
│   ├── Why Networking
│   │   → Resource sharing (files, printers, internet)
│   │   → Communication between devices
│   │   → Centralized management
│   │   → Scalable system architectures
│   │
│   └── Examples
│       → Home WiFi networks
│       → Corporate networks
│       → The Internet
│
├── 2. Types of Networks
│
├── LAN (Local Area Network)
│   │
│   ├── Why LAN
│   │   → Connects devices within small geographic areas
│   │
│   ├── What it Provides
│   │   ├── High-speed communication
│   │   ├── Low latency
│   │   └── Local resource sharing
│   │
│   └── Example
│       → Office network
│
├── WAN (Wide Area Network)
│   │
│   ├── Why WAN
│   │   → Connects networks across large geographical regions
│   │
│   ├── What it Provides
│   │   ├── Long distance communication
│   │   └── Interconnection of multiple LANs
│   │
│   └── Example
│       → The Internet
│
├── MAN (Metropolitan Area Network)
│   │
│   ├── Why MAN
│   │   → Connects networks across a city
│   │
│   └── Example
│       → City-wide internet services
│
├── PAN (Personal Area Network)
│   │
│   ├── Why PAN
│   │   → Connects devices around a single user
│   │
│   └── Example
│       → Bluetooth devices
│
│
├── 3. Network Devices
│
├── Router
│   │
│   ├── Why Router
│   │   → Connects multiple networks
│   │
│   ├── What it Provides
│   │   ├── Packet forwarding
│   │   ├── Routing decisions
│   │   └── Internet connectivity
│   │
│   └── Analogy
│       → Like a traffic director between networks
│
├── Switch
│   │
│   ├── Why Switch
│   │   → Connects multiple devices in a LAN
│   │
│   ├── What it Provides
│   │   ├── MAC-based forwarding
│   │   └── Efficient local communication
│   │
│   └── Analogy
│       → Smart connector for local devices
│
├── Hub
│   │
│   ├── Why Hub
│   │   → Simple device connecting multiple devices
│   │
│   └── What it Provides
│       → Broadcasts data to all connected devices
│
├── Modem
│   │
│   ├── Why Modem
│   │   → Connects home or office networks to ISP
│   │
│   └── What it Provides
│       → Converts digital signals to analog and vice versa
│
│
├── 4. OSI Model
│
├── Why OSI Model
│   │   → Standard framework for network communication
│
├── Layers
│   │
│   ├── Layer 7 – Application
│   │   → User-facing services
│   │   → Examples: HTTP, FTP
│   │
│   ├── Layer 6 – Presentation
│   │   → Encryption, compression, data formatting
│   │
│   ├── Layer 5 – Session
│   │   → Session management between applications
│   │
│   ├── Layer 4 – Transport
│   │   → Reliable communication between hosts
│   │   → Protocols: TCP, UDP
│   │
│   ├── Layer 3 – Network
│   │   → Logical addressing and routing
│   │   → Protocol: IP
│   │
│   ├── Layer 2 – Data Link
│   │   → MAC addressing and frame transmission
│   │
│   └── Layer 1 – Physical
│       → Physical transmission through cables or wireless signals
│
│
├── 5. TCP/IP Model
│
├── Why TCP/IP
│   │   → Practical networking model used on the internet
│
├── Layers
│   │
│   ├── Application Layer
│   │   → HTTP, HTTPS, DNS, FTP
│   │
│   ├── Transport Layer
│   │   → TCP and UDP
│   │
│   ├── Internet Layer
│   │   → IP addressing and routing
│   │
│   └── Network Access Layer
│       → Physical transmission and hardware
│
│
├── 6. TCP vs UDP
│
├── TCP (Transmission Control Protocol)
│   │
│   ├── Why TCP
│   │   → Reliable communication
│   │
│   ├── Features
│   │   ├── Connection-oriented
│   │   ├── Error checking
│   │   ├── Ordered delivery
│   │   └── Retransmission of lost packets
│   │
│   └── Examples
│       → HTTP
│       → HTTPS
│       → FTP
│       → SSH
│
├── UDP (User Datagram Protocol)
│   │
│   ├── Why UDP
│   │   → Faster transmission with low overhead
│   │
│   ├── Features
│   │   ├── Connectionless
│   │   ├── No guarantee of delivery
│   │   └── Low latency
│   │
│   └── Examples
│       → DNS
│       → Video streaming
│       → Online gaming
│
│
├── Part II – Core Networking Concepts
│
├── 7. IP Addressing
│
├── Why IP Address
│   │   → Unique identifier for devices on a network
│
├── IPv4
│   │
│   ├── Example
│   │   → 192.168.1.1
│   │
│   ├── Size
│   │   → 32-bit address
│   │
│   └── Private IP Ranges
│       → 10.0.0.0 – 10.255.255.255
│       → 172.16.0.0 – 172.31.255.255
│       → 192.168.0.0 – 192.168.255.255
│
├── IPv6
│   │
│   ├── Example
│   │   → 2001:db8:3333:4444:5555:6666:7777:8888
│   │
│   └── Size
│       → 128-bit address
│
│
├── 8. DNS (Domain Name System)
│
├── Why DNS
│   │   → Converts domain names to IP addresses
│
├── What it Provides
│   │   ├── Human readable internet navigation
│   │   └── Efficient domain resolution
│
├── DNS Resolution Flow
│   │
│   ├── Step 1
│   │   → User enters domain in browser
│   │
│   ├── Step 2
│   │   → Browser checks cache
│   │
│   ├── Step 3
│   │   → OS resolver checks local cache
│   │
│   ├── Step 4
│   │   → Query sent to recursive DNS server
│   │
│   ├── Step 5
│   │   → Root server queried
│   │
│   ├── Step 6
│   │   → TLD server queried
│   │
│   ├── Step 7
│   │   → Authoritative DNS server responds
│   │
│   └── Step 8
│       → IP returned to client
│
│
├── 9. HTTP vs HTTPS
│
├── HTTP
│   │
│   ├── Port
│   │   → 80
│   │
│   └── Characteristics
│       → No encryption
│
├── HTTPS
│   │
│   ├── Port
│   │   → 443
│   │
│   └── Characteristics
│       → Secure communication using TLS/SSL
│
│
├── 10. NAT (Network Address Translation)
│
├── Why NAT
│   │   → Allows multiple devices to share a single public IP
│
├── Types
│   │
│   ├── Static NAT
│   │   → One-to-one mapping
│   │
│   ├── Dynamic NAT
│   │   → Mapping using IP pools
│   │
│   └── PAT (Port Address Translation)
│       → Multiple devices share one public IP using ports
│
│
├── 11. Load Balancing
│
├── Why Load Balancing
│   │   → Distributes traffic across servers
│
├── What it Provides
│   │   ├── High availability
│   │   ├── Scalability
│   │   └── Fault tolerance
│
├── Types
│   │
│   ├── Layer 4 Load Balancer
│   │   → Works at TCP/UDP layer
│   │
│   └── Layer 7 Load Balancer
│       → Works at HTTP/HTTPS layer
│
│
├── 12. CDN (Content Delivery Network)
│
├── Why CDN
│   │   → Reduce latency and speed up content delivery
│
├── What it Provides
│   │   ├── Cached content near users
│   │   └── Reduced load on origin servers
│
│
├── 13. Firewall
│
├── Why Firewall
│   │   → Protect networks from unauthorized access
│
├── Types
│   │
│   ├── Network Firewall
│   │
│   ├── Application Firewall
│   │
│   └── Stateful Firewall
│
│
├── 14. Common Networking Ports
│
│   ├── 21 → FTP
│   ├── 22 → SSH
│   ├── 25 → SMTP
│   ├── 53 → DNS
│   ├── 80 → HTTP
│   ├── 443 → HTTPS
│   ├── 3306 → MySQL
│   └── 5432 → PostgreSQL
│
│
├── 15. Networking Commands
│
├── Check IP Address
│   │
│   ├── Windows
│   │   → ipconfig
│   │
│   └── Linux / macOS
│       → ifconfig
│
├── Connectivity Test
│   │
│   └── ping google.com
│
├── Trace Route
│   │
│   └── tracert google.com
│
└── DNS Lookup
│
└── nslookup google.com
