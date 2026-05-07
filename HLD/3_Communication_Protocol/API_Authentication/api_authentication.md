# API Authentication Methods — Complete Notes with Communication Diagrams

---

# 1. What is API Authentication?

API authentication is the process of verifying:

- Who is making the request
- Whether they are allowed to access the API

Authentication ensures:
- Security
- Access control
- Identity verification
- Protected communication

---

# 2. API Key Authentication

## Overview

A simple unique key is sent with every request.

Server validates the key before allowing access.

---

## Communication Flow

```text
+--------+                    +-------------+
| Client | ---- API Key ----> | API Server |
+--------+                    +-------------+
                                   |
                                   | Validate Key
                                   v
                            +--------------+
                            | Key Database |
                            +--------------+
```

---

## Request Example

```http
GET /products
x-api-key: abc123
```

---

## Internal Processing

```text
1. Client sends API key
2. Server checks stored keys
3. If valid → allow request
4. Else → reject request
```

---

## Advantages

- Simple
- Fast
- Easy implementation

---

## Disadvantages

- Weak security
- No user identity
- Easy to leak

---

## Best Use Cases

- Public APIs
- Internal tools
- Low-security systems

---

# 3. Basic Authentication

## Overview

Client sends:

```text
username:password
```

encoded in Base64.

---

## Communication Flow

```text
+--------+                                 +-------------+
| Client | -- username:password(Base64) -->| API Server |
+--------+                                 +-------------+
                                                  |
                                                  | Verify Credentials
                                                  v
                                           +-------------+
                                           | User DB     |
                                           +-------------+
```

---

## Request Example

```http
Authorization: Basic dXNlcjpwYXNz
```

---

## Internal Flow

```text
1. Client sends username/password
2. Server decodes Base64
3. Server validates credentials
4. Access granted/rejected
```

---

## Advantages

- Very easy
- Built into HTTP

---

## Disadvantages

- Password sent every request
- Must use HTTPS
- Poor scalability

---

## Best Use Cases

- Legacy systems
- Testing environments

---

# 4. Session-Based Authentication

## Overview

Server creates and stores a session after login.

Client stores only session ID.

---

# Login Flow

```text
                LOGIN
+--------+ -----------------> +-------------+
| Client | username/password  | API Server |
+--------+                    +-------------+
                                     |
                                     | Create Session
                                     v
                              +---------------+
                              | Session Store |
                              +---------------+
                                     |
                                     | session_id
                                     v
+--------+ <----------------- +-------------+
| Client |   session cookie   | API Server |
+--------+                    +-------------+
```

---

# Authenticated Request Flow

```text
+--------+ ---- session_id ----> +-------------+
| Client |                       | API Server |
+--------+                       +-------------+
                                         |
                                         | Lookup Session
                                         v
                                  +---------------+
                                  | Session Store |
                                  +---------------+
```

---

## Key Concepts

- Session stored on server
- Client stores session ID in cookie

---

## Advantages

- Easy logout/revoke
- Traditional web standard

---

## Disadvantages

- Server memory usage
- Harder horizontal scaling

---

## Best Use Cases

- Traditional websites
- Server-rendered applications

---

# 5. Bearer Token Authentication

## Overview

Client receives token after login.

Token is sent with every request.

---

# Login Flow

```text
+--------+ ---- Login ----> +-------------+
| Client |                  | Auth Server |
+--------+                  +-------------+
                                   |
                                   | Generate Token
                                   v
                            +--------------+
                            | Access Token |
                            +--------------+

+--------+ <--- Token ---- +-------------+
| Client |                 | Auth Server |
+--------+                 +-------------+
```

---

# API Access Flow

```text
+--------+ ---- Bearer Token ----> +-------------+
| Client |                         | API Server |
+--------+                         +-------------+
                                           |
                                           | Validate Token
                                           v
                                    Access Granted
```

---

## Request Example

```http
Authorization: Bearer eyJhbGciOi...
```

---

## Advantages

- Stateless
- Widely used
- Good scalability

---

## Disadvantages

- Token theft risk
- Requires expiration handling

---

## Best Use Cases

- Mobile apps
- SPAs
- Modern APIs

---

# 6. JWT (JSON Web Token)

## Overview

JWT is a self-contained signed token.

Contains:
- User identity
- Roles
- Claims
- Expiration

---

# JWT Structure

```text
HEADER.PAYLOAD.SIGNATURE
```

---

# JWT Communication Flow

```text
+--------+ ---- Login ----> +-------------+
| Client |                  | Auth Server |
+--------+                  +-------------+
                                   |
                                   | Create JWT
                                   v
                              +----------+
                              | JWT Token|
                              +----------+

+--------+ <--- JWT -------- +-------------+
| Client |                   | Auth Server |
+--------+                   +-------------+
```

---

# Request Validation

```text
+--------+ ---- JWT ----> +-------------+
| Client |                | API Server |
+--------+                +-------------+
                                  |
                                  | Verify Signature
                                  | Decode Payload
                                  v
                           User Authenticated
```

---

# JWT Internal Structure

## Header

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

---

## Payload

```json
{
  "user": "alice",
  "role": "admin"
}
```

---

## Signature

```text
HMACSHA256(header.payload, secret)
```

---

## Advantages

- Stateless
- Scalable
- Fast validation

---

## Disadvantages

- Hard to revoke
- Large payload possible

---

## Best Use Cases

- Microservices
- Distributed systems
- Cloud-native apps

---

# 7. OAuth 2.0

## Overview

OAuth allows delegated access.

Example:
- Login with Google
- Login with GitHub

---

# OAuth Actors

```text
User
Client Application
Authorization Server
Resource Server(API)
```

---

# OAuth Authorization Code Flow

```text
 ┌──────┐
 │ User │
 └──┬───┘
    |
    | Login via Google
    v
┌─────────────┐
│ Client App  │
└────┬────────┘
     |
     | Redirect User
     v
┌────────────────────┐
│ Authorization Svr  │
└────┬───────────────┘
     |
     | User grants permission
     |
     | Authorization Code
     v
┌─────────────┐
│ Client App  │
└────┬────────┘
     |
     | Exchange code for token
     v
┌────────────────────┐
│ Authorization Svr  │
└────┬───────────────┘
     |
     | Access Token
     v
┌─────────────┐
│ Client App  │
└────┬────────┘
     |
     | Bearer Token
     v
┌────────────────────┐
│ Resource/API Svr   │
└────────────────────┘
```

---

## OAuth Tokens

### Access Token
Short-lived token used for API access.

### Refresh Token
Used to obtain new access tokens.

---

## Advantages

- Industry standard
- Delegated permissions
- Secure

---

## Disadvantages

- Complex implementation
- Multiple flows

---

## Best Use Cases

- Third-party login
- Enterprise identity systems

---

# 8. HMAC Authentication

## Overview

Client signs request using secret key.

Server recomputes signature.

If signatures match:
- Request is authentic
- Request is untampered

---

# Communication Flow

```text
+--------+ ---- Request + Signature ----> +-------------+
| Client |                                    API Server |
+--------+                                  +-------------+
                                                    |
                                                    | Recompute Signature
                                                    |
                                                    | Match?
                                                    v
                                              Allow / Reject
```

---

# Internal Working

## Client Side

```text
Request Data
     |
     v
Create Hash using Secret Key
     |
     v
Attach Signature
```

---

## Example

### Client

```text
HMAC(secret_key, request_data)
```

### Server

```text
HMAC(secret_key, request_data)
```

If both hashes match:
- Request authenticated

---

## Advantages

- Very secure
- Prevents tampering
- No password transfer

---

## Disadvantages

- More complex
- Clock synchronization sometimes needed

---

## Best Use Cases

- AWS APIs
- Payment systems
- Financial systems

---

# 9. Mutual TLS (mTLS)

## Overview

Both:
- Client verifies server
- Server verifies client

using certificates.

---

# Communication Flow

```text
             TLS Handshake

+--------+ <---- Certificate ----> +-------------+
| Client |                         | API Server |
+--------+                         +-------------+
     |                                    |
     | Verify Server Cert                 |
     |                                    |
     | Send Client Cert                   |
     |----------------------------------->|
                                          |
                                          | Verify Client Cert
                                          v
                                   Secure Connection
```

---

# Normal TLS vs mTLS

## HTTPS

```text
Client verifies server only
```

---

## mTLS

```text
Client verifies server
AND
Server verifies client
```

---

## Advantages

- Extremely secure
- Strong identity verification

---

## Disadvantages

- Certificate management overhead
- Complex setup

---

## Best Use Cases

- Banking
- Enterprise systems
- Internal secure services

---

# 10. Comparison Table

| Method | Security | Stateful | Complexity | Typical Use |
|---|---|---|---|---|
| API Key | Low | No | Easy | Public APIs |
| Basic Auth | Low | No | Easy | Legacy systems |
| Session | Medium | Yes | Medium | Websites |
| Bearer Token | Medium | No | Medium | APIs |
| JWT | High | No | Medium | Microservices |
| OAuth2 | High | No | Complex | Third-party login |
| HMAC | High | No | Complex | Financial APIs |
| mTLS | Very High | No | Complex | Enterprise security |

---

# 11. Storage of Authentication State

| Method | Server Stores State? |
|---|---|
| API Key | Usually No |
| Basic Auth | No |
| Session | Yes |
| JWT | No |
| OAuth2 | Usually No |
| HMAC | No |
| mTLS | No |

---

# 12. Real-World Examples

| System | Authentication |
|---|---|
| AWS APIs | HMAC + IAM |
| Google Login | OAuth2 |
| Banking APIs | mTLS |
| Microservices | JWT |
| Traditional Websites | Session |
| Public APIs | API Keys |

---

# 13. Modern Cloud Architecture Example

```text
Frontend
   |
   | Login
   v
Auth Service
   |
   | JWT
   v
Frontend
   |
   | Bearer JWT
   v
API Gateway
   |
   | Validate JWT
   v
Microservices
```

---

# 14. Important Security Concepts

# HTTPS

Always use HTTPS.

Without HTTPS:
- Tokens can be stolen
- Passwords exposed
- MITM attacks possible

---

# Token Expiry

```text
Access Token:
Short lifetime

Refresh Token:
Long lifetime
```

---

# Least Privilege

OAuth scopes example:

```text
read:profile
write:email
```

---

# Token Rotation

```text
Old token invalidated
New token issued
```

---

# Replay Protection

Used mainly in:
- HMAC
- OAuth
- Banking APIs

Methods:
- Nonce
- Timestamp
- Request signing

---

# 15. Best Authentication Choice

| Scenario | Recommended |
|---|---|
| Public API | API Key |
| Web App | Session or JWT |
| Mobile App | OAuth2 + JWT |
| Microservices | JWT |
| Enterprise Security | mTLS |
| Financial APIs | HMAC |
| Third-party Login | OAuth2 |

---

# 16. Important Interview Questions

## Q1. Difference between Authentication and Authorization?

### Authentication
Who are you?

### Authorization
What can you access?

---

## Q2. Difference between JWT and Session?

### Session
- Stateful
- Stored on server

### JWT
- Stateless
- Stored on client

---

## Q3. Why is JWT scalable?

Because server does not store session state.

---

## Q4. Why use OAuth instead of API Keys?

OAuth provides:
- Delegated access
- User consent
- Scoped permissions
- Better security

---

## Q5. Why use HMAC?

To:
- Verify authenticity
- Prevent tampering
- Avoid sending secrets directly

---

# 17. Summary

| Authentication | Main Idea |
|---|---|
| API Key | Simple key validation |
| Basic Auth | Username/password |
| Session | Server-side login state |
| Bearer Token | Token-based access |
| JWT | Self-contained signed token |
| OAuth2 | Delegated authorization |
| HMAC | Signed requests |
| mTLS | Certificate-based mutual trust |

---