What REST Is: REST defines rules and principles for how clients and servers should communicate over the web in a simple, 
scalable way.

Most REST APIs run on top of HTTP.

Core REST Principles
1. Client–Server Separation: Client handles UI

Server handles data & logic

They evolve independently
-------------------------------------------------------------------
2. Stateless

Each request contains all information needed

Server does not store client state

Authentication usually via tokens
---------------------------------------------------------------------
3. Resources

Everything is treated as a resource, identified by a URL.

Examples:

/users
/users/42
/orders/10/items
----------------------------------------------------------------------
4. HTTP Methods (CRUD Mapping)
HTTP Method	Action	Example
GET	Read	GET /users
POST	Create	POST /users
PUT	Update (full)	PUT /users/42
PATCH	Update (partial)	PATCH /users/42
DELETE	Delete	DELETE /users/42

-------------------------------------------------------------------------

6. Representation

Resources are exchanged as representations, usually:

JSON (most common)

XML (older)

Example response:

{
  "id": 42,
  "name": "Alex",
  "email": "alex@example.com"
}

6. Uniform Interface

REST uses:
Standard URLs
Standard HTTP methods
Standard status codes

This makes APIs predictable and easy to use.

REST Response Status Codes
200 OK – success
201 Created – resource created
400 Bad Request – client error
401 Unauthorized – not logged in
404 Not Found – resource missing
500 Internal Server Error – server error

REST vs HTTP (Important!)
HTTP → communication protocol
REST → design style that uses HTTP correctly

You can use HTTP without REST, and REST almost always uses HTTP.

REST vs SOAP
REST	SOAP
Lightweight	Heavy
Uses HTTP	Uses XML + strict rules
JSON	XML only
Faster, simpler	More secure but complex
Example REST Flow
