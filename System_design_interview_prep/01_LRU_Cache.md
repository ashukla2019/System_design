# LRU Cache Design

## Senior System Design Interview Notes

---

# 1. Problem Statement

Design a Least Recently Used (LRU) Cache.

The cache stores frequently accessed data in memory to reduce expensive operations such as:

- Disk access
- Database queries
- Network calls

When the cache reaches maximum capacity, the least recently used item must be removed.

---

# 2. Example

Cache capacity:

```
3 entries

```

Operations:

```
PUT(A,10)

PUT(B,20)

PUT(C,30)

GET(A)

PUT(D,40)

```

Cache state:

Before D:

```
A -> C -> B

```

A is recently accessed.

After inserting D:

```
D -> A -> C

```

B is removed because it is least recently used.

---

# 3. Requirements

## Functional Requirements

The cache should support:

```
GET(key)

PUT(key,value)

DELETE(key)

```

---

## Non Functional Requirements

Expected:

- O(1) lookup
- O(1) insertion
- O(1) deletion
- Thread safety
- Low memory overhead
- High throughput

---

# 4. High Level Architecture

LRU Cache uses two data structures:

1. Hash Table
2. Doubly Linked List


Architecture:

```
                +----------------+
                | Hash Table     |
                +----------------+

                       |
                       |

                Cache Node Address


        Most Recent                 Least Recent

             HEAD
              |
              v

        +-----+-----+-----+-----+
        | A   | B   | C   | D   |
        +-----+-----+-----+-----+

                                  ^
                                  |
                                 TAIL

```

---

# 5. Why Hash Table?

A linked list alone:

```
Search = O(n)

```

For example:

```
Find key 500

Need to scan every node

```

Hash table provides:

```
Average lookup = O(1)

```

Mapping:

```
key ---> cache node pointer

```

Example:

```
101 ---> Node address

102 ---> Node address

```

---

# 6. Why Doubly Linked List?

LRU requires maintaining usage order.

Every access changes ordering.

Need operations:

## Move node to front

```
O(1)

```

## Remove least used node

```
O(1)

```

Doubly linked list provides:

```
previous pointer

next pointer

```

---

# 7. Data Structures

## Cache Node

```c
typedef struct CacheNode
{
    int key;

    int value;


    struct CacheNode *prev;

    struct CacheNode *next;


}CacheNode;

```

---

## Cache Structure

```c
#define HASH_SIZE 1024


typedef struct
{
    int capacity;

    int size;


    CacheNode *head;

    CacheNode *tail;


    CacheNode *table[HASH_SIZE];


    pthread_mutex_t lock;


}LRUCache;

```

---

# 8. Cache Operations

---

# GET Operation

Flow:

```
GET(key)

   |

Hash lookup

   |

Node found?

   |

Move node to HEAD

   |

Return value

```

---

Algorithm:

1. Calculate hash.
2. Find node.
3. Remove node from current position.
4. Insert at front.
5. Return value.

---

# PUT Operation

Flow:

```
PUT(key,value)

       |

Existing key?

       |

   Yes ---- Update value

       |

   Move to HEAD


       |

   No ---- Create node


       |

   Insert into cache


       |

 Capacity exceeded?


       |

 Remove tail node

```

---

# 9. Doubly Linked List Operations

## Remove Node

```c
void remove_node(CacheNode *node)
{
    node->prev->next =
        node->next;


    node->next->prev =
        node->prev;
}

```

---

## Insert At Front

```c
void insert_front(
LRUCache *cache,
CacheNode *node)
{

    node->next =
        cache->head->next;


    node->prev =
        cache->head;



    cache->head->next->prev =
        node;


    cache->head->next =
        node;

}

```

---

# 10. Eviction Logic

When:

```
size > capacity

```

Remove:

```
tail->prev

```

because it is least recently used.

---

# 11. Complete Operation Complexity

| Operation | Complexity |
|---|---|
| GET | O(1) |
| PUT | O(1) |
| DELETE | O(1) |
| Search | O(1) |

---

# 12. Thread Safety Design

## Simple Design

Use one mutex:

```
Thread 1

    |
 lock

 Update cache

    |
 unlock


Thread 2

 wait

```

Protect:

- Hash table
- Linked list

---

Example:

```c
pthread_mutex_lock(&cache->lock);


/*
 modify cache
*/


pthread_mutex_unlock(&cache->lock);

```

---

# 13. Scaling LRU Cache

A single lock limits performance.

For large systems:

---

# Sharded Cache

Split cache into partitions.

Example:

```
Shard 0

Shard 1

Shard 2

Shard 3

```

Each shard has:

- Separate hash table
- Separate lock

Benefits:

- More parallel operations
- Less lock contention

---

# 14. Memory Management

Problems:

- Memory leak
- Double free
- Fragmentation


Solutions:

Use:

- Memory pool allocator
- Object cache
- Preallocated nodes

---

# 15. Distributed LRU Cache

For large scale:

Example:

```
Client

 |

Cache Router

 |

+-------+-------+

Node1  Node2  Node3

```

---

# Data Distribution

Use:

## Consistent Hashing

Example:

```
hash(key)

     |

     v

Cache node

```

Advantages:

- Easy scaling
- Minimal data movement

---

# 16. Failure Handling

## Cache Node Failure

Options:

- Replication
- Data reload
- Failover

---

## Stale Data

Solutions:

- TTL
- Version numbers
- Cache invalidation

---

# 17. Production Optimizations

## Batch Operations

Instead of:

```
GET A

GET B

GET C

```

Use:

```
GET(A,B,C)

```

---

## Lock-Free Techniques

Possible approaches:

- Atomic operations
- Lock-free queues
- RCU techniques

---

## Memory Locality

Improve cache performance:

- Compact structures
- Avoid pointer chasing
- Align structures to cache lines

---

# 18. Real World Usage

LRU cache is used in:

## Operating Systems

Page cache:

```
Frequently used memory pages

```

---

## Databases

Buffer pool:

```
Disk blocks cached in RAM

```

---

## Storage Systems

Examples:

- Metadata cache
- Block cache
- Read cache

---

## Networking

Examples:

- Connection cache
- Route cache

---

# 19. Senior Interview Questions

## Q1. Why not use only a hash table?

Answer:

Hash table provides lookup but cannot track access order.

---

## Q2. Why not use only linked list?

Answer:

Lookup becomes O(n).

---

## Q3. How would you make it thread-safe?

Answer:

Use:

- Mutex
- RW lock
- Sharded locks

---

## Q4. How would you handle millions of entries?

Answer:

- Partition cache
- Use memory pools
- Reduce lock contention
- Use efficient eviction policy

---

## Q5. How would you design a distributed LRU?

Answer:

Use:

- Consistent hashing
- Multiple cache nodes
- Replication
- Failure detection

---

# 20. Design Summary

LRU Cache combines:

```
Hash Table

+

Doubly Linked List

+

Synchronization

+

Memory Management

```

Key properties:

```
Lookup        O(1)

Insertion     O(1)

Deletion      O(1)

Eviction      O(1)

```

This pattern is a fundamental building block for:

- Operating systems
- Databases
- Storage controllers
- Distributed systems

