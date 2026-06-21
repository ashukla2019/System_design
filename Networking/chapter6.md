# IP Addressing

IP Address = Logical Address of a device.

Used by routers to deliver packets.

Without IP:

Internet cannot exist.

---

# Why IP Address Needed

Suppose:

Laptop A
Laptop B

Need unique identifiers.

Like:

House Addresses

Without address:

Delivery impossible.

---

# IPv4

Most common.

Length:

32 bits

Structure:

4 octets

Example:

192.168.1.10

Each octet:

0 - 255

---

# Binary Form

192.168.1.10

=

11000000
10101000
00000001
00001010

Total:

32 bits

---

# IPv6

Length:

128 bits

Example:

2001:db8::1

Created to solve IPv4 exhaustion.

---

# Public IP

Globally routable.

Visible on Internet.

Example:

49.36.x.x

Assigned by ISP.

Unique worldwide.

---

# Private IP

Used inside LAN.

Not routable on Internet.

Ranges:

10.0.0.0 - 10.255.255.255

172.16.0.0 - 172.31.255.255

192.168.0.0 - 192.168.255.255

---

# Loopback Address

127.0.0.1

Represents:

This machine

Command:

ping 127.0.0.1

Tests local TCP/IP stack.

---

# APIPA

Automatic Private IP Address

Range:

169.254.0.0/16

Assigned when DHCP unavailable.

---

# Static IP

Manually configured.

Advantages:

Predictable

Used for:

Servers
Routers

---

# Dynamic IP

Assigned automatically.

Usually through DHCP.

Used by:

Laptops
Mobiles

---

# CIDR Notation

Example:

192.168.1.0/24

Meaning:

24 bits network

8 bits host

---

# Special Addresses

0.0.0.0

Current Network

---

127.0.0.1

Loopback

---

255.255.255.255

Broadcast

---

# Network Example

IP:

192.168.1.10

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

# Interview Questions

Q1. IPv4 size?

32 bits

---

Q2. IPv6 size?

128 bits

---

Q3. Private IP ranges?

10.0.0.0/8

172.16.0.0/12

192.168.0.0/16

---

Q4. Loopback address?

127.0.0.1

---

Q5. Why IPv6?

IPv4 exhaustion

---

Q6. Difference between public and private IP?

Public:
Internet routable

Private:
LAN only