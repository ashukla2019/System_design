# ARP (Address Resolution Protocol)

One of the most important protocols in networking.

Question:

We know destination IP.

How do we find destination MAC?

Answer:

ARP

---

# Why ARP Exists

Switches use:

MAC Addresses

Routers use:

IP Addresses

Suppose:

PC1:

IP:
192.168.1.10

MAC:
AA:AA:AA

PC2:

IP:
192.168.1.20

MAC:
BB:BB:BB

PC1 wants to communicate.

Knows:

192.168.1.20

Does NOT know:

BB:BB:BB

ARP solves this.

---

# ARP Process

Step 1

ARP Request

Broadcast

"Who has 192.168.1.20?"

Destination MAC:

FF:FF:FF:FF:FF:FF

Everyone receives.

---

Step 2

PC2 responds.

ARP Reply

"192.168.1.20 is BB:BB:BB"

Unicast.

---

Step 3

PC1 stores result.

ARP Cache:

192.168.1.20 → BB:BB:BB

---

# ARP Cache

Operating system stores mappings.

Example:

IP              MAC

192.168.1.1     AA:AA
192.168.1.20    BB:BB

Avoids repeated ARP requests.

---

# View ARP Cache

Windows:

arp -a

Linux:

ip neigh

or

arp -n

---

# Local Communication Example

PC1

192.168.1.10

↓

Needs

192.168.1.20

↓

ARP Broadcast

↓

ARP Reply

↓

Frame Sent

---

# Remote Communication Example

PC1:

192.168.1.10

Google:

142.250.x.x

Different network.

ARP does NOT find Google MAC.

Instead:

ARP finds Router MAC.

Default Gateway:

192.168.1.1

Flow:

PC1
 ↓
Router MAC
 ↓
Router forwards

Important Interview Question.

---

# Gratuitous ARP

Device announces itself.

Example:

"192.168.1.20 is me"

Uses:

- Duplicate IP detection
- Failover systems

---

# ARP Spoofing

Attacker sends fake ARP replies.

Example:

Attacker claims:

"Router MAC = Mine"

Traffic redirected.

Used in:

Man-in-the-Middle attacks.

---

# ARP Packet Fields

Sender MAC
Sender IP
Target MAC
Target IP

Simple protocol.

---

# ARP Works Only Inside LAN

Important.

ARP cannot cross routers.

ARP is a broadcast protocol.

Routers block broadcasts.

---

# Interview Questions

Q1. Why ARP needed?

IP → MAC mapping.

---

Q2. ARP works at which layer?

Layer 2 / Layer 3 boundary.

---

Q3. ARP request is?

Broadcast

---

Q4. ARP reply is?

Unicast

---

Q5. Can ARP cross router?

No