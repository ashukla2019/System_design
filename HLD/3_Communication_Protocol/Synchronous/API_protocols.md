# API Communication Types

## REST
**Working**
- HTTP-based, resource-oriented
- Uses `GET, POST, PUT, DELETE`
- Data format: JSON

**When to Use**
- Simple CRUD APIs
- Public-facing services
- Web & mobile apps

**Pros:** Simple, stateless, widely supported  
**Cons:** Over/under-fetching possible

---

## GraphQL
**Working**
- Single endpoint
- Client requests exact fields
- JSON response

**When to Use**
- Complex UI data needs
- Avoid over/under-fetching
- Mobile apps

**Pros:** Flexible, efficient data fetching  
**Cons:** Complex server, caching harder

---

## SOAP
**Working**
- XML-based protocol
- Strict contract (WSDL)
- Strong security standards

**When to Use**
- Banking systems
- Enterprise & legacy apps

**Pros:** Reliable, secure  
**Cons:** Heavy, slow, verbose

---

## gRPC
**Working**
- Uses HTTP/2
- Binary protocol (Protobuf)
- Supports streaming

**When to Use**
- Microservices
- Internal service communication
- Low-latency systems

**Pros:** Very fast, efficient  
**Cons:** Not browser-friendly

---

## WebSocket
**Working**
- Persistent, full-duplex connection
- Real-time data flow

**When to Use**
- Chat apps
- Live dashboards
- Games, notifications

**Pros:** Real-time, low latency  
**Cons:** Connection management needed

---

## Quick Comparison

| Tech | Model | Data | Best For |
|---|---|---|---|
| REST | Request/Response | JSON | Public APIs |
| GraphQL | Query-based | JSON | Complex UI |
| SOAP | Contract-based | XML | Enterprise |
| gRPC | RPC | Protobuf | Microservices |
| WebSocket | Persistent | Any | Real-time |

---

## Interview Thumb Rules
- **CRUD API?** → REST  
- **UI controls data?** → GraphQL  
- **Banking/Legacy?** → SOAP  
- **Service-to-service?** → gRPC  
- **Live updates?** → WebSocket  
