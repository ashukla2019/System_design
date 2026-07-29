# SQL Interview Notes for Senior Embedded Developers

## Overview

SQL (**Structured Query Language**) is used to:

- Store data
- Retrieve data
- Update data
- Delete data
- Manage relational databases

For senior embedded developers, SQL interviews focus on:

- SQL fundamentals
- Database design
- Query optimization
- Indexing
- Transactions
- Concurrency
- SQLite internals
- Data storage design for embedded systems
- Reliability during failures

---

# 1. SQL Fundamentals

## What is SQL?

SQL is a language used to communicate with relational databases.

Example:

```sql
SELECT *
FROM sensors;
```

This retrieves all sensor records.

---

# 2. Relational Database Concepts

A relational database organizes data as:

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

## Device Table

| device_id | model | status |
|-----------|-------|--------|
| 101 | Sensor-A | Active |
| 102 | Sensor-B | Offline |

---

# 3. SQL Command Categories

SQL commands are divided into five categories:

```
SQL Commands
     |
     ├── DDL  → Data Definition Language
     |
     ├── DML  → Data Manipulation Language
     |
     ├── DQL  → Data Query Language
     |
     ├── DCL  → Data Control Language
     |
     └── TCL  → Transaction Control Language
```

---

# 4. DDL - Data Definition Language

## Purpose

Defines and modifies database structure.

Commands:

| Command | Purpose |
|-|-|
| CREATE | Create database objects |
| ALTER | Modify existing objects |
| DROP | Delete objects |
| TRUNCATE | Remove all rows |

---

## CREATE

```sql
CREATE TABLE devices
(
    device_id INT PRIMARY KEY,
    model VARCHAR(50)
);
```

Creates:

```
devices table

device_id
model
```

---

## ALTER

Add a column:

```sql
ALTER TABLE devices
ADD status VARCHAR(20);
```

---

## DROP

Deletes complete object:

```sql
DROP TABLE devices;
```

---

## TRUNCATE

Deletes all rows but keeps structure:

```sql
TRUNCATE TABLE devices;
```

---

# 5. DML - Data Manipulation Language

## Purpose

Works with data inside tables.

Commands:

| Command | Purpose |
|-|-|
| INSERT | Add data |
| UPDATE | Modify data |
| DELETE | Remove data |

---

## INSERT

```sql
INSERT INTO devices
VALUES
(101,'Sensor-A');
```

---

## UPDATE

```sql
UPDATE devices
SET status='ACTIVE'
WHERE device_id=101;
```

---

## DELETE

```sql
DELETE FROM devices
WHERE device_id=101;
```

---

# 6. DQL - Data Query Language

## Purpose

Retrieve data.

Command:

```
SELECT
```

Example:

```sql
SELECT *
FROM devices;
```

Filtering:

```sql
SELECT model
FROM devices
WHERE device_id=101;
```

---

# 7. DCL - Data Control Language

## Purpose

Controls user permissions.

Commands:

| Command | Purpose |
|-|-|
| GRANT | Give permissions |
| REVOKE | Remove permissions |

---

## GRANT

Example:

```sql
GRANT SELECT
ON devices
TO developer;
```

Allows:

```
Developer
    |
    |
 Read devices table
```

---

## REVOKE

```sql
REVOKE SELECT
ON devices
FROM developer;
```

Removes access.

---

## Embedded Example

```
Device Database

Admin
 |
 Full access


Firmware Service
 |
 Read access


Logger Service
 |
 Insert access
```

---

# 8. TCL - Transaction Control Language

## Purpose

Controls database transactions.

Commands:

| Command | Purpose |
|-|-|
| COMMIT | Save changes permanently |
| ROLLBACK | Undo changes |
| SAVEPOINT | Create checkpoint |

---

## COMMIT

```sql
BEGIN;

UPDATE device
SET status='ACTIVE'
WHERE id=101;

COMMIT;
```

---

## ROLLBACK

```sql
BEGIN;

DELETE FROM logs;

ROLLBACK;
```

---

## SAVEPOINT

```sql
BEGIN;

INSERT INTO logs
VALUES(1,'Boot');

SAVEPOINT checkpoint1;

INSERT INTO logs
VALUES(2,'Error');

ROLLBACK TO checkpoint1;

COMMIT;
```

Result:

```
Boot log saved

Error log removed
```

---

# 9. Primary Key

A primary key uniquely identifies a row.

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
- Indexed automatically

Embedded examples:

- Device ID
- Serial number
- MAC address

---

# 10. Foreign Key

Creates relationships between tables.

Example:

Device:

|device_id|
|-|
|101|

Reading:

|reading_id|device_id|value|
|-|-|-|
|1|101|25.5|

SQL:

```sql
FOREIGN KEY(device_id)
REFERENCES devices(device_id);
```

---

# 11. SQL Constraints

Constraints enforce data correctness.

## NOT NULL

Value cannot be empty.

```sql
name VARCHAR(50) NOT NULL;
```

---

## UNIQUE

No duplicate values.

```sql
email VARCHAR(100) UNIQUE;
```

---

## DEFAULT

Provides default value.

```sql
status VARCHAR(20)
DEFAULT 'ACTIVE';
```

---

## CHECK

Validates conditions.

```sql
temperature FLOAT
CHECK(temperature > -50);
```

---

## PRIMARY KEY

Unique row identifier.

---

## FOREIGN KEY

Maintains relationships.

---

# 12. SQL Joins

Joins combine data from multiple tables.

---

## INNER JOIN

Returns matching records.

```sql
SELECT
d.model,
r.value

FROM devices d

INNER JOIN readings r

ON d.device_id=r.device_id;
```

---

## LEFT JOIN

Returns all records from left table.

Useful for finding missing relationships.

---

# 13. Indexing

## Why indexes?

Without index:

```
1 Million rows

Search
 |
Scan every row
```

With index:

```
Index
 |
Fast lookup
```

Create index:

```sql
CREATE INDEX idx_device
ON readings(device_id);
```

---

## Advantages

- Faster SELECT
- Faster searching

## Disadvantages

- Extra storage
- Slower INSERT/UPDATE

---

# 14. Query Optimization

Avoid:

```sql
SELECT *
FROM logs;
```

Prefer:

```sql
SELECT timestamp,message
FROM logs
WHERE device_id=101;
```

Benefits:

- Less memory usage
- Less CPU usage
- Faster execution

---

# 15. Transactions and ACID

Transactions ensure reliable database operations.

Example:

Bank transfer:

```
Account A
 -100

Account B
 +100
```

---

# ACID Properties

## Atomicity

All or nothing.

---

## Consistency

Database remains valid.

---

## Isolation

Transactions do not interfere.

---

## Durability

Committed data survives failures.

---

# 16. Database Normalization

Purpose:

- Remove duplicate data
- Improve consistency

---

Bad design:

```
Device

device_id
owner
owner_phone
owner_address
```

---

Better:

```
Device

device_id
owner_id


Owner

owner_id
phone
address
```

---

# 17. Normal Forms

## 1NF

Atomic values.

---

## 2NF

Remove partial dependency.

---

## 3NF

Remove transitive dependency.

Interview answer:

> Normalization reduces redundancy and improves consistency.

---

# 18. SQL vs NoSQL

| SQL | NoSQL |
|-|-|
| Tables | Documents |
| Fixed schema | Flexible schema |
| Strong consistency | Eventual consistency |
| Complex queries | Large-scale data |

---

# 19. SQLite for Embedded Systems

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

- No database server
- Small footprint
- ACID support
- Single file database

Used in:

- IoT devices
- Automotive systems
- Mobile devices
- Edge devices

---

# 20. SQLite Important Interview Topics

## WAL Mode

Write-Ahead Logging improves concurrency.

Traditional:

```
Write
 |
Database File
```

WAL:

```
Write
 |
WAL File
 |
Checkpoint
 |
Database
```

Benefits:

- Faster writes
- Better concurrency

---

## Journal Modes

SQLite supports:

- DELETE
- TRUNCATE
- PERSIST
- MEMORY
- WAL

Used for recovery after crashes.

---

## Database Locking

SQLite supports:

- Shared locks
- Reserved locks
- Exclusive locks

Important for multiple threads/processes.

---

# 21. Embedded Database Design

Example sensor table:

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

# 22. Handling Limited Storage

Techniques:

- Delete old records
- Compress data
- Store aggregated values
- Circular buffers
- Data retention policy

Example:

```
Keep last 30 days

Delete older records
```

---

# 23. Power Failure Handling

Important for embedded systems.

Approaches:

- Use transactions
- Enable WAL mode
- Use journal files
- Commit small batches
- Verify database integrity

Example:

```sql
BEGIN;

INSERT sensor_data;

COMMIT;
```

If power fails before COMMIT:

```
Data rollback
```

---

# 24. SQL Security

## SQL Injection

Bad:

```cpp
query =
"SELECT * FROM user WHERE name='"
+ input;
```

Problem:

User input changes SQL command.

Solution:

Use:

- Prepared statements
- Parameterized queries

---

# 25. Common Interview Questions

## DELETE vs TRUNCATE vs DROP

|Command|Purpose|Rollback|
|-|-|-|
|DELETE|Remove rows|Yes|
|TRUNCATE|Remove all rows|Usually no|
|DROP|Remove table|No|

---

## WHERE vs HAVING

WHERE:

Filters before grouping.

HAVING:

Filters after GROUP BY.

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
Separate index pointing to data
```

---

## Debug Slow Query

Steps:

1. Use execution plan

```sql
EXPLAIN QUERY PLAN
SELECT *
FROM readings;
```

2. Check indexes

3. Reduce unnecessary columns

4. Optimize joins

5. Improve schema

---

# Senior Embedded Developer SQL Checklist

## SQL Basics

- SELECT
- INSERT
- UPDATE
- DELETE
- Joins

## SQL Categories

- DDL
- DML
- DQL
- DCL
- TCL

## Database Design

- Primary keys
- Foreign keys
- Constraints
- Normalization

## Performance

- Indexing
- Query optimization
- Execution plans

## Transactions

- ACID
- COMMIT
- ROLLBACK
- SAVEPOINT

## Embedded Specific

- SQLite architecture
- WAL mode
- Journal modes
- Locking
- Flash storage limitations
- Sensor data storage
- Log management
- Power failure recovery

## Security

- SQL Injection
- Prepared statements

---

# Final Interview Focus

For a Senior Embedded Developer, prioritize:

1. SQLite internals
2. Transactions and ACID
3. Indexing
4. Query optimization
5. Sensor/telemetry data design
6. Flash storage limitations
7. Recovery after power failures
8. Database consistency
9. Concurrency handling
10. Prepared statements
