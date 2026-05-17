# Network Security & Cryptography — Problem → Solution → Next Problem Flow

This approach makes it easier to learn because each technology exists to solve a weakness of the previous one.

---

# 1. Communication Over Network Starts

Alice wants to send data to Bob.

```text
Alice  ----------------->  Bob
        Network/Internet
```

But the internet is untrusted.

Three major problems appear immediately.

---

# 2. Problem #1 — Anyone Can READ the Data

```text
Alice ---- Password ----> Bob
              ^
              |
          Attacker reads it
```

This breaks:

# Confidentiality

Sensitive data becomes visible:
- passwords
- bank data
- personal messages

---

# 3. Solution #1 — Encryption

Encrypt plaintext into ciphertext.

```text
Plaintext ---> Encryption ---> Ciphertext
```

Now attacker sees:

```text
x83@!as9#K
```

instead of actual message.

---

# 4. First Encryption Method — Symmetric Encryption

Uses ONE shared secret key.

```text
Alice <---- Shared Key K ----> Bob
```

Encryption:

```text
Ciphertext = Encrypt(Data, K)
```

Decryption:

```text
Plaintext = Decrypt(Ciphertext, K)
```

---

# 5. Why Symmetric Encryption Became Popular

It is:
- Fast
- Efficient
- Good for large data

Used in:
- AES
- ChaCha20

---

# 6. New Problem Created by Symmetric Encryption

To use encryption:

# Both sides need same secret key

But:

```text
How do Alice and Bob securely share key K?
```

If key is sent normally:

```text
Alice ---- Key K ----> Bob
             ^
             |
        Attacker steals key
```

Now attacker can decrypt everything.

This is:

# Key Distribution Problem

---

# 7. Solution #2 — Asymmetric Cryptography

Instead of one key:

Use TWO keys.

```text
Public Key  -> Shared openly
Private Key -> Kept secret
```

---

# 8. How Asymmetric Encryption Solves Key Sharing

Bob creates:

```text
Public Key
Private Key
```

Bob shares ONLY public key.

```text
Alice ---- encrypts using Public Key ----> Bob
Bob ---- decrypts using Private Key ----> Data
```

Now secret key is never transmitted openly.

Problem solved.

---

# 9. New Problem with Asymmetric Encryption

Asymmetric encryption is:

- Slow
- Computationally expensive

Bad for:
- large files
- videos
- continuous traffic

So we cannot encrypt entire internet traffic this way.

---

# 10. Solution #3 — Hybrid Encryption

Combine BOTH systems.

---

## Step 1 — Use Asymmetric Encryption Once

Used only to securely exchange a symmetric session key.

```text
Alice ---> Encrypt(Session Key using Public Key)
```

---

## Step 2 — Use Symmetric Encryption for Actual Data

Now both sides share session key.

Use fast AES encryption for communication.

```text
AES(Session Key)
```

This gives:
- Security
- Speed

---

# 11. This Is What HTTPS/TLS Uses

HTTPS works like this:

```text
Asymmetric Crypto
        ↓
Secure Session Key Exchange
        ↓
Symmetric Encryption (AES/ChaCha20)
        ↓
Fast Secure Communication
```

Provides:
- Confidentiality

---

# 12. New Problem — What If Data Is MODIFIED?

Even if encrypted:

Attacker may alter packets.

Example:

```text
Transfer ₹1000
```

changed to:

```text
Transfer ₹9000
```

This breaks:

# Integrity

---

# 13. Solution #4 — Hash Functions

Hash converts data into fixed fingerprint.

Example:

```text
SHA256("hello")
= A1B2C3...
```

If even one bit changes:

```text
SHA256("Hello")
= Z9X8Y7...
```

Completely different hash.

---

# 14. New Problem with Hashes

Attacker can modify BOTH:
- message
- hash

```text
Modified Data + New Hash
```

Receiver cannot detect attacker.

---

# 15. Solution #5 — MAC (Message Authentication Code)

MAC uses:

```text
Hash + Secret Key
```

```text
MAC = Hash(Data + SecretKey)
```

Now attacker cannot generate correct MAC
without knowing secret key.

Provides:
- Integrity
- Authentication

---

# 16. New Problem — How Do We Know WHO Sent It?

Even with encryption:

Anyone knowing key could send data.

Need identity verification.

This is:

# Authentication Problem

---

# 17. Solution #6 — Authentication Methods

Examples:
- Passwords
- MFA
- SSH Keys
- Certificates

---

# 18. New Problem — Fake Public Keys (MITM Attack)

Suppose attacker intercepts communication.

```text
Alice wants Bob's Public Key
```

Attacker sends HIS key instead.

```text
Alice ---> Encrypts using Attacker Key
```

Attacker now decrypts everything.

This is:

# Man-in-the-Middle Attack

---

# 19. Solution #7 — Digital Certificates (PKI)

Need trusted authority.

Enter:

# Certificate Authority (CA)

---

# 20. How PKI Solves MITM

Process:

```text
1. Bob creates Public/Private key pair
2. Bob sends Public Key to CA
3. CA verifies Bob identity
4. CA signs certificate
5. Browser trusts CA
6. Browser trusts Bob Public Key
```

Now attacker cannot easily replace key.

---

# 21. New Problem — What If Sender DENIES Sending Message?

Example:

```text
"I never approved that transaction."
```

Need proof of sender.

---

# 22. Solution #8 — Digital Signatures

# Digital Signature — Complete Simple Flow

---

# Goal of Digital Signature

Digital signatures solve:

```text
1. Was message modified?
2. Did message really come from sender?
3. Can sender deny sending it later?
```

Provides:
- Integrity
- Authentication
- Non-Repudiation

---

# Example Scenario

Alice wants to send:

```text
Transfer ₹5000
```

to Bob.

---

# Sender Side (Alice)

---

## Step 1 — Create Hash of Message

Alice computes hash:

```text
Hash("Transfer ₹5000")
= H123
```

Hash acts like:
- fingerprint of message

Even tiny message change creates different hash.

---

## Step 2 — Sign Hash Using Alice Private Key

Alice uses her private key:

```text
Signature = Encrypt(H123, Alice_Private_Key)
```

This encrypted hash becomes:

# Digital Signature

Only Alice private key can create this signature.

---

## Step 3 — Send Message + Signature

Alice sends:

```text
Message:
Transfer ₹5000

Signature:
XYZ789
```

---

# Receiver Side (Bob)

Bob receives:
- message
- signature

Now verification begins.

---

## Step 4 — Bob Hashes Received Message Again

Bob computes hash:

```text
Hash("Transfer ₹5000")
= H123
```

This is:
- newly calculated hash

---

## Step 5 — Bob Verifies Signature Using Alice Public Key

Bob uses Alice public key:

```text
Decrypt(Signature, Alice_Public_Key)
= H123
```

This gives:
- original signed hash

---

## Step 6 — Compare Both Hashes

Bob compares:

```text
Calculated Hash = H123
Signed Hash = H123
```

If equal:

```text
✓ Message unchanged
✓ Message came from Alice
✓ Signature is valid
```

---

# If Attacker Modifies Message

Suppose attacker changes:

```text
Transfer ₹5000
```

to:

```text
Transfer ₹9000
```

---

## Bob Recalculates Hash

Bob computes:

```text
Hash("Transfer ₹9000")
= H999
```

But signature still contains:

```text
H123
```

Comparison:

```text
H999 != H123
```

Verification fails.

Bob immediately knows:

```text
Message was modified
OR
signature is fake
```

---

# Important Concept

Digital signature is tied to:

```text
1. Exact message content
2. Sender private key
```

So:
- changing message invalidates signature
- attacker cannot generate new valid signature
without sender private key

---

# What Digital Signature Provides

| Feature | Provided? |
|---|---|
| Confidentiality | No |
| Integrity | Yes |
| Authentication | Yes |
| Non-Repudiation | Yes |

---

# Encryption vs Digital Signature

| Encryption | Digital Signature |
|---|---|
| Hides message | Proves sender |
| Uses receiver public key | Uses sender private key |
| Provides confidentiality | Provides integrity/authentication |

---

# Complete Flow Diagram

```text
Sender Side
-----------

Message
   ↓
Hash Function
   ↓
Message Hash
   ↓
Encrypt Hash Using Sender Private Key
   ↓
Digital Signature
   ↓
Send:
- Message
- Signature


Receiver Side
-------------

Receive:
- Message
- Signature
   ↓
Hash Message Again
   ↓
Decrypt Signature Using Sender Public Key
   ↓
Compare Hashes
   ↓
If Equal:
✓ Message unchanged
✓ Sender verified
```

---

# Final One-Line Summary

```text
Digital signature works by signing the message hash using sender private key, and receiver verifies it using sender public key to ensure message integrity and sender authenticity.
```

---

# 23. New Problem — Replay Attacks

Attacker records valid request:

```text
Transfer ₹5000
```

and resends later.

Even though message is valid.

---

# 24. Solution #9 — Nonces & Timestamps

Add:
- random nonce
- timestamp
- sequence number

Old message becomes invalid.

---

# 25. New Problem — Long-Term Key Compromise

Suppose server private key leaks tomorrow.

Can attacker decrypt old captured traffic?

Earlier:
- YES

Very dangerous.

---

# 26. Solution #10 — Forward Secrecy

Use temporary session keys.

Protocols:
- DHE
- ECDHE

Each session uses new ephemeral keys.

So:
- old traffic remains secure
- even if long-term key leaks later

Used in:
- TLS 1.3

---

# 27. Modern Secure Communication Stack

Modern systems combine everything:

```text
Authentication
    ↓
Certificates (PKI)
    ↓
Asymmetric Crypto
    ↓
Secure Session Key Exchange
    ↓
Symmetric Encryption
    ↓
MAC / AEAD Integrity Protection
    ↓
Forward Secrecy
```

---

# 28. AEAD — Modern Combined Security

Modern encryption modes combine:
- Confidentiality
- Integrity
- Authentication

Examples:
- AES-GCM
- ChaCha20-Poly1305

This avoids separate MAC handling.

---

# 29. Availability (CIA Triad Final Part)

Even secure systems are useless if unavailable.

Threats:
- DDoS
- Hardware failure
- Power outage

Solutions:
- Load balancing
- Redundancy
- Failover
- Rate limiting

Provides:
- Availability

---

# 30. Authorization

Authentication:
```text
Who are you?
```

Authorization:
```text
What are you allowed to access?
```

Models:
- RBAC
- ABAC
- ACL

---

# 31. Threat Models

## Passive Attacker

Can:
- Observe traffic

Cannot:
- Modify traffic

---

## Active Attacker

Can:
- Read
- Modify
- Inject
- Delete packets

---

## Insider Attacker

Legitimate user abusing access.

---

# 32. Hash Security Properties

## Pre-image Resistance

Cannot reverse hash to original input.

---

## Second Pre-image Resistance

Cannot find another input with same hash as target input.

---

## Collision Resistance

Cannot find two different inputs producing same hash.

---

# 33. Final Big Picture

---

## Symmetric Encryption

Solved:
- Fast secure encryption

Problem:
- Key sharing

---

## Asymmetric Encryption

Solved:
- Secure key exchange
- Scalability

Problem:
- Slow
- MITM risk

---

## Certificates (PKI)

Solved:
- Public key authenticity

Problem:
- Still need fast encryption

---

## Hybrid Encryption

Solved:
- Secure + fast communication

Used in:
- HTTPS
- TLS
- VPN
- SSH

---

# 34. Entire Story in One Flow

```text
Need secure communication
        ↓
Problem: Anyone can READ data
        ↓
Solution: Encryption
        ↓
Problem: How to share secret key?
        ↓
Solution: Asymmetric cryptography
        ↓
Problem: Asymmetric is slow
        ↓
Solution: Hybrid encryption
        ↓
Problem: Data can be modified
        ↓
Solution: Hash/MAC/AEAD
        ↓
Problem: Fake identities / MITM
        ↓
Solution: Certificates (PKI)
        ↓
Problem: Sender denial
        ↓
Solution: Digital signatures
        ↓
Problem: Replay attacks
        ↓
Solution: Nonces/Timestamps
        ↓
Problem: Future private key leak
        ↓
Solution: Forward secrecy
```

---

# 35. Real-World Mapping

| Technology | What It Solves |
|---|---|
| AES | Fast encryption |
| RSA/ECC | Secure key exchange |
| TLS/HTTPS | Secure web communication |
| VPN | Secure network tunnel |
| SHA-256 | Integrity verification |
| MAC | Integrity + authentication |
| Digital Signature | Integrity + identity proof |
| PKI/Certificates | Prevent fake public keys |
| DHE/ECDHE | Forward secrecy |
| MFA | Strong authentication |

---

# 36. Final One-Line Summary

```text
Modern security works by combining:
Asymmetric cryptography for trust and key exchange,
Symmetric cryptography for speed,
Hashes/MACs for integrity,
Certificates for authentication,
and Forward Secrecy for long-term protection.
```