# Firewall Notes – Interview Preparation

## 1. Introduction to Firewall
- A **firewall** is a network security device or software that monitors, filters, and controls incoming and outgoing network traffic based on predefined security rules.
- Purpose: Protects internal networks from unauthorized access and cyber threats.
- Can be **hardware-based, software-based, or cloud-based**.

---

## 2. Types of Firewalls

### 2.1 Packet Filtering Firewall
- Inspects each packet's **source IP, destination IP, protocol, and port number**.
- Works at **Layer 3 (Network)** and **Layer 4 (Transport)**.
- **Pros:** Fast, simple.
- **Cons:** Cannot inspect payload; limited against complex attacks.

### 2.2 Stateful Inspection Firewall
- Tracks **state of active connections** and makes decisions based on the connection state.
- Operates at **Layer 3 & 4**, sometimes Layer 5 (Session).
- **Pros:** More secure than packet filtering.
- **Cons:** Slightly slower due to state tracking.

### 2.3 Application Layer Firewall (Proxy Firewall)
- Works at **Layer 7 (Application)**.
- Inspects **application-level data**, e.g., HTTP, FTP.
- Can filter based on **URL, content, headers, or commands**.
- **Pros:** Detects application attacks like SQLi, XSS.
- **Cons:** Slower, complex to configure.

### 2.4 Next-Generation Firewall (NGFW)
- Combines **stateful inspection, deep packet inspection, intrusion prevention (IPS), and application awareness**.
- Often includes **SSL/TLS inspection** and **user identity-based policies**.
- Examples: Palo Alto, Fortinet, Check Point.

### 2.5 Cloud Firewall / Web Application Firewall (WAF)
- **Cloud-based firewall** protecting web applications from attacks.
- Monitors traffic for **SQL injection, cross-site scripting (XSS), DDoS)**.
- Azure Example: **Azure WAF**  
- AWS Example: **AWS WAF**

---

## 3. Firewall Deployment Modes

1. **Network-based Firewall**
   - Deployed at the network perimeter.
   - Protects entire network segments.
2. **Host-based Firewall**
   - Installed on individual servers or endpoints.
   - Examples: Windows Defender Firewall, iptables.
3. **Cloud Firewall**
   - Managed firewall in cloud environments.
   - Examples: AWS WAF, Azure Firewall, GCP Cloud Armor.
4. **Inline vs Transparent Mode**
   - Inline: Traffic passes through firewall, can block/allow.
   - Transparent: Monitors traffic without modifying routing.

---

## 4. Key Firewall Features
- **Packet Filtering:** Allow/block traffic based on IP, port, protocol.
- **Stateful Inspection:** Maintain state of connections.
- **Deep Packet Inspection (DPI):** Inspect payload for malicious content.
- **VPN Support:** Secure site-to-site or client connections.
- **Logging & Monitoring:** Tracks allowed/denied traffic for auditing.
- **Intrusion Prevention System (IPS):** Detects and blocks malicious traffic.
- **High Availability (HA):** Redundant firewall setup for fault tolerance.

---

## 5. Common Firewall Rules & Policies
- **Allow rule:** Permit traffic from trusted sources.
- **Deny/Drop rule:** Block unwanted traffic.
- **Default Deny:** Deny all traffic unless explicitly allowed (best practice).
- **Time-based rules:** Allow/block traffic at specific times.
- **Geo-blocking:** Restrict traffic from specific countries or regions.

---

## 6. Firewall in Cloud Context
- **AWS:** Security Groups (instance-level), Network ACLs (subnet-level), WAF.
- **Azure:** Network Security Groups (NSG), Azure Firewall, Azure WAF.
- **GCP:** VPC Firewall rules, Cloud Armor for application-level protection.
- **Best Practices:**
  - Principle of **least privilege**.
  - Use layered security (firewall + WAF + IPS + monitoring).
  - Keep firewall rules **simple, auditable, and updated**.

---

## 7. Firewall Interview Tips
- Be clear on **differences between network, host, and cloud firewalls**.
- Understand **stateful vs stateless** firewalls.
- Know **common firewall rules and best practices**.
- Be ready to **explain cloud firewall components** for AWS, Azure, GCP.
- Example scenario questions:
  - “How would you secure a web application in a multi-tier architecture?”
  - “Difference between NSG and Azure Firewall?”
  - “How does a WAF differ from a traditional firewall?”

---
