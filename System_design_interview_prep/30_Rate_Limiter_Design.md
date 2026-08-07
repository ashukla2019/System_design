# 30. Rate Limiter Design

> Designing a scalable distributed rate limiting system similar to those used in API gateways, cloud platforms, and large-scale internet services.

---

# Table of Contents

1. Introduction
2. Why Rate Limiting?
3. Requirements
4. High-Level Architecture
5. Rate Limiting Models
6. Fixed Window Algorithm
7. Sliding Window Algorithm
8. Sliding Window Log
9. Token Bucket Algorithm
10. Leaky Bucket Algorithm
11. Comparison of Algorithms
12. Distributed Rate Limiting
13. Redis-Based Design
14. API Gateway Integration
15. User-Based Limits
16. IP-Based Limits
17. Global Rate Limits
18. Handling Bursts
19. Failure Handling
20. Scaling
21. Monitoring
22. Security
23. Real-World Systems
24. Interview Questions
25. Summary

---

# 1. Introduction

A rate limiter controls how many requests a client can make within a given period.

Example:

```
User

↓

100 requests/minute allowed
```

Additional requests:

```
429 Too Many Requests
```

---

# 2. Why Rate Limiting?

Rate limiting protects systems from:

- Abuse
- DDoS attacks
- Excessive traffic
- Resource exhaustion
- Cost overruns

Examples:

- API limits
- Login attempts
- Payment APIs
- Search APIs

---

# 3. Functional Requirements

The system should:

- Track request counts
- Allow valid requests
- Reject excessive requests
- Support multiple users
- Work across servers
- Provide low latency

---

# 4. Non-Functional Requirements

Latency:

<1 ms overhead

Availability:

99.99%

Scale:

Millions of requests/sec

Accuracy:

Predictable limits

---

# 5. High-Level Architecture

```
                 Client

                   |

             API Gateway

                   |

            Rate Limiter

                   |

        +----------+----------+

        |                     |

      Redis              Backend Services
```

---

# 6. Rate Limiting Dimensions

Limits can be applied by:

## User

Example:

```
User123

1000 requests/hour
```

---

## IP Address

Example:

```
1.2.3.4

100 requests/minute
```

---

## API Endpoint

Example:

```
/login

5 attempts/minute
```

---

## Application Key

Example:

```
API Key ABC

10000 requests/day
```

---

# 7. Fixed Window Algorithm

Simplest approach.

Example:

Limit:

```
100 requests/minute
```

Window:

```
12:00:00 - 12:00:59
```

Counter:

```
Requests = 80
```

Allow.

---

## Implementation

Store:

```
user_id

+

current_minute

+

count
```

Example:

```
user123:1200

count=50
```

---

## Advantages

- Simple
- Fast
- Low memory

---

## Disadvantages

Boundary problem.

Example:

```
12:00:59

100 requests


12:01:00

100 requests
```

200 requests in 2 seconds.

---

# 8. Sliding Window Algorithm

Provides smoother limiting.

Combines previous and current windows.

Formula:

```
Requests =
Previous Window Weight

+

Current Window Count
```

---

Example:

Limit:

```
100/min
```

At:

```
12:01:30
```

Consider:

```
12:00:30 - 12:01:30
```

---

# 9. Sliding Window Log

Stores every request timestamp.

Example:

```
[
12:00:01,

12:00:05,

12:00:10
]
```

For every request:

1. Remove expired timestamps.
2. Count remaining.
3. Allow or reject.

---

## Advantages

Very accurate.

---

## Disadvantages

High memory usage.

---

# 10. Token Bucket Algorithm

Most commonly used.

Concept:

A bucket contains tokens.

Example:

```
Capacity = 100 tokens

Refill = 10 tokens/sec
```

Each request consumes:

```
1 token
```

---

Example:

```
Bucket

100 tokens

↓

Request

↓

99 tokens
```

---

If:

```
Tokens = 0
```

Request rejected.

---

## Advantages

- Handles bursts
- Memory efficient
- Flexible

---

# 11. Leaky Bucket Algorithm

Requests enter a bucket.

They leave at a fixed rate.

Example:

```
Incoming:

1000 req/sec


Output:

100 req/sec
```

Excess requests are dropped.

---

## Advantages

Smooth traffic.

---

## Disadvantages

Cannot handle large bursts.

---

# 12. Algorithm Comparison

|Algorithm|Accuracy|Burst Support|Memory|
|-|-|-|-|
|Fixed Window|Low|Good|Low|
|Sliding Window Log|High|Good|High|
|Sliding Window Counter|Medium|Good|Medium|
|Token Bucket|High|Excellent|Low|
|Leaky Bucket|High|Limited|Low|

---

# 13. Distributed Rate Limiting

Problem:

Multiple application servers.

Example:

```
Server A

100 requests


Server B

100 requests
```

Total:

```
200 requests
```

Limit broken.

---

Solution:

Centralized state.

```
Servers

↓

Redis

↓

Rate Limit State
```

---

# 14. Redis-Based Design

Redis stores counters.

Example:

Key:

```
rate:user123
```

Value:

```
75
```

TTL:

```
60 seconds
```

---

Request flow:

```
Request

↓

Redis INCR

↓

Check Limit

↓

Allow / Reject
```

---

# 15. Atomic Operations

Problem:

Two servers update simultaneously.

Solution:

Use:

- Redis Lua scripts
- Atomic commands

Example:

```
Check

+

Increment

+

Expire
```

as one operation.

---

# 16. Token Bucket with Redis

Store:

```
tokens

last_refill_time
```

Example:

```
{
 tokens:50,
 timestamp:123456
}
```

Algorithm:

```
New Tokens

=

Elapsed Time × Refill Rate
```

---

# 17. API Gateway Integration

Architecture:

```
Client

↓

API Gateway

↓

Authentication

↓

Rate Limiter

↓

Service
```

Benefits:

- Central control
- Protects backend
- Consistent policies

---

# 18. User-Based Limits

Example:

Free User:

```
100 requests/day
```

Premium User:

```
10000 requests/day
```

Store:

```
user_plan

limit

current_usage
```

---

# 19. IP-Based Limits

Useful for:

- Anonymous users
- Login protection
- Public APIs

Example:

```
IP:

10 requests/minute
```

Challenges:

- NAT users
- Shared networks

---

# 20. Global Rate Limiting

For worldwide systems:

```
US Region

EU Region

Asia Region
```

Need:

- Global counters
- Regional synchronization

Options:

## Central Store

Simple but higher latency.

---

## Local + Global Limits

Example:

```
Local limit:

100/sec


Global limit:

10000/sec
```

---

# 21. Handling Bursts

Real traffic is not uniform.

Example:

```
Normal:

100 req/sec


Sudden spike:

10000 req/sec
```

Solutions:

- Token bucket
- Queue buffering
- Backpressure
- Priority handling

---

# 22. Failure Handling

## Redis Failure

Options:

### Fail Open

Allow requests.

Pros:

- Availability

Cons:

- Abuse possible

---

### Fail Closed

Reject requests.

Pros:

- Protection

Cons:

- Service unavailable

---

Decision depends on system criticality.

---

# 23. Scaling Rate Limiters

Strategies:

## Horizontal Scaling

Multiple limiter nodes.

---

## Partition State

Example:

```
hash(user_id)

↓

Redis shard
```

---

## Local Caching

Store temporary counters locally.

---

# 24. Monitoring

Metrics:

## Traffic

- Requests/sec
- Rejected requests

## Performance

- Latency
- Redis latency

## Usage

- Top users
- Top APIs

## Security

- Abuse attempts
- Attack patterns

---

# 25. Security

Rate limiting protects against:

- Brute-force attacks
- API abuse
- Scraping
- Credential stuffing

Combine with:

- CAPTCHA
- IP reputation
- Authentication
- WAF

---

# 26. Real-World Systems

## AWS API Gateway

Features:

- Throttling
- Usage plans
- API keys

---

## Cloudflare Rate Limiting

Features:

- Edge enforcement
- DDoS protection
- Bot protection

---

## Envoy Rate Limiting

Features:

- Distributed rate limiting
- Service mesh integration

---

# 27. Interview Questions

## Q1. Why do we need distributed rate limiting?

Because requests are distributed across multiple servers and a local counter cannot enforce a global limit.

---

## Q2. Token bucket vs leaky bucket?

|Token Bucket|Leaky Bucket|
|-|-|
|Allows bursts|Smooth output|
|Flexible|Fixed rate|
|Common for APIs|Traffic shaping|

---

## Q3. Where should rate limiting happen?

Usually:

```
Client

↓

API Gateway

↓

Service
```

before expensive processing.

---

## Q4. How do you make Redis rate limiting accurate?

Use:

- Atomic operations
- Lua scripts
- Proper TTL handling

---

## Q5. What happens during limiter failure?

Choose:

- Fail open
- Fail closed

based on business requirements.

---

# 28. Best Practices

- Apply limits at the edge.
- Use token bucket for APIs.
- Store counters centrally.
- Use atomic operations.
- Monitor rejected requests.
- Provide clear error responses.
- Use different limits for user tiers.
- Protect authentication endpoints.
- Design for distributed deployment.
- Test under traffic spikes.

---

# 29. Summary

A rate limiter is a critical distributed component that protects services from excessive traffic while maintaining fair resource usage. Algorithms such as token bucket, sliding window, and leaky bucket provide different trade-offs between accuracy, memory usage, and burst handling. Large-scale systems typically combine API gateways, Redis-backed counters, distributed state management, and adaptive policies to enforce limits across millions of users.

---

**Next: 31_Monitoring_and_Logging_System.md**

Topics:
- Metrics collection
- Logs architecture
- Distributed tracing
- Time-series databases
- Alerting
- Prometheus architecture
- Grafana dashboards
- ELK stack
- OpenTelemetry
- SLO/SLA monitoring
- Large-scale observability platforms
