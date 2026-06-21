# TLS Handshake

One of the most important interview topics.

Question:

How do browser and server securely exchange keys?

Answer:

TLS Handshake

---

# SSL vs TLS

SSL

Old

Deprecated

---

TLS

Modern

Secure

Used today

---

# Goal

Create shared secret key.

After that:

Use fast symmetric encryption.

---

# Step 1

Client Hello

Browser sends:

Supported TLS Versions

Supported Cipher Suites

Random Number

---

Example

Client Hello

TLS 1.3

AES256

Random_A

---

# Step 2

Server Hello

Server replies:

Chosen Cipher

Certificate

Random Number

---

Example

Server Hello

AES256

Certificate

Random_B

---

# Step 3

Certificate Validation

Browser verifies:

- Trusted CA
- Valid Signature
- Domain Match
- Expiration Date

If invalid:

Security warning.

---

# Step 4

Key Exchange

Browser obtains:

Server Public Key

Creates secret.

Encrypts secret using public key.

Sends to server.

---

# Step 5

Server Decrypts

Uses:

Private Key

Obtains secret.

Now:

Both sides know secret.

---

# Step 6

Session Key Generated

Using:

Random_A

Random_B

Shared Secret

Both compute:

Same session key.

---

# Step 7

Secure Communication

All future traffic:

Encrypted with AES

Fast.

---

# Why TLS Uses Hybrid Encryption

Asymmetric:

Secure key exchange

Symmetric:

Fast encryption

Best of both worlds.

---

# Perfect Forward Secrecy

Modern TLS generates temporary keys.

Even if private key leaks later:

Old sessions remain safe.

---

# TLS 1.3 Improvements

Faster handshake

Better security

Fewer round trips

Most modern websites use TLS 1.3

---

# Interview Questions

Q1. Why TLS handshake needed?

Securely exchange session key.

---

Q2. What is exchanged in certificate?

Public key.

---

Q3. Who has private key?

Server only.

---

Q4. Why AES after handshake?

Much faster than RSA.

---

Q5. What is Perfect Forward Secrecy?

Past sessions remain secure.