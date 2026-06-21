# TCP (Transmission Control Protocol)

TCP is the most important transport protocol.

Provides:

- Reliable delivery
- Ordered delivery
- Error recovery

Used by:

HTTP
HTTPS
SSH
FTP
SMTP

---

# Why TCP Exists

IP only delivers packets.

IP does NOT guarantee:

- Delivery
- Order
- Reliability

TCP adds those guarantees.

---

# TCP Header

Contains:

Source Port
Destination Port
Sequence Number
ACK Number
Window Size
Flags
Checksum

---

# Ports

Example:

Source:

192.168.1.10:50000

Destination:

142.250.x.x:443

443 = HTTPS

---

# Sequence Number

Every byte is numbered.

Example:

Packet 1

Seq = 1000

Packet 2

Seq = 2000

Allows reordering.

---

# Acknowledgement

Receiver confirms data.

Example:

Received:

1-1000

ACK:

1001

Meaning:

Send next byte.

---

# Three-Way Handshake

Establishes connection.

Client
Server

Step 1

SYN

Client → Server

---

Step 2

SYN + ACK

Server → Client

---

Step 3

ACK

Client → Server

Connection established.

---

# Why 3-Way Handshake?

Verifies:

- Client reachable
- Server reachable
- Sequence numbers synchronized

---

# Data Transfer

After handshake:

Data sent.

Example:

HTTP Request

TCP guarantees:

- Reliability
- Order

---

# Retransmission

Packet lost?

TCP resends.

Example:

Seq 1000

No ACK

↓

Timeout

↓

Retransmit

---

# Flow Control

Prevent receiver overload.

Uses:

Window Size

Example:

Receiver says:

"I can accept 5000 bytes"

Sender respects limit.

---

# Sliding Window

Allows multiple packets before ACK.

Improves performance.

Without:

Send → Wait

With:

Send many packets

More efficient.

---

# Congestion Control

Prevents network overload.

Algorithms:

Slow Start
Congestion Avoidance

---

# Four-Way Termination

Close connection.

Client → FIN

Server → ACK

Server → FIN

Client → ACK

Connection closed.

---

# TCP Flags

SYN

Start connection

---

ACK

Acknowledgement

---

FIN

Close connection

---

RST

Reset connection

---

PSH

Push data immediately

---

URG

Urgent data

---

# TCP Advantages

- Reliable
- Ordered
- Error recovery

---

# TCP Disadvantages

- More overhead
- Slower than UDP

---

# Interview Questions

Q1. Why TCP reliable?

ACK + Retransmission

---

Q2. What is 3-way handshake?

SYN
SYN-ACK
ACK

---

Q3. What is sequence number?

Tracks packet ordering.

---

Q4. What is sliding window?

Multiple packets before ACK.

---

Q5. Why TCP slower than UDP?

Reliability overhead.