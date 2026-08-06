# Memory Pool Allocator Design

## System Design Interview Notes

---

# 1. Problem Statement

Design a memory pool allocator that manages a fixed amount of memory and provides fast allocation and deallocation of objects.

A memory pool avoids repeated calls to:

```c
malloc()

free()

```

by pre-allocating memory blocks and reusing them.

---

# 2. Why Memory Pool?

General heap allocation has overhead:

- System calls
- Metadata management
- Fragmentation
- Lock contention
- Variable allocation time

Memory pools provide:

- Faster allocation
- Predictable latency
- Better cache locality
- Reduced fragmentation

---

# 3. Real World Usage

Memory pools are used in:

- Operating systems
- Network packet processing
- Database engines
- Storage systems
- Embedded systems
- High-frequency applications

---

# 4. Basic Concept

Instead of:

```
Application

    |
    |
 malloc()

    |
    |
 Heap

```

Use:

```
Application

    |

Memory Pool

    |

Preallocated Memory Blocks

```

---

# 5. Architecture

```
              Memory Pool


+--------------------------------+

| Block | Block | Block | Block |

+--------------------------------+

    |       |       |       |

    v       v       v       v


  Free   Used   Free   Used


```

---

# 6. Requirements

## Functional Requirements

Support:

```
pool_create()

pool_alloc()

pool_free()

pool_destroy()

```

---

## Non Functional Requirements

Need:

- Fast allocation
- Low fragmentation
- Thread safety
- Predictable latency
- Efficient memory usage

---

# 7. Data Structures

## Memory Block

Each block contains metadata.

```c
typedef struct Block
{

    struct Block *next;


    int free;


}Block;

```

---

## Memory Pool

```c
typedef struct
{

    void *memory;


    Block *free_list;


    size_t block_size;


    size_t total_blocks;


    pthread_mutex_t lock;


}MemoryPool;

```

---

# 8. Pool Creation

Steps:

1. Allocate large memory area.
2. Divide into fixed-size blocks.
3. Create free list.


Example:

```
Allocate 1 MB


Split:

Block1

Block2

Block3

...


```

---

# 9. Free List Design

Initially:

```
Free List


Block1

  |

Block2

  |

Block3

  |

Block4

```

When allocation happens:

```
Remove first block


Free List:


Block2

 |

Block3

```

---

# 10. Allocation Algorithm

Flow:

```
pool_alloc()


      |

Check free list


      |

Available?


      |

Yes


      |

Remove block


      |

Return memory


```

---

Example:

```c
void *pool_alloc(
MemoryPool *pool)
{

    pthread_mutex_lock(
    &pool->lock);


    if(pool->free_list == NULL)
    {

        pthread_mutex_unlock(
        &pool->lock);

        return NULL;
    }


    Block *block =
        pool->free_list;


    pool->free_list =
        block->next;


    pthread_mutex_unlock(
    &pool->lock);


    return (void*)(block+1);

}

```

---

# 11. Free Algorithm

Flow:

```
pool_free()


     |

Convert address to block


     |

Add block to free list


```

---

Example:

```c
void pool_free(
MemoryPool *pool,
void *ptr)
{

    Block *block =
       ((Block *)ptr)-1;


    pthread_mutex_lock(
    &pool->lock);


    block->next =
        pool->free_list;


    pool->free_list =
        block;


    pthread_mutex_unlock(
    &pool->lock);

}

```

---

# 12. Fixed Size vs Variable Size Pool

## Fixed Size Pool

Example:

```
All blocks = 64 bytes

```

Advantages:

- Fast
- Simple
- No fragmentation

Used for:

- Network packets
- Objects

---

## Variable Size Pool

Supports:

```
32 bytes

128 bytes

512 bytes

```

Advantages:

- Flexible

Disadvantages:

- More complex

---

# 13. Fragmentation

## External Fragmentation

Free memory exists but is scattered.

---

## Internal Fragmentation

Allocated block is larger than requested.

Example:

Request:

```
50 bytes

```

Allocated:

```
64 bytes

```

Unused:

```
14 bytes

```

---

# 14. Thread Safety

Options:

## Global Lock

Simple:

```
One mutex protects pool

```

Problem:

- Lock contention

---

## Per Thread Pool

Each thread owns its pool.

Advantages:

- No locking
- Better performance

---

## Lock-Free Free List

Uses:

- Atomic operations
- Compare-and-swap

---

# 15. Memory Alignment

Important for performance.

Example:

```c
struct Object
{
    int value;

};

```

Memory should align to CPU requirements.

Benefits:

- Faster access
- Avoid hardware penalties

---

# 16. Cache Optimization

Avoid:

- Random memory access
- Pointer chasing

Prefer:

- Contiguous memory
- Cache-friendly structures

---

# 17. Failure Handling

Handle:

- Pool exhausted
- Invalid free
- Double free
- Memory corruption

---

# 18. Debug Features

Production allocators often add:

## Guard Bytes

Detect overflow.

Example:

```
[Guard][Data][Guard]

```

---

## Allocation Tracking

Store:

- Allocation location
- Timestamp
- Thread ID

Useful for leak detection.

---

# 19. Memory Pool vs malloc()

| Feature | Memory Pool | malloc |
|-|-|-|
| Speed | Fast | Slower |
| Allocation time | Predictable | Variable |
| Fragmentation | Low | Higher |
| Flexibility | Limited | High |
| Management | Manual | Automatic |

---

# 20. Real World Design Example

Storage IO path:

```
Incoming Request

        |

Allocate Buffer

        |

Process IO

        |

Return Buffer


        |

Pool Reuse

```

Benefits:

- No allocation overhead
- Stable latency

---

# 21. Interview Questions

## Q1. Why use memory pool?

Answer:

To achieve fast predictable allocation and reduce fragmentation.

---

## Q2. How do you make it thread-safe?

Answer:

Use:

- Mutex
- Thread-local pools
- Atomic free list

---

## Q3. How do you detect memory corruption?

Answer:

Use:

- Guard bytes
- Checksums
- Debug metadata

---

## Q4. How does memory pool improve performance?

Answer:

Because allocation becomes:

```
Remove block from free list

```

instead of expensive heap management.

---

## Q5. How would you design a kernel allocator?

Answer:

Use:

- Slab allocator concepts
- Object caches
- Per CPU pools

---

# Design Summary

Memory Pool Allocator consists of:

```
Preallocated Memory

+

Block Management

+

Free List

+

Synchronization

+

Debug Tracking

```

Key properties:

```
Fast allocation

Predictable latency

Low fragmentation

Efficient memory reuse

```
