# VLAN (Virtual LAN)

VLAN allows a single switch to act like multiple switches.

Without VLAN:

Everyone belongs to same network.

With VLAN:

Separate logical networks.

---

# Problem Without VLAN

Switch

PC1
PC2
HR
Finance
Engineering

All devices receive broadcasts.

Security issue.

---

# Solution

Create VLANs.

VLAN 10

HR

VLAN 20

Finance

VLAN 30

Engineering

Now isolated.

---

# Example

Port 1 -> VLAN 10
Port 2 -> VLAN 10

Port 3 -> VLAN 20
Port 4 -> VLAN 20

Port 5 -> VLAN 30
Port 6 -> VLAN 30

---

# Benefits

- Security
- Isolation
- Smaller broadcast domains
- Better management

---

# Access Port

Belongs to one VLAN.

Example:

PC → Switch

Most common.

---

# Trunk Port

Carries multiple VLANs.

Used between:

Switch ↔ Switch

Switch ↔ Router

Switch ↔ Firewall

---

# VLAN Tagging

IEEE 802.1Q

Adds VLAN ID.

Frame:

Ethernet Header
VLAN Tag
Payload

---

# Broadcast Domain

Every VLAN has its own broadcast domain.

Example:

VLAN10

ARP broadcast stays inside VLAN10.

Does not enter VLAN20.

---

# Inter-VLAN Routing

Question:

Can VLAN10 communicate with VLAN20?

Not directly.

Need Router.

Example:

VLAN10
    |
Router
    |
VLAN20

Router routes traffic.

---

# STP (Spanning Tree Protocol)

Problem:

Redundant links cause loops.

Example:

Switch A
  ↔
Switch B
  ↔
Switch C
  ↔
Switch A

Broadcast storm occurs.

---

# Broadcast Storm

Frame loops forever.

Network collapses.

---

# STP Solution

Blocks redundant path.

Creates loop-free topology.

---

# Root Bridge

STP elects one switch:

Root Bridge

All paths calculated from it.

---

# Switch Learning Process

Unknown MAC

↓

Flood

↓

Learn Source MAC

↓

Store in MAC Table

↓

Future traffic becomes unicast

---

# Interview Questions

Q1. Why VLAN?

Logical separation.

---

Q2. What is trunk?

Carries multiple VLANs.

---

Q3. What is access port?

Single VLAN.

---

Q4. Why STP needed?

Prevent loops.

---

Q5. What is broadcast domain?

Area where broadcast traffic travels.