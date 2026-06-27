## Security Layer

Protects the system from unauthorized access, attacks and data leakage.

### SSL/TLS
- Encrypts communication between client and server.

#### Working

```text
Client
 │
 ├─ Client Hello
 │
 ├─ Supported Cipher Suites
 │
 ▼
Server
 │
 ├─ Server Hello
 ├─ Certificate
 ├─ Public Key
 │
 ▼
Client Verifies Certificate
 │
 ▼
Session Key Exchange
 │
 ▼
Encrypted Communication Starts
```

Purpose:
- Confidentiality
- Integrity
- Authentication

---

### Authentication

Verifies identity of a user or application.

Question:

```text
Who are you?
```

#### Working

```text
User
 │
 ├─ Username/Password
 │
 ▼
Auth Service
 │
 ├─ Validate Credentials
 │
 ▼
JWT / Session Created
 │
 ▼
Returned To User
```

Methods:
- API Key
- Basic Auth
- Session Auth
- JWT
- OAuth
- SSO

---

### JWT

Signed token carrying user identity and permissions.

#### Working

```text
Login
 │
 ▼
Auth Server
 │
 ├─ Generate JWT
 │
 ▼
Client Stores JWT
 │
 ▼
Every Request
 │
 └─ Authorization: Bearer <token>
```

Server validates:

```text
Signature
Expiry
Claims
Roles
```

---

### OAuth 2.0

Delegated authorization without sharing passwords.

#### Working

```text
User
 │
 ▼
Google Login
 │
 ▼
Google Auth Server
 │
 ▼
Access Token
 │
 ▼
Application
```

Example:

```text
Login with Google
Login with GitHub
```

---

### Authorization

Determines what authenticated users can access.

Question:

```text
What can you do?
```

#### Working

```text
User Authenticated
 │
 ▼
Check Role
 │
 ├─ Admin
 ├─ Manager
 └─ User
 │
 ▼
Allow / Deny
```

---

### RBAC

Role Based Access Control.

```text
Admin
 ├─ Read
 ├─ Write
 └─ Delete

User
 └─ Read
```

---

### ABAC

Access based on attributes.

Example:

```text
Role = Manager
Location = Pune
Time = Office Hours
```

Access granted only if policy matches.

---

### Zero Trust

Never trust anyone by default.

#### Working

```text
Every Request
 │
 ▼
Verify Identity
 │
 ▼
Verify Device
 │
 ▼
Verify Location
 │
 ▼
Grant Access
```

---

## Communication Layer

Defines how services communicate with each other.

---

### REST

HTTP based communication.

#### Working

```text
Client
 │
 ├─ GET /users/1
 │
 ▼
Server
 │
 ├─ Process Request
 │
 ▼
JSON Response
```

Characteristics:
- Stateless
- Human Readable
- JSON

---

### SOAP

XML based enterprise communication.

#### Working

```text
Client
 │
 ▼
SOAP Envelope
 │
 ▼
Server
 │
 ▼
SOAP Response
```

Characteristics:
- Strong contracts
- WS-Security
- Enterprise focused

---

### GraphQL

Client requests only required data.

#### Working

```text
Client Query
 │
 ▼
GraphQL Server
 │
 ▼
Resolver
 │
 ▼
Database
 │
 ▼
Requested Fields Only
```

Example:

```graphql
{
  user {
    name
    email
  }
}
```

---

### gRPC

Remote procedure calls over HTTP/2.

#### Working

```text
Service A
 │
 ▼
Protocol Buffer
 │
 ▼
HTTP/2
 │
 ▼
Service B
```

Characteristics:
- Binary format
- Low latency
- Streaming support

---

### WebSocket

Persistent bidirectional connection.

#### Working

```text
Client
 │
 ├─ WebSocket Handshake
 │
 ▼
Connection Open
 │
 ▼
Client ↔ Server
 │
 ▼
Real-Time Updates
```

Use Cases:
- Chat
- Gaming
- Live Dashboard

---

### RabbitMQ

Message Queue.

#### Working

```text
Producer
 │
 ▼
Queue
 │
 ▼
Consumer
```

Flow:

```text
Order Created
 │
 ▼
Queue
 │
 ▼
Email Service
```

Characteristics:
- Reliable delivery
- Retry support
- Task distribution

---

### Kafka

Event Streaming Platform.

#### Working

```text
Producer
 │
 ▼
Topic
 │
 ▼
Partition
 │
 ▼
Consumer Group
```

Flow:

```text
Order Created
 │
 ▼
Kafka Topic
 │
 ├─ Analytics
 │
 ├─ Fraud Service
 │
 └─ Notification Service
```

Characteristics:
- Event Replay
- High Throughput
- Distributed

---

### Sync vs Async

Synchronous

```text
Client
 │
 ▼
Server
 │
 ▼
Wait
 │
 ▼
Response
```

Examples:
- REST
- SOAP
- GraphQL Query
- gRPC

Asynchronous

```text
Producer
 │
 ▼
Queue
 │
 ▼
Consumer
```

Examples:
- Kafka
- RabbitMQ
- Event Driven Systems

Hybrid

```text
REST + Kafka
gRPC + Kafka
GraphQL + Subscription
```

Used in most modern systems.