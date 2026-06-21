# Network Troubleshooting

Essential skill for DevOps, SRE and Cloud Engineers.

---

# ping

Uses ICMP.

Tests connectivity.

Example:

ping google.com

Checks:

Reachability

Latency

Packet Loss

---

# traceroute

Shows packet path.

Linux:

traceroute google.com

Windows:

tracert google.com

---

# nslookup

DNS troubleshooting.

Example:

nslookup google.com

Returns:

IP Address

---

# dig

Advanced DNS tool.

Example:

dig google.com

---

# netstat

Displays:

Connections

Listening Ports

Routing Table

---

# ss

Modern replacement for netstat.

Linux:

ss -tuln

---

# curl

HTTP testing.

Example:

curl https://google.com

Useful for APIs.

---

# tcpdump

Packet capture.

Example:

tcpdump -i eth0

---

# Wireshark

GUI packet analyzer.

Can inspect:

ARP

TCP

DNS

TLS

HTTP

Everything.

---

# Common Troubleshooting Flow

Cannot Open Website

↓

Check IP

ipconfig / ifconfig

↓

Ping Gateway

↓

Ping DNS

↓

nslookup

↓

curl

↓

tcpdump/Wireshark

---

# Interview Questions

Q1. What does ping use?

ICMP

---

Q2. Purpose of traceroute?

Show network path.

---

Q3. Purpose of nslookup?

DNS troubleshooting.

---

Q4. Best packet analysis tool?

Wireshark