WebSocket is a communication protocol that enables real-time, two-way (full-duplex) communication between a client and a server
over a single, long-lived connection.
It’s very different from HTTP/REST.

What Problem WebSocket Solves
HTTP is request → response only.
For real-time updates, the client must keep asking the server (polling).

WebSocket allows:
Server → client messages anytime
Instant updates
Much less network overhead

-------------------------------------------------------------------------------
How WebSocket Works
1. Handshake (Starts as HTTP)

WebSocket begins with an HTTP request:

GET /chat HTTP/1.1
Upgrade: websocket
Connection: Upgrade

Server responds:
HTTP/1.1 101 Switching Protocols


--------------------------------------------------------------------------------------

2. Persistent Connection
Connection stays open
Both sides can send messages anytime
No request/response limitation

WebSocket Characteristics
Full-duplex (two-way)
Low latency
Persistent

Works over:
ws:// (not secure)
wss:// (secure, encrypted)

-------------------------------------------------------------------------------------------
Common Use Cases
Chat applications
Online games
Live notifications
tock prices / live scores
Collaboration tools (Google Docs-like)
IoT dashboards
