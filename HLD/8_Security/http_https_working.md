# HTTP vs HTTPS Flow

---

# HTTP FLOW

```text
User types:
http://example.com
        ↓
DNS Lookup
example.com → IP Address
        ↓
TCP 3-Way Handshake
SYN → SYN-ACK → ACK
        ↓
Browser sends HTTP Request
(GET / POST / PUT etc.)
        ↓
Data Encapsulation
HTTP → TCP → IP → Ethernet
        ↓
Packets travel through routers/network
        ↓
Server receives packets
        ↓
Data Decapsulation
Ethernet → IP → TCP → HTTP
        ↓
Web Server processes request
        ↓
HTTP Response generated
(200 OK, HTML, JSON etc.)
        ↓
Response sent back
        ↓
Browser renders webpage
```

---

# Problems with HTTP

HTTP communication is **not encrypted**.

This creates major security issues:

- Data travels as plain text
- Attackers can sniff packets
- Passwords and cookies can be stolen
- Data can be modified during transmission
- No identity verification of server
- Vulnerable to:
  - Man-in-the-Middle (MITM) attacks
  - Session hijacking
  - Packet sniffing
  - Data tampering

Example:

```text
User Login:
username=admin
password=123456
```

In HTTP, anyone monitoring the network can read this data.

---

# How HTTPS Solves These Problems

HTTPS = HTTP + TLS/SSL Encryption

HTTPS adds:

- Encryption
- Authentication
- Data Integrity

Benefits:

| Problem in HTTP | Solution in HTTPS |
|---|---|
| Plain text communication | Data encrypted using TLS |
| Password theft | Credentials encrypted |
| MITM attacks | Certificate validation |
| Data tampering | Integrity checks |
| Fake websites | CA-signed certificates |

---

# HTTPS FLOW

```text
User types:
https://google.com
        ↓
DNS Lookup
google.com → IP Address
        ↓
TCP 3-Way Handshake
SYN → SYN-ACK → ACK
        ↓
TLS Handshake starts
        ↓
Client Hello
(Supported TLS versions, ciphers, random)
        ↓
Server Hello
(Selected TLS version, cipher, random)
        ↓
Server sends Certificate
(Public Key + CA Signature)
        ↓
Browser verifies Certificate
        ↓
Key Exchange
(Shared Secret established)
        ↓
Session Keys generated
        ↓
Secure Encrypted TLS Tunnel established
        ↓
Encrypted HTTP Communication
HTTP → TLS Encrypt → TCP → IP → Ethernet
        ↓
Packets travel through routers/network
        ↓
Server receives packets
        ↓
TLS Decryption
Ethernet → IP → TCP → TLS Decrypt → HTTP
        ↓
Web Server processes request
        ↓
Encrypted HTTP Response sent
        ↓
Browser decrypts response
        ↓
Browser renders webpage
```

---

# Key Difference

## HTTP

```text
HTTP Data → Plain Text → Internet
```

Anyone can read the traffic.

---

## HTTPS

```text
HTTP Data → TLS Encryption → Internet
```

Traffic becomes encrypted and secure.

---

# Simple Real-World Analogy

## HTTP

Like sending a postcard.

Anyone handling it can read the message.

---

## HTTPS

Like sending a locked box.

Only the sender and receiver have the key.

---

# Summary

| Feature | HTTP | HTTPS |
|---|---|---|
| Encryption | ❌ No | ✅ Yes |
| Security | ❌ Low | ✅ High |
| Uses TLS/SSL | ❌ No | ✅ Yes |
| Data Privacy | ❌ No | ✅ Yes |
| Certificate Validation | ❌ No | ✅ Yes |
| Default Port | 80 | 443 |
