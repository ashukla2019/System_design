# 26. Message Queue Design

> Designing a scalable distributed messaging system similar to Apache Kafka, RabbitMQ, Amazon SQS, Google Pub/Sub, and Apache Pulsar.

---

# Table of Contents

1. Introduction
2. Why Message Queues?
3. Requirements
4. High-Level Architecture
5. Core Components
6. Message Model
7. Producer Design
8. Consumer Design
9. Topics
10. Partitions
11. Message Ordering
12. Storage Design
13. Replication
14. Acknowledgements
15. Delivery Semantics
16. Consumer Groups
17. Offset Management
18. Retry Handling
19. Dead Letter Queue
20. Backpressure
21. Scaling
22. Failure Handling
23. Security
24. Monitoring
25. Real-world Systems
26. Interview Questions
27. Summary

---

# 1. Introduction

A message queue is a distributed system that allows applications to communicate asynchronously.

Instead of:

```
Service A

↓

Service B
```

Direct communication:

```
Service A

↓

Message Queue

↓

Service B
```

The producer and consumer become independent.

---

# 2. Why Message Queues?

Modern systems need:

- Asynchronous processing
- Traffic smoothing
- Fault isolation
- Event-driven architecture
- Decoupling services

Example:

E-commerce order flow:

```
Order Service

↓

Message Queue

↓

Payment Service

↓

Inventory Service

↓

Notification Service
```

---

# 3. Functional Requirements

The system should support:

- Publish messages
- Consume messages
- Store messages
- Deliver messages
- Retry failures
- Preserve ordering
- Scale horizontally
- Replicate data
- Handle failures

---

# 4. Non-Functional Requirements

Availability:

99.99%

Latency:

Milliseconds

Throughput:

Millions of messages/sec

Durability:

No message loss

Scalability:

Petabytes of events

---

# 5. High-Level Architecture

```
                Producers

                    |
                    |
             Message Broker

       +------------+------------+

       |            |            |

    Topic A      Topic B      Topic C

       |            |            |

   Consumer     Consumer     Consumer
```

---

# 6. Core Components

## Producer

Creates messages.

Responsibilities:

- Serialization
- Routing
- Partition selection
- Retry handling

---

## Broker

The message server.

Responsibilities:

- Store messages
- Replicate data
- Manage consumers
- Handle delivery

---

## Consumer

Reads messages.

Responsibilities:

- Processing
- Acknowledgement
- Offset management

---

# 7. Message Model

A message contains:

```
{
 id,
 key,
 payload,
 timestamp,
 headers,
 partition,
 offset
}
```

Example:

```
OrderCreated

{
 orderId:12345,
 customerId:100
}
```

---

# 8. Topics

A topic is a logical stream of messages.

Example:

```
orders

payments

notifications
```

Messages are appended to topics.

---

# 9. Partitions

Large topics are split into partitions.

Example:

```
Topic: Orders


Partition 0

Partition 1

Partition 2
```

Each partition is an ordered log.

---

# 10. Partitioning Strategy

## Hash Based

```
hash(message.key)

↓

partition
```

Example:

```
Customer ID

↓

Same customer always goes to same partition
```

Maintains ordering.

---

## Round Robin

```
Message1 → P0

Message2 → P1

Message3 → P2
```

Better distribution.

---

# 11. Message Ordering

Ordering is usually guaranteed only within a partition.

Example:

Partition:

```
Message 1

Message 2

Message 3
```

Order preserved.

Across partitions:

```
P0

Message A

P1

Message B
```

No global ordering.

---

# 12. Storage Design

Kafka-style storage:

```
Topic

↓

Partition

↓

Segment Files

↓

Messages
```

Messages are append-only.

---

# 13. Log Structure

Example:

```
Offset

0  Event A

1  Event B

2  Event C

3  Event D
```

Consumers track their current offset.

---

# 14. Retention Policy

Messages are removed based on:

## Time

Example:

```
Keep 7 days
```

---

## Size

Example:

```
Keep latest 500 GB
```

---

## Compaction

Keep latest value per key.

Example:

```
User123

Version1

Version2

Version3
```

Only latest survives.

---

# 15. Replication

Partitions are replicated.

Example:

Replication Factor = 3

```
Leader

↓

Follower 1

↓

Follower 2
```

Leader handles writes.

Followers replicate.

---

# 16. Producer Write Flow

```
Producer

↓

Select Partition

↓

Send Message

↓

Leader Broker

↓

Replicate

↓

ACK
```

---

# 17. Consumer Read Flow

```
Consumer

↓

Request Messages

↓

Broker

↓

Return Batch

↓

Process

↓

Commit Offset
```

---

# 18. Acknowledgement Modes

## Fire and Forget

Producer sends message.

No confirmation.

Fast but unsafe.

---

## Synchronous ACK

```
Send

↓

Wait

↓

Success
```

Higher reliability.

---

## Asynchronous ACK

Send multiple messages.

Receive callbacks later.

---

# 19. Delivery Semantics

## At Most Once

Message delivered zero or one time.

Possible loss.

```
Send

↓

Commit Offset

↓

Process
```

---

## At Least Once

Message may be delivered multiple times.

```
Process

↓

ACK

```

Most common.

Requires idempotency.

---

## Exactly Once

Message processed once.

Requires:

- Transaction support
- Idempotent producers
- Deduplication

---

# 20. Consumer Groups

Multiple consumers share workload.

Example:

```
Topic

Partition0

Partition1

Partition2


Consumer A → P0

Consumer B → P1

Consumer C → P2
```

---

# 21. Offset Management

Offset represents consumer progress.

Example:

```
Partition

0

1

2

3

4

^

Current Offset
```

Stored in:

- Broker
- External database

---

# 22. Consumer Rebalancing

When consumers change:

```
Consumer joins

↓

Partitions redistributed
```

Example:

Before:

```
A → P0,P1

B → P2
```

After:

```
A → P0

B → P1

C → P2
```

---

# 23. Retry Handling

Failed message:

```
Consumer

↓

Processing Error

↓

Retry Queue

↓

Process Again
```

Strategies:

- Immediate retry
- Delayed retry
- Exponential backoff

---

# 24. Dead Letter Queue (DLQ)

Messages that permanently fail go to DLQ.

Example:

```
Main Queue

↓

Failed 5 times

↓

Dead Letter Queue
```

Used for:

- Debugging
- Manual processing
- Investigation

---

# 25. Backpressure

Problem:

Producer faster than consumer.

Example:

```
Producer

100K msg/sec


Consumer

10K msg/sec
```

Queue grows.

Solutions:

- Rate limiting
- Consumer scaling
- Batching
- Load shedding

---

# 26. Message Batching

Instead of:

```
Send

Send

Send
```

Use:

```
Batch

↓

Send
```

Benefits:

- Higher throughput
- Lower network overhead

---

# 27. Scaling Strategy

Increase:

## Brokers

```
10

↓

100
```

---

## Partitions

```
100

↓

10000
```

---

## Consumers

```
10

↓

1000
```

---

# 28. Failure Handling

## Broker Failure

```
Leader Failure

↓

Elect New Leader

↓

Continue Processing
```

---

## Consumer Failure

```
Consumer Dies

↓

Rebalance

↓

Another Consumer Takes Partition
```

---

## Network Failure

Use:

- Retries
- Timeouts
- Replication
- Idempotency

---

# 29. Security

Authentication:

- TLS
- SASL
- OAuth

Authorization:

- Topic permissions
- ACLs
- RBAC

Encryption:

- Data in transit
- Data at rest

---

# 30. Monitoring

Important metrics:

## Broker

- Disk usage
- Network throughput
- CPU
- Memory

## Messages

- Publish rate
- Consume rate
- Queue depth
- Lag

## Consumers

- Consumer lag
- Processing latency
- Error rate

## Reliability

- Failed deliveries
- Retries
- DLQ size
- Replication status

---

# 31. Real-world Systems

## Apache Kafka

Features:

- Distributed commit log
- Partitioned topics
- Consumer groups
- Exactly-once processing
- High throughput

Used for:

- Event streaming
- Analytics
- Logs

---

## RabbitMQ

Features:

- AMQP protocol
- Routing keys
- Exchanges
- Queues
- Flexible messaging

Used for:

- Task queues
- Enterprise messaging

---

## Amazon SQS

Features:

- Fully managed
- Automatic scaling
- Standard and FIFO queues
- Dead-letter queues

---

## Google Pub/Sub

Features:

- Global messaging
- Push and pull subscriptions
- Automatic scaling

---

## Apache Pulsar

Features:

- Multi-tenancy
- Separate compute/storage
- Geo-replication
- Tiered storage

---

# 32. Kafka vs RabbitMQ

|Feature|Kafka|RabbitMQ|
|-|-|-|
|Model|Log streaming|Queue messaging|
|Throughput|Very high|High|
|Ordering|Partition based|Queue based|
|Retention|Long-term|Usually consumed|
|Replay|Excellent|Limited|
|Best For|Events|Tasks|

---

# 33. Interview Questions

## Q1. Why use a message queue?

To decouple services, handle traffic spikes, and enable asynchronous processing.

---

## Q2. How does Kafka achieve high throughput?

- Sequential disk writes
- Partition parallelism
- Batching
- Zero-copy transfer
- Compression

---

## Q3. How do you guarantee ordering?

Use:

- Same partition key
- Single partition consumer
- Ordered processing

---

## Q4. How do you avoid duplicate processing?

Use:

- Idempotent consumers
- Unique message IDs
- Deduplication tables
- Exactly-once transactions

---

## Q5. What happens when a consumer crashes?

The broker detects failure and reassigns partitions to healthy consumers.

---

# 34. Best Practices

- Design messages to be immutable.
- Use idempotent consumers.
- Monitor consumer lag.
- Use retries with exponential backoff.
- Keep messages small.
- Use batching for throughput.
- Use DLQ for poison messages.
- Partition based on workload.
- Choose retention based on business needs.
- Monitor broker disk growth.

---

# 35. Summary

A distributed message queue provides reliable asynchronous communication between services. It achieves scalability through partitioning, durability through replication, and reliability through acknowledgements, retries, and consumer coordination. Systems like Kafka, RabbitMQ, SQS, Pub/Sub, and Pulsar use different approaches depending on whether the primary requirement is event streaming, task distribution, or enterprise messaging.

---

**Next: 27_Search_Engine_Design.md**

Topics:
- Web crawler
- Document indexing
- Inverted index
- Tokenization
- Ranking algorithms
- TF-IDF
- BM25
- Query processing
- Distributed indexing
- Sharding
- Elasticsearch architecture
- Search ranking pipeline
