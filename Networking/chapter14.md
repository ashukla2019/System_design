# DHCP

DHCP automatically assigns:

- IP Address
- Subnet Mask
- Gateway
- DNS Server

Without DHCP:

Every device must be configured manually.

---

# Problem DHCP Solves

Suppose:

1000 employees

Need IP addresses.

Manual assignment:

Impossible.

DHCP automates it.

---

# DHCP Components

DHCP Client

Your laptop

---

DHCP Server

Router
Windows Server
Linux Server

---

# DHCP Process

Called:

DORA

Must memorize.

---

# D = Discover

Client broadcasts:

"I need IP."

Source:

0.0.0.0

Destination:

255.255.255.255

---

# O = Offer

DHCP Server replies:

"Use 192.168.1.100"

---

# R = Request

Client says:

"I want 192.168.1.100"

---

# A = Acknowledge

Server confirms.

Client receives:

IP Address
Subnet Mask
Gateway
DNS

Done.

---

# DORA Diagram

Client
  |
Discover
  |
Server
  |
Offer
  |
Client
  |
Request
  |
Server
  |
Acknowledge
  |
Client configured

---

# DHCP Lease

IP assigned temporarily.

Example:

24 Hours

After expiration:

Renewal occurs.

---

# Lease Renewal

Client sends request.

Server renews lease.

Usually:

50% of lease time.

---

# DHCP Ports

Server:

67

Client:

68

Uses:

UDP

---

# DHCP Reservation

Always give same IP.

Example:

Printer

MAC Address:

AA:BB:CC

Always gets:

192.168.1.50

---

# DHCP Relay Agent

Client and Server in different networks.

Router forwards DHCP requests.

Without relay:

DHCP broadcast cannot cross router.

---

# Interview Questions

Q1. What is DORA?

Discover
Offer
Request
Acknowledge

---

Q2. Which ports DHCP uses?

67
68

---

Q3. Why UDP?

Fast
Simple

---

Q4. Why DHCP needed?

Automatic IP assignment.

---

Q5. Can DHCP broadcasts cross routers?

No