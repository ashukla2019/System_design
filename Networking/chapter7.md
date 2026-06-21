# Subnetting

Subnetting is one of the most important networking concepts.

Interviewers love subnetting because it tests:

- Binary understanding
- IP Addressing
- Routing
- Network Design

Without subnetting:

- AWS VPCs
- Azure VNets
- Kubernetes Networking
- Routing

become difficult.

---

# Why Subnetting Exists

Suppose you have:

Network:
192.168.1.0/24

Total Addresses:

256

Usable Hosts:

254

Problem:

You only need:

- 50 PCs
- 20 Servers
- 10 Printers

A /24 wastes addresses.

Solution:

Split network into smaller networks.

This is called:

Subnetting

---

# IP Address Structure

Example:

192.168.1.10

Binary:

11000000.10101000.00000001.00001010

IPv4:

32 bits

---

# Network vs Host Portion

Example:

192.168.1.10/24

Binary:

11000000.10101000.00000001 . 00001010
<------24 bits---------> <8 bits>

Network Portion           Host Portion

---

# CIDR Notation

Example:

/24

Means:

24 bits = Network

8 bits = Host

Total:

32 bits

---

# Subnet Mask

CIDR      Mask

/8        255.0.0.0
/16       255.255.0.0
/24       255.255.255.0
/25       255.255.255.128
/26       255.255.255.192
/27       255.255.255.224
/28       255.255.255.240
/29       255.255.255.248
/30       255.255.255.252
/32       255.255.255.255

Memorize these.

---

# Formula

Host Bits = 32 - Prefix

Hosts = 2^(Host Bits)

Usable Hosts = Hosts - 2

Why -2?

One address:

Network Address

One address:

Broadcast Address

Cannot assign them.

---

# Example 1

192.168.1.0/24

Host Bits:

32 - 24 = 8

Hosts:

2^8 = 256

Usable:

254

---

# Example 2

192.168.1.0/25

Host Bits:

7

Hosts:

128

Usable:

126

---

# Example 3

192.168.1.0/26

Host Bits:

6

Hosts:

64

Usable:

62

---

# Quick Table

CIDR     Total     Usable

/24      256       254
/25      128       126
/26      64        62
/27      32        30
/28      16        14
/29      8         6
/30      4         2

Very important.

---

# Finding Network Address

Example:

192.168.1.100/24

Mask:

255.255.255.0

Network:

192.168.1.0

Broadcast:

192.168.1.255

Usable:

192.168.1.1

to

192.168.1.254

---

# Example /25

Network:

192.168.1.0/25

Range:

192.168.1.0
to
192.168.1.127

Network:

192.168.1.0

Broadcast:

192.168.1.127

Usable:

192.168.1.1
to
192.168.1.126

---

Second Subnet

192.168.1.128/25

Network:

192.168.1.128

Broadcast:

192.168.1.255

Usable:

192.168.1.129
to
192.168.1.254

---

# Magic Number Trick

Mask:

255.255.255.192

CIDR:

/26

Interesting octet:

192

Magic Number:

256 - 192 = 64

Subnets:

0
64
128
192

Therefore:

192.168.1.0/26
192.168.1.64/26
192.168.1.128/26
192.168.1.192/26

Easy interview trick.

---

# AWS Example

VPC:

10.0.0.0/16

Subnet A:

10.0.1.0/24

Subnet B:

10.0.2.0/24

Subnet C:

10.0.3.0/24

AWS uses subnetting everywhere.

---

# VLSM

Variable Length Subnet Mask

Allows different subnet sizes.

Example:

Need:

100 Hosts
50 Hosts
20 Hosts

Create:

/25
/26
/27

instead of equal-size subnets.

Efficient.

---

# Supernetting

Opposite of subnetting.

Combine smaller networks.

Example:

192.168.0.0/24
192.168.1.0/24

Combine:

192.168.0.0/23

Used in route summarization.

---

# Interview Questions

Q1. How many usable hosts in /27?

32 - 27 = 5

2^5 = 32

32 - 2 = 30

Answer:

30

---

Q2. Network address of 192.168.1.50/24?

192.168.1.0

---

Q3. Broadcast of 192.168.1.0/24?

192.168.1.255

---

Q4. Why subnet?

- Better utilization
- Smaller broadcast domains
- Better security
- Easier routing