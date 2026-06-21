# Proxy and Reverse Proxy

Very common in System Design and Cloud.

---

# Forward Proxy

Client knows proxy.

Client
 ↓
Proxy
 ↓
Internet

Examples:

Corporate Networks

School Networks

Content Filtering

---

# Uses

Hide client IP

Content filtering

Caching

Security

---

# Reverse Proxy

Client does NOT know proxy exists.

Client
 ↓
Reverse Proxy
 ↓
Servers

---

# Uses

Load Balancing

SSL Termination

Caching

Security

Compression

---

# Example

User
 ↓
Nginx
 ↓
Backend Servers

---

# Reverse Proxy vs Load Balancer

Reverse Proxy:

Application Layer

Often Layer 7

---

Load Balancer:

Traffic Distribution

Layer 4 or Layer 7

---

# Popular Reverse Proxies

Nginx

HAProxy

Traefik

Envoy

Apache

---

# API Gateway

Advanced Reverse Proxy

Features:

Authentication

Rate Limiting

Caching

Routing

Monitoring

---

# AWS Mapping

ALB

Reverse Proxy

---

API Gateway

Managed Reverse Proxy

---

CloudFront

Reverse Proxy + CDN

---

# Interview Questions

Q1. Difference between proxy and reverse proxy?

Proxy:
Protects clients

Reverse Proxy:
Protects servers

---

Q2. Why reverse proxy?

Security and load balancing.

---

Q3. Is Nginx a reverse proxy?

Yes.