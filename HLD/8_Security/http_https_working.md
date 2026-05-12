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