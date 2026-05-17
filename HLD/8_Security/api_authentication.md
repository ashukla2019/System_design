# API Authentication Methods — Problem → Solution Notes

---

# 1. Why Do We Need API Authentication?

## Problem

Without authentication:

- Anyone can call APIs
- Data can be stolen
- Attackers can impersonate users
- APIs can be abused

Example:

```text
Attacker → API → Sensitive Data
```

So APIs need a way to verify:

```text
Who are you?
Can you access this?
```

---

# 2. API Key Authentication

# Problem It Solves

## Problem

Public APIs need:
- simple access control
- request tracking
- usage monitoring

But full login systems are too heavy.

---

# Solution

Give each client a unique API key.

Server validates the key before processing request.

---

# Flow

```text
Client has unique API Key

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

# How It Works

```text
1. Client sends API key
2. Server checks database
3. If key exists:
      request allowed
4. Else:
      reject request
```

---

# Problem Solved

✅ Identifies calling application  
✅ Restricts unauthorized access  
✅ Tracks API usage

---

# Limitations

❌ Does not verify actual user identity  
❌ Key can be leaked

---

# Best Use Cases

```text
Public APIs
Internal tools
Low-security systems
```

---

# 3. Basic Authentication

# Problem It Solves

## Problem

Server needs simple username/password verification.

---

# Solution

Send username/password with every request.

---

# Flow

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

# How It Works

```text
1. Client sends credentials
2. Server decodes Base64
3. Server validates username/password
4. Access granted or rejected
```

---

# Problem Solved

✅ Verifies user identity  
✅ Very easy implementation

---

# Limitations

❌ Password travels every request  
❌ Requires HTTPS  
❌ Weak for modern systems

---

# Best Use Cases

```text
Legacy systems
Testing environments
```

---

# 4. Session-Based Authentication

# Problem It Solves

## Problem

Sending password on every request is risky.

Server needs:
- persistent login
- easy logout
- centralized control

---

# Solution

After login:
- server creates session
- client stores only session ID

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

# Authenticated Request

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

# How It Works

```text
1. User logs in once
2. Server creates session
3. Client stores session ID cookie
4. Future requests send session ID
5. Server retrieves stored session
```

---

# Problem Solved

✅ Password not sent repeatedly  
✅ Easy logout/revoke  
✅ Centralized session control

---

# Limitations

❌ Server memory usage increases  
❌ Scaling becomes harder

---

# Best Use Cases

```text
Traditional websites
Server-rendered applications
```

---

# 5. Bearer Token Authentication

# Problem It Solves

## Problem

Modern APIs need:
- stateless authentication
- scalable systems
- mobile support

Sessions require server storage.

---

# Solution

Server generates token after login.

Client sends token with every request.

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

# API Access

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

# How It Works

```text
1. User logs in
2. Auth server generates token
3. Client stores token
4. Client sends token in requests
5. Server validates token
```

---

# Problem Solved

✅ Stateless authentication  
✅ Better scalability  
✅ Good for APIs/mobile apps

---

# Limitations

❌ Stolen token can be abused  
❌ Requires expiry handling

---

# Best Use Cases

```text
REST APIs
Mobile apps
SPAs
```

---

# 6. JWT (JSON Web Token)

# Problem It Solves

## Problem

Server wants:
- stateless authentication
- user information inside token
- no database lookup for every request

---

# Solution

Store user details inside signed token.

---

# JWT Structure

```text
HEADER.PAYLOAD.SIGNATURE
```

---

# Flow

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

# Validation Flow

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

# JWT Signature Formula

```text
HMACSHA256(header.payload, secret)
```

---

# Problem Solved

✅ Stateless authentication  
✅ Faster validation  
✅ User claims embedded in token

---

# Limitations

❌ Hard to revoke immediately  
❌ Large token size possible

---

# Best Use Cases

```text
Microservices
Cloud-native systems
Distributed APIs
```

---

# 7. OAuth 2.0

# Problem It Solves

## Problem

User wants to allow third-party apps access WITHOUT sharing password.

Example:

```text
Login with Google
Login with GitHub
```

Without OAuth:

```text
User gives password directly to app
```

Very dangerous.

---

# Solution

Authorization server gives limited delegated access tokens.

---

# OAuth Actors

```text
User
Client Application
Authorization Server
Resource Server
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

# Problem Solved

✅ User password never shared with third-party app  
✅ Limited scoped access  
✅ Delegated authorization

---

# Limitations

❌ Complex implementation  
❌ Multiple flows/tokens

---

# Best Use Cases

```text
Google Login
Enterprise SSO
Third-party integrations
```

---

# 8. HMAC Authentication

# Problem It Solves

## Problem

Server needs to ensure:
- request is genuine
- request not modified in transit
- secret key never exposed

---

# Solution

Client signs request using secret key.

Server recomputes signature independently.

---

# Flow

```text
+--------+ ---- Request + Signature ----> +-------------+
| Client |                                    API Server |
+--------+                                  +-------------+
                                                    |
                                                    | Recompute Signature
                                                    | Compare
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
Create Signature using Secret Key
     |
     v
Attach Signature
```

---

# Signature Formula

```text
HMAC(secret_key, request_data)
```

---

# Verification

```text
1. Client computes HMAC hash
2. Sends request + signature
3. Server computes same HMAC
4. Compare signatures
5. If same:
      request authentic
```

---

# Problem Solved

✅ Prevents tampering  
✅ Secret key never transmitted  
✅ Verifies authenticity

---

# Limitations

❌ More implementation complexity  
❌ Clock synchronization sometimes needed

---

# Best Use Cases

```text
AWS APIs
Financial APIs
Payment systems
```

---

# 9. Mutual TLS (mTLS)

# Problem It Solves

## Problem

Normal HTTPS only verifies server identity.

But highly secure systems also need:

```text
Server must verify client identity
```

---

# Solution

Both sides exchange certificates.

---

# Flow

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

# How It Works

```text
1. Server sends certificate
2. Client verifies server
3. Client sends its certificate
4. Server verifies client
5. Secure communication established
```

---

# Problem Solved

✅ Strong mutual identity verification  
✅ Very secure communication  
✅ Prevents unauthorized clients

---

# Limitations

❌ Certificate management overhead  
❌ Complex setup

---

# Best Use Cases

```text
Banking
Enterprise systems
Internal secure services
```

---

# 10. Quick Comparison — Problem vs Solution

| Problem | Authentication Solution |
|---|---|
| Simple app identification | API Key |
| Username/password verification | Basic Auth |
| Persistent login sessions | Session Authentication |
| Stateless scalable APIs | Bearer Token |
| Stateless identity + claims | JWT |
| Third-party delegated access | OAuth2 |
| Tamper-proof signed requests | HMAC |
| Mutual identity verification | mTLS |

---

# 11. Real-World Examples

| System | Authentication Used | Problem Solved |
|---|---|---|
| AWS APIs | HMAC | Request integrity |
| Google Login | OAuth2 | Third-party login |
| Banking APIs | mTLS | Strong trust |
| Microservices | JWT | Stateless auth |
| Traditional Websites | Session | Persistent login |
| Public APIs | API Key | Simple access control |

---

# 12. Final Summary

| Authentication | Main Problem Solved |
|---|---|
| API Key | Identify calling application |
| Basic Auth | Verify username/password |
| Session | Avoid password every request |
| Bearer Token | Stateless authentication |
| JWT | Self-contained identity |
| OAuth2 | Delegated authorization |
| HMAC | Prevent tampering |
| mTLS | Mutual trust verification |

---