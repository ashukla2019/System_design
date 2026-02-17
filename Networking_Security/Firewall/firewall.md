# 🔥 Firewall – Complete Notes (Cyber Security)

## 1️⃣ What is a Firewall?

A firewall is a network security device (hardware or software) that monitors and filters incoming and outgoing traffic based on predefined security rules.

It acts as a barrier between trusted and untrusted networks.

Example:
- Internal Network (Trusted)
- Internet (Untrusted)

---

## 2️⃣ Why Firewall is Important?

- Blocks unauthorized access
- Prevents external attacks
- Controls outbound traffic
- Enforces security policies
- Protects servers and endpoints

---

## 3️⃣ Types of Firewalls

### A) Based on Deployment

#### 1. Network Firewall
- Installed at network perimeter
- Protects entire network

#### 2. Host-Based Firewall
- Installed on individual systems
- Example: iptables (Linux), Windows Defender Firewall

---

### B) Based on Technology

#### 1️⃣ Packet Filtering Firewall (Layer 3 & 4)
- Filters based on:
  - IP address
  - Port number
  - Protocol
- Fast but less intelligent

---

#### 2️⃣ Stateful Inspection Firewall
- Tracks active connections
- Remembers session state
- More secure than packet filtering

---

#### 3️⃣ Proxy Firewall (Application Layer Firewall)
- Works at Layer 7
- Inspects application data
- Acts as intermediary between client and server

---

#### 4️⃣ Next-Generation Firewall (NGFW)
- Deep Packet Inspection (DPI)
- Application awareness
- Intrusion Prevention System (IPS)
- URL filtering
- Malware protection

Examples:
- Palo Alto
- FortiGate
- Cisco ASA

---

## 4️⃣ Firewall Rule Components

A firewall rule typically contains:

- Source IP
- Destination IP
- Source Port
- Destination Port
- Protocol (TCP/UDP/ICMP)
- Action (Allow/Deny)

Example Rule:

Allow TCP from 10.0.0.0/24 to 192.168.1.10 on port 443


---

## 5️⃣ Common Firewall Concepts

### 🔹 Default Deny Policy
Block everything unless explicitly allowed.

### 🔹 Inbound vs Outbound Rules
- Inbound → Incoming traffic
- Outbound → Outgoing traffic

### 🔹 NAT (Network Address Translation)
- SNAT (Source NAT)
- DNAT (Destination NAT)
- Port forwarding

### 🔹 DMZ (Demilitarized Zone)
Public-facing servers placed in isolated network segment.

---

## 6️⃣ Firewall in Cloud

### AWS
- Security Groups (Stateful)
- NACL (Stateless)

### Azure
- NSG (Network Security Group)

### GCP
- VPC Firewall Rules

---

## 7️⃣ Firewall vs IDS vs IPS

| Feature | Firewall | IDS | IPS |
|----------|----------|-----|-----|
| Blocks traffic | ✅ | ❌ | ✅ |
| Detects attacks | Limited | ✅ | ✅ |
| Inline protection | ✅ | ❌ | ✅ |

---

## 8️⃣ Common Firewall Attacks

- Port scanning
- DDoS
- IP spoofing
- Firewall misconfiguration
- Rule shadowing

---

## 9️⃣ Firewall Best Practices

- Use least privilege rules
- Remove unused rules
- Regularly review firewall logs
- Enable logging
- Avoid “Any → Any → Allow”
- Use network segmentation
- Implement multi-layer security

---

## 🔟 Important Ports to Know

| Port | Service |
|------|---------|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 53 | DNS |
| 25 | SMTP |
| 3389 | RDP |
| 514 | Syslog |

---

## 📌 Interview Quick Definition

A firewall is a security device that monitors and filters network traffic based on predefined rules to protect systems from unauthorized access.

---

## 📚 Summary

A firewall is a core component of network security that:
- Controls traffic flow
- Enforces security policies
- Prevents unauthorized access
- Supports monitoring and logging
- Protects both on-prem and cloud environments
