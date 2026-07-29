# NoSQL Interview Notes for Senior Embedded Developers

## Overview

NoSQL means:

> Not Only SQL

NoSQL databases are designed for:

- Large-scale distributed systems
- High-speed data ingestion
- Flexible schemas
- Massive amounts of unstructured or semi-structured data

For senior embedded developers, NoSQL is important for:

- IoT telemetry
- Device data storage
- Edge computing
- Sensor streams
- Offline-first applications
- Cloud-connected devices

---

# 1. Why NoSQL?

Traditional SQL databases have:

```
Fixed Schema
     |
Tables
     |
Rows
     |
Relationships
```

This works well for:

- Banking
- ERP systems
- Transaction-heavy applications


But modern systems generate:

- Sensor data
- Logs
- Events
- Device telemetry
- JSON messages

Example:

```json
{
 "deviceId":101,
 "temperature":25.5,
 "battery":80,
 "location":"Pune"
}
```

The structure may change frequently.

NoSQL provides:

- Flexible schema
- High scalability
- Fast writes

---

# 2. SQL vs NoSQL

| SQL | NoSQL |
|-|-|
| Relational | Non-relational |
| Tables | Documents/Key-value/Graphs |
| Fixed schema | Flexible schema |
| Strong relationships | Less relationship dependency |
| Vertical scaling | Horizontal scaling |
| ACID transactions | BASE consistency |
| Complex joins | Application-level relationships |

---

# 3. Types of NoSQL Databases

NoSQL databases are mainly divided into:

```
NoSQL
 |
 |---- Key Value
 |
 |---- Document
 |
 |---- Column Family
 |
 |---- Graph
```

---

# 4. Key-Value Database

## Concept

Stores data as:

```
Key → Value
```

Example:

```
device:101

{
 temperature:25,
 battery:90
}
```

---

## Examples

- Redis
- Amazon DynamoDB

---

## Advantages

- Extremely fast
- Simple model
- High scalability

---

## Use Cases

Embedded examples:

- Device configuration
- Cache
- Session storage
- Latest sensor value


Example:

```
Key:

device_101_temperature


Value:

25.5
```

---

# 5. Document Database

## Concept

Stores data as documents.

Usually JSON format.

Example:

```json
{
 "deviceId":101,

 "sensor":{
     "temperature":25.5,
     "voltage":3.3
 },

 "status":"ACTIVE"
}
```

---

## Examples

- MongoDB
- CouchDB

---

## Advantages

- Flexible schema
- Natural object representation
- Easy application mapping

---

## Embedded Use Cases

Device metadata:

```json
{
 "serial":"ABC123",
 "model":"Sensor-X",
 "firmware":"1.2.0",
 "features":[
    "temperature",
    "pressure"
 ]
}
```

---

# 6. Column Family Database

## Concept

Stores data in column groups.

Example:

```
Device Table


device_id

101


temperature

25.5


timestamp

123456
```

---

## Examples

- Cassandra
- HBase

---

## Advantages

- Massive write scalability
- Good for time-series data

---

## Use Cases

IoT:

```
Millions of devices

Millions of readings/sec
```

---

# 7. Graph Database

## Concept

Stores:

```
Nodes
 |
Relationships
 |
Edges
```

Example:

```
Device

 |
connected_to

 |

Gateway

 |
connected_to

 |

Cloud
```

---

## Examples

- Neo4j

---

## Use Cases

- Network topology
- Device relationships
- Dependency analysis

---

# 8. CAP Theorem

Very important interview topic.

CAP means:

```
C → Consistency

A → Availability

P → Partition Tolerance
```

A distributed system can guarantee only two strongly.

---

## Consistency

Every read gets latest data.

Example:

```
Write temperature = 30

All nodes return 30
```

---

## Availability

System always responds.

---

## Partition Tolerance

System continues working even if network fails.

---

## Examples

### CP System

Prioritize:

- Consistency
- Partition tolerance

Example:

Banking systems


### AP System

Prioritize:

- Availability
- Partition tolerance

Example:

IoT telemetry systems

---

# 9. BASE Model

Many NoSQL systems follow BASE.

BASE:

```
Basically Available

Soft state

Eventually consistent
```

---

## Basically Available

System responds even during failures.

---

## Soft State

Data may change over time.

---

## Eventually Consistent

All replicas become consistent eventually.

Example:

```
Device sends temperature

Server A:
25

Server B:
24

After replication:

Both:
25
```

---

# 10. Schema Design in NoSQL

SQL:

Design tables first.

NoSQL:

Design based on queries.

---

Example:

Question:

"Show latest temperature for device"


Store:

```json
{
 deviceId:101,
 latestTemperature:25.5
}
```

instead of:

```
Millions of historical records lookup
```

---

# 11. Denormalization

SQL:

Avoid duplicate data.

NoSQL:

Often duplicates data for speed.

Example:

Instead of:

```
Device

device_id


Location

location_id
```

Store:

```json
{
 deviceId:101,

 location:{
   city:"Pune"
 }
}
```

Advantages:

- Faster reads
- Less joins

---

# 12. Replication

Replication means copying data.

Example:

```
Primary Database

       |
       |
----------------

Replica 1

Replica 2
```

Benefits:

- High availability
- Disaster recovery

---

# 13. Sharding

Sharding divides data across servers.

Example:

Without sharding:

```
One database

1 billion records
```

With sharding:

```
Server A
Device 1-1M


Server B
Device 1M-2M
```

---

Advantages:

- Horizontal scaling
- Faster writes

---

# 14. Indexing in NoSQL

Indexes improve lookup speed.

Example:

MongoDB:

```javascript
db.devices.createIndex(
{
 deviceId:1
})
```

Without index:

```
Scan all documents
```

With index:

```
Direct lookup
```

---

# 15. Redis for Embedded Systems

Redis is a key-value database.

Architecture:

```
Application

    |

 Redis

    |

Memory
```

Advantages:

- Very fast
- In-memory
- Simple commands

Use cases:

- Cache
- Latest sensor values
- Device state

Example:

```
SET device101_temperature 25.5
```

---

# 16. MongoDB Basics

MongoDB stores:

```
Database

 |
Collection

 |
Document
```

Example:

```json
{
"name":"Sensor-A",
"value":25
}
```

Operations:

Insert:

```javascript
db.sensor.insertOne(
{
temperature:25
})
```

Query:

```javascript
db.sensor.find()
```

---

# 17. Cassandra for IoT

Cassandra is designed for:

- Huge write volume
- Distributed systems

Architecture:

```
Device

 |

Cassandra Cluster

 |

Multiple Nodes
```

Good for:

- Sensor history
- Logs
- Time-series data

---

# 18. Time-Series Databases

Designed for timestamp data.

Example:

```
Timestamp

Temperature

Voltage

Pressure
```

Examples:

- InfluxDB
- TimescaleDB

---

IoT example:

```
Device

10 readings/sec

1 million devices

```

Traditional database may struggle.

---

# 19. NoSQL Security

Important:

## Authentication

Verify users/devices.

---

## Authorization

Control permissions.

---

## Encryption

Protect stored data.

---

## Input Validation

Prevent injection attacks.

---

# 20. NoSQL Reliability in Embedded Systems

Important considerations:

## Limited Storage

Solutions:

- Data compression
- Retention policies
- Aggregation


Example:

Store:

```
Average temperature every minute

instead of

every millisecond value
```

---

## Network Failure

Solutions:

- Local buffering
- Retry queues
- Synchronization later

Example:

```
Device Offline

     |

Store locally

     |

Upload when connected
```

---

# 21. SQL + NoSQL Hybrid Architecture

Many systems use both.

Example:

```
Device

 |
 |
 +---- SQLite
 |      |
 |      Local configuration
 |
 |
 +---- NoSQL Cloud
        |
        Telemetry data
```

---

# 22. Common Senior Interview Questions

---

## Q1. Why use NoSQL instead of SQL?

Answer:

> NoSQL is preferred when applications need flexible schemas, high write throughput, horizontal scaling, and distributed storage.

---

## Q2. Difference between SQL and MongoDB?

SQL:

```
Tables
Rows
Columns
```

MongoDB:

```
Collections
Documents
Fields
```

---

## Q3. What is sharding?

Answer:

> Sharding divides data across multiple servers to support horizontal scalability.

---

## Q4. What is replication?

Answer:

> Replication maintains copies of data on multiple nodes for availability and fault tolerance.

---

## Q5. Explain CAP theorem.

Answer:

> In a distributed system, during a network partition, we must choose between consistency and availability.

---

# Senior Embedded Developer NoSQL Checklist

## Fundamentals

- NoSQL concepts
- SQL vs NoSQL
- Schema design

## Database Types

- Key-value
- Document
- Column family
- Graph

## Distributed Systems

- CAP theorem
- BASE model
- Replication
- Sharding

## Embedded Use Cases

- IoT telemetry
- Device state storage
- Offline synchronization
- Sensor data management

## Performance

- Indexing
- Data modeling
- Query patterns

## Reliability

- Failure handling
- Data retention
- Synchronization

---

# Final Interview Focus

For Senior Embedded Developers, prioritize:

1. NoSQL data modeling
2. CAP theorem
3. Replication
4. Sharding
5. IoT telemetry storage
6. Time-series databases
7. Offline device synchronization
8. Redis usage
9. MongoDB document design
10. Choosing SQL vs NoSQL correctly
