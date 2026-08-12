TCP/IP and OSI Models — How They Work
1. Why Do We Need Network Models?

When two computers communicate over a network, many different things need to happen:

An application creates data.
The data needs to be formatted.
The data needs to be split into packets.
The packets need to be addressed.
The network needs to move the packets.
The receiving computer needs to reconstruct the data.
The receiving application needs to understand the data.

Network models divide these responsibilities into layers.

The two models you will commonly encounter are:

OSI Model — 7 layers
TCP/IP Model — usually represented as 4 layers
2. OSI Model

OSI stands for:

Open Systems Interconnection

The OSI model has 7 layers.

+-----------------------+
| 7. Application        |
+-----------------------+
| 6. Presentation       |
+-----------------------+
| 5. Session            |
+-----------------------+
| 4. Transport          |
+-----------------------+
| 3. Network            |
+-----------------------+
| 2. Data Link          |
+-----------------------+
| 1. Physical           |
+-----------------------+


From Layer 7 to Layer 1:

Application
Presentation
Session
Transport
Network
Data Link
Physical

3. Layer 7 — Application

This is the layer closest to the user/application.

Examples:

HTTP
HTTPS
DNS
SMTP
FTP
SSH


Suppose your browser requests:

https://example.com


The application creates an HTTP request:

GET / HTTP/1.1
Host: example.com


The Application layer is responsible for protocols that applications use to communicate.

Important:

The OSI Application layer does not mean the browser itself.

It refers to network protocols/services used by applications.

4. Layer 6 — Presentation

The Presentation layer deals with how data is represented.

Conceptually, it can handle:

Data encoding
Data conversion
Encryption
Compression

For example:

Application data
       ↓
Encoding
       ↓
Encryption
       ↓
Data


In real-world TCP/IP networking, these responsibilities are often handled by applications or protocols rather than being a separate layer.

For example, TLS provides encryption for HTTPS.

5. Layer 5 — Session

The Session layer is concerned with managing communication sessions.

Conceptually:

Start session
     ↓
Exchange data
     ↓
Maintain session
     ↓
End session


In modern TCP/IP networking, session functionality is usually implemented by higher-level protocols/applications rather than as a separate OSI layer.

6. Layer 4 — Transport

This layer provides end-to-end communication between processes.

The most important protocols are:

TCP
UDP


Transport protocols use port numbers.

Examples:

HTTP  → TCP port 80
HTTPS → TCP port 443
SSH   → TCP port 22
DNS   → usually UDP/TCP port 53

TCP

TCP provides reliable, ordered communication.

It handles things such as:

Connection establishment
Sequencing
Acknowledgements
Retransmission
Flow control
Congestion control

Example:

Sender                         Receiver

Segment 1 -------------------->
             <---------------- ACK

Segment 2 -------------------->
             <---------------- ACK


If a segment is lost:

Segment 1 -------------------->

Segment 2 --------X

Segment 3 -------------------->

             <---------------- ACK

          Missing segment
                 ↓
             Retransmit

UDP

UDP is much simpler.

It does not provide TCP's connection-oriented reliability mechanisms.

Application
     ↓
    UDP
     ↓
    IP


UDP is useful when low overhead and speed are more important than guaranteed delivery.

7. Layer 3 — Network

The Network layer is responsible for logical addressing and routing.

The main protocol is:

IP


Examples:

IPv4
IPv6


An IP address identifies a host/interface at the network layer.

Example:

192.168.1.10


Routers operate primarily at this layer.

Imagine:

Computer A
192.168.1.10
      |
      |
    Router
      |
      |
    Router
      |
      |
Computer B
192.168.10.20


The IP layer helps determine how packets travel from the source network to the destination network.

8. Layer 2 — Data Link

The Data Link layer handles communication over a particular local network/link.

Examples include:

Ethernet
Wi-Fi


It uses concepts such as:

MAC addresses
Ethernet frames
Wi-Fi frames

Example MAC address:

00:1A:2B:3C:4D:5E


A switch primarily operates at Layer 2.

For example:

Computer A
    |
  Switch
 /      \
PC B    PC C


The switch uses MAC addresses to forward Ethernet frames within the local network.

9. Layer 1 — Physical

The Physical layer deals with actually transmitting bits.

Examples:

Electrical signals
Light signals
Radio signals
Copper cables
Fiber-optic cables
Wi-Fi radio


Conceptually:

Bits:

101101001011...

       ↓

Electrical / optical / radio signals

       ↓

Physical medium


Layer 1 doesn't understand:

HTTP
TCP
IP
MAC addresses


It provides the physical transmission of bits.

10. TCP/IP Model

The TCP/IP model is more closely related to the protocols actually used on the Internet.

A common 4-layer representation is:

+-----------------------+
| Application           |
+-----------------------+
| Transport             |
+-----------------------+
| Internet              |
+-----------------------+
| Link / Network Access |
+-----------------------+

11. Mapping OSI to TCP/IP

The models can be approximately mapped like this:

OSI Model                 TCP/IP Model

7. Application  ┐
6. Presentation ├───────> Application
5. Session      ┘

4. Transport    ────────> Transport

3. Network      ────────> Internet

2. Data Link    ┐
1. Physical     ┘───────> Link / Network Access


The important difference is:

OSI      → 7 layers
TCP/IP   → 4 layers


OSI separates Application, Presentation, and Session.

TCP/IP generally combines those responsibilities into the Application layer.

OSI also separates Data Link and Physical.

TCP/IP generally combines them into the Link/Network Access layer.

12. How Data Actually Travels

Suppose you type:

https://example.com


into your browser.

Your application creates data.

Conceptually:

Application
    |
    | HTTP
    ↓
Transport
    |
    | TCP
    ↓
Internet
    |
    | IP
    ↓
Link
    |
    | Ethernet / Wi-Fi
    ↓
Physical
    |
    | Bits/signals
    ↓
Network


The receiving computer performs the reverse process:

Physical
    ↓
Link
    ↓
Internet
    ↓
Transport
    ↓
Application

13. Encapsulation

This is one of the most important networking concepts.

As data moves down the layers, each layer adds its own information.

Suppose the application creates:

Hello

Application Layer
Application Data
----------------
Hello

Transport Layer

TCP adds a TCP header:

+-------------------+
| TCP Header        |
+-------------------+
| Hello             |
+-------------------+


This is commonly called a:

TCP Segment

Internet Layer

IP adds an IP header:

+-------------------+
| IP Header         |
+-------------------+
| TCP Header        |
+-------------------+
| Hello             |
+-------------------+


This is an:

IP Packet

Link Layer

Ethernet/Wi-Fi adds its own header and trailer:

+-------------------+
| Ethernet Header   |
+-------------------+
| IP Header         |
+-------------------+
| TCP Header        |
+-------------------+
| Hello             |
+-------------------+
| Ethernet Trailer  |
+-------------------+


This is a:

Frame

Finally, the Physical layer sends the frame as bits/signals.

14. Encapsulation Diagram

The whole process can be visualized as:

Application Data
       |
       ↓
+----------------------+
| TCP Header           |
| Application Data     |
+----------------------+
       |
       ↓
+----------------------+
| IP Header            |
| TCP Header           |
| Application Data     |
+----------------------+
       |
       ↓
+----------------------+
| Ethernet Header      |
| IP Header            |
| TCP Header           |
| Application Data     |
| Ethernet Trailer     |
+----------------------+
       |
       ↓
      Bits


This process is called:

Encapsulation

15. Decapsulation

The receiving computer performs the opposite process.

It receives the frame:

+----------------------+
| Ethernet Header      |
| IP Header            |
| TCP Header           |
| Application Data     |
| Ethernet Trailer     |
+----------------------+


The network interface processes the Link layer information.

Then IP processes the IP header.

Then TCP processes the TCP header.

Finally, the application receives the data:

Hello


This process is called:

Decapsulation

16. What Does Each Layer Add?

A useful simplified view is:

Application
    ↓
Application data

Transport
    ↓
TCP/UDP header
    ↓
Segment / Datagram

Internet
    ↓
IP header
    ↓
Packet

Link
    ↓
Ethernet/Wi-Fi header + trailer
    ↓
Frame

Physical
    ↓
Bits/signals


Remember:

TCP → Segment
UDP → Datagram
IP  → Packet
Ethernet/Wi-Fi → Frame
Physical → Bits

17. Example: Opening a Website

Suppose you open:

https://example.com


A simplified sequence is:

Browser
   |
   | HTTPS
   ↓
TLS
   |
   | TCP
   ↓
IP
   |
   | Ethernet/Wi-Fi
   ↓
Network


At the destination:

Network
   |
   ↓
Ethernet/Wi-Fi
   |
   ↓
IP
   |
   ↓
TCP
   |
   ↓
TLS
   |
   ↓
HTTP
   |
   ↓
Web Server

18. Where Does TLS Fit?

TLS is not exactly one of the traditional OSI layers.

It sits conceptually between the application protocols and the transport layer.

For HTTPS:

Application
    |
    | HTTP
    ↓
   TLS
    |
    | encrypted application data
    ↓
   TCP
    |
    ↓
    IP
    |
    ↓
Ethernet/Wi-Fi


So:

HTTP
 ↓
TLS
 ↓
TCP
 ↓
IP
 ↓
Ethernet/Wi-Fi


TLS provides:

Encryption
Authentication
Integrity
19. Where Does DNS Fit?

DNS is generally considered an Application-layer protocol.

For example:

Browser
   |
   | "What is the IP address of example.com?"
   ↓
DNS
   |
   ↓
IP address


DNS may use UDP or TCP, and modern DNS can also use transports/security mechanisms such as DoT or DoH.

Conceptually:

Application
    |
    | DNS
    ↓
Transport
    |
    | UDP/TCP
    ↓
Internet
    |
    | IP
    ↓
Link

20. What Does a Router Do?

A router primarily operates at the IP/Network layer.

Suppose:

PC A
192.168.1.10
      |
      ↓
   Router
      |
      ↓
PC B
192.168.2.20


The router looks at the IP packet and determines where to forward it.

Conceptually:

+----------------------+
| IP Header            |
| Source: 192.168.1.10 |
| Dest:   192.168.2.20 |
+----------------------+


The router makes a routing decision based on the destination IP.

The Layer 2 frame normally changes as the packet moves from one link to another.

The IP packet is forwarded across the network, while the link-layer frame is specific to each local link.

21. What Does a Switch Do?

A traditional Ethernet switch primarily operates at Layer 2.

It learns MAC addresses.

For example:

MAC A → Port 1
MAC B → Port 2
MAC C → Port 3


When a frame arrives:

Destination MAC = MAC B


the switch can forward it toward the appropriate port.

Simplified:

PC A
 |
 | Frame
 ↓
Switch
 |
 +----> PC B
 |
 +----> PC C

22. OSI vs TCP/IP
OSI	TCP/IP	Examples
Application	Application	HTTP, DNS, SSH
Presentation	Application	TLS, encoding, compression
Session	Application	Session-related mechanisms
Transport	Transport	TCP, UDP
Network	Internet	IP, ICMP
Data Link	Link	Ethernet, Wi-Fi
Physical	Link	Cables, fiber, radio

The mapping is not perfectly one-to-one.

The OSI model is primarily useful as a conceptual/reference model.

The TCP/IP model is more closely aligned with the protocols used by the Internet.

23. A Practical Way to Remember the Layers

For troubleshooting, think from the bottom upward:

Layer 1 → Can I physically connect?

Layer 2 → Can I communicate on my local network?

Layer 3 → Can I reach the destination IP?

Layer 4 → Can I reach the required port?

Layer 7 → Is the application/service working?


For example, if a web server isn't reachable:

Cable/Wi-Fi
    ↓
Ethernet
    ↓
IP routing
    ↓
TCP port 443
    ↓
TLS
    ↓
HTTP
    ↓
Web application


You can troubleshoot each stage independently.

24. The Big Picture

When sending data:

                 SENDING

Application
     |
     ↓
+------------------+
| Application Data |
+------------------+
     |
     ↓
+------------------+
| TCP Header       |
| Application Data |
+------------------+
     |
     ↓
+------------------+
| IP Header        |
| TCP Header       |
| Application Data |
+------------------+
     |
     ↓
+------------------+
| Ethernet Header  |
| IP Header        |
| TCP Header       |
| Application Data |
| Ethernet Trailer |
+------------------+
     |
     ↓
   Bits/Signals
     |
     ↓
   NETWORK
     |
     ↓

                 RECEIVING

   Bits/Signals
     |
     ↓
Ethernet/Wi-Fi
     |
     ↓
Remove Link header/trailer
     |
     ↓
IP
     |
     ↓
Remove IP header
     |
     ↓
TCP
     |
     ↓
Remove TCP header
     |
     ↓
Application
     |
     ↓
Application Data

25. Final Mental Model

Remember these five things:

Application → What data does the application want to send?

Transport   → Which process/application should receive it?
              TCP/UDP + ports

Internet    → Where should the packet go?
              IP + routing

Link        → How do I communicate over this local network?
              Ethernet/Wi-Fi + MAC

Physical    → How are the bits actually transmitted?
              Electrical/light/radio signals


The most important flow is:

Application
     ↓
Transport
     ↓
Internet
     ↓
Link
     ↓
Physical


On the receiving side:

Physical
     ↓
Link
     ↓
Internet
     ↓
Transport
     ↓
Application


The process of adding headers as data moves down the stack is encapsulation.

The process of removing those headers as data moves up the stack is decapsulation.

That is the fundamental idea behind how the OSI/TCP-IP layered networking model works.
