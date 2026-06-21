# HTTP (HyperText Transfer Protocol)

HTTP is the protocol used by browsers and web servers
to communicate.

When you open:

http://example.com

Browser and server exchange HTTP messages.

---

# Why HTTP Exists

Suppose:

Browser wants webpage.

Questions:

- What resource?
- What action?
- What format?

HTTP standardizes communication.

---

# Client Server Model

Browser
   |
HTTP Request
   |
Server
   |
HTTP Response
   |
Browser

---

# HTTP Characteristics

Application Layer Protocol

Uses TCP

Default Port:

80

Stateless

Request/Response Model

---

# Stateless Protocol

Each request is independent.

Server does NOT remember previous requests.

Example:

Request 1

GET /home

Request 2

GET /profile

Server treats them separately.

---

# HTTP Request Structure

Request Line

Headers

Body

---

Example

GET /index.html HTTP/1.1

Host: google.com

User-Agent: Chrome

Accept: text/html

---

# Request Methods

Most Important Interview Topic

---

# GET

Retrieve data.

Example:

GET /users

Characteristics:

Read only

Should not modify data

---

# POST

Create data.

Example:

POST /users

Body:

{
  "name":"John"
}

---

# PUT

Replace existing resource.

Example:

PUT /users/10

Replaces entire resource.

---

# PATCH

Partial update.

Example:

PATCH /users/10

Updates only changed fields.

---

# DELETE

Remove resource.

Example:

DELETE /users/10

---

# HEAD

Returns headers only.

No body.

Used for:

Health checks

---

# OPTIONS

Returns supported methods.

Used in:

CORS

---

# HTTP Response Structure

Status Line

Headers

Body

---

Example

HTTP/1.1 200 OK

Content-Type: text/html

Content-Length: 1024

<html>...</html>

---

# HTTP Status Codes

Must memorize.

---

# 1xx Informational

100 Continue

---

# 2xx Success

200 OK

201 Created

204 No Content

---

# 3xx Redirection

301 Moved Permanently

302 Found

304 Not Modified

---

# 4xx Client Errors

400 Bad Request

401 Unauthorized

403 Forbidden

404 Not Found

429 Too Many Requests

---

# 5xx Server Errors

500 Internal Server Error

502 Bad Gateway

503 Service Unavailable

504 Gateway Timeout

---

# HTTP Headers

Metadata about request/response.

Examples:

Host

User-Agent

Authorization

Accept

Content-Type

Content-Length

Cookie

Cache-Control

---

# Content Types

HTML

text/html

---

JSON

application/json

---

XML

application/xml

---

File Upload

multipart/form-data

---

# Cookies

Used to maintain state.

Server sends:

Set-Cookie

Browser stores cookie.

Future requests include:

Cookie Header

---

# Sessions

HTTP is stateless.

Sessions add state.

Flow:

Login
 ↓
Session Created
 ↓
Session ID Stored
 ↓
Future Requests Use Session ID

---

# HTTP Versions

HTTP/1.0

One request per connection.

---

HTTP/1.1

Persistent connections.

Most widely used.

---

HTTP/2

Multiplexing.

Multiple requests on one connection.

Much faster.

---

HTTP/3

Uses QUIC.

Built on UDP.

Lower latency.

---

# Interview Questions

Q1. Is HTTP stateful?

No

Stateless

---

Q2. Default HTTP port?

80

---

Q3. Difference between PUT and PATCH?

PUT:
Full update

PATCH:
Partial update

---

Q4. Difference between 401 and 403?

401:
Authentication needed

403:
Authenticated but forbidden

---

Q5. Which HTTP method creates resources?

POST