# Backup Software Design

## Overview

Backup software is a system that creates copies of important data so it can be recovered if files are deleted, corrupted, or lost due to hardware failure or cyberattacks.

### Objectives

- Protect user data
- Automate backups
- Reduce storage usage
- Secure backup data
- Restore files quickly

---

# High-Level Architecture

```text
                +---------------------+
                |     User / Admin    |
                +----------+----------+
                           |
                    Web/Desktop UI
                           |
                +----------v----------+
                |  Backup Controller  |
                +----------+----------+
                           |
          +----------------+----------------+
          |                |                |
 +--------v-------+ +------v-------+ +------v-------+
 | Backup Agent   | | Scheduler    | | Policy Engine|
 +--------+-------+ +------+-------+ +------+-------+
          |                |                |
          +----------------+----------------+
                           |
                    Backup Pipeline
                           |
     +-----------+---------+----------+-----------+
     |           |                    |           |
+----v----+ +----v----+         +-----v-----+ +---v----+
|Snapshot | |Compress |         |Encrypt    | |Dedupe  |
+----+----+ +----+----+         +-----+-----+ +---+----+
     |           |                    |           |
     +-----------+--------------------+-----------+
                           |
                   Storage Manager
                           |
     +---------------------+----------------------+
     |                     |                      |
+----v----+         +------v------+        +------v------+
| Local   |         | Cloud Store |        | NAS / SAN   |
| Storage |         |             |        | Repository  |
+---------+         +-------------+        +-------------+

                           |
                    Restore Manager
                           |
                 File / Folder / System
                      Recovery
```

---

# Components

## 1. User / Admin

The administrator configures backup settings using a desktop or web interface.

Examples:
- Select folders to back up
- Configure schedules
- Start manual backup
- Restore files
- View backup history

---

## 2. Backup Controller

Acts as the central coordinator.

Responsibilities:

- Receives user requests
- Starts backup jobs
- Coordinates all backup modules
- Tracks backup status

---

## 3. Backup Agent

Installed on client machines.

Responsibilities:

- Scan files
- Detect changes
- Read selected data
- Send data to the backup pipeline

Example:

```
Documents
Pictures
Videos
Database
      │
      ▼
 Backup Agent
```

---

## 4. Scheduler

Determines when backups should run.

Example schedules:

- Every hour
- Every day at 10 PM
- Every Sunday
- Every month

Example:

```
10 PM
  │
  ▼
Scheduler
  │
  ▼
Start Backup
```

---

## 5. Policy Engine

Defines backup rules.

Examples:

- Backup only Documents folder
- Keep backups for 30 days
- Delete backups older than 6 months
- Perform incremental backups daily

Without policies, every backup would require manual configuration.

---

# Backup Pipeline

The pipeline processes data before storage.

---

## Step 1 — Snapshot

Captures the exact state of files at the backup moment.

```
Original Files
      │
      ▼
Snapshot
```

Even if files change later, the backup remains consistent.

---

## Step 2 — Compression

Reduces storage requirements.

Example:

```
Original Size = 1000 MB

Compression

↓

Compressed Size = 650 MB
```

Benefits:

- Saves disk space
- Faster transfers

---

## Step 3 — Encryption

Protects backup data.

Example:

```
Original

Hello World

↓

Encrypted

X9@L#P8K2
```

Only authorized users with the encryption key can restore the data.

---

## Step 4 — Deduplication

Removes duplicate data blocks.

Example:

Computer A

```
File1
File2
File3
```

Computer B

```
File1
File4
```

Instead of storing File1 twice:

```
Stored Data

File1
File2
File3
File4
```

Benefits:

- Lower storage usage
- Faster backups

---

# Storage Manager

Stores processed backups.

Possible storage destinations:

- Local Disk
- External Hard Drive
- NAS
- SAN
- Cloud Storage

Example:

```
Backup Data
     │
     ▼
Storage Manager
     │
 ┌───┼──────────┐
 │   │          │
 ▼   ▼          ▼

Disk NAS     Cloud
```

---

# Backup Catalog

Stores metadata about backups.

Example:

| File | Version | Date |
|------|---------|------|
| Report.docx | V1 | Jan 1 |
| Report.docx | V2 | Jan 5 |
| Report.docx | V3 | Jan 10 |

The catalog does **not** contain the actual file data. It records:

- Backup location
- Backup time
- File versions
- Checksums
- Storage path

---

# Restore Manager

Responsible for recovering files.

Workflow:

```
User
 │
 ▼
Restore Manager
 │
 ▼
Locate Backup
 │
 ▼
Decrypt
 │
 ▼
Decompress
 │
 ▼
Restore Files
```

---

# Backup Workflow

```
User Starts Backup
        │
        ▼
Backup Agent Scans Files
        │
        ▼
Scheduler Checks Time
        │
        ▼
Policy Engine Applies Rules
        │
        ▼
Take Snapshot
        │
        ▼
Compress Data
        │
        ▼
Encrypt Data
        │
        ▼
Deduplicate Data
        │
        ▼
Store Backup
        │
        ▼
Update Backup Catalog
        │
        ▼
Backup Completed
```

---

# Restore Workflow

```
User Requests Restore
        │
        ▼
Search Backup Catalog
        │
        ▼
Locate Backup Files
        │
        ▼
Decrypt Backup
        │
        ▼
Decompress Data
        │
        ▼
Restore Original Files
```

---

# Types of Backup

## Full Backup

Copies every selected file.

Advantages

- Easy restore
- Complete copy

Disadvantages

- Large storage requirement
- Slowest backup

---

## Incremental Backup

Copies only files changed since the last backup (full or incremental).

Example:

Monday

```
A
B
C
```

Tuesday

Only B changes.

Incremental backup stores:

```
B
```

Advantages

- Fast
- Small storage

Disadvantages

- Restore may require multiple backup sets.

---

## Differential Backup

Copies files changed since the last full backup.

Example:

Monday (Full)

```
A
B
C
```

Tuesday

```
B changes
```

Wednesday

```
C changes
```

Differential backup on Wednesday stores:

```
B
C
```

Advantages

- Faster restore than incremental

Disadvantages

- Backup size grows until the next full backup

---

# Database Design

## Users

| Column | Description |
|----------|-------------|
| UserID | Primary Key |
| Name | User Name |
| Email | Email Address |

---

## Devices

| Column | Description |
|----------|-------------|
| DeviceID | Primary Key |
| UserID | Owner |
| DeviceName | Computer Name |
| OperatingSystem | Windows/Linux/macOS |

---

## BackupJobs

| Column | Description |
|----------|-------------|
| JobID | Primary Key |
| DeviceID | Device |
| BackupType | Full/Incremental/Differential |
| Schedule | Daily/Weekly |
| Status | Running/Completed/Failed |

---

## BackupFiles

| Column | Description |
|----------|-------------|
| FileID | Primary Key |
| JobID | Backup Job |
| FilePath | Original Path |
| Size | File Size |
| Hash | Checksum |
| Version | Version Number |

---

## StorageLocations

| Column | Description |
|----------|-------------|
| StorageID | Primary Key |
| Type | Local/NAS/Cloud |
| Path | Storage Path |
| Capacity | Available Capacity |

---

# Features

- Full Backup
- Incremental Backup
- Differential Backup
- File Versioning
- Compression
- Deduplication
- Encryption
- Scheduled Backup
- Manual Backup
- Cloud Backup
- Backup Verification
- Disaster Recovery
- Email Notifications
- Multi-device Support
- Role-based Access Control

---

# Technology Stack

Frontend

- React
- Angular
- Flutter

Backend

- Java (Spring Boot)
- .NET
- Node.js
- Python

Database

- PostgreSQL
- MySQL

Storage

- Local File System
- NAS
- Amazon S3-compatible Storage
- Azure Blob Storage

Message Queue

- RabbitMQ
- Apache Kafka

Authentication

- OAuth 2.0
- JWT

---

# Non-Functional Requirements

- High Availability
- Fault Tolerance
- Scalability
- Data Integrity
- Secure Encryption
- Fast Restore Time
- Cross-Platform Support
- Logging and Monitoring
- Backup Verification

---

# Example Scenario

Suppose your computer contains:

```
Resume.docx
Photos/
Music/
Projects/
```

### Monday

A **Full Backup** stores everything.

### Tuesday

Only **Resume.docx** is modified.

An **Incremental Backup** stores only the updated Resume.docx.

### Wednesday

The file is accidentally deleted.

The Restore Manager:

1. Searches the Backup Catalog.
2. Finds the latest