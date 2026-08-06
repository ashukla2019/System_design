# Hash Table Design

## System Design Interview Notes

---

# 1. Problem Statement

Design a hash table that stores key-value pairs and supports efficient:

- Insert
- Lookup
- Delete
- Update

A hash table provides average:

```
O(1)

```

time complexity for these operations.

---

# 2. Example

Store employee information:

```
Key:

employee_id


Value:

employee_details

```

Example:

```
101 -> John

102 -> Alice

103 -> Bob

```

---

# 3. Requirements

## Functional Requirements

Support:

```
insert(key,value)

get(key)

delete(key)

update(key,value)

resize()

```

---

## Non Functional Requirements

The design should provide:

- Fast lookup
- Efficient memory usage
- Low collision rate
- Thread safety
- Scalability

---

# 4. High Level Architecture

A hash table consists of:

1. Hash function
2. Bucket array
3. Collision handling mechanism


Architecture:

```
                Key

                 |

                 v

          +--------------+

          | Hash Function|

          +--------------+

                 |

                 v

             Bucket Index


        +----+----+----+----+

        | 0  | 1  | 2  | 3  |

        +----+----+----+----+

             |

             |

          Stored Entry

```

---

# 5. Hash Function

A hash function converts a key into an index.

Example:

```
index = hash(key) % table_size

```

Example:

```
hash("user1") = 125

125 % 10 = 5


Bucket = 5

```

---

# 6. Properties of Good Hash Function

A good hash function should have:

## Fast Execution

Hash calculation should be inexpensive.

---

## Uniform Distribution

Keys should spread across buckets.

Bad:

```
Bucket 1:

A
B
C
D

```

Good:

```
Bucket 1: A

Bucket 2: B

Bucket 3: C

```

---

## Low Collision Rate

Different keys should rarely produce the same index.

---

# 7. Collision Handling

Collision occurs when:

```
hash(key1) == hash(key2)

```

Example:

```
hash(A)=5

hash(B)=5

```

Solutions:

1. Separate chaining
2. Open addressing

---

# 8. Separate Chaining

Each bucket contains a linked list.

Example:

```
Bucket 5


        +-----+
        | A   |
        +-----+
            |
            v
        +-----+
        | B   |
        +-----+
            |
            v
        +-----+
        | C   |
        +-----+

```

---

## Advantages

- Simple implementation
- Supports many entries
- Easy deletion

---

## Disadvantages

- Extra memory for pointers
- Poor cache locality

---

# 9. Data Structures

## Hash Entry

```c
typedef struct HashNode
{
    char *key;

    int value;


    struct HashNode *next;


}HashNode;

```

---

## Hash Table

```c
#define TABLE_SIZE 1024


typedef struct
{
    HashNode *buckets[TABLE_SIZE];

}HashTable;

```

---

# 10. Insert Operation

Steps:

1. Calculate hash.
2. Find bucket.
3. Check existing key.
4. Update or insert node.

Flow:

```
insert(key,value)

        |

    hash(key)

        |

    bucket index

        |

   existing key?

        |

  Update / Create node

```

---

# 11. Lookup Operation

Steps:

1. Calculate hash.
2. Access bucket.
3. Traverse linked list.
4. Compare keys.

Example:

```c
HashNode *find(
HashTable *table,
char *key)
{
    int index = hash(key);


    HashNode *node =
        table->buckets[index];


    while(node)
    {
        if(strcmp(node->key,key)==0)
            return node;


        node=node->next;
    }


    return NULL;
}

```

---

# 12. Delete Operation

Steps:

1. Calculate bucket.
2. Find node.
3. Update links.
4. Free memory.

---

# 13. Time Complexity

Average case:

| Operation | Complexity |
|---|---|
| Insert | O(1) |
| Lookup | O(1) |
| Delete | O(1) |

Worst case:

```
O(n)

```

when all keys collide.

---

# 14. Load Factor

Load factor measures table utilization.

Formula:

```
Load Factor = Number of Entries / Number of Buckets

```

Example:

```
Entries = 800

Buckets = 1000


Load Factor = 0.8

```

---

# 15. Resizing

When load factor becomes high:

Example:

```
Current table:

100 buckets


New table:

200 buckets

```

Steps:

1. Allocate larger table.
2. Recalculate hash values.
3. Move entries.

This is called:

```
Rehashing

```

---

# 16. Open Addressing

Instead of linked lists, store entries inside the table.

---

# Linear Probing

If bucket occupied:

Try next bucket.

Example:

```
Index 5 occupied

Try 6

Try 7

```

---

## Advantages

- Better cache locality
- Less memory usage

---

## Disadvantages

- Clustering problem

---

# Quadratic Probing

Search pattern:

```
index + 1²

index + 2²

index + 3²

```

Reduces clustering.

---

# Double Hashing

Use second hash function:

```
index = hash1(key) + i * hash2(key)

```

---

# 17. Thread Safety

Multiple threads accessing hash table require synchronization.

---

# Approach 1: Global Lock

Structure:

```
One mutex

Protect entire table

```

Advantages:

- Simple

Disadvantages:

- Low concurrency

---

# Approach 2: Bucket Locking

Each bucket has its own lock.

Example:

```
Bucket 0 -> Lock 0

Bucket 1 -> Lock 1

Bucket 2 -> Lock 2

```

Advantages:

- Higher parallelism

---

# Approach 3: Read-Write Lock

Reads:

```
Multiple readers allowed

```

Writes:

```
Exclusive lock

```

---

# 18. Memory Management Considerations

Need to handle:

- Allocation failures
- Memory leaks
- Duplicate keys
- Cleanup during destroy

Example:

```c
free(node->key);

free(node);

```

---

# 19. Distributed Hash Table Concepts

For distributed systems, a normal hash table is extended using:

## Consistent Hashing

Maps keys to nodes.

Example:

```
Key

 |

Hash Ring

 |

Storage Node

```

---

Benefits:

- Scalable
- Minimal data movement

---

# 20. Real World Usage

Hash tables are used for:

- Database indexes
- Cache lookup
- Metadata management
- Symbol tables
- Routing tables
- Configuration storage

---

# 21. Interview Questions

## Q1. How do you handle collisions?

Answer:

Use:

- Chaining
- Open addressing

---

## Q2. Why does resizing require rehashing?

Answer:

Because bucket index depends on table size.

Example:

```
hash(key) % size

```

Changing size changes location.

---

## Q3. How do you make a hash table thread-safe?

Answer:

Options:

- Global mutex
- Bucket-level locks
- Read-write locks
- Lock-free techniques

---

## Q4. What happens if all keys collide?

Answer:

Performance degrades from:

```
O(1)

```

to:

```
O(n)

```

---

## Q5. How would you scale a hash table across machines?

Answer:

Use:

- Consistent hashing
- Partitioning
- Replication
- Distributed hash tables

---

# Design Summary

A hash table consists of:

```
Hash Function

+

Bucket Array

+

Collision Handling

+

Memory Management

+

Synchronization

```

Key characteristics:

```
Average Lookup     O(1)

Average Insert     O(1)

Average Delete     O(1)

```

Hash tables are fundamental building blocks for caches, databases, metadata services, and distributed systems.
