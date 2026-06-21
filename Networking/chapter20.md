# Firewalls

Firewall controls network traffic.

It decides:

Allow
or
Deny

based on rules.

---

# Why Firewalls Needed

Without Firewall:

Internet
    ↓
Server

Anyone can access.

---

With Firewall:

Internet
    ↓
Firewall
    ↓
Server

Filtered access.

---

# Packet Filtering Firewall

Checks:

Source IP
Destination IP
Protocol
Port

Example:

Allow:

TCP 443

Deny:

TCP 23

---

# Stateful Firewall

Tracks connection state.

Example:

Outgoing HTTPS request

Return traffic automatically allowed.

Much smarter.

---

# Stateless Firewall

Checks each packet independently.

No memory.

Example:

Network ACL

---

# Next Generation Firewall

Features:

Deep Packet Inspection

Application Awareness

IDS

IPS

Malware Detection

---

# Firewall Rules Example

Allow:

TCP 443

Allow:

TCP 22

Deny:

Everything Else

---

# Inbound Rules

Internet
 ↓
Server

Controls incoming traffic.

---

# Outbound Rules

Server
 ↓
Internet

Controls outgoing traffic.

---

# AWS Mapping

Security Group

Stateful

---

Network ACL

Stateless

---

AWS Network Firewall

Enterprise Firewall

---

AWS WAF

Web Application Firewall

---

# Common Ports

22 SSH

80 HTTP

443 HTTPS

53 DNS

3306 MySQL

5432 PostgreSQL

---

# Interview Questions

Q1. Difference between SG and NACL?

SG:
Stateful

NACL:
Stateless

---

Q2. Why firewall?

Security.

---

Q3. What is WAF?

Protects web applications.