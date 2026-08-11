# REST vs SOAP vs gRPC vs WebSocket — Interview Cheat Sheet

## 1. REST

**REST = HTTP-based API using resources and HTTP methods.**

Example:

```text
Client
  │
  │ GET /users/10
  ▼
HTTP
  │
  ▼
Server
  │
  │ returns JSON
  ▼
Client
```

Typical:

```text
GET    /users/10
POST   /users
PUT    /users/10
DELETE /users/10
```

**Data:** Usually JSON
**Transport:** HTTP/1.1 or HTTP/2
**Model:** Request → Response

**Remember:**

> REST is resource-oriented and uses standard HTTP methods.

---

# 2. SOAP

**SOAP = protocol based on XML messages.**

Example:

```text
Client
  │
  │ SOAP XML request
  ▼
HTTP
  │
  ▼
Server
  │
  │ SOAP XML response
  ▼
Client
```

Example message conceptually:

```xml
<Envelope>
   <Body>
      <GetUser>
         <id>10</id>
      </GetUser>
   </Body>
</Envelope>
```

**Data:** XML
**Transport:** Usually HTTP
**Model:** Request → Response
**Common:** Enterprise/legacy systems

**Remember:**

> SOAP is a strict XML-based messaging protocol with built-in standards for things like security and reliability.

---

# 3. gRPC

**gRPC = RPC framework using Protobuf + HTTP/2.**

Client code:

```cpp
client->GetUser(10);
```

Flow:

```text
Client
  │
  │ GetUser(10)
  ▼
Stub
  │
  ▼
Protobuf

  │
  ▼
HTTP/2
  │
  ▼
Network
  │
  ▼
Server gRPC
  │
  ▼
Server GetUser()
  │
  ▼
Response
```

**Data:** Protobuf binary
**Transport:** HTTP/2
**Model:** Remote function call
**Supports:** Unary + streaming

**Remember:**

> gRPC makes a remote function call look like a local function call.

---

# 4. WebSocket

**WebSocket = persistent, two-way communication channel.**

Connection:

```text
Client
  │
  │ HTTP handshake
  ▼
Server
  │
  │ WebSocket connection established
  ▼
══════════════════════════════════
       Persistent connection
══════════════════════════════════
  ▲                    │
  │                    │
  │ messages           │ messages
  │                    │
  ▼                    ▼
Client               Server
```

After connection, **both sides can send messages at any time**.

```text
Client ───────────► Server
Client ◄─────────── Server
Client ───────────► Server
Client ◄─────────── Server
```

**Data:** Text or binary
**Transport:** TCP
**Model:** Persistent bidirectional communication
**Common:** Chat, live notifications, real-time updates

**Remember:**

> WebSocket keeps a connection open so both client and server can send data anytime.

---

# 5. Quick Comparison

|                       | REST                | SOAP                     | gRPC              | WebSocket              |
| --------------------- | ------------------- | ------------------------ | ----------------- | ---------------------- |
| Type                  | Architectural style | Protocol                 | RPC framework     | Communication protocol |
| Data                  | JSON commonly       | XML                      | Protobuf          | Text/Binary            |
| Transport             | HTTP                | HTTP commonly            | HTTP/2            | TCP                    |
| Communication         | Request/Response    | Request/Response         | RPC               | Bidirectional          |
| Persistent connection | Usually no          | Usually request/response | HTTP/2 connection | **Yes**                |
| Streaming             | Limited             | Limited                  | **Excellent**     | **Excellent**          |
| Typical use           | Public APIs         | Enterprise/legacy        | Microservices     | Real-time apps         |

---

# 6. Easiest Way to Remember

```text
REST
  → "Give me this resource"
  → HTTP + JSON

SOAP
  → "Send this structured XML message"
  → XML + HTTP

gRPC
  → "Call this function on another machine"
  → Protobuf + HTTP/2

WebSocket
  → "Keep the connection open and talk anytime"
  → Persistent bidirectional connection
```

# 7. Interview One-Liners

```text
REST:
Resource-oriented HTTP API.

SOAP:
XML-based messaging protocol.

gRPC:
RPC framework using Protobuf over HTTP/2.

WebSocket:
Persistent bidirectional communication over TCP.
```
