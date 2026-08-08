# Thread Pool Design

## System Design Interview Notes + C++ Implementation

---

# 1. Problem Statement

Design a thread pool that manages a group of worker threads to execute tasks efficiently.

Instead of creating a new thread for every request, a fixed number of worker threads are created once and reused.

```text
Without Thread Pool:

Request 1
   |
Create Thread
   |
Execute Task
   |
Destroy Thread


Request 2
   |
Create Thread
   |
Execute Task
   |
Destroy Thread
```

With a thread pool:

```text
                    Task Queue
                        |
        +---------------+---------------+
        |               |               |
        v               v               v
    Worker 1        Worker 2        Worker 3
        |               |               |
        +---------------+---------------+
                        |
                  Execute Tasks
```

---

# 2. Why Thread Pool?

Creating and destroying threads repeatedly has overhead.

Problems with creating a thread for every task:

- Thread creation cost
- Thread destruction cost
- Memory allocation for thread stack
- Context switching overhead
- Too many threads can exhaust system resources
- Difficult concurrency control

A thread pool provides:

- Thread reuse
- Controlled concurrency
- Better resource utilization
- Reduced thread creation overhead
- Better throughput

---

# 3. Basic Idea

A thread pool consists of:

```text
             Thread Pool
                  |
        +---------+---------+
        |                   |
        v                   v
   Worker Threads       Task Queue
        |                   |
        |                   |
        +---------+---------+
                  |
           Synchronization
                  |
        +---------+---------+
        |                   |
      Mutex          Condition Variable
```

Workers continuously take tasks from the queue.

---

# 4. Example

Suppose we have:

```text
3 worker threads
```

and submit:

```text
Task 1
Task 2
Task 3
Task 4
Task 5
```

Initially:

```text
Worker 1 -> Task 1
Worker 2 -> Task 2
Worker 3 -> Task 3

Queue:
Task 4 -> Task 5
```

When Worker 1 finishes:

```text
Worker 1 -> Task 4

Queue:
Task 5
```

When Worker 2 finishes:

```text
Worker 2 -> Task 5

Queue:
empty
```

The threads are reused instead of being recreated.

---

# 5. Requirements

## Functional Requirements

The thread pool should support:

```text
Create Pool

Submit Task

Execute Task

Shutdown Pool
```

In C++:

```cpp
ThreadPool pool(4);

pool.submit(...);

pool.shutdown();
```

---

## Non-Functional Requirements

The system should provide:

- Thread safety
- Efficient task execution
- Controlled resource usage
- Graceful shutdown
- Safe memory management
- Good throughput
- No busy waiting

---

# 6. High-Level Architecture

```text
                         Client
                           |
                           |
                      submit(task)
                           |
                           v
                  +----------------+
                  |   Task Queue   |
                  +----------------+
                           |
                     Condition
                     Variable
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
      Worker 1         Worker 2         Worker 3
          |                |                |
          +----------------+----------------+
                           |
                      Execute Task
```

---

# 7. Main Components

A thread pool contains:

## 1. Worker Threads

Responsible for executing tasks.

## 2. Task Queue

Stores pending tasks.

## 3. Mutex

Protects shared state.

## 4. Condition Variable

Allows workers to sleep when there are no tasks.

## 5. Shutdown State

Controls when workers should terminate.

---

# 8. Task Queue

Tasks are stored in FIFO order.

Example:

```text
HEAD
 |
 v

Task 1 -> Task 2 -> Task 3 -> Task 4

                                      ^
                                      |
                                     TAIL
```

Operations:

```text
enqueue()
dequeue()
```

In C++ we can use:

```cpp
std::queue<std::function<void()>>
```

---

# 9. Why `std::function<void()>`?

Instead of manually creating a C-style task structure:

```c
typedef struct Task
{
    void (*function)(void *);
    void *argument;
} Task;
```

C++ can represent a task using:

```cpp
std::function<void()>
```

This allows us to store:

```cpp
[] {
    cout << "Hello";
}
```

or:

```cpp
[] {
    calculateSomething();
}
```

or:

```cpp
std::bind(...)
```

or any callable object.

Example:

```cpp
std::function<void()> task = [] {
    std::cout << "Executing task\n";
};
```

---

# 10. Worker Thread Flow

Every worker executes approximately:

```text
while(true)
{
    Lock mutex

    while(queue is empty AND pool is not shutting down)
        wait

    if(shutdown AND queue is empty)
        exit

    get task from queue

    Unlock mutex

    execute task
}
```

Important:

The worker should **not hold the mutex while executing the task**.

---

# 11. Why Not Hold the Lock While Executing?

Bad design:

```cpp
lock();

task = queue.front();

execute(task);   // BAD

unlock();
```

Suppose the task takes:

```text
5 seconds
```

The mutex remains locked for 5 seconds.

Other workers or clients may be unable to access the shared queue.

Correct:

```cpp
lock();

task = queue.front();

unlock();

execute(task);
```

The lock protects only the shared queue.

---

# 12. Condition Variable

Workers should not continuously check the queue.

Bad:

```cpp
while (queue.empty())
{
    // keep checking
}
```

This is called **busy waiting** and wastes CPU.

Instead:

```text
Worker
   |
Queue empty
   |
Sleep
   |
   | condition_variable.wait()
   |
Task arrives
   |
Wake worker
   |
Execute task
```

---

# 13. Condition Variable Usage

Producer:

```cpp
condition.notify_one();
```

Worker:

```cpp
condition.wait(lock);
```

Typical pattern:

```cpp
condition.wait(lock, [this] {
    return stop || !tasks.empty();
});
```

The worker wakes when:

```text
stop == true

OR

tasks are available
```

---

# 14. Task Submission

The submission flow is:

```text
submit(task)
      |
      v
Acquire mutex
      |
      v
Add task to queue
      |
      v
Notify worker
      |
      v
Release mutex
```

Example:

```cpp
{
    std::unique_lock<std::mutex> lock(queueMutex);

    tasks.emplace(...);
}

condition.notify_one();
```

---

# 15. Why Notify After Unlock?

Both patterns can work, but this is a clean pattern:

```cpp
{
    std::unique_lock<std::mutex> lock(queueMutex);

    tasks.emplace(...);
}

condition.notify_one();
```

The worker can wake and immediately acquire the mutex without waiting for the submitting thread to release it.

---

# 16. Shutdown Design

There are two common shutdown semantics.

## Graceful Shutdown

Stop accepting new tasks but finish tasks already queued.

```text
Stop accepting tasks
        |
        v
Finish queued tasks
        |
        v
Workers exit
```

---

## Immediate Shutdown

Stop as quickly as possible and discard pending tasks.

```text
Stop accepting tasks
        |
        v
Discard pending tasks
        |
        v
Workers exit
```

The implementation below supports **graceful shutdown**.

---

# 17. Graceful Shutdown

Suppose:

```text
Queue:

Task 1
Task 2
Task 3
```

and:

```cpp
pool.shutdown();
```

Workers should continue:

```text
Task 1 -> Execute
Task 2 -> Execute
Task 3 -> Execute
```

Then:

```text
Workers terminate
```

This is usually safer because submitted work is not silently lost.

---

# 18. Thread Safety

Shared state includes:

```text
Task Queue
Shutdown Flag
```

These are protected using:

```text
std::mutex
```

The condition variable coordinates:

```text
Worker <-> Task Producer
```

---

# 19. Data Members

A C++ thread pool can use:

```cpp
std::vector<std::thread> workers;

std::queue<std::function<void()>> tasks;

std::mutex queueMutex;

std::condition_variable condition;

bool stop;
```

Conceptually:

```text
ThreadPool
    |
    +-- workers
    |
    +-- task queue
    |
    +-- mutex
    |
    +-- condition variable
    |
    +-- shutdown flag
```

---

# 20. Complete C++ Implementation

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <functional>
#include <future>
#include <stdexcept>

class ThreadPool {
private:

    // Worker threads
    std::vector<std::thread> workers;

    // Queue of tasks waiting to execute
    std::queue<std::function<void()>> tasks;

    // Protects the task queue and shutdown state
    std::mutex queueMutex;

    // Used to wake sleeping workers
    std::condition_variable condition;

    // Indicates that the pool is shutting down
    bool stop;


public:

    // ---------------------------------------------------------
    // Constructor
    // ---------------------------------------------------------

    explicit ThreadPool(size_t threadCount)
        : stop(false) {

        if (threadCount == 0) {
            throw std::invalid_argument(
                "Thread count must be greater than 0"
            );
        }

        // Create worker threads
        for (size_t i = 0; i < threadCount; ++i) {

            workers.emplace_back([this] {

                while (true) {

                    std::function<void()> task;

                    {
                        std::unique_lock<std::mutex> lock(
                            queueMutex
                        );

                        // Wait until:
                        //
                        // 1. There is a task
                        // OR
                        // 2. Pool is shutting down
                        //
                        condition.wait(
                            lock,
                            [this] {
                                return stop || !tasks.empty();
                            }
                        );

                        // If shutdown was requested and
                        // there are no remaining tasks,
                        // terminate this worker.
                        if (stop && tasks.empty()) {
                            return;
                        }

                        // Get next task
                        task = std::move(tasks.front());

                        tasks.pop();
                    }

                    // Execute outside the lock.
                    task();
                }
            });
        }
    }


    // ---------------------------------------------------------
    // Submit Task
    // ---------------------------------------------------------
    //
    // Accepts any callable and its arguments.
    //
    // Returns std::future so the caller can retrieve:
    //
    // - Return value
    // - Exception thrown by task
    //
    template <class F, class... Args>
    auto submit(F&& f, Args&&... args)
        -> std::future<
            std::invoke_result_t<F, Args...>
        >
    {
        using ReturnType =
            std::invoke_result_t<F, Args...>;

        // Create packaged task.
        auto task =
            std::make_shared<
                std::packaged_task<ReturnType()>
            >(
                std::bind(
                    std::forward<F>(f),
                    std::forward<Args>(args)...
                )
            );

        // Future associated with the task.
        std::future<ReturnType> result =
            task->get_future();

        {
            std::unique_lock<std::mutex> lock(
                queueMutex
            );

            // Do not accept tasks after shutdown.
            if (stop) {
                throw std::runtime_error(
                    "Cannot submit task after shutdown"
                );
            }

            // Add task to queue.
            tasks.emplace(
                [task]() {
                    (*task)();
                }
            );
        }

        // Wake one worker.
        condition.notify_one();

        return result;
    }


    // ---------------------------------------------------------
    // Shutdown
    // ---------------------------------------------------------
    //
    // Graceful shutdown:
    //
    // 1. Stop accepting new tasks.
    // 2. Finish queued tasks.
    // 3. Workers terminate.
    // 4. Join all threads.
    //
    void shutdown() {

        {
            std::unique_lock<std::mutex> lock(
                queueMutex
            );

            // Tell workers to stop after
            // completing queued tasks.
            stop = true;
        }

        // Wake all workers.
        condition.notify_all();

        // Wait for all workers to finish.
        for (std::thread& worker : workers) {

            if (worker.joinable()) {
                worker.join();
            }
        }
    }


    // ---------------------------------------------------------
    // Destructor
    // ---------------------------------------------------------

    ~ThreadPool() {

        shutdown();
    }
};
```

---

# 21. Using the Thread Pool

Example:

```cpp
#include <iostream>

int main() {

    ThreadPool pool(4);

    auto future1 = pool.submit([] {
        std::cout << "Task 1 running\n";
        return 10;
    });


    auto future2 = pool.submit([] {
        std::cout << "Task 2 running\n";
        return 20;
    });


    auto future3 = pool.submit([] {
        std::cout << "Task 3 running\n";
        return 30;
    });


    std::cout << "Result 1: "
              << future1.get()
              << std::endl;


    std::cout << "Result 2: "
              << future2.get()
              << std::endl;


    std::cout << "Result 3: "
              << future3.get()
              << std::endl;


    pool.shutdown();

    return 0;
}
```

---

# 22. Complete Example

Here is the implementation and usage together:

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <functional>
#include <future>
#include <stdexcept>

class ThreadPool {
private:

    std::vector<std::thread> workers;

    std::queue<std::function<void()>> tasks;

    std::mutex queueMutex;

    std::condition_variable condition;

    bool stop;


public:

    explicit ThreadPool(size_t threadCount)
        : stop(false) {

        if (threadCount == 0) {
            throw std::invalid_argument(
                "Thread count must be greater than 0"
            );
        }

        for (size_t i = 0; i < threadCount; ++i) {

            workers.emplace_back([this] {

                while (true) {

                    std::function<void()> task;

                    {
                        std::unique_lock<std::mutex> lock(
                            queueMutex
                        );

                        condition.wait(
                            lock,
                            [this] {
                                return stop || !tasks.empty();
                            }
                        );

                        if (stop && tasks.empty()) {
                            return;
                        }

                        task = std::move(tasks.front());

                        tasks.pop();
                    }

                    // Execute task outside lock.
                    task();
                }
            });
        }
    }


    template <class F, class... Args>
    auto submit(F&& f, Args&&... args)
        -> std::future<
            std::invoke_result_t<F, Args...>
        >
    {
        using ReturnType =
            std::invoke_result_t<F, Args...>;

        auto task =
            std::make_shared<
                std::packaged_task<ReturnType()>
            >(
                std::bind(
                    std::forward<F>(f),
                    std::forward<Args>(args)...
                )
            );

        std::future<ReturnType> result =
            task->get_future();

        {
            std::unique_lock<std::mutex> lock(
                queueMutex
            );

            if (stop) {
                throw std::runtime_error(
                    "Cannot submit task after shutdown"
                );
            }

            tasks.emplace(
                [task]() {
                    (*task)();
                }
            );
        }

        condition.notify_one();

        return result;
    }


    void shutdown() {

        {
            std::unique_lock<std::mutex> lock(
                queueMutex
            );

            stop = true;
        }

        condition.notify_all();

        for (std::thread& worker : workers) {

            if (worker.joinable()) {
                worker.join();
            }
        }
    }


    ~ThreadPool() {

        shutdown();
    }
};


int main() {

    ThreadPool pool(4);


    auto future1 = pool.submit([] {

        std::cout << "Executing Task 1\n";

        return 10;
    });


    auto future2 = pool.submit([] {

        std::cout << "Executing Task 2\n";

        return 20;
    });


    auto future3 = pool.submit([] {

        std::cout << "Executing Task 3\n";

        return 30;
    });


    auto future4 = pool.submit([] {

        std::cout << "Executing Task 4\n";

        return 40;
    });


    std::cout
        << "Result 1: "
        << future1.get()
        << std::endl;


    std::cout
        << "Result 2: "
        << future2.get()
        << std::endl;


    std::cout
        << "Result 3: "
        << future3.get()
        << std::endl;


    std::cout
        << "Result 4: "
        << future4.get()
        << std::endl;


    pool.shutdown();

    return 0;
}
```

---

# 23. How the Implementation Works

The constructor creates worker threads:

```cpp
ThreadPool pool(4);
```

This creates:

```text
Worker 1
Worker 2
Worker 3
Worker 4
```

They immediately start waiting for work.

---

# 24. Worker Loop

The worker executes:

```cpp
while (true)
{
    wait for task

    get task

    execute task
}
```

The important code is:

```cpp
condition.wait(
    lock,
    [this] {
        return stop || !tasks.empty();
    }
);
```

The worker sleeps until:

```text
tasks are available

OR

shutdown is requested
```

---

# 25. Task Submission

When:

```cpp
pool.submit(...);
```

is called:

```text
Client
  |
  v
submit()
  |
  v
Lock mutex
  |
  v
Add task to queue
  |
  v
Unlock mutex
  |
  v
notify_one()
```

A sleeping worker wakes up.

---

# 26. Why `notify_one()`?

Suppose:

```text
4 workers
```

and:

```text
1 task
```

Only one worker needs to wake up.

Therefore:

```cpp
condition.notify_one();
```

is efficient.

If we used:

```cpp
condition.notify_all();
```

all four workers could wake up even though only one task exists.

This can cause unnecessary contention.

---

# 27. Why `notify_all()` During Shutdown?

During shutdown:

```cpp
condition.notify_all();
```

is appropriate because **all sleeping workers need to wake up and check the shutdown condition**.

```text
Worker 1 sleeping
Worker 2 sleeping
Worker 3 sleeping
Worker 4 sleeping

        shutdown()

            |

       notify_all()

            |

+-----------+-----------+-----------+
|           |           |           |
v           v           v           v

Worker 1  Worker 2   Worker 3   Worker 4
   |          |          |          |
   +----------+----------+----------+
                    |
                  Exit
```

---

# 28. Why Use `std::future`?

Consider:

```cpp
auto future = pool.submit([] {
    return 100;
});
```

The task runs asynchronously.

The caller can later do:

```cpp
int result = future.get();
```

The future allows us to retrieve:

```text
Return value
```

and also propagates:

```text
Exceptions
```

from the worker task.

---

# 29. Exception Handling

Suppose:

```cpp
auto future = pool.submit([] {
    throw std::runtime_error("Something failed");
});
```

The worker does not need to manually catch the exception.

The `std::packaged_task` captures the exception and stores it in the future.

When:

```cpp
future.get();
```

is called, the exception is rethrown.

Example:

```cpp
try {

    auto future = pool.submit([] {
        throw std::runtime_error("Task failed");
    });

    future.get();

}
catch (const std::exception& e) {

    std::cout
        << "Error: "
        << e.what()
        << std::endl;
}
```

---

# 30. Shutdown Sequence

The shutdown function:

```cpp
void shutdown()
{
    stop = true;

    notify_all();

    join workers;
}
```

Conceptually:

```text
shutdown()
    |
    v
Stop accepting tasks
    |
    v
Wake workers
    |
    v
Workers finish queued tasks
    |
    v
Queue becomes empty
    |
    v
Workers exit
    |
    v
join()
    |
    v
Shutdown complete
```

---

# 31. Why `join()`?

Calling:

```cpp
worker.join();
```

means:

> Wait until this worker thread finishes.

Without joining the threads, the main program could exit while worker threads are still running.

Joining ensures clean shutdown.

---

# 32. Important Shutdown Invariant

The worker checks:

```cpp
if (stop && tasks.empty()) {
    return;
}
```

This is important.

Suppose:

```text
stop = true

Queue:
Task 1
Task 2
```

The worker should NOT immediately exit.

It should execute:

```text
Task 1
Task 2
```

Then:

```text
Queue empty
stop = true
```

Now it exits.

Therefore this implementation provides:

# Graceful Shutdown

---

# 33. Destructor Safety

The destructor calls:

```cpp
~ThreadPool()
{
    shutdown();
}
```

This provides automatic cleanup.

For example:

```cpp
{
    ThreadPool pool(4);

    pool.submit(...);

}
```

When the scope ends:

```text
Destructor
    |
    v
shutdown()
    |
    v
join workers
```

---

# 34. CPU-Bound vs IO-Bound Tasks

The number of threads should depend on the workload.

## CPU-Bound

Examples:

- Compression
- Encryption
- Image processing
- Mathematical calculations

If the machine has:

```text
8 CPU cores
```

a reasonable starting point might be:

```text
8 worker threads
```

or a small multiple depending on the workload.

Too many CPU-bound threads can increase:

```text
Context switching
CPU contention
```

---

# 35. IO-Bound

Examples:

- Network calls
- File operations
- Database operations
- Waiting for external services

Threads spend time waiting.

Therefore:

```text
Thread count > CPU core count
```

may make sense.

However, too many threads can still cause:

- Memory overhead
- Scheduling overhead
- Resource exhaustion

---

# 36. Fixed Thread Pool

Example:

```text
8 workers
```

Advantages:

- Simple
- Predictable
- Easy resource management
- Easy to reason about

Good for:

```text
Known workload
Stable traffic
```

---

# 37. Dynamic Thread Pool

A more advanced pool can dynamically change the number of workers.

Example:

```text
Minimum = 4
Maximum = 100
```

If the queue grows:

```text
Queue size increases
        |
        v
Create additional workers
```

When demand decreases:

```text
Workers become idle
        |
        v
Remove idle workers
```

This provides better resource utilization but increases complexity.

---

# 38. Bounded Task Queue

The implementation above uses an unbounded queue.

That can be dangerous.

Suppose:

```text
Incoming tasks = 1,000,000/sec

Processing capacity = 10,000/sec
```

The queue can grow indefinitely.

Eventually:

```text
Memory usage
    |
    v
    v
    v
Out of Memory
```

A production system should often use a **bounded queue**.

Example:

```text
Maximum Queue Size = 10,000
```

If the queue is full, possible policies include:

```text
Reject task
Block producer
Drop oldest
Drop newest
Run task in caller thread
```

---

# 39. Backpressure

A bounded queue provides backpressure.

Example:

```text
Producer
   |
   v
+----------------+
| Task Queue     |
| max = 10,000   |
+----------------+
   |
   v
Workers
```

If the queue is full:

```text
Producer
   |
   v
Queue Full
   |
   +----> Reject
   |
   +----> Block
   |
   +----> Retry
```

This prevents the system from accepting unlimited work.

---

# 40. Work Stealing

A more advanced architecture gives every worker its own queue:

```text
Worker 1 Queue

Worker 2 Queue

Worker 3 Queue

Worker 4 Queue
```

Suppose:

```text
Worker 1:
Task Task Task Task Task

Worker 2:
empty

Worker 3:
empty

Worker 4:
empty
```

Idle workers can steal tasks from Worker 1.

```text
Worker 2
    |
    | steal
    v

Worker 1 Queue
```

This is called:

# Work Stealing

It can improve scalability and reduce contention.

---

# 41. Global Queue vs Per-Worker Queue

## Global Queue

```text
             Global Queue
            /     |      \
           /      |       \
       Worker1 Worker2 Worker3
```

Advantages:

- Simple
- Easy task distribution

Disadvantages:

- One mutex can become a bottleneck
- High contention under heavy load

---

## Per-Worker Queue

```text
Worker 1 -> Queue 1

Worker 2 -> Queue 2

Worker 3 -> Queue 3
```

Advantages:

- Less contention
- Better scalability

Disadvantages:

- More complex
- Need work stealing
- Task balancing becomes harder

---

# 42. Deadlock Prevention

Avoid holding the queue mutex while executing user tasks.

Bad:

```cpp
lock();

task = queue.front();

task();

unlock();
```

Correct:

```cpp
lock();

task = queue.front();

unlock();

task();
```

Why?

A task might:

```text
Submit another task
Wait for another future
Acquire another lock
Perform slow IO
```

Holding the queue mutex during task execution can create serious contention or deadlocks.

---

# 43. Common Deadlock Scenario

Suppose:

```text
Worker 1
    |
    | holds queue mutex
    |
    v
Task executes
    |
    v
Task submits another task
    |
    v
submit() tries to acquire queue mutex
```

But Worker 1 already owns it.

Result:

```text
Deadlock
```

Therefore:

```text
Never hold the queue lock while executing user code.
```

This is an important interview point.

---

# 44. Performance Bottlenecks

Potential bottlenecks:

```text
Global Mutex
     |
     v
High Task Submission Rate
     |
     v
Lock Contention
```

Solutions:

- Per-worker queues
- Work stealing
- Lock-free queues
- Batch task submission
- Multiple task queues
- Sharding

---

# 45. Task Granularity

Tasks should not be too small.

Bad:

```text
Task:
increment integer
```

If the system spends more time doing:

```text
queue -> lock -> wake -> schedule
```

than doing actual work, the thread pool becomes inefficient.

Tasks should have enough work to justify scheduling overhead.

---

# 46. Task Priority

A simple queue is:

```text
FIFO
```

But some systems require priorities:

```text
High Priority
Medium Priority
Low Priority
```

Architecture:

```text
        +----------------+
        | High Priority  |
        +----------------+
                 |
        +----------------+
        | Medium         |
        +----------------+
                 |
        +----------------+
        | Low Priority   |
        +----------------+
```

Workers should normally prefer high-priority tasks.

---

# 47. Real-World Thread Pool Architecture

A production-grade design may look like:

```text
                     Client
                       |
                       v
                Task Submission
                       |
                       v
              +----------------+
              | Load Balancer  |
              +----------------+
                       |
          +------------+------------+
          |            |            |
          v            v            v
      Queue 1       Queue 2      Queue 3
          |            |            |
       Worker        Worker       Worker
          |            |            |
          +------------+------------+
                       |
                  Work Stealing
                       |
                       v
                Task Execution
```

Additional features:

- Bounded queues
- Backpressure
- Task priority
- Dynamic workers
- Work stealing
- Metrics
- Monitoring
- Retry policies
- Timeouts
- Cancellation

---

# 48. Monitoring

A production thread pool should expose metrics such as:

```text
Active Workers
Idle Workers
Queue Size
Tasks Submitted
Tasks Completed
Tasks Failed
Task Execution Time
Queue Wait Time
Rejected Tasks
```

Example:

```text
Thread Pool Metrics

Workers:           16
Active:            14
Idle:               2

Queue Size:       342

Submitted:     1,000,000
Completed:       999,600
Failed:              50
Rejected:           350
```

These metrics help identify:

- Saturation
- Queue buildup
- Slow tasks
- Insufficient workers
- Downstream bottlenecks

---

# 49. Failure Handling

## Worker Failure

Possible strategies:

```text
Detect worker failure
        |
        v
Log failure
        |
        v
Create replacement worker
```

---

## Task Failure

A task may throw an exception.

Using:

```cpp
std::future
```

the exception can be propagated back to the caller.

Possible production strategies:

- Retry
- Dead-letter queue
- Logging
- Alerting
- Circuit breaker

---

# 50. Cancellation

Cancellation is more complicated.

Suppose:

```text
Task 1
Task 2
Task 3
```

If Task 3 has not started, we may remove it.

But if Task 1 is already executing:

```text
Worker
  |
  v
Task 1 running
```

we cannot safely kill the C++ thread arbitrarily.

Instead, cooperative cancellation can be implemented.

Example:

```cpp
std::atomic<bool> cancelled;
```

The task periodically checks:

```cpp
if (cancelled) {
    return;
}
```

---

# 51. Thread Pool vs Creating Threads Directly

| Feature | Thread Per Task | Thread Pool |
|---|---|---|
| Thread creation | Every task | Once |
| Thread reuse | No | Yes |
| Resource control | Poor | Better |
| Throughput | Lower | Higher |
| Implementation | Simple initially | More complex |
| Scalability | Poor | Better |
| Backpressure | Difficult | Easier |

---

# 52. Complexity

Let:

```text
T = number of worker threads
Q = number of queued tasks
```

Task submission:

```text
O(1)
```

Average dequeue:

```text
O(1)
```

Task execution:

```text
Depends on task
```

Shutdown:

```text
O(T)
```

because we join all worker threads.

---

# 53. Important Interview Questions

## Q1. Why not create a thread per request?

Answer:

Creating a thread for every request causes thread creation overhead, memory consumption, context switching, and potentially resource exhaustion.

A thread pool reuses a bounded number of worker threads.

---

## Q2. How many threads should the pool have?

Answer:

It depends on the workload.

CPU-bound:

```text
Around number of CPU cores
```

IO-bound:

```text
Can use more threads
```

But the optimal value should be measured based on workload and system limits.

---

## Q3. How do workers wait efficiently?

Use:

```text
Condition Variable
```

Workers sleep while there are no tasks instead of busy-waiting.

---

## Q4. Why use a mutex?

The task queue is shared between:

```text
Producers
+
Workers
```

The mutex protects concurrent access.

---

## Q5. Why use a condition variable?

It allows workers to sleep when the queue is empty and wake up when work arrives.

---

## Q6. Why call `notify_one()` after submitting?

Usually only one worker is needed for one newly available task.

---

## Q7. Why call `notify_all()` during shutdown?

Every sleeping worker needs to wake up and check the shutdown state.

---

## Q8. Why don't workers hold the mutex while executing tasks?

Because task execution may take a long time or call back into the thread pool.

Holding the mutex would create contention or potentially cause deadlocks.

---

## Q9. What happens if tasks arrive faster than workers can process them?

The queue grows.

A production system should use:

```text
Bounded Queue
+
Backpressure
```

to prevent unlimited memory growth.

---

## Q10. How can we improve scalability?

Use:

- Multiple queues
- Per-worker queues
- Work stealing
- Lock-free queues
- Dynamic worker scaling
- Task batching

---

# 54. System Design Discussion

A strong interview answer can follow this sequence:

```text
1. Requirements
        |
        v
2. Worker Threads
        |
        v
3. Task Queue
        |
        v
4. Mutex
        |
        v
5. Condition Variable
        |
        v
6. Task Submission
        |
        v
7. Worker Execution
        |
        v
8. Graceful Shutdown
        |
        v
9. Backpressure
        |
        v
10. Scalability
        |
        v
11. Monitoring
```

---

# 55. Basic Design

Start with:

```text
Thread Pool

    |
    +---- Worker Threads
    |
    +---- Global Task Queue
    |
    +---- Mutex
    |
    +---- Condition Variable
    |
    +---- Shutdown Flag
```

This is enough for a basic implementation.

---

# 56. Production-Level Design

For a large-scale system:

```text
                    Client
                      |
                      v
               Task Submission
                      |
                      v
              +---------------+
              | Load Balancer |
              +---------------+
                      |
          +-----------+-----------+
          |           |           |
          v           v           v
       Queue 1     Queue 2     Queue 3
          |           |           |
       Worker       Worker      Worker
          |           |           |
          +-----------+-----------+
                      |
                Work Stealing
                      |
                      v
                Task Execution
                      |
                      v
                 Monitoring
```

Consider:

```text
Bounded queues
Backpressure
Work stealing
Task priorities
Dynamic scaling
Timeouts
Retries
Cancellation
Metrics
```

---

# 57. Final Design Summary

A basic thread pool consists of:

```text
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

The core worker algorithm is:

```text
while(true)
{
    lock queue

    wait until:
        task available
        OR shutdown

    if shutdown AND queue empty:
        exit

    get task

    unlock queue

    execute task
}
```

The key design principle is:

```text
Protect shared state with a mutex,
but never hold the mutex while executing user code.
```

---

# 58. Key Takeaways

Remember these points for interviews:

```text
Thread Pool
    |
    +-- Reuses worker threads
    |
    +-- Avoids thread creation per request
    |
    +-- Uses a task queue
    |
    +-- Uses mutex for synchronization
    |
    +-- Uses condition variable for efficient waiting
    |
    +-- Supports graceful shutdown
    |
    +-- Should usually have bounded queues in production
    |
    +-- Can scale using work stealing
```

For a basic implementation:

```text
std::vector<std::thread>
        +
std::queue<std::function<void()>>
        +
std::mutex
        +
std::condition_variable
        +
std::future
```

This provides a clean and reusable C++ thread-pool implementation.
