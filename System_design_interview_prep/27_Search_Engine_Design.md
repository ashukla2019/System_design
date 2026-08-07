# 27. Search Engine Design

> Designing a large-scale search engine similar to Google Search, Elasticsearch, Apache Solr, or OpenSearch.

---

# Table of Contents

1. Introduction
2. Search Engine Overview
3. Requirements
4. High-Level Architecture
5. Crawling System
6. URL Frontier
7. Document Processing Pipeline
8. Document Storage
9. Inverted Index
10. Indexing Pipeline
11. Query Processing
12. Ranking System
13. TF-IDF
14. BM25
15. Distributed Search Architecture
16. Sharding
17. Replication
18. Caching
19. Autocomplete
20. Spell Correction
21. Personalization
22. Security
23. Scaling
24. Failure Handling
25. Monitoring
26. Real-World Systems
27. Interview Questions
28. Summary

---

# 1. Introduction

A search engine helps users find relevant information from billions of documents.

A typical workflow:

```
Documents

↓

Crawling

↓

Processing

↓

Indexing

↓

Ranking

↓

Search Results
```

Examples:

- Web search
- Enterprise search
- Product search
- Log search
- Document search

---

# 2. Search Engine Overview

A search engine has two major phases:

## Offline Phase

Building the index.

```
Crawler

↓

Parser

↓

Indexer

↓

Search Index
```

---

## Online Phase

Serving queries.

```
User Query

↓

Query Processor

↓

Search Index

↓

Ranking

↓

Results
```

---

# 3. Functional Requirements

Users should be able to:

- Search documents
- Filter results
- Sort results
- Auto-complete queries
- Correct spelling mistakes
- Search quickly
- Receive relevant ranking

---

# 4. Non-Functional Requirements

Latency:

<100 ms

Scale:

Billions of documents

Availability:

99.99%

Throughput:

Millions of queries/sec

Freshness:

Near real-time indexing

---

# 5. High-Level Architecture

```
                 Users

                   |

              Load Balancer

                   |

            Query Service

                   |

        +----------+----------+

        |                     |

 Search Index Cluster     Ranking Service

        |

 Document Storage
```

Offline pipeline:

```
Web Pages

↓

Crawler

↓

Parser

↓

Indexer

↓

Distributed Index
```

---

# 6. Web Crawler

A crawler discovers and downloads documents.

Responsibilities:

- Find URLs
- Download pages
- Follow links
- Respect robots.txt
- Avoid duplicates

Architecture:

```
URL Frontier

↓

Crawler Workers

↓

HTML Downloader

↓

Parser
```

---

# 7. URL Frontier

Stores URLs waiting to be crawled.

Example:

```
Queue

google.com

amazon.com

github.com
```

Features:

- Priority scheduling
- Duplicate prevention
- Domain politeness

---

# 8. Crawler Workflow

```
URL Frontier

↓

Fetch URL

↓

Download HTML

↓

Extract Links

↓

Store Document

↓

Add New URLs
```

---

# 9. Crawler Challenges

## Duplicate Pages

Solution:

- URL normalization
- Content hashing
- Fingerprinting

---

## Infinite Websites

Example:

```
Calendar pages

?page=1

?page=2

?page=3
```

Solution:

- Crawl limits
- Priority scoring

---

## Politeness

Avoid overwhelming websites.

Use:

- Rate limits
- Crawl delays

---

# 10. Document Processing

Raw HTML:

```
<html>

<h1>Hello</h1>

</html>
```

Converted into:

```
Title

Body

Links

Metadata
```

---

# 11. Text Processing Pipeline

Steps:

```
Document

↓

Tokenization

↓

Normalization

↓

Stop Word Removal

↓

Stemming

↓

Indexing
```

---

# 12. Tokenization

Convert text into tokens.

Example:

Input:

```
"Distributed systems are powerful"
```

Output:

```
Distributed

systems

powerful
```

---

# 13. Normalization

Examples:

Lowercase:

```
Database

database
```

becomes:

```
database
```

Remove punctuation:

```
hello!
```

becomes:

```
hello
```

---

# 14. Stop Words

Remove common words:

```
the

is

a

an
```

Improves index size.

---

# 15. Stemming

Reduce words to common root.

Example:

```
running

runs

runner
```

become:

```
run
```

---

# 16. Inverted Index

The core data structure of search engines.

Instead of:

```
Document → Words
```

Store:

```
Word → Documents
```

Example:

Documents:

```
D1:
cloud storage

D2:
cloud database
```

Index:

```
cloud

↓

D1,D2


storage

↓

D1


database

↓

D2
```

---

# 17. Posting List

Each term has a list:

```
cloud

[
D1,
D2,
D5,
D10
]
```

May include:

- Frequency
- Position
- Location

---

# 18. Index Building

Pipeline:

```
Documents

↓

Parser

↓

Tokens

↓

Term Dictionary

↓

Posting Lists

↓

Index Segments
```

---

# 19. Segment-Based Indexing

Large indexes are split into segments.

Example:

```
Segment 1

Documents 1-1M


Segment 2

Documents 1M-2M
```

Benefits:

- Parallel processing
- Easier updates

---

# 20. Query Processing

User query:

```
distributed database
```

Pipeline:

```
Query

↓

Tokenization

↓

Normalization

↓

Lookup Terms

↓

Retrieve Documents

↓

Rank

↓

Return Results
```

---

# 21. Ranking

Search engines rank documents by relevance.

Factors:

- Term frequency
- Document frequency
- Popularity
- Freshness
- User behavior
- Authority

---

# 22. TF-IDF

Term Frequency:

How often a term appears.

```
TF =
Term occurrences /
Total words
```

---

Inverse Document Frequency:

How rare a term is.

```
IDF =
log(
Total Documents /
Documents containing term
)
```

---

Score:

```
TF × IDF
```

Higher score means more relevance.

---

# 23. BM25 Ranking

Modern search systems often use BM25.

Improves TF-IDF by considering:

- Document length
- Term saturation
- Query length

Formula concept:

```
Score =
Term Importance

×

Frequency

×

Document Length Adjustment
```

---

# 24. Distributed Search Architecture

Large indexes cannot fit on one machine.

Solution:

Shard the index.

```
Search Cluster


Shard 1

Shard 2

Shard 3

Shard 4
```

---

# 25. Query Fanout

User query:

```
cloud database
```

Router sends request:

```
Shard1

Shard2

Shard3

Shard4
```

Each returns candidates.

Then:

```
Merge Results

↓

Final Ranking
```

---

# 26. Index Sharding Strategies

## Document Based

Each shard stores documents.

Example:

```
Doc ID hash

↓

Shard
```

---

## Term Based

Terms are distributed.

Example:

```
A-M

↓

Shard1


N-Z

↓

Shard2
```

Document-based is more common.

---

# 27. Replication

Search indexes are replicated.

Example:

```
Primary Shard

↓

Replica 1

↓

Replica 2
```

Benefits:

- High availability
- Faster queries
- Failure recovery

---

# 28. Caching

## Query Cache

Stores popular queries.

Example:

```
"weather"

↓

Cached Results
```

---

## Document Cache

Stores frequently accessed documents.

---

## Filter Cache

Stores common filters.

---

# 29. Autocomplete

Autocomplete requires prefix search.

Example:

User types:

```
ama
```

Results:

```
amazon

amazon prime

amazon web services
```

Implemented using:

- Trie
- Finite State Transducer
- Prefix index

---

# 30. Spell Correction

Techniques:

- Edit distance
- Language models
- Dictionary lookup

Example:

```
amazn

↓

amazon
```

---

# 31. Personalization

Ranking can consider:

- Location
- Search history
- Preferences
- Language

Requires:

- User profiles
- Machine learning models

---

# 32. Security

Protection against:

- Malicious crawling
- Query abuse
- Index poisoning

Methods:

- Authentication
- Rate limiting
- Access control
- Content filtering

---

# 33. Scaling

## Horizontal Scaling

Add:

```
More Crawlers

More Indexers

More Search Nodes
```

---

## Parallel Indexing

Documents processed simultaneously.

---

## Incremental Updates

Only changed documents are reindexed.

---

# 34. Failure Handling

Crawler failure:

```
Restart Worker

Resume Queue
```

---

Indexer failure:

```
Retry Batch

Restore From Checkpoint
```

---

Search node failure:

```
Route To Replica
```

---

# 35. Monitoring

Metrics:

## Crawling

- Pages/sec
- Crawl errors
- Queue size

## Indexing

- Documents indexed/sec
- Index size
- Merge time

## Search

- Query latency
- Queries/sec
- Ranking latency

## Quality

- Click-through rate
- Failed searches
- Relevance score

---

# 36. Real-World Systems

## Elasticsearch

Features:

- Distributed inverted index
- Lucene engine
- Full-text search
- Aggregations
- Near real-time indexing

---

## Apache Solr

Features:

- Lucene-based
- Enterprise search
- Advanced query support

---

## OpenSearch

Features:

- Elasticsearch-compatible fork
- Distributed search
- Analytics

---

# 37. Interview Questions

## Q1. Why use an inverted index?

Because searching by term becomes efficient.

Instead of scanning every document:

```
Term

↓

Document List
```

---

## Q2. How does Google search millions of pages quickly?

Using:

- Distributed crawling
- Inverted indexes
- Ranking algorithms
- Massive caching
- Parallel query execution

---

## Q3. How do you update indexes?

Use:

- Incremental indexing
- Segment merging
- Background refresh

---

## Q4. How do you scale search?

- Shard indexes
- Replicate shards
- Add query nodes
- Cache popular searches

---

## Q5. How do you improve relevance?

Use:

- Better ranking models
- User signals
- Machine learning
- Freshness scoring

---

# 38. Best Practices

- Use inverted indexes for text search.
- Separate indexing from querying.
- Shard large indexes.
- Replicate search data.
- Cache popular queries.
- Use incremental indexing.
- Monitor query latency.
- Tune ranking algorithms continuously.
- Handle duplicate content.
- Design for eventual index consistency.

---

# 39. Summary

A scalable search engine combines web crawling, document processing, inverted indexing, ranking algorithms, and distributed query execution. The inverted index enables fast retrieval, while ranking systems such as BM25 improve relevance. Large-scale search requires distributed indexing, sharding, replication, caching, and continuous optimization to handle billions of documents and millions of queries.

---

**Next: 28_Load_Balancer_Design.md**

Topics:
- Layer 4 vs Layer 7 load balancing
- Reverse proxy
- Health checks
- Routing algorithms
- Consistent hashing
- Service discovery
- Failover
- Global load balancing
- Anycast
- CDN integration
- Real-world load balancers
