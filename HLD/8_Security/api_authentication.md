# Authentication Methods — What Problem Each One Solves

---

# 1. Simple App Identification → API Key

# Problem

Server wants to know:

```text
Which application is calling my API?
```

But:
- no user login needed
- no strong security required

Example:
- Weather API
- Maps API
- Public API service

---

# Solution → API Key

Server gives each app a unique key.

Example:

```text
App A → abc123
App B → xyz789
```

Request:

```http
x-api-key: abc123
```

---

# What Problem It Solves

```text
Identifies the application making request
```

NOT:
- actual user identity
- strong authentication

---

# Real Example

```text
Google Maps API
```

Your app sends API key so Google knows:
- which app is calling
- usage limits
- billing

---

# Simple Visualization

```text
App ---- API Key ----> Server
```

---

# 2. Username/Password Verification → Basic Auth

# Problem

Server needs to verify:

```text
Is this really the correct user?
```

using:
- username
- password

---

# Solution → Basic Authentication

Client sends:

```text
username:password
```

encoded in Base64.

---

# What Problem It Solves

```text
Verifies user credentials directly
```

---

# Real Example

```text
Old admin panels
Internal tools
Routers/modems login
```

---

# Visualization

```text
Client ---- username/password ----> Server
```

---

# Issue

Password travels every request.

So HTTPS becomes mandatory.

---

# 3. Persistent Login Sessions → Session Authentication

# Problem

Without sessions:

```text
User must send password every request
```

Very inefficient and risky.

Server wants:

✅ User logs in once  
✅ Stay logged in  
✅ Easy logout

---

# Solution → Session Authentication

After login:

```text
Server creates session
```

Client stores only:

```text
session_id
```

---

# What Problem It Solves

```text
Maintains logged-in state
```

without sending password repeatedly.

---

# Real Example

```text
Amazon website
Facebook website
Banking websites
```

---

# Visualization

```text
Login → Session Created → Cookie Stored
```

Then:

```text
Cookie → Server → User recognized
```

---

# 4. Stateless Scalable APIs → Bearer Token

# Problem

Sessions require server memory.

In large cloud systems:

```text
Millions of users
Many servers
Load balancers
Microservices
```

Managing sessions becomes difficult.

---

# Solution → Bearer Token

After login:

```text
Server gives token
```

Client sends token every request.

Server validates token.

No session storage needed.

---

# What Problem It Solves

```text
Stateless scalable authentication
```

---

# Real Example

```text
Mobile apps
REST APIs
Cloud APIs
```

---

# Visualization

```text
Client ---- Bearer Token ----> API
```

---

# Why "Bearer"?

Because:

```text
Whoever bears/holds token gets access
```

So token theft is dangerous.

---

# 5. Stateless Identity + Claims → JWT

# Problem

Bearer token alone may only identify access.

But APIs also need:

```text
Who is user?
What role?
What permissions?
When token expires?
```

without database lookup every request.

---

# Solution → JWT

JWT stores user information INSIDE token.

Example payload:

```json
{
  "user": "alice",
  "role": "admin",
  "exp": 123456789
}
```

Signed cryptographically.

---

# What Problem It Solves

```text
Carries user identity + permissions statelessly
```

---

# Real Example

```text
Microservices
API Gateway
Cloud-native apps
```

---

# Visualization

```text
JWT =
Header + Payload + Signature
```

---

# Why Powerful?

Each service can validate JWT independently.

No central session lookup needed.

Very scalable.

---

# 6. Third-Party Delegated Access → OAuth2

# Problem

User wants:

```text
Login with Google
```

But user should NOT give Google password to app directly.

Need:

```text
Limited delegated access
```

---

# Solution → OAuth2

Google authenticates user.

Google gives access token to app.

App gets limited permission.

---

# What Problem It Solves

```text
Safe third-party delegated access
```

---

# Real Example

```text
Login with Google
Login with GitHub
Login with Microsoft
```

---

# Visualization

```text
User
  |
  | Login via Google
  v
Google Auth Server
  |
  | Token
  v
Application
```

---

# Important Idea

User password never shared with third-party app.

---

# 7. Tamper-Proof Signed Requests → HMAC

# Problem

Server needs to ensure:

```text
Request was NOT modified
```

and:

```text
Request truly came from trusted client
```

Especially for:
- payments
- financial APIs
- AWS APIs

---

# Solution → HMAC

Client creates signature using:
- secret key
- request data

Server recomputes signature.

If signatures match:
- request authentic
- request untampered

---

# What Problem It Solves

```text
Integrity + authenticity of request
```

---

# Real Example

```text
AWS Signature V4
Stripe webhooks
Payment gateways
```

---

# Visualization

```text
Request + Signature ---> Server

Server recomputes signature
```

---

# Key Advantage

Secret key never transmitted.

---

# 8. Mutual Identity Verification → mTLS

# Problem

Normal HTTPS only verifies:

```text
Server identity
```

But some systems also need:

```text
Client identity verification
```

before communication starts.

---

# Solution → mTLS

Both sides exchange certificates.

Both verify each other.

---

# What Problem It Solves

```text
Mutual trust verification
```

---

# Real Example

```text
Banking systems
Enterprise internal APIs
Government systems
```

---

# Visualization

```text
Client <---- Certificates ----> Server
```

Both verify certificates.

---

# Why Very Secure?

Even if attacker knows API endpoint:

```text
Without valid certificate:
    access denied
```

---

# Final Simplified Summary

| Problem | Solution | Main Idea |
|---|---|---|
| Which app is calling? | API Key | App identification |
| Is username/password correct? | Basic Auth | Credential verification |
| Keep user logged in | Session | Server-side login state |
| Scale APIs without sessions | Bearer Token | Stateless auth |
| Carry identity + roles | JWT | Self-contained identity |
| Login via Google/GitHub | OAuth2 | Delegated access |
| Detect request tampering | HMAC | Signed requests |
| Verify both client and server | mTLS | Mutual certificate trust |

---