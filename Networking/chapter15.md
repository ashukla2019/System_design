# NAT (Network Address Translation)

One of the most important concepts.

Question:

How can millions of devices with private IPs
access the Internet?

Answer:

NAT

---

# Why NAT Exists

Private IP:

192.168.1.10

Google cannot route private IPs.

Need translation.

Router performs NAT.

---

# Example

Laptop:

192.168.1.10

Router Public IP:

49.36.100.50

Google sees:

49.36.100.50

Not:

192.168.1.10

---

# NAT Flow

Laptop

192.168.1.10
       ↓
Router NAT
       ↓
49.36.100.50
       ↓
Internet

---

# NAT Table

Private IP      Public IP

192.168.1.10    49.36.100.50
192.168.1.11    49.36.100.50

Router tracks mappings.

---

# Static NAT

One-to-one mapping.

Example:

10.0.0.10

↓

49.36.100.10

Always same.

Used for:

Public servers.

---

# Dynamic NAT

Pool of public IPs.

Private IP gets available public IP.

Not fixed.

---

# PAT (Port Address Translation)

Most common NAT.

Also called:

NAT Overload

Many private IPs

↓

One public IP

Uses ports.

---

# Example

192.168.1.10:50000

↓

49.36.100.50:50000

---

192.168.1.11:50001

↓

49.36.100.50:50001

---

Google replies.

Router checks port.

Sends response to correct device.

---

# Why PAT Important

Without PAT:

Every device needs public IP.

Impossible.

PAT saves IPv4 addresses.

---

# SNAT

Source NAT

Changes source address.

Common outbound traffic.

---

# DNAT

Destination NAT

Changes destination address.

Used for:

Port forwarding.

---

# Port Forwarding

Example:

Internet User
      ↓
49.36.100.50:80
      ↓
192.168.1.20:80

Allows external access.

---

# NAT Advantages

- Saves IPv4 addresses
- Hides internal network
- Adds security

---

# NAT Disadvantages

- Breaks end-to-end connectivity
- Additional processing

---

# AWS NAT Gateway

Private Subnet
       ↓
NAT Gateway
       ↓
Internet Gateway
       ↓
Internet

Used heavily in AWS.

---

# Interview Questions

Q1. Why NAT needed?

Private IPs cannot access Internet directly.

---

Q2. Most common NAT?

PAT

---

Q3. Difference between SNAT and DNAT?

SNAT:
Changes source

DNAT:
Changes destination

---

Q4. Which AWS service performs NAT?

NAT Gateway

---

Q5. Why does NAT help IPv4?

Reduces public IP usage.