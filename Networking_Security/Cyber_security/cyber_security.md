# Network Security and Cryptography Fundamentals

---

# 1. Three Fundamental Risks in Network Communication

When sending data over a network, three major risks exist:

## 1.1 Confidentiality – Anyone Can Read the Data

If data is not encrypted, attackers can intercept and view it  
(e.g., passwords, credit card numbers).

**Solution:** Encryption (TLS, HTTPS, VPN)

---

## 1.2 Integrity – Anyone Can Modify the Data

An attacker can alter messages in transit  
(e.g., change a bank transfer amount).

**Solution:**  
- Hashing  
- Message Authentication Codes (MACs)  
- Digital Signatures  

---

## 1.3 Authentication – Anyone Can Pretend to Be You

An attacker may spoof identity  
(e.g., fake website, stolen credentials).

**Solution:**  
- Passwords  
- Multi-Factor Authentication (MFA)  
- Digital Certificates (PKI)  
- Public/Private Key Authentication  

---

# 2. Classic Security Principles (CIA Triad)

- **Confidentiality** → Prevent unauthorized reading  
- **Integrity** → Prevent unauthorized modification  
- **Authentication** → Verify identity  
- **Availability** → Ensure systems remain accessible  

---

# 3. Preventing Network Security Threats

---

## 3.1 Prevent Reading (Confidentiality)

**Problem:** Attackers can sniff or intercept data.  
**Solution:** Encryption  

Encryption converts plaintext into ciphertext.

### Common Solutions

- TLS/SSL (HTTPS)(web traffic encryption)
- VPN(network traffic encryption)
- AES (symmetric encryption)
- End-to-End Encryption (E2EE)

Note:
TLS and VPN use **hybrid encryption** (both symmetric and asymmetric).  
AES alone is purely symmetric.

---

## 3.2 Prevent Modification (Integrity)

**Problem:** Attackers can alter data in transit.

### Hash Functions (SHA-256)
- Generate fixed-size digest
- If data changes → hash changes

### Message Authentication Code (MAC)
- Secret key + hash
- Ensures integrity and authenticity

### Digital Signatures
- Uses public/private key cryptography
- Ensures integrity + authentication + non-repudiation

---

## 3.3 Prevent Impersonation (Authentication)

**Problem:** Someone pretends to be another user or server.

### Common Solutions

- Passwords
- MFA
- Digital Certificates
- Public/Private key authentication

---

# 4. Real-World Example: HTTPS

When visiting a secure website:

1. Browser verifies server certificate (Authentication)
2. Asymmetric encryption exchanges session key
3. Symmetric encryption protects data
4. MAC/AEAD ensures integrity

Provides:
- Confidentiality
- Integrity
- Authentication

---

# 5. Symmetric Key Encryption

---

## 5.1 How It Works

Uses **one shared secret key (K)** for:

- Encryption
- Decryption

Ciphertext = Encrypt(Plaintext, K)  
Plaintext = Decrypt(Ciphertext, K)

---

## 5.2 Common Algorithms

- AES (128/192/256-bit)
- ChaCha20
- 3DES (legacy)
- DES (obsolete)

---

## 5.3 Advantages

- Very fast
- Efficient for large data
- Low computational overhead

---

# 6. Problems with Symmetric Encryption

---

## 6.1 Key Distribution Problem

How do two parties securely share the secret key?

If transmitted insecurely → attacker can intercept.

---

## 6.2 Scalability Problem

For n users:

n(n - 1) / 2 keys required

Example:
100 users → 4950 keys

Hard to manage at scale.

---

## 6.3 No Built-in Authentication

Knowing the key ≠ proving identity.

If key leaks → impersonation possible.

---

## 6.4 Key Storage Risk

If stored key is compromised:
- Past messages decrypted
- Future communication compromised

---

# 7. Solutions to Symmetric Encryption Problems

The primary solution to symmetric encryption weaknesses is:

# Asymmetric Cryptography

---

## 7.1 Solving Key Distribution Using Asymmetric Encryption

Instead of sending secret key directly:

1. Receiver generates Public/Private key pair.
2. Sender generates symmetric session key.
3. Sender encrypts session key using receiver’s Public Key.
4. Receiver decrypts using Private Key.

Now both share secret key securely.

This is called:

# Hybrid Encryption

---

## 7.2 Why Asymmetric Improves Scalability

Symmetric-only system:
n(n - 1) / 2 keys required

Asymmetric system:
Each user needs only:
- One private key
- One public key

For n users:
Only n key pairs required.

Much more scalable.

---

## 7.3 Key Exchange Protocols

Modern systems use:

- Diffie-Hellman (DH)
- Elliptic Curve Diffie-Hellman (ECDH)

These allow secure shared secret generation
without transmitting the secret itself.

---

## 7.4 Session Keys

- Temporary keys
- Used per session
- Destroyed after use

Provides:
- Limited damage if key leaks
- Forward secrecy

---

## 7.5 Authenticated Encryption (AEAD)

Modern modes:
- AES-GCM
- ChaCha20-Poly1305

Provide:
- Confidentiality
- Integrity
- Authentication

---

# 8. Asymmetric Encryption

Uses two keys:

- Public Key (shared)
- Private Key (secret)

Encrypt with Public Key  
Decrypt with Private Key

---

## 8.1 Problems

### Man-in-the-Middle (MITM)

Public key may be replaced by attacker.

Asymmetric encryption alone does NOT guarantee authenticity.

### Performance Overhead

Much slower than symmetric encryption.

### Private Key Compromise

If stolen:
- Messages decrypted
- Identity stolen
- Signatures forged

---

# 9. Solutions to Asymmetric Problems

---

## 9.1 Digital Certificates (PKI)

Bind identity to public key.

### How It Works

1. Server generates key pair.
2. Sends public key to Certificate Authority (CA).
3. CA verifies identity.
4. CA signs certificate.
5. Browser verifies CA signature.
6. If valid → trusts public key.

Prevents MITM.

---

## 9.2 Digital Signatures

Provide:
- Authentication
- Integrity
- Non-repudiation

### Working

1. Hash message.
2. Encrypt hash with Private Key.
3. Send message + signature.
4. Receiver:
   - Hashes message.
   - Decrypts signature using Public Key.
   - Compares hashes.

If equal → signature valid.

---

## 9.3 Non-Repudiation

Sender cannot deny sending message because:
Only private key owner could create signature.

---

# 10. Authorization

Authentication → Who you are  
Authorization → What you can access  

Models:
- RBAC
- ABAC
- ACL

---

# 11. Availability

Ensures systems remain accessible.

### Threats
- DDoS
- Hardware failure
- Power outage

### Solutions
- Load balancing
- Redundancy
- Failover systems
- Rate limiting

---

# 12. Replay Attacks

Attacker captures valid message and resends later.

### Solutions
- Nonces
- Timestamps
- Sequence numbers
- Challenge-response

---

# 13. Forward Secrecy

Even if long-term private key is compromised,
past sessions remain secure.

Achieved using:
- DHE
- ECDHE

Used in TLS 1.3.

---

# 14. Hash Function Security Properties

### Pre-image Resistance
Cannot derive original input from hash.

### Second Pre-image Resistance
Cannot find different input with same hash as given input.

### Collision Resistance
Cannot find any two different inputs with same hash.

---

# 15. Threat Models

## Passive Attacker
Can observe traffic only.

## Active Attacker
Can modify/inject/delete messages.

## Insider Attacker
Has legitimate access and abuses privileges.

---

# Final Concept Summary

Symmetric Encryption:
- Fast
- Efficient
- Has key distribution problem

Asymmetric Encryption:
- Solves key distribution
- Improves scalability
- Slower

Hybrid Encryption:
- Asymmetric → secure key exchange
- Symmetric → fast data encryption
- Used in TLS, HTTPS, VPN

Modern security systems rely on combining both approaches.
