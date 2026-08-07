# 29. URL Shortener Design

> Designing a scalable URL shortening service similar to Bitly, TinyURL, and large-scale redirect systems.

---

# Table of Contents

1. Introduction
2. Why URL Shorteners?
3. Requirements
4. High-Level Architecture
5. Request Flow
6. URL Generation
7. Short Code Design
8. Base62 Encoding
9. Distributed ID Generation
10. Database Design
11. Storage Architecture
12. Redirect Flow
13. Caching
14. Expiration
15. Analytics System
16. Scaling
17. Failure Handling
18. Security
19. Monitoring
20. Real-World Architecture
21. Interview Questions
22. Summary

---

# 1. Introduction

A URL shortener converts a long URL into a compact identifier.

Example:

Long URL:

```
https://example.com/products/category/item?id=12345
```

Short URL:

```
https://short.ly/aB91x
```

When users open the short URL:

```
short.ly/aB91x

↓

Original URL
```

---

# 2. Why URL Shorteners?

Use cases:

- Social media links
- Marketing campaigns
- QR codes
- Tracking links
- Email sharing

Requirements:

- Fast redirects
- High availability
- Unique URLs
- Massive scale

---

# 3. Functional Requirements

The system should support:

## Create URL

Input:

```
Long URL
```

Output:

```
Short URL
```

---

## Redirect

Input:

```
Short URL
```

Output:

```
Original URL
```

---

## Optional Features

- Expiration
- Custom aliases
- Analytics
- Click tracking
- User accounts

---

# 4. Non-Functional Requirements

Latency:

Redirect <10 ms

Availability:

99.99%

Scale:

Billions of URLs

Traffic:

Millions of redirects/sec

Durability:

No URL loss

---

# 5. High-Level Architecture

```
             User

              |

        Load Balancer

              |

        URL Service

       /           \

  Database       Cache

       |

  Analytics System
```

---

# 6. Core Components

## API Service

Handles:

- URL creation
- Redirect requests
- Authentication

---

## ID Generator

Creates unique short IDs.

Example:

```
123456

↓

Base62

↓

abcD9
```

---

## Database

Stores mappings:

```
Short Code

↓

Long URL
```

---

## Cache

Stores popular URLs.

Example:

```
aB91x

↓

https://example.com/page
```

---

# 7. URL Creation Flow

Example:

User submits:

```
https://amazon.com/product/123
```

Flow:

```
Client

↓

API Server

↓

Generate ID

↓

Store Mapping

↓

Return Short URL
```

---

# 8. Redirect Flow

User opens:

```
short.ly/aB91x
```

Flow:

```
Client

↓

Load Balancer

↓

URL Service

↓

Cache Lookup

↓

Database

↓

Redirect Response
```

---

# 9. URL Generation Strategies

Several approaches exist.

---

# 10. Random String Generation

Generate:

```
a8X91k
```

Check database:

```
Exists?

No

↓

Store
```

Advantages:

- Simple
- Hard to guess

Disadvantages:

- Collision checking

---

# 11. Hashing Original URL

Example:

```
SHA256(URL)

↓

First 7 characters
```

Example:

```
8fA91bc
```

Advantages:

- Deterministic

Disadvantages:

- Collisions

---

# 12. Base62 Encoding

Most common approach.

Characters:

```
a-z

A-Z

0-9
```

Total:

```
62 characters
```

---

Example:

Numeric ID:

```
100000
```

Converted:

```
q0T8
```

URL:

```
short.ly/q0T8
```

---

# 13. Why Base62?

Because URLs need:

- Short length
- Human readability
- Large namespace

Number of combinations:

Length 7:

```
62^7

≈ 3.5 trillion URLs
```

---

# 14. Distributed ID Generation

Large systems cannot use one database counter.

Solutions:

---

## Database Auto Increment

Example:

```
1

2

3

4
```

Problems:

- Single bottleneck
- Hard to distribute

---

## UUID

Example:

```
550e8400-e29b
```

Problems:

- Too long

---

## Snowflake Algorithm

Used by large distributed systems.

Format:

```
Timestamp

+

Machine ID

+

Sequence Number
```

Example:

```
64-bit ID
```

Benefits:

- Globally unique
- Distributed
- Time sortable

---

# 15. Database Design

## URL Mapping Table

Example:

```
url_mapping

------------------

id

short_code

long_url

created_at

expires_at

user_id
```

---

Example:

```
1

aB91x

https://example.com/page

2026-01-01
```

---

# 16. Database Choice

Options:

## Relational Database

Examples:

- MySQL
- PostgreSQL

Advantages:

- Strong consistency
- Simple schema

---

## NoSQL Database

Examples:

- Cassandra
- DynamoDB

Advantages:

- Massive scale
- High write throughput

---

# 17. Storage Scaling

Partition by:

```
short_code hash
```

Example:

```
hash(aB91x)

↓

Shard 5
```

---

# 18. Read vs Write Pattern

URL shorteners are read-heavy.

Example:

```
Create URLs

1 million/day


Redirects

100 million/day
```

Optimize reads.

---

# 19. Caching Strategy

Most popular links should be cached.

Architecture:

```
Request

↓

Cache

↓

Database
```

---

Cache:

```
Key:

short_code


Value:

long_url
```

---

# 20. Cache Eviction

Strategies:

- LRU
- TTL
- LFU

Popular URLs remain longer.

---

# 21. Expiration

URLs may expire.

Example:

```
Created:

Jan 1


Expires:

Feb 1
```

Options:

- Database cleanup jobs
- TTL indexes
- Background workers

---

# 22. Analytics System

Track:

- Click count
- User location
- Device
- Browser
- Timestamp
- Referrer

---

Architecture:

```
Redirect Request

↓

Event Queue

↓

Analytics Processor

↓

Data Warehouse
```

---

# 23. Avoid Blocking Redirects

Do not:

```
Redirect

↓

Write Analytics

↓

Return
```

Slow.

Instead:

```
Redirect

↓

Publish Event

↓

Return Immediately
```

---

# 24. Abuse Prevention

Problems:

- Spam links
- Malware URLs
- Phishing

Solutions:

- URL scanning
- Rate limiting
- Domain reputation checks
- Blacklists
- User verification

---

# 25. Custom Aliases

Example:

Default:

```
short.ly/aB91x
```

Custom:

```
short.ly/summer-sale
```

Need:

- Availability check
- Reserved words list

---

# 26. Scaling Redirect Traffic

Solutions:

## CDN

Cache redirects globally.

```
User

↓

CDN Edge

↓

Redirect
```

---

## Read Replicas

Database replicas handle reads.

---

## Multi-region Deployment

```
US Region

EU Region

Asia Region
```

---

# 27. Failure Handling

## Cache Failure

Fallback:

```
Cache

↓

Database
```

---

## Database Failure

Use:

- Replication
- Automatic failover

---

## ID Generator Failure

Use:

- Multiple generators
- Worker pools

---

# 28. Monitoring

Metrics:

## API

- Requests/sec
- Latency
- Error rate

## Redirects

- Redirect latency
- Cache hit ratio

## Database

- Query latency
- Storage usage

## Security

- Abuse attempts
- Invalid URLs

---

# 29. Real-World Architecture

Large-scale design:

```
Users

↓

Global Load Balancer

↓

Regional URL Services

↓

Redis Cache

↓

Distributed Database

↓

Analytics Pipeline
```

---

# 30. Interview Questions

## Q1. How do you generate unique short URLs?

Options:

- Base62 encoding
- Snowflake IDs
- Random generation
- Hashing

---

## Q2. How many URLs can Base62 support?

For length N:

```
62^N
```

Example:

7 characters:

```
62^7 ≈ 3.5 trillion
```

---

## Q3. How do you scale reads?

Use:

- Cache
- CDN
- Read replicas
- Regional deployment

---

## Q4. How do you prevent duplicate URLs?

Options:

- Hash original URL
- Store URL fingerprint
- Allow duplicates intentionally

---

## Q5. How do you handle billions of URLs?

Use:

- Sharding
- Distributed IDs
- Replication
- Cache layers

---

# 31. Best Practices

- Use Base62 encoding for compact IDs.
- Use distributed ID generation.
- Keep redirect path extremely fast.
- Cache popular URLs.
- Store analytics asynchronously.
- Use database sharding.
- Protect against malicious links.
- Monitor cache hit rate.
- Design for high read traffic.
- Use multi-region deployment.

---

# 32. Summary

A URL shortener is a read-heavy distributed system requiring extremely fast redirects, unique ID generation, scalable storage, caching, and asynchronous analytics. The core design challenge is generating compact unique identifiers while supporting billions of URLs and millions of redirects per second.

---

**Next: 30_Rate_Limiter_Design.md**

Topics:
- Rate limiting algorithms
- Token bucket
- Leaky bucket
- Fixed window
- Sliding window
- Distributed rate limiting
- Redis implementation
- API gateway integration
- Abuse prevention
- Global throttling
