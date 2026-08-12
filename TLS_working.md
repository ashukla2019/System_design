How TLS 1.3 Works

TLS (Transport Layer Security) is the protocol that provides security for HTTPS connections.How TLS 1.3 Works

TLS (Transport Layer Security) is the protocol that provides security for HTTPS connections.

The main goals of TLS are:

Authentication — verify that you're talking to the real server.
Confidentiality — prevent others from reading your data.
Integrity — prevent others from modifying your data.
1. ClientHello

When you connect to a website:

https://example.com


your browser starts the TLS handshake by sending a ClientHello.

Conceptually:

Client
  |
  | ClientHello
  | - TLS versions supported
  | - Cryptographic algorithms supported
  | - Random value
  | - Diffie-Hellman public key share
  |
  +-----------------------------> Server


The browser is basically saying:

"Here are the TLS versions and cryptographic options I support. Here is some fresh random data and my public key share."

2. Random Value

The ClientHello contains a random value.

For example:

Connection 1 → random = A8F2...
Connection 2 → random = 91C7...
Connection 3 → random = 4D21...


The random value provides fresh, unpredictable data for each handshake.

It contributes to the TLS key schedule and helps ensure that different connections don't simply reuse the same cryptographic context.

The important point is:

Random value ≠ encryption key


It is one of the inputs used during the TLS handshake and key derivation.

3. Diffie-Hellman Key Share

The client also sends a Diffie-Hellman public key share.

For example:

Client:

private key = A
public key  = A_public


The server creates its own pair:

Server:

private key = B
public key  = B_public


They exchange only the public parts:

Client                         Server

A_public  -------------------->

          <-------------------- B_public


The client calculates:

Client private key + Server public key
              ↓
        shared secret


The server calculates:

Server private key + Client public key
              ↓
        shared secret


Both sides independently arrive at the same shared secret.

The secret itself is never sent over the network.

An attacker can see:

A_public
B_public


but cannot practically calculate the shared secret without the private keys.

4. ServerHello

The server responds with ServerHello.

Conceptually:

Client                         Server
  |                              |
  | -------- ClientHello ------> |
  |                              |
  | <-------- ServerHello -------|
  |          + key share         |


The server chooses the TLS version and cryptographic parameters that will be used.

The server also provides its own Diffie-Hellman public key share.

At this point, both sides can calculate the shared secret.

5. Server Authentication with a Certificate

Now the important question is:

How does the browser know that this server is actually example.com?

The server sends a certificate.

Conceptually:

Server
   |
   | Certificate
   | CertificateVerify
   |
   ↓
Browser


The certificate contains information about the server's identity and a public key.

The certificate is signed by a Certificate Authority (CA).

Your browser has a list of trusted CA certificates.

The browser checks the certificate chain:

example.com
     ↓
Server certificate
     ↓
Certificate Authority signature
     ↓
Trusted CA
     ↓
✓ Certificate trusted


The server also sends CertificateVerify.

The server uses its private key to create a digital signature over the handshake transcript.

The browser verifies that signature using the public key associated with the certificate.

This proves that the server actually possesses the private key corresponding to the certificate.

6. Deriving TLS Traffic Keys

At this point, both sides have shared secret material from Diffie-Hellman.

TLS 1.3 uses HKDF to derive the actual secrets and traffic keys.

Conceptually:

Diffie-Hellman shared secret
             +
      TLS handshake data
             +
        Other inputs
             |
             ↓
            HKDF
             |
       +-----+-----+
       |           |
       ↓           ↓
 Client keys    Server keys


The random values and handshake transcript also participate in the TLS key schedule.

There isn't just one single "TLS key."

TLS derives different secrets for different stages and directions of communication.

7. Finished Message

Both sides maintain a transcript of the handshake.

For example:

ClientHello
ServerHello
EncryptedExtensions
Certificate
CertificateVerify
...


TLS uses this transcript when generating the Finished authentication value.

The client and server verify the Finished messages.

This allows them to confirm that:

The handshake was not modified.
Both sides derived the expected secrets.
The other side possesses the required cryptographic material.

If verification fails, the connection is terminated.

8. Encrypted HTTPS Data

Once the handshake is complete, normal application data can flow.

For example, your browser might send:

GET /account HTTP/1.1
Host: example.com
Cookie: ...


TLS encrypts and authenticates this data before sending it over the network.

Conceptually:

Browser                         Server
   |                              |
   | ===== encrypted HTTP =====> |
   | <==== encrypted HTTP ====== |
   | ===== encrypted HTTP =====> |


An attacker watching the network sees encrypted TLS records rather than the HTTP contents.

9. What an Attacker Can See

Suppose:

Your computer -------- Internet -------- Server
                         ^
                         |
                      Attacker


The attacker may be able to observe things such as:

ClientHello
ServerHello
IP addresses
Packet sizes
Timing
Encrypted TLS records


But they should not be able to read or modify the protected application data.

TLS does not hide all metadata.

For example, network-level information such as IP addresses, packet timing, and traffic sizes can still be visible.

Putting Everything Together

The TLS 1.3 handshake can be visualized like this:

              TLS 1.3 HANDSHAKE

Browser                                      Server
   |                                            |
   | ClientHello                               |
   | - TLS versions                            |
   | - Cryptographic algorithms                |
   | - Random value                            |
   | - DH public key share                     |
   |------------------------------------------->|
   |                                            |
   |             ServerHello                   |
   |             - selected parameters         |
   |             - DH public key share         |
   |             Certificate                   |
   |             CertificateVerify             |
   |             Finished                      |
   |<-------------------------------------------|
   |                                            |
   | Finished                                  |
   |------------------------------------------->|
   |                                            |
   |       Both derive traffic keys            |
   |                                            |
   |=========== Encrypted HTTP ===============>|
   |<========== Encrypted HTTP ================|

The Most Important Concepts

The entire process can be remembered with this model:

Certificate
     ↓
Proves server identity

Diffie-Hellman
     ↓
Establishes shared secret

HKDF
     ↓
Derives TLS traffic keys

Finished
     ↓
Confirms handshake integrity

Symmetric encryption
     ↓
Protects actual HTTPS data

Why Does TLS Use Both Asymmetric and Symmetric Cryptography?
Asymmetric cryptography

Used primarily for:

Authentication
Digital signatures
Key exchange


Examples include:

ECDSA
EdDSA
Diffie-Hellman / ECDHE

Symmetric cryptography

Used for the actual application data:

HTTP requests
HTTP responses
JSON
Cookies
Images
API data


Symmetric encryption is much more efficient for large amounts of data.

Therefore, TLS essentially does:

       Asymmetric cryptography
                +
         Diffie-Hellman
                ↓
        Shared secret material
                ↓
              HKDF
                ↓
       Symmetric traffic keys
                ↓
      ========================
          HTTPS traffic
      ========================

One-Sentence Summary

TLS authenticates the server using certificates, establishes shared secret material using Diffie-Hellman, derives traffic keys using a key-derivation function, verifies the handshake, and then uses symmetric authenticated encryption to protect the actual HTTPS data.

The main goals of TLS are:

Authentication — verify that you're talking to the real server.
Confidentiality — prevent others from reading your data.
Integrity — prevent others from modifying your data.
1. ClientHello

When you connect to a website:

https://example.com


your browser starts the TLS handshake by sending a ClientHello.

Conceptually:

Client
  |
  | ClientHello
  | - TLS versions supported
  | - Cryptographic algorithms supported
  | - Random value
  | - Diffie-Hellman public key share
  |
  +-----------------------------> Server


The browser is basically saying:

"Here are the TLS versions and cryptographic options I support. Here is some fresh random data and my public key share."

2. Random Value

The ClientHello contains a random value.

For example:

Connection 1 → random = A8F2...
Connection 2 → random = 91C7...
Connection 3 → random = 4D21...


The random value provides fresh, unpredictable data for each handshake.

It contributes to the TLS key schedule and helps ensure that different connections don't simply reuse the same cryptographic context.

The important point is:

Random value ≠ encryption key


It is one of the inputs used during the TLS handshake and key derivation.

3. Diffie-Hellman Key Share

The client also sends a Diffie-Hellman public key share.

For example:

Client:

private key = A
public key  = A_public


The server creates its own pair:

Server:

private key = B
public key  = B_public


They exchange only the public parts:

Client                         Server

A_public  -------------------->

          <-------------------- B_public


The client calculates:

Client private key + Server public key
              ↓
        shared secret


The server calculates:

Server private key + Client public key
              ↓
        shared secret


Both sides independently arrive at the same shared secret.

The secret itself is never sent over the network.

An attacker can see:

A_public
B_public


but cannot practically calculate the shared secret without the private keys.

4. ServerHello

The server responds with ServerHello.

Conceptually:

Client                         Server
  |                              |
  | -------- ClientHello ------> |
  |                              |
  | <-------- ServerHello -------|
  |          + key share         |


The server chooses the TLS version and cryptographic parameters that will be used.

The server also provides its own Diffie-Hellman public key share.

At this point, both sides can calculate the shared secret.

5. Server Authentication with a Certificate

Now the important question is:

How does the browser know that this server is actually example.com?

The server sends a certificate.

Conceptually:

Server
   |
   | Certificate
   | CertificateVerify
   |
   ↓
Browser


The certificate contains information about the server's identity and a public key.

The certificate is signed by a Certificate Authority (CA).

Your browser has a list of trusted CA certificates.

The browser checks the certificate chain:

example.com
     ↓
Server certificate
     ↓
Certificate Authority signature
     ↓
Trusted CA
     ↓
✓ Certificate trusted


The server also sends CertificateVerify.

The server uses its private key to create a digital signature over the handshake transcript.

The browser verifies that signature using the public key associated with the certificate.

This proves that the server actually possesses the private key corresponding to the certificate.

6. Deriving TLS Traffic Keys

At this point, both sides have shared secret material from Diffie-Hellman.

TLS 1.3 uses HKDF to derive the actual secrets and traffic keys.

Conceptually:

Diffie-Hellman shared secret
             +
      TLS handshake data
             +
        Other inputs
             |
             ↓
            HKDF
             |
       +-----+-----+
       |           |
       ↓           ↓
 Client keys    Server keys


The random values and handshake transcript also participate in the TLS key schedule.

There isn't just one single "TLS key."

TLS derives different secrets for different stages and directions of communication.

7. Finished Message

Both sides maintain a transcript of the handshake.

For example:

ClientHello
ServerHello
EncryptedExtensions
Certificate
CertificateVerify
...


TLS uses this transcript when generating the Finished authentication value.

The client and server verify the Finished messages.

This allows them to confirm that:

The handshake was not modified.
Both sides derived the expected secrets.
The other side possesses the required cryptographic material.

If verification fails, the connection is terminated.

8. Encrypted HTTPS Data

Once the handshake is complete, normal application data can flow.

For example, your browser might send:

GET /account HTTP/1.1
Host: example.com
Cookie: ...


TLS encrypts and authenticates this data before sending it over the network.

Conceptually:

Browser                         Server
   |                              |
   | ===== encrypted HTTP =====> |
   | <==== encrypted HTTP ====== |
   | ===== encrypted HTTP =====> |


An attacker watching the network sees encrypted TLS records rather than the HTTP contents.

9. What an Attacker Can See

Suppose:

Your computer -------- Internet -------- Server
                         ^
                         |
                      Attacker


The attacker may be able to observe things such as:

ClientHello
ServerHello
IP addresses
Packet sizes
Timing
Encrypted TLS records


But they should not be able to read or modify the protected application data.

TLS does not hide all metadata.

For example, network-level information such as IP addresses, packet timing, and traffic sizes can still be visible.

Putting Everything Together

The TLS 1.3 handshake can be visualized like this:

              TLS 1.3 HANDSHAKE

Browser                                      Server
   |                                            |
   | ClientHello                               |
   | - TLS versions                            |
   | - Cryptographic algorithms                |
   | - Random value                            |
   | - DH public key share                     |
   |------------------------------------------->|
   |                                            |
   |             ServerHello                   |
   |             - selected parameters         |
   |             - DH public key share         |
   |             Certificate                   |
   |             CertificateVerify             |
   |             Finished                      |
   |<-------------------------------------------|
   |                                            |
   | Finished                                  |
   |------------------------------------------->|
   |                                            |
   |       Both derive traffic keys            |
   |                                            |
   |=========== Encrypted HTTP ===============>|
   |<========== Encrypted HTTP ================|

The Most Important Concepts

The entire process can be remembered with this model:

Certificate
     ↓
Proves server identity

Diffie-Hellman
     ↓
Establishes shared secret

HKDF
     ↓
Derives TLS traffic keys

Finished
     ↓
Confirms handshake integrity

Symmetric encryption
     ↓
Protects actual HTTPS data

Why Does TLS Use Both Asymmetric and Symmetric Cryptography?
Asymmetric cryptography

Used primarily for:

Authentication
Digital signatures
Key exchange


Examples include:

ECDSA
EdDSA
Diffie-Hellman / ECDHE

Symmetric cryptography

Used for the actual application data:

HTTP requests
HTTP responses
JSON
Cookies
Images
API data


Symmetric encryption is much more efficient for large amounts of data.

Therefore, TLS essentially does:

       Asymmetric cryptography
                +
         Diffie-Hellman
                ↓
        Shared secret material
                ↓
              HKDF
                ↓
       Symmetric traffic keys
                ↓
      ========================
          HTTPS traffic
      ========================

One-Sentence Summary

TLS authenticates the server using certificates, establishes shared secret material using Diffie-Hellman, derives traffic keys using a key-derivation function, verifies the handshake, and then uses symmetric authenticated encryption to protect the actual HTTPS data.
