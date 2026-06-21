# CDN (Content Delivery Network)

A CDN stores copies of content closer to users.

Purpose:

Reduce latency.

Improve performance.

Reduce server load.

---

# Problem Without CDN

User (India)
      ↓
USA Server

Distance:

Very large

Result:

High latency

Slow website

---

# With CDN

User (India)
      ↓
Mumbai Edge Location
      ↓
USA Origin Server

Content served from nearby location.

Much faster.

---

# CDN Components

User

↓

Edge Location

↓

Origin Server

---

# Origin Server

Original content location.

Example:

EC2

S3

Web Server

---

# Edge Location

CDN cache server.

Stores frequently accessed content.

Closer to users.

---

# Cache Hit

Requested content exists in CDN cache.

User
 ↓
CDN

Served immediately.

Fast.

---

# Cache Miss

Content not found.

User
 ↓
CDN
 ↓
Origin

CDN stores copy.

Future requests become cache hits.

---

# Static Content

Ideal for CDN.

Examples:

Images

CSS

JavaScript

Videos

PDFs

---

# Dynamic Content

Generated on demand.

Examples:

Bank Balance

Shopping Cart

Live Dashboard

Usually not cached.

---

# CDN Benefits

Lower Latency

Reduced Bandwidth

Reduced Server Load

Better Availability

DDoS Protection

---

# CDN Caching

Content stored temporarily.

Example:

TTL = 3600 seconds

After expiry:

Refresh from origin.

---

# Popular CDNs

CloudFront

Cloudflare

Akamai

Fastly

---

# AWS Mapping

CloudFront

Origin:

S3

ALB

EC2

API Gateway

---

# Interview Questions

Q1. What is CDN?

Distributed cache network.

---

Q2. Difference between Cache Hit and Cache Miss?

Hit:
Served from CDN

Miss:
Fetched from origin

---

Q3. Why CDN?

Lower latency.