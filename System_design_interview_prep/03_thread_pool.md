# Thread Pool Design

## System Design Interview Notes

---

# 1. Problem Statement

Design a thread pool that manages a group of worker threads to execute tasks efficiently.

Instead of creating a new thread for every request, a fixed number of worker threads are created and reused.

---

# 2. Why Thread Pool?

Creating threads repeatedly has overhead:

- Thread creation cost
- Memory allocation for stack
- Context switching overhead
- Resource management complexity

A thread pool improves:

- Performance
- Resource utilization
- System stability

---

# 3. Example

Without thread pool:

```
Request 1
   |
Create Thread
   |
Execute
   |
Destroy Thread


Request 2
   |
Create Thread
   |
Execute
   |
Destroy Thread

```

With thread pool:

```
                Task Queue

                    |
                    |
        +-----------+-----------+

        |           |           |

    Worker 1    Worker 2    Worker 3


```

Workers are created once and reused.

---

# 4. Requirements

## Functional Requirements

Support:

```
create_pool()

submit_task()

execute_task()

shutdown_pool()

```

---

## Non Functional Requirements

Should provide:

- Efficient task execution
- Thread safety
- Controlled resource usage
- Graceful shutdown
- Error handling

---

# 5. High Level Architecture

Components:

1. Worker Threads
2. Task Queue
3. Synchronization Mechanism
4. Thread Manager


Architecture:

```

                 Client

                   |

                   |

              submit task

                   |

                   v


            +-------------+

            | Task Queue  |

            +-------------+

                   |

        +----------+----------+

        |          |          |

        v          v          v


    Worker1    Worker2    Worker3


```

---

# 6. Data Structures

## Task Structure

A task contains:

- Function pointer
- Argument


```c
typedef struct Task
{

    void (*function)(void *);

    void *argument;


    struct Task *next;


}Task;

```

---

# Worker Thread

```c
typedef struct
{

    pthread_t thread;


}Worker;

```

---

# Thread Pool Structure

```c
typedef struct
{

    Worker *workers;


    int thread_count;


    Task *task_head;

    Task *task_tail;


    pthread_mutex_t lock;


    pthread_cond_t condition;


    int shutdown;


}ThreadPool;

```

---

# 7. Task Queue

Tasks are stored in FIFO order.

Example:

```
HEAD

 |

 v

Task1 -> Task2 -> Task3

                        

TAIL

```

Operations:

```
enqueue()

dequeue()

```

---

# 8. Worker Thread Flow

Each worker executes:

```
while(true)

{

    lock queue


    while(queue empty)

        wait


    get task


    unlock queue


    execute task


}

```

---

# 9. Condition Variable Usage

Problem:

Worker threads should not continuously check queue.

Bad:

```
while(queue empty)
{
    check again
}

```

This wastes CPU.

---

Solution:

Condition variable:

```
Worker sleeps

        |

Task arrives

        |

Signal worker

        |

Worker wakes

```

---

# 10. Task Submission

Flow:

```
submit_task()

        |

Acquire lock

        |

Add task to queue

        |

Signal condition variable

        |

Release lock

```

---

Example:

```c
pthread_mutex_lock(&pool->lock);


add_task(task);


pthread_cond_signal(
&pool->condition);


pthread_mutex_unlock(
&pool->lock);

```

---

# 11. Worker Execution

Worker waits:

```c
pthread_cond_wait(
&pool->condition,
&pool->lock);

```

When task arrives:

```
Wake up

Get task

Execute

Return to waiting

```

---

# 12. Shutdown Design

Shutdown has two modes:

## Immediate Shutdown

Discard pending tasks.

```
Stop workers immediately

```

---

## Graceful Shutdown

Complete existing tasks.

Flow:

```
Stop accepting new tasks

        |

Finish queued tasks

        |

Terminate workers

```

---

# 13. Thread Safety

Shared resources:

- Task queue
- Shutdown flag
- Worker state


Protection:

```
Mutex

+

Condition variable

```

---

# 14. Deadlock Prevention

Avoid:

- Holding multiple locks
- Calling external functions while holding lock
- Lock ordering issues

---

# 15. Performance Optimization

## Fixed Size Pool

Example:

```
8 worker threads

```

Good for predictable workloads.

---

## Dynamic Pool

Increase threads when load increases.

Example:

```
Minimum:

4 threads


Maximum:

100 threads

```

---

## Work Stealing

Each worker has local queue.

Example:

```
Worker 1 Queue

Worker 2 Queue

Worker 3 Queue

```

Idle workers steal tasks.

Used in high-performance systems.

---

# 16. CPU Bound vs IO Bound

## CPU Bound Tasks

Example:

- Compression
- Encryption
- Calculation


Recommended:

```
Threads ≈ CPU cores

```

---

## IO Bound Tasks

Example:

- Network requests
- Disk operations


Can use more threads.

---

# 17. Failure Handling

## Worker Thread Failure

Options:

- Detect thread exit
- Restart worker
- Log failure

---

## Task Failure

Task should handle:

- Exceptions/errors
- Retry logic
- Cleanup

---

# 18. Memory Management

Need cleanup for:

- Task objects
- Queue nodes
- Worker resources


Shutdown sequence:

```
Stop accepting tasks

        |

Wake workers

        |

Join threads

        |

Free memory

```

---

# 19. Real World Usage

Thread pools are used in:

- Web servers
- Database engines
- Storage systems
- Network servers
- Background processing systems

---

# 20. Interview Questions

## Q1. Why not create a thread per request?

Answer:

Thread creation has overhead and can exhaust system resources.

---

## Q2. How many threads should a pool have?

Answer:

Depends on workload:

CPU bound:

```
Number of CPU cores

```

IO bound:

```
More threads possible

```

---

## Q3. How do workers wait efficiently?

Answer:

Use:

- Condition variables
- Semaphores

---

## Q4. How do you handle shutdown?

Answer:

Support:

- Graceful shutdown
- Immediate shutdown

---

## Q5. How do you improve scalability?

Answer:

Use:

- Multiple queues
- Work stealing
- Lock-free queues
- Dynamic resizing

---

# Design Summary

A thread pool consists of:

```
Worker Threads

+

Task Queue

+

Mutex

+

Condition Variable

+

Shutdown Management

```

Key benefits:

```
Thread reuse

Reduced overhead

Controlled concurrency

Better resource utilization

```
