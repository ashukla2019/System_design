User types:
http://example.com
        ↓
DNS lookup
example.com → IP
        ↓
TCP Handshake
SYN → SYN-ACK → ACK
        ↓
Browser sends HTTP request
(GET / POST etc.)
        ↓
HTTP data encapsulated
HTTP → TCP → IP → Ethernet
        ↓
Packets travel through routers
        ↓
Server receives packets
        ↓
Decapsulation
Ethernet → IP → TCP → HTTP
        ↓
Web server processes request
        ↓
HTTP response generated
(200 OK, HTML, JSON etc.)
        ↓
Response sent back
        ↓
Browser renders webpage


------------------

User types:
https://google.com
        ↓
DNS lookup
        ↓
TCP Handshake
SYN → SYN-ACK → ACK
        ↓
TLS Handshake starts
        ↓
Client Hello
(supported TLS/ciphers)
        ↓
Server Hello
(selected cipher)
        ↓
Server sends Certificate
(public key + CA signature)
        ↓
Browser verifies certificate
        ↓
Key Exchange
(shared secret created)
        ↓
Session Key generated
        ↓
Secure encrypted tunnel established
        ↓
Encrypted HTTP communication
HTTP → TLS Encrypt → TCP → IP
        ↓
Server decrypts request
        ↓
Processes request
        ↓
Encrypted response sent
        ↓
Browser decrypts response
        ↓
Webpage rendered