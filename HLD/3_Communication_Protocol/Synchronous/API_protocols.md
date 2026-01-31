

1️⃣ REST (Representational State Transfer)
How it works
Uses HTTP

Resources identified by URLs

Uses HTTP methods: GET, POST, PUT, DELETE

Data format: JSON (mostly)

Client ──HTTP──> Server
GET /users/1 → JSON response
When to use
✅ Simple APIs
✅ Public APIs
✅ CRUD-based systems
✅ Web & mobile apps

🧠 Think: “Standard, easy, everywhere”

2️⃣ GraphQL
How it works
Single endpoint

Client asks exactly what data it needs

Server returns only requested fields

Client → /graphql
{
  user(id:1) {
    name
    email
  }
}
When to use
✅ Avoid over-fetching / under-fetching
✅ Complex UI with many data needs
✅ Mobile apps (bandwidth saving)

🧠 Think: “Client controls data”

3️⃣ SOAP (Simple Object Access Protocol)
How it works
XML-based

Very strict contract (WSDL)

Can use HTTP, SMTP, etc.

Heavy but secure & reliable

Client → XML Request → Server
When to use
✅ Banking systems
✅ Enterprise / legacy systems
✅ High security & strict contracts required

🧠 Think: “Old but trusted enterprise standard”

4️⃣ gRPC
How it works
Uses HTTP/2

Binary data (Protocol Buffers)

Very fast, supports streaming

Service A ⇄ gRPC ⇄ Service B
When to use
✅ Microservices
✅ Internal service-to-service communication
✅ High performance & low latency systems

🧠 Think: “Fastest backend communication”

5️⃣ WebSocket
How it works
Persistent connection

Full-duplex (both sides talk anytime)

Real-time communication

Client ⇄ WebSocket ⇄ Server
When to use
✅ Chat applications
✅ Live notifications
✅ Stock prices
✅ Online games

🧠 Think: “Real-time, live updates”

🔥 Quick Comparison Table
Tech	Pattern	Data	Speed	Best Use
REST	Request/Response	JSON	Medium	Public APIs
GraphQL	Query-based	JSON	Medium	Complex UIs
SOAP	Contract-based	XML	Slow	Enterprise
gRPC	Binary RPC	Protobuf	⚡ Fast	Microservices
WebSocket	Persistent	Any	⚡⚡	Real-time apps
🎯 Which one should you choose?
Simple API? → REST

UI needs exact data? → GraphQL

Bank / legacy system? → SOAP

Microservices / internal APIs? → gRPC

Live updates? → WebSocket