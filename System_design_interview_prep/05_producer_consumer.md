# Producer-Consumer Pattern Design

## System Design Interview Notes

---

# 1. Problem Statement

Design a mechanism where one or more producer threads generate data and one or more consumer threads process that data asynchronously.

The producer and consumer should work independently without losing data or causing race conditions.

---

# 2. Real World Examples

Producer-consumer pattern is used in:

- Network packet processing
- Logging systems
- Storage IO pipelines
- Message queues
- Database background workers
- Task scheduling systems

---

# 3. Basic Concept

There are two roles:

## Producer

Creates data.

Example:

```
Receive network packet

Generate log message

Create IO request

```

---

## Consumer

Processes data.

Example:

```
Write packet

Store log

Execute IO

```

---

# 4. Architecture

```

             Producer Threads


                    |

                    |

                    v


          +----------------+

          |  Shared Queue  |

          +----------------+

                    |

                    |

                    v


             Consumer Threads


```

---

# 5. Problem Without Synchronization

Example:

Producer:

```
Add item

```

Consumer:

```
Remove item

```

Both access the same queue.

Possible problems:

- Race condition
- Data corruption
- Lost updates
- Invalid memory access

---

# 6. Requirements

## Functional Requirements

Support:

```
produce()

consume()

queue management()

shutdown()

```

---

## Non Functional Requirements

Need:

- Thread safety
- High throughput
- Low latency
- Fair scheduling
- Proper shutdown

---

# 7. Data Structures

## Queue Node

```c
typedef struct Node
{

    void *data;

    struct Node *next;


}Node;

```

---

## Queue Structure

```c
typedef struct
{

    Node *head;

    Node *tail;


    int size;

    int capacity;


    pthread_mutex_t lock;


    pthread_cond_t not_empty;


    pthread_cond_t not_full;


}BlockingQueue;

```

---

# 8. Synchronization Components

Three important primitives:

## Mutex

Protects shared queue.

Example:

```
Only one thread modifies queue at a time

```

---

## Condition Variable

Allows waiting efficiently.

Example:

```
Consumer waits when queue empty

Producer wakes consumer

```

---

## Semaphore

Tracks available resources.

Example:

```
Empty slots

Available items

```

---

# 9. Producer Flow

Algorithm:

```
produce(item)


    |

Acquire lock


    |

Queue full?


    |

Yes

Wait


    |

Insert item


    |

Signal consumer


    |

Release lock

```

---

# 10. Consumer Flow

Algorithm:

```
consume()


    |

Acquire lock


    |

Queue empty?


    |

Yes

Wait


    |

Remove item


    |

Signal producer


    |

Release lock

```

---

# 11. Producer Implementation

Example:

```c
void produce(
BlockingQueue *queue,
void *item)
{

    pthread_mutex_lock(
        &queue->lock);


    while(queue->size ==
          queue->capacity)
    {

        pthread_cond_wait(
        &queue->not_full,
        &queue->lock);

    }


    enqueue(queue,item);


    pthread_cond_signal(
    &queue->not_empty);


    pthread_mutex_unlock(
    &queue->lock);

}

```

---

# 12. Consumer Implementation

Example:

```c
void *consume(
BlockingQueue *queue)
{

    pthread_mutex_lock(
    &queue->lock);


    while(queue->size == 0)
    {

        pthread_cond_wait(
        &queue->not_empty,
        &queue->lock);

    }


    void *item =
        dequeue(queue);


    pthread_cond_signal(
    &queue->not_full);


    pthread_mutex_unlock(
    &queue->lock);


    return item;

}

```

---

# 13. Why Use while Instead of if?

Wrong:

```c
if(queue empty)
    wait();

```

Correct:

```c
while(queue empty)
    wait();

```

Reason:

- Spurious wakeups can occur
- Condition may change before thread runs

---

# 14. Bounded vs Unbounded Queue

## Bounded Queue

Fixed capacity.

Example:

```
Queue size = 1000

```

When full:

Producer waits.

Advantages:

- Controlled memory usage

---

## Unbounded Queue

No fixed limit.

Advantages:

- Higher throughput

Disadvantages:

- Memory exhaustion risk

---

# 15. Multiple Producers and Consumers

Example:

```

Producer 1  \
Producer 2   \
Producer 3    ---> Queue ---> Consumer 1
                              Consumer 2
                              Consumer 3

```

Requires:

- Mutex protection
- Fair scheduling
- Queue management

---

# 16. Lock-Free Producer Consumer

For high-performance systems:

Use:

- Atomic operations
- Memory barriers
- Lock-free queues

Example:

```
Producer updates tail

Consumer updates head

```

---

# 17. Performance Improvements

## Batch Processing

Instead of:

```
Consume one item

Process

Consume one item

```

Use:

```
Consume 100 items

Process together

```

Benefits:

- Less synchronization overhead
- Better cache usage

---

## Multiple Queues

Instead of one global queue:

```
Queue 1

Queue 2

Queue 3

```

Improves scalability.

---

# 18. Failure Handling

Need to handle:

## Producer Failure

Options:

- Retry
- Remove producer
- Log error

---

## Consumer Failure

Options:

- Restart consumer
- Requeue task
- Error reporting

---

# 19. Shutdown Design

Graceful shutdown:

```
Stop accepting new items

        |

Process remaining items

        |

Terminate threads

```

---

Common technique:

Special termination message:

```
POISON_PILL

```

Consumer exits when it receives it.

---

# 20. Real World Usage

## Logging System

```
Application

   |

Log Queue

   |

Logger Thread

```

---

## Storage IO Pipeline

```
Request Generator

      |

IO Queue

      |

Disk Workers

```

---

## Network Processing

```
NIC

 |

Packet Queue

 |

Processing Threads

```

---

# 21. Interview Questions

## Q1. Why is producer-consumer needed?

Answer:

It separates data generation from processing and allows asynchronous execution.

---

## Q2. How do you prevent queue overflow?

Answer:

Use:

- Bounded queue
- Back pressure
- Producer blocking

---

## Q3. How do you prevent consumer starvation?

Answer:

Use:

- Fair scheduling
- Multiple consumers
- Queue prioritization

---

## Q4. Mutex vs semaphore?

Answer:

Mutex protects shared data.

Semaphore manages resource count.

---

## Q5. How would you improve throughput?

Answer:

Use:

- Multiple workers
- Batch processing
- Lock-free queues
- Queue partitioning

---

# Design Summary

Producer-consumer consists of:

```
Producer Threads

+

Shared Queue

+

Synchronization

+

Consumer Threads

```

Key concepts:

```
Thread synchronization

Queue management

Back pressure

Asynchronous processing

```

This pattern is one of the most common building blocks in concurrent systems.
