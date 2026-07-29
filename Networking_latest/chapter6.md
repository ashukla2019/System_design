# Chapter 6 – TCP & UDP (Part 1)
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Master TCP and UDP for senior networking interviews. This is the **most important chapter** in the handbook. Companies like **Arista, Cisco, Juniper, NVIDIA, Broadcom, and Qualcomm** ask TCP questions in almost every networking interview.

---

# Why Do We Need TCP?

IP only delivers packets.

IP **does NOT guarantee**:

- Packet delivery
- Packet order
- Duplicate prevention
- Error recovery

Example

```
Sender

Packet1

Packet2

Packet3

        Internet

Packet2

Packet3

Packet1

Receiver
```

Packets may:

- Arrive late
- Arrive out of order
- Be lost
- Be duplicated

TCP solves these problems.

---

# What is TCP?

TCP (Transmission Control Protocol) provides:

- Reliable communication
- Ordered delivery
- Error recovery
- Flow control
- Congestion control

TCP is **connection-oriented**.

A connection must be established before data transfer.

---

# TCP vs UDP

| TCP | UDP |
|------|------|
| Reliable | Best Effort |
| Connection Oriented | Connectionless |
| Ordered Delivery | No Ordering |
| Retransmission | No Retransmission |
| Slower | Faster |
| Larger Header | Smaller Header |

---

# When to Use TCP?

Examples

```
HTTPS

SSH

FTP

SMTP

Database Connections
```

Why?

Because losing data is unacceptable.

---

# When to Use UDP?

Examples

```
DNS

VoIP

Video Streaming

Online Games

DHCP
```

Why?

Speed is more important than perfect reliability.

---

# TCP Header

Interviewers expect you to know the important fields.

```
+--------------------------------+
| Source Port                    |
+--------------------------------+
| Destination Port               |
+--------------------------------+
| Sequence Number                |
+--------------------------------+
| Acknowledgement Number         |
+--------------------------------+
| Flags                          |
+--------------------------------+
| Window Size                    |
+--------------------------------+
| Checksum                       |
+--------------------------------+
```

Important fields

| Field | Purpose |
|--------|----------|
| Source Port | Sender Application |
| Destination Port | Receiver Application |
| Sequence Number | Ordering |
| ACK Number | Reliability |
| Window Size | Flow Control |
| Flags | Connection State |

---

# TCP Flags

Most important flags

```
SYN

ACK

FIN

RST

PSH

URG
```

Interview Tip

Know these four very well:

- SYN
- ACK
- FIN
- RST

---

# Three-Way Handshake

Most frequently asked networking interview question.

Purpose

- Establish connection
- Synchronize sequence numbers

Flow

```
Client

SYN
Seq = X

---------------------->

Server

<----------------------

SYN + ACK
Seq = Y
Ack = X+1

---------------------->

ACK
Ack = Y+1

Connection Established
```

---

# Why Three Steps?

Interview Favorite

Why not two?

Suppose:

Old delayed SYN packet arrives.

With only two messages,

The server cannot know whether the client actually received its reply.

The third ACK confirms:

```
Both sides are ready.
```

---

# Sequence Number

Every byte in TCP has a sequence number.

Example

```
Data

100 Bytes

Sequence = 1000
```

Receiver expects

```
1100
```

next.

This allows:

- Ordered delivery
- Loss detection

---

# Acknowledgement Number

Receiver replies

```
ACK = Next Expected Byte
```

Example

Sender

```
Seq = 1000

Length = 100
```

Receiver sends

```
ACK = 1100
```

Meaning

"I have received everything up to byte 1099."

---

# Complete Connection Flow

```
Application

↓

Socket

↓

TCP

↓

SYN

↓

SYN + ACK

↓

ACK

↓

Connection Ready

↓

Data Transfer
```

---

# Connection Termination

TCP closes gracefully using **FIN**.

```
Client

FIN

---------------------->

Server

ACK

<----------------------

Server

FIN

<----------------------

Client

ACK

---------------------->

Connection Closed
```

This is called the

**Four-Way Handshake**

---

# Why Four Steps?

TCP connections are full duplex.

Each direction closes independently.

Therefore,

Each side sends its own FIN.

---

# RST (Reset)

RST immediately terminates a connection.

Used when

- Invalid connection
- Unexpected packet
- Closed port

Unlike FIN,

RST is **not graceful**.

---

# Linux Socket Flow

```
socket()

↓

connect()

↓

TCP Handshake

↓

send()

↓

recv()

↓

close()
```

The Linux kernel performs the TCP handshake automatically.

Applications usually don't send SYN or ACK packets directly.

---

# Common Interview Questions

## Q1 Why do we need TCP?

Because IP does not guarantee reliable delivery.

---

## Q2 Why is TCP reliable?

Because it uses:

- Sequence Numbers
- ACKs
- Retransmissions
- Checksums

---

## Q3 Why is TCP connection-oriented?

Both sides must establish a connection before exchanging data.

---

## Q4 Why is UDP faster?

UDP does not perform:

- Connection setup
- Retransmissions
- Ordering
- Flow control

---

## Q5 Why is the TCP handshake three-way instead of two-way?

The third ACK confirms that both sides have synchronized sequence numbers and are ready for communication.

---

## Q6 Why does TCP use four packets to close a connection?

Each direction of communication closes independently.

---

## Q7 What is RST?

RST immediately aborts a TCP connection without graceful shutdown.

---

## Q8 What is a Sequence Number?

It identifies the position of data in the byte stream.

---

## Q9 What is an ACK Number?

The next byte the receiver expects to receive.

---

# Common Mistakes

❌ Saying TCP guarantees zero packet loss.

✔ TCP recovers from packet loss using retransmissions.

---

❌ Thinking ACK means "packet received."

✔ ACK means "all bytes before this ACK number have been received."

---

❌ Saying FIN closes both directions simultaneously.

✔ FIN closes one direction at a time.

---

❌ Saying UDP has no checksum.

✔ UDP includes a checksum, but it does not provide retransmissions or ordering.

---

# Quick Revision

```
TCP

↓

Reliable

↓

Connection

↓

3-Way Handshake

↓

Sequence Number

↓

ACK Number

↓

Data Transfer

↓

FIN

↓

4-Way Close

↓

RST
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| TCP | Reliable |
| UDP | Fast |
| Handshake | SYN → SYN+ACK → ACK |
| Close | FIN → ACK → FIN → ACK |
| Sequence Number | Byte Position |
| ACK Number | Next Expected Byte |
| RST | Immediate Abort |
| Common TCP Apps | HTTPS, SSH, FTP |
| Common UDP Apps | DNS, DHCP, VoIP |

---

# Chapter Summary

After completing this part, you should be able to explain:

- Why TCP exists.
- TCP vs UDP.
- TCP header fields.
- TCP flags.
- Three-way handshake.
- Sequence and ACK numbers.
- Four-way connection termination.
- RST.
- Basic Linux socket flow.

---

**Next:** **TCP (Part 2)** – Sliding Window, Flow Control, Congestion Control, Retransmissions, TIME_WAIT, Keepalive, Nagle Algorithm, Delayed ACK, and the Linux TCP state machine.
--------------------------
# Chapter 6 – TCP & UDP (Part 2)
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** This chapter covers the advanced TCP concepts that are asked in senior networking interviews at Arista, Cisco, NVIDIA, Broadcom, Qualcomm, and Juniper.

---

# Sliding Window

One of the most important TCP interview topics.

Suppose the sender waits for an ACK after every packet.

```
Packet1

↓

ACK

↓

Packet2

↓

ACK

↓

Packet3

↓

ACK
```

This is very slow.

Instead,

TCP sends multiple packets before waiting.

```
Packet1

Packet2

Packet3

Packet4

Packet5

↓

ACK
```

This is called the **Sliding Window**.

It improves network utilization.

---

# Window Size

Window Size tells the sender

> "You can send this much data before waiting."

Example

```
Window Size = 5000 Bytes
```

Sender can transmit

```
5000 Bytes
```

without stopping.

---

# Sliding Window Example

Suppose

```
Window = 4000 Bytes

Each Packet = 1000 Bytes
```

Initially

```
Packet1

Packet2

Packet3

Packet4
```

are sent.

Receiver sends

```
ACK = 5000
```

Now the window slides.

```
Packet5

Packet6

Packet7

Packet8
```

This continuous movement is why it's called a **Sliding Window**.

---

# Flow Control

Flow Control protects the **receiver**.

Example

```
Sender = 10 Gbps

Receiver = 1 Gbps
```

Without flow control

```
Receiver Buffer

FULL

↓

Packets Lost
```

TCP solves this using the **Receive Window (rwnd)**.

Receiver advertises

```
Window = 2000 Bytes
```

Sender must not exceed it.

---

# Congestion Control

Flow Control protects

```
Receiver
```

Congestion Control protects

```
Network
```

Imagine

```
1000 Clients

↓

One Router

↓

Packets Dropped
```

Network becomes congested.

TCP automatically reduces its sending rate.

---

# Slow Start

Interview Favorite.

TCP begins cautiously.

```
1 Packet

↓

2 Packets

↓

4 Packets

↓

8 Packets

↓

16 Packets
```

The congestion window (**cwnd**) grows exponentially at first.

This avoids overwhelming the network immediately.

---

# Congestion Avoidance

Once TCP reaches a threshold,

Growth becomes slower.

Instead of doubling,

```
10

↓

11

↓

12

↓

13
```

Growth becomes approximately linear.

This prevents congestion.

---

# Packet Loss

How does TCP detect loss?

Two methods.

### Method 1

Timeout

No ACK received.

Retransmit.

---

### Method 2

Duplicate ACK

Example

Receiver gets

```
1

2

4

5
```

Packet **3** is missing.

Receiver repeatedly sends

```
ACK = 3
```

After receiving **three duplicate ACKs**,

TCP assumes Packet 3 is lost.

It retransmits immediately.

This is called **Fast Retransmit**.

---

# Fast Recovery

Instead of starting again from one packet,

TCP reduces the congestion window and continues transmitting.

This recovers faster than Slow Start.

---

# TCP State Machine

Very popular in interviews.

```
CLOSED

↓

LISTEN

↓

SYN_SENT

↓

SYN_RECEIVED

↓

ESTABLISHED

↓

FIN_WAIT_1

↓

FIN_WAIT_2

↓

TIME_WAIT

↓

CLOSED
```

Know these states.

You do **not** need to memorize every rarely used state.

---

# TIME_WAIT

One of the most asked interview questions.

After closing,

Connection enters

```
TIME_WAIT
```

Why?

Two reasons.

### Reason 1

Ensure the final ACK reaches the peer.

### Reason 2

Prevent delayed packets from an old connection being accepted by a new connection.

Typical duration

```
2 × MSL
```

(MSL = Maximum Segment Lifetime)

---

# Keepalive

Suppose

```
Client crashes.
```

Server doesn't know.

Connection remains open.

TCP Keepalive periodically sends probes.

If no response arrives,

The connection is closed.

---

# Nagle Algorithm

Purpose

Reduce many tiny packets.

Instead of

```
1 Byte

1 Byte

1 Byte

1 Byte
```

TCP combines them into

```
4 Bytes
```

Benefits

- Fewer packets
- Better bandwidth utilization

Problem

Adds latency.

Interactive applications often disable it using

```
TCP_NODELAY
```

---

# Delayed ACK

Receiver doesn't ACK immediately.

It waits briefly.

Maybe another packet arrives.

Then

One ACK can acknowledge multiple packets.

Benefits

- Fewer ACK packets
- Better efficiency

---

# MSS (Maximum Segment Size)

Maximum TCP payload.

Typical Ethernet

```
MTU = 1500

IP Header = 20

TCP Header = 20

MSS = 1460 Bytes
```

Interview Tip

Don't confuse

```
MTU

and

MSS
```

---

# MTU vs MSS

| MTU | MSS |
|------|------|
| Entire IP Packet | TCP Payload Only |
| Layer 3 | Layer 4 |
| Usually 1500 Bytes | Usually 1460 Bytes |

---

# TCP Retransmission

Suppose

```
Packet 5 Lost
```

Sender

```
1

2

3

4

5

6
```

Receiver repeatedly ACKs

```
ACK = 5
```

Sender retransmits

```
Packet 5
```

without sending everything again.

---

# Linux Socket Flow

```
socket()

↓

connect()

↓

TCP Handshake

↓

Sliding Window

↓

Flow Control

↓

Congestion Control

↓

send()

↓

recv()

↓

close()
```

Applications rarely implement TCP themselves.

The Linux kernel handles these mechanisms.

---

# Common Interview Questions

## Q1 Difference between Flow Control and Congestion Control?

Flow Control protects the receiver.

Congestion Control protects the network.

---

## Q2 What is Sliding Window?

Allows multiple packets to be in flight before waiting for ACKs.

---

## Q3 Why is TIME_WAIT needed?

- Ensures the last ACK can be retransmitted if needed.
- Prevents delayed packets from affecting new connections.

---

## Q4 What is Slow Start?

TCP starts with a small congestion window and increases it rapidly until a threshold.

---

## Q5 What is Fast Retransmit?

Retransmit a missing packet after three duplicate ACKs instead of waiting for a timeout.

---

## Q6 Why use Keepalive?

To detect peers that have silently disappeared.

---

## Q7 Why disable Nagle Algorithm?

Applications like SSH, gaming, or interactive systems prefer low latency over sending fewer packets.

---

## Q8 Difference between MTU and MSS?

MTU is the maximum IP packet size.

MSS is the maximum TCP payload size.

---

## Q9 Why doesn't TCP wait only for timeouts?

Timeouts are slow.

Duplicate ACKs allow TCP to detect packet loss much earlier.

---

# Common Mistakes

❌ Saying Flow Control prevents network congestion.

✔ Flow Control protects the receiver.

---

❌ Saying Congestion Control protects the receiver.

✔ Congestion Control protects the network.

---

❌ Thinking TIME_WAIT is unnecessary.

✔ Removing TIME_WAIT can cause delayed packets from an old connection to corrupt a new one.

---

❌ Confusing MTU and MSS.

✔ MTU includes headers.

✔ MSS excludes IP and TCP headers.

---

# Quick Revision

```
TCP

↓

Sliding Window

↓

Flow Control

↓

Congestion Control

↓

Slow Start

↓

Congestion Avoidance

↓

Duplicate ACK

↓

Fast Retransmit

↓

TIME_WAIT

↓

Keepalive

↓

Nagle

↓

Delayed ACK

↓

MSS
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| Sliding Window | Multiple packets before ACK |
| Flow Control | Protects Receiver |
| Congestion Control | Protects Network |
| Slow Start | Exponential Growth |
| Congestion Avoidance | Linear Growth |
| Fast Retransmit | 3 Duplicate ACKs |
| TIME_WAIT | Final ACK + Old Packet Protection |
| Keepalive | Detect Dead Peer |
| Nagle | Reduce Small Packets |
| Delayed ACK | Reduce ACK Traffic |
| MTU | IP Packet Size |
| MSS | TCP Payload Size |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Sliding Window
- Window Size
- Flow Control
- Congestion Control
- Slow Start
- Congestion Avoidance
- Fast Retransmit
- Fast Recovery
- TCP State Machine
- TIME_WAIT
- Keepalive
- Nagle Algorithm
- Delayed ACK
- MTU vs MSS
- Linux TCP implementation

---

**Next Chapter:** **DNS, DHCP & NAT** – Name resolution, IP address allocation, NAT/PAT, and the complete packet flow from entering `www.google.com` to receiving the webpage.

