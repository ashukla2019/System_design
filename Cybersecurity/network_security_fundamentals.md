# Network Security and Cryptography Fundamentals

---

# 1. Three Fundamental Risks in Network Communication

When sending data over a network, three major risks exist:

## 1.1 Confidentiality  – Anyone Can Read the Data

If data is not encrypted, attackers can intercept and view it  
(e.g., passwords, credit card numbers).

**Solution:** Encryption (HTTPS, TLS)

---

## 1.2 Integrity  – Anyone Can Modify the Data

An attacker can alter messages in transit  
(e.g., change a bank transfer amount).

**Solution:**  
- Hashing  
- Digital Signatures  
- Message Authentication Codes (MACs)

---

## 1.3 Authentication  – Anyone Can Pretend to Be You

An attacker may spoof identity  
(e.g., fake website, stolen login credentials).

**Solution:**  
- Passwords  
- Certificates  
- Multi-Factor Authentication (MFA)

---

# 2. Classic Security Principles

These risks map to core security principles:

- **Confidentiality** → Prevent unauthorized reading  
- **Integrity** → Prevent unauthorized modification  
- **Authentication** → Verify identity  

---

# 3. Preventing Network Security Threats

---

## 3.1 Prevent Reading (Confidentiality)

**Problem:** Attackers can sniff or intercept data.  
**Solution:** Encryption  

Encryption converts plaintext into ciphertext.

### Common Solutions

- TLS/SSL (HTTPS) – Secures web traffic  
- VPN – Encrypts network traffic  
- AES – Symmetric encryption algorithm  
- End-to-End Encryption (E2EE)

---

## 3.2 Prevent Modification (Integrity)

**Problem:** Attackers can alter data in transit.  
**Solution:** Integrity verification mechanisms  

### Hash Functions (SHA-256)

- Generate fixed-size digest  
- If data changes → hash changes  

### Message Authentication Code (MAC)

- Secret key + hash  
- Ensures integrity and authenticity  

### Digital Signatures

- Uses public/private key cryptography  
- Verifies integrity and sender identity  

---

## 3.3 Prevent Impersonation (Authentication)

**Problem:** Someone pretends to be another user or server.  

### Common Solutions

- Passwords  
- Multi-Factor Authentication (MFA)  
  - Password + OTP + Biometrics  
- Digital Certificates (PKI)  
- Public/Private Key Authentication  

---

# 4. Combined Real-World Example: HTTPS

When visiting a secure website:

- TLS encrypts data → **Confidentiality**
- MAC + hashing ensure → **Integrity**
- Digital certificate verifies server → **Authentication**

---

# 5. Symmetric Key Encryption

---

## 5.1 How Symmetric Encryption Works

Uses **one shared secret key (K)** for:

- Encryption  
- Decryption  

### Process

1. Sender and receiver share secret key (K)  
2. Sender encrypts plaintext using K  
3. Ciphertext is transmitted  
4. Receiver decrypts using same key  

### Mathematical Representation
Ciphertext = Encrypt(Plaintext, K)
Plaintext = Decrypt(Ciphertext, K)


If key is correct → data restored  
If key is wrong → unreadable  

### Example

Plaintext: HELLO  
Secret Key: KEY123  
Encrypted Output: X9@P$2  

Only someone with KEY123 can decrypt it.

---

## 5.2 Common Symmetric Algorithms

- AES (Advanced Encryption Standard)  
- DES (obsolete)  
- 3DES (legacy)  
- ChaCha20 (modern, fast)  

### AES is Used In:

- HTTPS  
- VPNs  
- Wi-Fi security  
- Disk encryption  

---

# 6. Problems with Symmetric Encryption

---

## 6.1 Key Distribution Problem

How do two parties securely share the secret key?

If sent over the same network → attacker can intercept it.

---

## 6.2 Scalability Problem

If 100 users communicate securely:

Each pair requires a unique key.

Formula:
n(n - 1) / 2

For 100 users:
4950 keys required


Hard to manage at scale.

---

## 6.3 No Built-in Authentication

Symmetric encryption alone:

- Does not prove sender identity  
- Only proves knowledge of the key  

If key leaks → anyone can impersonate.

---

## 6.4 Key Storage Risk

If key storage is compromised:

- Attacker can decrypt past messages  
- Future messages also compromised  

---

# 7. Solutions to Symmetric Encryption Problems

---

## 7.1 Hybrid Encryption

Sender
  |
  |-- Generate Symmetric Key (Session Key)
  |
  |-- Encrypt Data with Session Key  ---> Encrypted Data
  |
  |-- Encrypt Session Key with Receiver's Public Key
  |
  |-------------------------------> Send Both
                                    |
                                    v
                               Receiver
                                    |
                        Decrypt Session Key (Private Key)
                                    |
                        Decrypt Data (Session Key)


---

## 7.2 Key Exchange Protocols

Instead of sending secret key directly:

- Diffie-Hellman (DH)  
- Elliptic Curve Diffie-Hellman (ECDH)  

Allows two parties to create shared secret  
without transmitting the secret itself.

---

## 7.3 Session Keys

- Temporary keys  
- Used for one session  
- Discarded afterward  

Provides:

- Forward Secrecy  
- Limited damage if key leaks  

---

## 7.4 Authenticated Encryption

Modern modes:

- AES-GCM  
- ChaCha20-Poly1305  

Provide:

- Confidentiality  
- Integrity  
- Authentication  

All in one operation.

---

# 8. Problem with Asymmetric Encryption

In asymmetric cryptography:

- Everyone has a public key  
- Anyone can encrypt using it  
- Only private key owner can decrypt  

---

## 8.1 Man-in-the-Middle (MITM) Attack

Example:

1. You request Alice’s public key  
2. Mallory intercepts and sends her own key  
3. You encrypt using Mallory’s key  
4. Mallory decrypts and re-encrypts using Alice’s key  
5. Neither party notices  

Asymmetric encryption alone does NOT provide authentication.

---

# 9. Solutions to Authenticate Public Keys

---

## 9.1 Digital Certificates (PKI)

Used in HTTPS.

### How It Works

1. Certificate Authority (CA) verifies identity  
2. CA signs the public key  
3. Signed key becomes a Digital Certificate  

When receiving a certificate:

- Verify CA signature  
- If valid → trust the key  

Example:

Opening https://google.com:

- Google sends certificate  
- Browser verifies using trusted CAs  
- Secure connection established  

---

## 9.2 Digital Signatures

Process:

1. Sender hashes message  
2. Signs hash with private key  
3. Receiver verifies using public key  

If verification succeeds:

- Message authentic  
- Message not modified  

Provides:

- Authentication  
- Integrity  
- Non-repudiation  

---
---

## 9.3 Non-Repudiation

Non-repudiation ensures that a sender cannot deny sending a message.

This is typically achieved using **digital signatures**.

If a message is signed using a private key:
- Only the private key owner could have created the signature
- The sender cannot later deny sending it

### Important In:
- Online banking
- Digital contracts
- Legal communications
- Secure email systems

---

# 10. Authorization

Authentication verifies **who you are**.  
Authorization determines **what you are allowed to do**.

Example:
- Logging into a system → Authentication
- Accessing admin panel → Authorization

### Common Authorization Models

- Role-Based Access Control (RBAC)
- Attribute-Based Access Control (ABAC)
- Access Control Lists (ACLs)

Authorization is a critical but separate security principle.

---

# 11. Availability

Availability ensures that systems and data are accessible when needed.

It completes the full **CIA Triad**:

- Confidentiality
- Integrity
- Availability

### Threats to Availability

- Distributed Denial-of-Service (DDoS) attacks
- Hardware failures
- Power outages
- Resource exhaustion

### Solutions

- Load balancing
- Redundancy
- Failover systems
- Rate limiting
- DDoS mitigation services

---

# 12. Replay Attacks

A replay attack occurs when an attacker:

1. Captures a valid message
2. Resends it later to gain unauthorized access

Example:
- Capturing a valid authentication request
- Replaying it to impersonate a user

### Solutions

- Nonces (random one-time numbers)
- Timestamps
- Sequence numbers
- Challenge-response protocols

These ensure that old messages cannot be reused.

---

# 13. Forward Secrecy

Forward Secrecy ensures that:

> Even if a server’s long-term private key is compromised, past encrypted sessions remain secure.

This is achieved using:

- Ephemeral Diffie-Hellman (DHE)
- Elliptic Curve Diffie-Hellman Ephemeral (ECDHE)

Used in:
- TLS 1.2 (optional)
- TLS 1.3 (mandatory)

Forward secrecy protects historical communications.

---

# 14. Hash Function Security Properties

A secure cryptographic hash function must provide:

## 14.1 Pre-image Resistance

Given a hash value H, it should be computationally infeasible to find the original input.

## 14.2 Second Pre-image Resistance

Given input A, it should be infeasible to find another input B such that:

Hash(A) = Hash(B)

## 14.3 Collision Resistance

It should be infeasible to find *any two different inputs* that produce the same hash.

---

# 15. Threat Models

Understanding threat models helps define security assumptions.

## 15.1 Passive Attacker

- Can observe traffic
- Cannot modify messages
- Example: Eavesdropping

## 15.2 Active Attacker

- Can intercept, modify, inject, or delete messages
- Example: Man-in-the-Middle (MITM)

## 15.3 Insider Attacker

- Has legitimate system access
- Misuses privileges

Security protocols must be designed considering these attacker models.
------------

# What Is a Digital Signature?

A digital signature is a cryptographic mechanism that verifies:

- **Authenticity** – Who sent the message  
- **Integrity** – The message was not altered  
- **Non-repudiation** – The sender cannot deny it later  

Digital signatures rely on **public-key cryptography** (like RSA or ECDSA).

---

# High-Level Analogy

Imagine you have:

- A **private stamp** only you own → **Private Key**
- A **public stamp verifier** everyone can use → **Public Key**

You stamp a document → Others verify using the public verifier.

---

# How Digital Signatures Work (Step by Step)

## 1. Hashing the Data

Before signing, the message is hashed.
Message → Hash Function → Message Digest


Example: `SHA-256`

### Why hash?

- Hashing is fast  
- Prevents signing huge data directly  
- Ensures integrity  

---

## 2. Signing with the Private Key

A cryptographic algorithm (RSA/ECDSA) encrypts the hash with the private key.

Signature = Encrypt(Hash(Message), PrivateKey)


Only the owner has the private key → Ensures authenticity.

---

## 3. Sending the Message + Signature

The sender sends:

- The original message  
- The digital signature  

---

## 4. Verification by the Receiver

The receiver does two things:

### A. Hash the Received Message
Received Message → SHA-256 → hash1

### B. Decrypt the Signature Using Sender’s Public Key
Decrypt(Signature, PublicKey) → hash2


If:
hash1 == hash2

Then the signature is valid.

This means:

- The message was not changed  
- The sender is verified  
- The sender cannot deny signing  

---

# Why the Public Key Works

Because:

- **Private key signs**
- **Public key verifies**

The public key cannot generate a signature — it can only verify one.









