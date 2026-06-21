# VPN (Virtual Private Network)

VPN creates an encrypted tunnel over public networks.

Purpose:

Secure communication.

---

# Without VPN

Office
 ↓
Internet
 ↓
Remote User

Traffic visible.

---

# With VPN

Office
 ↓
Encrypted Tunnel
 ↓
Remote User

Traffic protected.

---

# Benefits

Encryption

Privacy

Secure Remote Access

Site Connectivity

---

# Site-to-Site VPN

Connects:

Office A

to

Office B

Example:

Pune Office
↔
Mumbai Office

Appears as one network.

---

# Remote Access VPN

Connects user to company network.

Example:

Employee working from home.

---

# VPN Tunnel

Traffic:

Encrypted

↓

Internet

↓

Decrypted

---

# VPN Protocols

IPSec

SSL VPN

WireGuard

OpenVPN

L2TP

PPTP (obsolete)

---

# IPSec

Most common Site-to-Site VPN protocol.

Provides:

Encryption

Authentication

Integrity

---

# IPSec Components

AH

Authentication Header

---

ESP

Encapsulating Security Payload

Provides encryption.

---

# SSL VPN

Uses HTTPS.

Easy remote access.

Example:

Browser-based VPN.

---

# Split Tunnel

Only company traffic goes through VPN.

Internet traffic uses local ISP.

Faster.

---

# Full Tunnel

All traffic goes through VPN.

More secure.

---

# AWS VPN Components

Virtual Private Gateway

Customer Gateway

VPN Connection

Transit Gateway VPN

Client VPN

---

# Site-to-Site VPN Flow

Office Router
      ↓
Encrypted Tunnel
      ↓
AWS VPC

---

# Client VPN Flow

Laptop
 ↓
Client VPN
 ↓
AWS VPC

---

# Interview Questions

Q1. Why VPN?

Secure communication.

---

Q2. Difference between Site-to-Site and Remote Access VPN?

Site-to-Site:
Network ↔ Network

Remote:
User ↔ Network

---

Q3. Most common VPN protocol?

IPSec

---

Q4. What is split tunneling?

Only corporate traffic uses VPN.