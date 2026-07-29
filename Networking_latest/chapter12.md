# Chapter 12 – Network Security (Interview Focus)
**Senior C/C++ Linux Networking Interview Handbook**

> **Goal:** Understand the networking security concepts commonly asked in senior interviews at **Arista, Cisco, Juniper, NVIDIA, Broadcom, Qualcomm, and cloud networking teams**. Focus on **how security protocols work**, not cryptography mathematics.

---

# Where Does Security Fit?

A typical secure connection looks like this:

```
Application (HTTPS)

↓

TLS

↓

TCP

↓

IP

↓

Ethernet

↓

NIC
```

Notice

```
TLS sits above TCP.
```

---

# Security Goals

Every security protocol tries to provide one or more of these:

| Goal | Meaning |
|-------|---------|
| Confidentiality | Prevent others from reading data |
| Integrity | Detect modified data |
| Authentication | Verify identity |
| Authorization | Control access |
| Non-Repudiation | Prevent denying an action |

---

# Encryption

Encryption converts readable data into unreadable data.

```
Hello World

↓

Encryption

↓

X9#@!Ab$%
```

Receiver decrypts it back.

```
Ciphertext

↓

Decryption

↓

Hello World
```

---

# Symmetric Encryption

One shared key.

```
Sender

↓

Key

↓

Receiver
```

Examples

- AES
- ChaCha20

Advantages

- Very fast
- Used for actual data transfer

Disadvantage

- Secure key exchange is required.

---

# Asymmetric Encryption

Two keys.

```
Public Key

Private Key
```

Example

```
Encrypt

↓

Public Key

↓

Decrypt

↓

Private Key
```

Examples

- RSA
- ECC

Advantages

- Secure key exchange
- Digital signatures

Disadvantages

- Slower than symmetric encryption

---

# Why TLS Uses Both

TLS combines both methods.

```
Handshake

↓

Asymmetric Encryption

↓

Shared Session Key

↓

Actual Data

↓

Symmetric Encryption
```

This provides both security and performance.

---

# Hash Function

A hash converts data into a fixed-size value.

```
Hello

↓

SHA-256

↓

2CF24DBA...
```

Properties

- One-way
- Fixed output size
- Tiny input change → completely different output

Uses

- Integrity
- Password storage (with proper password hashing algorithms)
- Digital signatures

---

# Digital Signature

Used to verify

- Sender identity
- Data integrity

```
Message

↓

Hash

↓

Encrypt Hash

↓

Private Key

↓

Digital Signature
```

Receiver

```
Public Key

↓

Verify Signature
```

---

# SSL vs TLS

Interview Favorite.

SSL

```
Old

Deprecated
```

TLS

```
Modern

Secure
```

Always say

```
TLS
```

not SSL.

---

# HTTPS

HTTPS is simply

```
HTTP

+

TLS
```

Flow

```
Browser

↓

TCP Handshake

↓

TLS Handshake

↓

Encrypted HTTP
```

---

# TLS Handshake (Simplified)

Very common interview question.

```
Client

↓

Client Hello

↓

Server

↓

Server Hello

↓

Certificate

↓

Key Exchange

↓

Session Key Created

↓

Encrypted Communication
```

After the handshake,

Most traffic uses fast symmetric encryption.

---

# Certificate

A certificate proves the server's identity.

Contains

- Public Key
- Domain Name
- Issuer (CA)
- Expiration Date

Example

```
www.google.com

↓

Certificate

↓

Verified
```

---

# Certificate Authority (CA)

A trusted organization that signs certificates.

```
Server

↓

Certificate

↓

CA Signs

↓

Browser Trusts
```

Without a trusted CA,

Browsers display certificate warnings.

---

# Firewall

A firewall filters network traffic.

```
Packet

↓

Firewall

↓

Allow

or

Drop
```

Rules may depend on

- IP Address
- Port
- Protocol
- Connection State

---

# Stateless Firewall

Checks every packet independently.

```
Packet

↓

Rule

↓

Allow / Drop
```

No connection history.

---

# Stateful Firewall

Tracks active connections.

```
TCP Connection

↓

Remember State

↓

Allow Replies
```

Much smarter than a stateless firewall.

Linux `conntrack` enables stateful behavior.

---

# Access Control List (ACL)

ACL = Ordered set of filtering rules.

Example

```
Permit

192.168.1.0/24

Port 22

------------------

Deny

Everything Else
```

Routers and switches commonly use ACLs.

---

# VPN (Virtual Private Network)

Creates an encrypted tunnel over an untrusted network.

```
Laptop

↓

Encrypted Tunnel

↓

Corporate Network
```

Benefits

- Privacy
- Secure remote access
- Encryption

---

# IPSec

Common VPN technology.

Operates at

```
Layer 3
```

Provides

- Encryption
- Authentication
- Integrity

Common in site-to-site VPNs.

---

# SSH

Secure replacement for Telnet.

```
Client

↓

Encrypted Connection

↓

Server
```

Uses

- Remote login
- Secure file transfer (SCP/SFTP)
- Administration

Default Port

```
22
```

---

# Common Secure Protocols

| Protocol | Port |
|-----------|-----:|
| HTTPS | 443 |
| HTTP | 80 |
| SSH | 22 |
| DNS | 53 |
| SMTP | 25 |
| IMAPS | 993 |
| POP3S | 995 |

Only memorize the most common ports.

---

# DoS vs DDoS

## DoS

One attacker.

```
Attacker

↓

Server
```

---

## DDoS

Many attackers.

```
Bot1

Bot2

Bot3

↓

Server
```

Much harder to defend against.

---

# XDP and DDoS Protection

Modern networking companies often use

```
NIC

↓

XDP

↓

Drop Malicious Packets

↓

Kernel
```

Packets can be dropped before traversing the full networking stack.

---

# Linux Security Tools

View firewall rules

```bash
iptables -L
```

Modern systems may use

```bash
nft list ruleset
```

Check listening ports

```bash
ss -tulnp
```

Inspect certificates

```bash
openssl s_client -connect google.com:443
```

---

# Common Interview Questions

## Q1 Difference between SSL and TLS?

SSL is obsolete.

TLS is the modern secure protocol.

---

## Q2 Why does TLS use both symmetric and asymmetric encryption?

Asymmetric encryption securely establishes a shared key.

Symmetric encryption efficiently protects application data.

---

## Q3 What is a certificate?

A digitally signed document that binds a public key to an identity.

---

## Q4 Why do we need a Certificate Authority?

To establish trust that the server's public key belongs to the claimed identity.

---

## Q5 Difference between HTTPS and HTTP?

HTTPS is HTTP protected by TLS encryption.

---

## Q6 Difference between Stateful and Stateless Firewalls?

Stateless firewalls inspect packets independently.

Stateful firewalls track connection state.

---

## Q7 What is IPSec?

A Layer-3 protocol suite that secures IP communications.

---

## Q8 Why use a VPN?

To securely connect remote users or sites over an untrusted network.

---

## Q9 What is the difference between hashing and encryption?

Hashing is one-way.

Encryption is reversible with the appropriate key.

---

# Common Mistakes

❌ Saying HTTPS uses only RSA.

✔ Modern TLS typically uses asymmetric cryptography for key exchange/authentication and symmetric encryption for data transfer.

---

❌ Thinking hashing can be decrypted.

✔ Cryptographic hash functions are one-way.

---

❌ Thinking a firewall encrypts traffic.

✔ Firewalls filter traffic. Encryption is handled by protocols like TLS or IPSec.

---

❌ Calling modern secure websites "SSL websites."

✔ The correct term is **TLS**.

---

# Quick Revision

```
HTTPS

↓

TLS

↓

Certificate

↓

CA

↓

Session Key

↓

Encrypted Traffic

↓

Firewall

↓

VPN

↓

IPSec

↓

SSH
```

---

# Interview Cheat Sheet

| Topic | Remember |
|--------|----------|
| HTTPS | HTTP + TLS |
| TLS | Modern Secure Protocol |
| SSL | Deprecated |
| Symmetric Encryption | Fast Data Encryption |
| Asymmetric Encryption | Key Exchange & Identity |
| Hash | One-Way Integrity Check |
| Certificate | Public Key + Identity |
| CA | Trusted Signer |
| Stateful Firewall | Tracks Connections |
| ACL | Packet Filtering Rules |
| VPN | Secure Tunnel |
| IPSec | Layer-3 Security |
| SSH | Secure Remote Login (Port 22) |

---

# Chapter Summary

After completing this chapter, you should be able to explain:

- Security goals
- Symmetric vs asymmetric encryption
- Hashing and digital signatures
- TLS handshake
- Certificates and Certificate Authorities
- HTTPS
- Firewalls and ACLs
- Stateful vs stateless filtering
- VPN and IPSec
- SSH
- DDoS basics and XDP-based mitigation

---

**Next Chapter:** **High Availability & Load Balancing** – LACP, Link Aggregation, VRRP, ECMP, Anycast, Load Balancers (L4/L7), HAProxy, health checks, redundancy, and network resilience. This is heavily asked in Arista and other networking interviews.