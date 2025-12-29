What HTTP Does: HTTP lets clients request resources (web pages, images, data, APIs) and lets servers respond with those 
resources.

Example:
You type https://example.com
Your browser sends an HTTP request, The server sends back an HTTP response with the webpage

**Client–Server Model:**
Client: browser, app, or device making the request
Server: computer that stores and serves data

Communication always starts with the client.

--------------------------------------------------------------------
HTTP Request
A request usually contains:
Method – what action to perform
Common methods:
GET → retrieve data
POST → send data
PUT → update data
DELETE → remove data
URL – where the request is sent
Headers – extra info (browser type, data format, auth info)
Body (optional) – data being sent (common with POST)

**Example:**
GET /index.html HTTP/1.1
Host: example.com

---------------------------------------------------------------------
HTTP Response
A response contains:
Status Code – result of the request
Common codes:
200 OK – success
404 Not Found – resource doesn’t exist
500 Internal Server Error – server problem
Headers – info about the response
Body – actual content (HTML, JSON, image, etc.)

-------------------------------------------------------------------------
Stateless Protocol
HTTP is stateless, meaning:
Each request is independent
The server does not remember previous requests by default
To handle logins and sessions, websites use:
Cookies
Tokens
Sessions

------------------------------------------------------------
HTTP vs HTTPS
HTTP → data sent in plain text (not secure)
HTTPS → encrypted using TLS/SSL (secure)

--------------------------------------------------------------------------------
HTTP Versions
HTTP/1.1 – traditional, widely supported
HTTP/2 – faster, multiplexed connections
HTTP/3 – uses QUIC (UDP), even faster and more reliable

---------------------------------------------------------------------------------
Where HTTP Is Used
Websites
REST APIs
Mobile apps
Cloud services

