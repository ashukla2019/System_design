# UDP (User Datagram Protocol)

UDP is a transport protocol.

Unlike TCP:

UDP is connectionless.

No:

- Handshake
- Reliability
- Retransmission
- Ordering

---

# Why UDP Exists

Speed.

Some applications care more about:

Fast delivery

than

Perfect delivery.

---

# TCP vs UDP

TCP

Reliable
Ordered
Slow

---

UDP

Unreliable
Unordered
Fast

---

# UDP Header

Very small.

Contains:

Source Port
Destination Port
Length
Checksum

Only 8 bytes.

TCP header:

20+ bytes.

---

# No Handshake

TCP:

SYN
SYN-ACK
ACK

UDP:

Send immediately.

---

# No Acknowledgement

Sender does not wait.

Example:

Packet lost

UDP ignores it.

---

# No Ordering

Packets may arrive:

3
1
2

Application handles it.

---

# Real Example

Video Call

Packet lost?

Better to continue.

Not wait for retransmission.

Therefore:

UDP.

---

# Common UDP Protocols

DNS

53

---

DHCP

67
68

---

SNMP

161

---

NTP

123

---

VoIP

UDP

---

Online Gaming

UDP

---

Streaming

UDP

---

# Advantages

Very fast

Low overhead

Low latency

---

# Disadvantages

Packet loss

No ordering

No reliability

---

# TCP vs UDP Summary

Feature      TCP      UDP

Reliable     Yes      No
Ordered      Yes      No
Handshake    Yes      No
Fast         No       Yes
Streaming    No       Yes
HTTPS        Yes      No

---

# Interview Questions

Q1. Why UDP faster?

No handshake
No ACK
No retransmission

---

Q2. DNS uses?

Usually UDP

---

Q3. Video streaming uses?

UDP

---

Q4. TCP or UDP for banking?

TCP

---

Q5. TCP or UDP for gaming?

UDP