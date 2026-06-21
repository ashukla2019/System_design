# HTTPS (HyperText Transfer Protocol Secure)

HTTPS = HTTP + TLS

Provides:

- Encryption
- Authentication
- Integrity

Without HTTPS:

Anyone can read traffic.

---

# Problem with HTTP

HTTP sends plain text.

Example:

Username = admin

Password = secret

Attacker can capture packets.

Read everything.

---

# HTTPS Solution

Encrypt data before sending.

Browser
   |
Encrypted Data
   |
Internet
   |
Server

Attacker sees:

Random encrypted bytes.

---

# HTTPS Uses

Protocol:

TLS

Transport:

TCP

Port:

443

---

# What HTTPS Provides

---

# Confidentiality

Nobody can read data.

Encryption protects traffic.

---

# Integrity

Data cannot be modified.

Hash verification detects tampering.

---

# Authentication

Confirms server identity.

Certificate proves ownership.

---

# Digital Certificate

Issued by:

Certificate Authority (CA)

Contains:

Domain Name

Public Key

Validity Period

CA Signature

---

# Certificate Authorities

Examples:

DigiCert

Let's Encrypt

GlobalSign

Sectigo

---

# HTTPS Connection Flow

User opens:

https://google.com

↓

TCP Handshake

↓

TLS Handshake

↓

Encrypted Session Key

↓

Secure Communication

---

# Symmetric Encryption

Same key:

Encrypt
Decrypt

Fast

Example:

AES

---

# Asymmetric Encryption

Two keys:

Public Key

Private Key

Example:

RSA

ECC

---

# Why Both Are Used

Asymmetric:

Secure key exchange

Symmetric:

Fast data transfer

---

# Browser Lock Icon

Indicates:

Valid certificate

Encrypted connection

---

# Self-Signed Certificate

Certificate signed by owner.

Not trusted by browsers.

Common in:

Testing

Labs

---

# Interview Questions

Q1. Difference between HTTP and HTTPS?

HTTPS encrypts traffic.

---

Q2. HTTPS port?

443

---

Q3. What protocol secures HTTPS?

TLS

---

Q4. Why not use asymmetric encryption for everything?

Too slow

---

Q5. What does certificate prove?

Server identity