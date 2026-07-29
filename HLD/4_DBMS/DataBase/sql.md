# SQL Interview Notes for Senior Embedded Developers

## Overview

SQL (**Structured Query Language**) is used to:

- Store data
- Retrieve data
- Update data
- Delete data
- Manage relational databases

For senior embedded developers, SQL interviews usually focus on:

- Database fundamentals
- Query optimization
- Storage design
- Transactions
- Indexing
- Concurrency
- SQLite usage
- Designing data storage for embedded systems

---

# 1. SQL Fundamentals

## What is SQL?

SQL is a language used to communicate with relational databases.

Example:

```sql
SELECT *
FROM sensors;
```

This retrieves all records from the `sensors` table.

---

# 2. Relational Database Concepts

A relational database organizes data into:

```
Database
   |
   ├── Tables
   |      |
   |      ├── Rows (Records)
   |      |
   |      └── Columns (Attributes)
```

Example:

### Device Table

| device_id | model | status |
|-----------|-------|--------|
| 101 | Sensor-A | Active |
| 102 | Sensor-B | Offline |

---

# 3. Primary Key

A primary key uniquely identifies each row.

Example:

```sql
CREATE TABLE devices
(
    device_id INT PRIMARY KEY,
    model VARCHAR(50)
);
```

Properties:

- Unique
- Cannot be NULL
- Usually indexed automatically

Embedded examples:

- Device ID
- MAC address
- Serial number

---

# 4. Foreign Key

A foreign key creates relationships between tables.

Example:

Device table:

| device_id |
|-----------|
|101|
|102|

Sensor readings:

|reading_id|device_id|value|
|-|-|-|
|1|101|25.5|
|2|101|26.1|

Relationship:

```
Device
  |
  |
Sensor Reading
```

SQL:

```sql
CREATE TABLE readings
(
    id INT PRIMARY KEY,
    device_id INT,
    value FLOAT,

    FOREIGN KEY(device_id)
    REFERENCES devices(device_id)
);
```

---

# 5. SQL Command Categories

## DDL (Data Definition Language)

Defines database structure.

Commands:

```
CREATE
ALTER
DROP
TRUNCATE
```

Example:

```sql
CREATE TABLE logs
(
    id INT,
    message VARCHAR(100)
);
```

---

## DML (Data Manipulation Language)

Changes data.

Commands:

```
INSERT
UPDATE
DELETE
```

Example:

```sql
INSERT INTO devices
VALUES(101,'Sensor-A');
```

---

## DQL (Data Query Language)

Reads data.

Command:

```
SELECT
```

Example:

```sql
SELECT *
FROM devices;
```

---

# 6. SELECT Queries

## Select specific columns

```sql
SELECT model
FROM devices;
```

---

## Filtering

```sql
SELECT *
FROM devices
WHERE status='Active';
```

---

## Sorting

```sql
SELECT *
FROM devices
ORDER BY device_id DESC;
```

---

## Limit results

```sql
SELECT *
FROM logs
LIMIT 10;
```

Useful for embedded logs.

---

# 7. SQL Joins

Joins combine data from multiple tables.

---

## INNER JOIN

Returns matching records.

Example:

```sql
SELECT 
d.model,
r.value

FROM devices d

INNER JOIN readings r

ON d.device_id=r.device_id;
```

Output:

```
Sensor-A 25.5
Sensor-A 26.1
```

---

## LEFT JOIN

Returns all records from the left table.

Example:

```sql
SELECT *
FROM devices d

LEFT JOIN readings r

ON d.device_id=r.device_id;
```

Used to find devices without readings.

---

# 8. Indexing

## Why use indexes?

Without index:

```
1 million records

Search
 |
Scan every row
```

With index:

```
Index
 |
Direct lookup
```

Create index:

```sql
CREATE INDEX idx_device
ON readings(device_id);
```

---

## Advantages

- Faster SELECT queries
- Faster searching

## Disadvantages

- Requires storage
- Slows INSERT/UPDATE operations

Because indexes must also be updated.

---

# 9. Query Optimization

Avoid:

```sql
SELECT *
FROM logs;
```

Better:

```sql
SELECT timestamp,message
FROM logs
WHERE device_id=101;
```

Reasons:

- Less data transfer
- Less memory usage
- Faster execution

---

# 10. Transactions

A transaction is a group of SQL operations executed as one unit.

Example:

Bank transfer:

```
Account A
-100

Account B
+100
```

Either everything succeeds or everything fails.

Example:

```sql
BEGIN;

UPDATE account
SET balance=balance-100;

UPDATE account
SET balance=balance+100;

COMMIT;
```

Failure:

```sql
ROLLBACK;
```

---

# 11. ACID Properties

## Atomicity

All operations succeed or none succeed.

Example:

```
Debit successful
Credit failed

Rollback
```

---

## Consistency

Database remains valid.

Example:

- No duplicate primary keys
- Constraints maintained

---

## Isolation

Transactions do not interfere with each other.

Example:

```
Transaction A updating data

Transaction B reading data
```

---

## Durability

Committed data survives failures.

Example:

```
Power failure

Data remains stored
```

---

# 12. Database Normalization

Purpose:

- Remove duplicate data
- Improve consistency

---

## Bad Design

```
Device

device_id
owner
owner_phone
owner_address
```

Owner data repeats.

---

## Better Design

Device table:

```
device_id
owner_id
```

Owner table:

```
owner_id
phone
address
```

---

# 13. Normal Forms

## 1NF

Atomic values.

Wrong:

```
Phone:
123,456
```

Correct:

```
Phone1
Phone2
```

---

## 2NF

Remove partial dependencies.

---

## 3NF

Remove transitive dependencies.

Interview answer:

> Normalization reduces redundancy and improves data consistency.

---

# 14. SQL vs NoSQL

| SQL | NoSQL |
|-|-|
| Tables | Documents |
| Fixed schema | Flexible schema |
| Strong consistency | Eventual consistency |
| Complex queries | High scalability |

---

## Embedded Examples

SQL:

```
Device
 |
Configuration
 |
Calibration
```

NoSQL:

```json
{
 "device":101,
 "temperature":25.5,
 "timestamp":123456
}
```

---

# 15. SQLite for Embedded Systems

SQLite architecture:

```
Application
     |
 SQLite Library
     |
 Database File
     |
 Flash Storage
```

Advantages:

- No database server required
- Small footprint
- ACID transactions
- Single file database

Used in:

- IoT devices
- Automotive systems
- Mobile devices

---

# 16. Embedded Database Design

## Sensor Data Storage

Example table:

```
Sensor_Data

id
device_id
timestamp
temperature
voltage
status
```

Index:

```sql
CREATE INDEX idx_time
ON Sensor_Data(timestamp);
```

---

# 17. Handling Limited Storage

Techniques:

- Delete old records
- Compress data
- Store aggregated values
- Circular buffers
- Data retention policies

Example:

```
Keep last 30 days data

Delete older records
```

---

# 18. SQL Security

## SQL Injection

Bad:

```cpp
query =
"SELECT * FROM user WHERE name='"
+ input;
```

Problem:

User input can modify SQL commands.

Solution:

Use:

- Prepared statements
- Parameterized queries

---

# 19. Common Senior Interview Questions

---

## DELETE vs TRUNCATE vs DROP

|Command|Purpose|Rollback|
|-|-|-|
|DELETE|Remove rows|Yes|
|TRUNCATE|Remove all rows|Usually no|
|DROP|Remove complete table|No|

---

## WHERE vs HAVING

WHERE:

- Filters rows before grouping

HAVING:

- Filters after GROUP BY

Example:

```sql
SELECT device_id,COUNT(*)

FROM readings

GROUP BY device_id

HAVING COUNT(*) > 100;
```

---

## Clustered vs Non-Clustered Index

Clustered:

```
Data stored physically according to index
```

Non-clustered:

```
Separate index pointing to actual data
```

---

## Debugging Slow SQL Queries

Steps:

### 1. Check execution plan

```sql
EXPLAIN QUERY PLAN
SELECT *
FROM readings;
```

### 2. Check indexes

### 3. Reduce unnecessary columns

### 4. Optimize joins

### 5. Improve schema design

---

# Senior Embedded Developer SQL Checklist

Before interview, prepare:

## SQL Basics

- SELECT
- INSERT
- UPDATE
- DELETE
- Joins

## Database Design

- Primary keys
- Foreign keys
- Normalization

## Performance

- Indexing
- Query optimization
- Execution plans

## Reliability

- Transactions
- ACID properties
- Recovery

## Embedded Specific

- SQLite architecture
- Flash storage limitations
- Sensor data storage
- Log management
- Data retention strategies

## Security

- SQL Injection
- Prepared statements

---

# Final Interview Focus

For a Senior Embedded Developer, prioritize:

1. SQLite internals
2. Transactions
3. Indexing
4. Query optimization
5. Storing telemetry/log data efficiently
6. Handling limited storage
7. Database reliability after power failures
8. Data consistency in embedded systems
