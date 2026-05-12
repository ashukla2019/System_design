# SSH Login to VM — Complete Sequence Flow

Example command:

```bash
ssh ubuntu@10.0.0.5
```

Where:
- Your Laptop = SSH Client
- VM = SSH Server (`sshd`)

---

# Complete SSH Login Sequence

```text
+----------------------+                     +----------------------+
| Your Laptop          |                     | VM                   |
| SSH Client           |                     | SSH Server (sshd)    |
+----------------------+                     +----------------------+

1. User runs:
   ssh ubuntu@10.0.0.5

        |---------------------------------------------------->|
        |                                                     |
        | 2. TCP SYN                                          |
        |---------------------------------------------------->|
        |                                                     |
        |<----------------------------------------------------|
        | 3. TCP SYN-ACK                                      |
        |                                                     |
        |---------------------------------------------------->|
        | 4. TCP ACK                                          |
        |                                                     |
        |        TCP Connection Established                   |
        |=====================================================|
        |                                                     |
        | 5. SSH Version Exchange                             |
        |<--------------------------------------------------->|
        |                                                     |
        | 6. Algorithm Negotiation                            |
        |<--------------------------------------------------->|
        |                                                     |
        |   Select:                                           |
        |   - AES256                                          |
        |   - ECDH                                            |
        |   - HMAC-SHA256                                     |
        |                                                     |
        |<----------------------------------------------------|
        | 7. Server sends Host Public Key                     |
        |                                                     |
        | 8. Client checks ~/.ssh/known_hosts                 |
        |                                                     |
        | 9. Host verification successful                     |
        |                                                     |
        |<--------------------------------------------------->|
        | 10. Diffie-Hellman / ECDH Exchange                  |
        |                                                     |
        |    Both generate SAME shared secret                 |
        |                                                     |
        |=====================================================|
        | 11. Encrypted Tunnel Created                        |
        |=====================================================|
        |                                                     |
        |---------------------------------------------------->|
        | 12. User Authentication Request                     |
        |                                                     |
        |   Password OR SSH Key Authentication                |
        |                                                     |
        |<----------------------------------------------------|
        | 13. Authentication Success                          |
        |                                                     |
        | 14. sshd creates PTY (/dev/pts/X)                   |
        |                                                     |
        | 15. sshd launches shell (/bin/bash)                 |
        |                                                     |
        |=====================================================|
        | 16. Secure Interactive SSH Session                  |
        |=====================================================|
        |                                                     |
        | User types commands                                 |
        |---------------------------------------------------->|
        |                                                     |
        | VM executes commands                                |
        |<----------------------------------------------------|
        |                                                     |
        | Output displayed on laptop terminal                 |
        |                                                     |
+----------------------+                     +----------------------+
```

---

# Internal Linux Flow

```text
Your Keyboard
      ↓
ssh client process
      ↓
TCP socket
      ↓
Linux TCP/IP stack
      ↓
NIC (network card)
      ↓
Network / Internet
      ↓
VM NIC
      ↓
VM Linux TCP/IP stack
      ↓
sshd process
      ↓
PTY (/dev/pts/X)
      ↓
bash shell
      ↓
Filesystem / Kernel
```

---

# Important Files Used

## On Client (Laptop)

### Known Hosts
```text
~/.ssh/known_hosts
```

Stores trusted server fingerprints.

---

### Private Key
```text
~/.ssh/id_ed25519
```

Used for SSH key authentication.

---

# On VM (Server)

### Authorized Keys
```text
~/.ssh/authorized_keys
```

Stores allowed public keys.

---

### SSH Server Config
```text
/etc/ssh/sshd_config
```

SSH daemon configuration.

---

# Authentication Flow (SSH Key Example)

```text
Client                         Server
------                         ------

Private Key
Public Key already stored

          ---- login request ---->

          <--- random challenge ---

Sign challenge using private key

          ---- signature --------->

          <--- verification success
```

Private key NEVER leaves laptop.

---

# Final Summary

```text
1. TCP connection established
2. SSH algorithms negotiated
3. Server identity verified
4. Shared secret generated
5. Encrypted tunnel created
6. User authenticated
7. PTY + shell created on VM
8. Secure remote shell session starts
```