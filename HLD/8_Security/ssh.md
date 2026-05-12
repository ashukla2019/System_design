# SSH (Secure Shell) — Complete Working Explained

## 1. What is SSH?

SSH (Secure Shell) is a secure network protocol used to:

- Login to remote machines
- Execute commands remotely
- Transfer files securely
- Manage servers/devices securely

Default SSH port:
```text
TCP 22
```

Common command:
```bash
ssh user@server-ip
```

Example:
```bash
ssh ubuntu@192.168.1.10
```

---

# 2. Why SSH Exists

Before SSH, people used:

- Telnet
- rlogin
- FTP

Problem:
- Passwords and data traveled in plain text
- Attackers could sniff network traffic

SSH solves this using:
- Encryption
- Authentication
- Integrity checks

---

# 3. High Level SSH Flow

```text
Client                          Server
------                          ------
SSH Request  ----------------->

           <------------------  Server Identity

Key Exchange ----------------->

Encrypted Tunnel Established

Username/Password OR SSH Key -->

           <------------------  Authentication Success

Secure Shell Session Starts
```

---

# 4. Main Components of SSH

| Component | Purpose |
|---|---|
| Encryption | Protects data confidentiality |
| Authentication | Verifies identity |
| Integrity | Prevents tampering |
| Key Exchange | Securely creates session keys |

---

# 5. What Happens When You Run SSH

Example:
```bash
ssh ubuntu@10.0.0.5
```

---

# STEP 1 — TCP Connection

SSH first creates TCP connection.

```text
Client → Server: TCP SYN
Server → Client: SYN-ACK
Client → Server: ACK
```

TCP connection established on port 22.

---

# STEP 2 — Protocol Negotiation

Both sides exchange supported algorithms.

Example:
```text
Encryption:
- AES256
- ChaCha20

Key Exchange:
- Diffie-Hellman
- ECDH

MAC:
- HMAC-SHA256

Compression:
- zlib
```

They select common supported algorithms.

---

# STEP 3 — Server Authentication

Server sends its public host key.

Example:
```text
Server Host Public Key
```

Client checks:
```text
~/.ssh/known_hosts
```

If first time:
```text
The authenticity of host can't be established.
Are you sure you want to continue?
```

After acceptance:
- Server fingerprint stored
- Prevents MITM attacks later

---

# STEP 4 — Key Exchange

SSH now securely creates session keys.

Usually uses:
- Diffie-Hellman
- ECDH

Goal:
```text
Create shared secret key
WITHOUT sending it directly over network
```

---

## Diffie-Hellman Simplified

Client and server independently compute same secret.

```text
Client Secret + Math
Server Secret + Math

→ Both derive SAME shared key
```

Attacker sees exchanged values but cannot derive final secret.

---

# STEP 5 — Session Encryption Starts

Using shared secret:

SSH creates:
- Encryption keys
- MAC keys
- IVs

Now all traffic becomes encrypted.

---

# 6. SSH Encryption

SSH uses symmetric encryption after key exchange.

Why symmetric?
- Much faster

Common algorithms:
- AES
- ChaCha20

Example:
```text
Plaintext:
ls -la

Encrypted:
a8f91ab2387f...
```

---

# 7. Integrity Protection

SSH ensures packets are not modified.

Uses:
```text
HMAC
```

Example:
```text
HMAC-SHA256
```

If packet altered:
- MAC validation fails
- Packet rejected

---

# 8. User Authentication

After encrypted tunnel established:

User authenticates.

Methods:
- Password authentication
- Public key authentication

---

# 9. Password Authentication

```text
Client → encrypted password
Server → verifies password
```

Password itself travels encrypted inside SSH tunnel.

---

# 10. SSH Key Authentication (Most Important)

Most secure/common method.

Uses:
- Private key
- Public key

---

## Key Generation

Command:
```bash
ssh-keygen
```

Creates:
```text
~/.ssh/id_rsa        → Private Key
~/.ssh/id_rsa.pub    → Public Key
```

---

## Public Key Setup

Public key copied to server:
```text
~/.ssh/authorized_keys
```

Server stores:
```text
Client Public Key
```

---

# 11. SSH Key Authentication Flow

## Step 1

Client says:
```text
I want to login as ubuntu
```

---

## Step 2

Server checks:
```text
authorized_keys
```

Finds matching public key.

---

## Step 3

Server sends random challenge.

---

## Step 4

Client signs challenge using PRIVATE KEY.

```text
Signature = Encrypt(challenge_hash, private_key)
```

---

## Step 5

Server verifies signature using PUBLIC KEY.

If valid:
```text
Authenticated
```

---

# IMPORTANT

Private key NEVER leaves client machine.

Only:
- Signature sent
- Public key already on server

This is why SSH keys are secure.

---

# 12. SSH Architecture

```text
+----------------------+
| SSH Client           |
| ssh command          |
+----------+-----------+
           |
           | Encrypted TCP
           |
+----------v-----------+
| SSH Server (sshd)    |
| Port 22              |
+----------------------+
```

---

# 13. SSH Daemon (sshd)

Server side process:
```text
sshd
```

Responsibilities:
- Listen on port 22
- Handle authentication
- Create sessions
- Execute commands

Check:
```bash
systemctl status sshd
```

---

# 14. SSH Channels

Single SSH connection can carry multiple channels.

Examples:
- Shell session
- File transfer
- Port forwarding

---

# 15. SSH File Transfer

Protocols over SSH:
- SCP
- SFTP

Example:
```bash
scp file.txt user@server:/tmp
```

Secure because SSH tunnel encrypts traffic.

---

# 16. SSH Port Forwarding (Tunneling)

SSH can tunnel traffic securely.

---

## Local Port Forwarding

```bash
ssh -L 8080:internal-db:3306 user@server
```

Meaning:
```text
localhost:8080
    →
SSH Tunnel
    →
internal-db:3306
```

Used for:
- Accessing private databases
- Secure internal services

---

## Remote Port Forwarding

```bash
ssh -R
```

Allows remote systems to access local machine.

---

# 17. SSH Packet Structure

Simplified:

```text
+----------------+
| Packet Length  |
+----------------+
| Padding Length |
+----------------+
| Payload        |
+----------------+
| Random Padding |
+----------------+
| MAC            |
+----------------+
```

Payload encrypted.

---

# 18. Known Hosts

File:
```text
~/.ssh/known_hosts
```

Stores:
```text
Server fingerprints
```

Purpose:
- Detect fake servers
- Prevent MITM attacks

---

# 19. Authorized Keys

File:
```text
~/.ssh/authorized_keys
```

Stores:
```text
Allowed public keys
```

---

# 20. SSH Config File

Client config:
```text
~/.ssh/config
```

Example:
```text
Host prod
    HostName 10.0.0.5
    User ubuntu
    IdentityFile ~/.ssh/prod.pem
```

Now:
```bash
ssh prod
```

---

# 21. SSH Security Features

| Feature | Purpose |
|---|---|
| Encryption | Privacy |
| MAC | Integrity |
| Host Verification | Prevent MITM |
| Public Key Auth | Strong authentication |
| Rekeying | Long session protection |

---

# 22. Common SSH Algorithms

| Purpose | Algorithms |
|---|---|
| Encryption | AES, ChaCha20 |
| Key Exchange | DH, ECDH |
| Integrity | HMAC-SHA256 |
| Host Key | RSA, ED25519 |

---

# 23. SSH vs HTTPS

| Feature | SSH | HTTPS |
|---|---|---|
| Purpose | Remote shell | Web security |
| Transport | TCP | TCP |
| Default Port | 22 | 443 |
| Authentication | Keys/password | Certificates |
| Interactive Shell | Yes | No |

---

# 24. Example Complete SSH Flow

```text
1. TCP connection established
2. Algorithms negotiated
3. Server identity verified
4. Diffie-Hellman key exchange
5. Shared secret generated
6. Encrypted tunnel created
7. User authenticated
8. Secure shell session starts
```

---

# 25. Real Linux Example

Generate keys:
```bash
ssh-keygen -t ed25519
```

Copy public key:
```bash
ssh-copy-id ubuntu@10.0.0.5
```

Connect:
```bash
ssh ubuntu@10.0.0.5
```

---

# 26. SSH Internals in Linux

When session starts:

```text
ssh client process
    ↓
TCP socket
    ↓
Kernel network stack
    ↓
NIC
    ↓
Network
    ↓
Remote NIC
    ↓
Kernel TCP/IP stack
    ↓
sshd process
    ↓
PTY (pseudo terminal)
    ↓
bash shell
```

---

# 27. PTY (Pseudo Terminal)

SSH creates virtual terminal:

```text
/dev/pts/*
```

This behaves like physical terminal.

Enables:
- Interactive shell
- Command execution
- stdin/stdout handling

---

# 28. SSH Agent

Tool:
```bash
ssh-agent
```

Stores decrypted private keys in memory.

Benefits:
- Avoid entering passphrase repeatedly

Add key:
```bash
ssh-add ~/.ssh/id_ed25519
```

---

# 29. Why SSH is Secure

Because:
- Passwords encrypted
- Strong cryptography
- Server identity validation
- Private keys never shared
- Integrity checks
- Replay protection

---

# 30. Simplified End-to-End Diagram

```text
+-----------+                     +-----------+
| SSH Client|                     | SSH Server|
+-----------+                     +-----------+
      |                                   |
      | TCP Handshake                     |
      |---------------------------------->|
      |                                   |
      | Algorithm Negotiation             |
      |<--------------------------------->|
      |                                   |
      | Host Key Verification             |
      |<--------------------------------->|
      |                                   |
      | Diffie-Hellman Exchange           |
      |<--------------------------------->|
      |                                   |
      | Encrypted Tunnel Created          |
      |===================================|
      |                                   |
      | User Authentication               |
      |---------------------------------->|
      |                                   |
      | Secure Shell Session              |
      |<=================================>|
```