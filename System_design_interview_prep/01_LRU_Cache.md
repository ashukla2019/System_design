# LRU Cache — C++ Implementation & System Design
---

# 1. Problem Statement

Design and implement an **LRU (Least Recently Used) Cache**.

The cache should support:

- `get(key)` — return the value associated with a key.
- `put(key, value)` — insert or update a key-value pair.
- When the cache exceeds its capacity, remove the **least recently used** entry.
- Both `get()` and `put()` should run in **O(1) average time**.

---

# 2. What is an LRU Cache?

LRU stands for **Least Recently Used**.

When a cache reaches its maximum capacity, we need to decide which item to remove.

An LRU cache removes the item that **has not been accessed for the longest time**.

For example, with capacity `3`:

```text
1  <- Least Recently Used
2
3  <- Most Recently Used
```

If we execute:

```cpp
get(1);
```

key `1` becomes the most recently used:

```text
2  <- Least Recently Used
3
1  <- Most Recently Used
```

Now:

```cpp
put(4, 40);
```

The cache is full, so key `2` is evicted:

```text
3
1
4  <- Most Recently Used
```

---

# 3. Requirements

## Functional Requirements

### `get(key)`

```cpp
int get(int key);
```

- Return the value if the key exists.
- Return `-1` if it does not exist.
- Accessing a key makes it the **most recently used**.

### `put(key, value)`

```cpp
void put(int key, int value);
```

- Insert a new key.
- Update an existing key.
- Updated/accessed keys become the **most recently used**.
- If capacity is exceeded, evict the **least recently used** key.

---

# 4. Why Two Data Structures?

We need two operations to be O(1):

1. Find a key quickly.
2. Move/remove an item quickly.

A single data structure cannot conveniently give us both.

## Hash Map

Use:

```cpp
unordered_map<int, Node*>
```

This provides approximately:

```text
get key -> O(1)
```

The map stores:

```text
key -> pointer to linked-list node
```

## Doubly Linked List

Use a doubly linked list to maintain usage order.

```text
HEAD -> [Most Recently Used] -> ... -> [Least Recently Used] -> TAIL
```

The convention is:

```text
HEAD = MRU side
TAIL = LRU side
```

A doubly linked list is important because we can remove an arbitrary node in O(1).

For example:

```text
A <-> B <-> C
```

Remove `B`:

```text
A.next = C
C.prev = A
```

No traversal is required.

---

# 5. Data Structure Design

We maintain:

```cpp
unordered_map<int, Node*> cache;
```

and:

```text
HEAD <-> Node <-> Node <-> Node <-> TAIL
```

The convention is:

```text
HEAD -> Most Recently Used
TAIL -> Least Recently Used
```

We use dummy `head` and `tail` nodes.

This avoids special cases when:

- Adding the first node.
- Removing the last node.
- Removing a node from the middle.
- Moving a node to the front.

---

# 6. Node Structure

Each linked-list node contains:

```cpp
struct Node {
    int key;
    int value;
    Node* prev;
    Node* next;
};
```

We store the **key inside the node** because when evicting the least recently used node, we need its key to remove it from the hash map.

---

# 7. Complete C++ Implementation

```cpp
#include <iostream>
#include <unordered_map>

using namespace std;

class LRUCache {
private:

    struct Node {
        int key;
        int value;
        Node* prev;
        Node* next;

        Node(int k, int v)
            : key(k), value(v), prev(nullptr), next(nullptr) {}
    };

    int capacity;

    // key -> corresponding linked-list node
    unordered_map<int, Node*> cache;

    // Dummy nodes
    Node* head; // MRU side
    Node* tail; // LRU side

    // Add node immediately after head.
    // Therefore, node becomes MRU.
    void addToFront(Node* node) {
        node->next = head->next;
        node->prev = head;

        head->next->prev = node;
        head->next = node;
    }

    // Remove a node from the linked list.
    void removeNode(Node* node) {
        node->prev->next = node->next;
        node->next->prev = node->prev;
    }

    // Move an existing node to the MRU position.
    void moveToFront(Node* node) {
        removeNode(node);
        addToFront(node);
    }

public:

    LRUCache(int capacity) : capacity(capacity) {

        head = new Node(-1, -1);
        tail = new Node(-1, -1);

        head->next = tail;
        tail->prev = head;
    }

    int get(int key) {

        auto it = cache.find(key);

        if (it == cache.end()) {
            return -1;
        }

        Node* node = it->second;

        // Access makes this key most recently used.
        moveToFront(node);

        return node->value;
    }

    void put(int key, int value) {

        // Key already exists.
        auto it = cache.find(key);

        if (it != cache.end()) {

            Node* node = it->second;

            node->value = value;

            // Updated key becomes MRU.
            moveToFront(node);

            return;
        }

        // Create a new node.
        Node* node = new Node(key, value);

        // Add to hash map.
        cache[key] = node;

        // New entry is MRU.
        addToFront(node);

        // Cache is over capacity.
        if (cache.size() > capacity) {

            // Node immediately before tail is LRU.
            Node* lru = tail->prev;

            // Remove from hash map.
            cache.erase(lru->key);

            // Remove from linked list.
            removeNode(lru);

            // Free memory.
            delete lru;
        }
    }

    ~LRUCache() {

        Node* current = head;

        while (current != nullptr) {

            Node* next = current->next;

            delete current;

            current = next;
        }
    }
};
```

---

# 8. Example Usage

```cpp
int main() {

    LRUCache cache(2);

    cache.put(1, 10);
    cache.put(2, 20);

    cout << cache.get(1) << endl;
    // 10

    cache.put(3, 30);
    // Key 2 is evicted.

    cout << cache.get(2) << endl;
    // -1

    cout << cache.get(3) << endl;
    // 30

    cache.put(4, 40);
    // Key 1 is evicted.

    cout << cache.get(1) << endl;
    // -1

    cout << cache.get(4) << endl;
    // 40

    return 0;
}
```

---

# 9. Step-by-Step Example

Assume:

```text
capacity = 3
```

Initially:

```text
HEAD <-> TAIL
```

## `put(1, 10)`

```text
HEAD <-> 1 <-> TAIL
         ^
        MRU
```

## `put(2, 20)`

```text
HEAD <-> 2 <-> 1 <-> TAIL
         ^         ^
        MRU       LRU
```

## `put(3, 30)`

```text
HEAD <-> 3 <-> 2 <-> 1 <-> TAIL
         ^                   ^
        MRU                 LRU
```

## `get(1)`

Key `1` was accessed, so move it to the front:

```text
HEAD <-> 1 <-> 3 <-> 2 <-> TAIL
         ^                   ^
        MRU                 LRU
```

## `put(4, 40)`

The cache exceeds capacity.

The node immediately before `TAIL` is `2`.

Evict `2`:

```text
HEAD <-> 4 <-> 1 <-> 3 <-> TAIL
         ^                   ^
        MRU                 LRU
```

---

# 10. Complexity

| Operation | Time Complexity | Explanation |
|---|---:|---|
| `get()` | O(1) average | Hash lookup + list move |
| `put()` existing key | O(1) average | Hash lookup + list move |
| `put()` new key | O(1) average | Hash insertion + list insertion |
| Eviction | O(1) | Remove tail node |
| Space | O(capacity) | Hash map + linked list |

The `unordered_map` gives O(1) **average** lookup.

Strictly speaking, a hash table can degrade to O(n) in pathological collision cases.

---

# 11. Why Not Use a Queue?

A normal queue gives:

```text
push -> O(1)
pop  -> O(1)
```

But suppose we have:

```text
1 2 3 4 5
```

and access `2`.

We need:

```text
1 3 4 5 2
```

Moving `2` from the middle of a normal queue requires finding/removing it.

Therefore:

```text
Queue alone -> Not sufficient
```

---

# 12. Why Not Use Only a Hash Map?

A hash map gives:

```text
get(key) -> O(1)
put(key) -> O(1)
```

But it doesn't maintain usage ordering.

We don't know:

```text
Which key was used least recently?
```

Therefore:

```text
Hash map alone -> Not sufficient
```

---

# 13. Why Hash Map + Doubly Linked List?

Together:

```text
                 Hash Map
              key -> Node*
                    |
                    v
HEAD <-> Node <-> Node <-> Node <-> TAIL
 ^                                      ^
MRU                                    LRU
```

The hash map answers:

```text
"Where is this key?"
```

The linked list answers:

```text
"What is the usage order?"
```

This gives the required O(1) operations.

---

# 14. System Design Discussion

The C++ class above solves the **in-memory data-structure problem**.

A production cache has additional requirements:

- Scalability
- High availability
- Fault tolerance
- Concurrency
- TTL
- Cache invalidation
- Distributed storage
- Replication
- Monitoring
- Failure handling
- Hot-key handling
- Cache stampede protection

---

# 15. Functional Requirements for a Production Cache

A distributed cache might provide:

```text
GET(key)
PUT(key, value)
DELETE(key)
```

Additional requirements:

- Maximum cache size
- TTL / expiration
- LRU eviction
- High read throughput
- Low latency
- Thread safety
- Fault tolerance
- Monitoring
- Replication
- Horizontal scaling

---

# 16. High-Level Architecture

A simple cache architecture:

```text
                 +----------------+
                 |    Clients     |
                 +-------+--------+
                         |
                         v
                 +---------------+
                 | Load Balancer |
                 +-------+-------+
                         |
            +------------+------------+
            |            |            |
            v            v            v
       App Server   App Server   App Server
            |            |            |
            +------------+------------+
                         |
                         v
                 +---------------+
                 | Cache Cluster |
                 +-------+-------+
                         |
                         v
                   +----------+
                   | Database |
                   +----------+
```

The cache cluster can contain multiple cache nodes.

---

# 17. Cache-Aside Pattern

One of the most common architectures is **cache-aside**.

On a read:

```text
Application
    |
    | GET key
    v
  Cache
    |
    +---- HIT ----> Return value
    |
    +---- MISS
           |
           v
       Database
           |
           v
      Put in cache
           |
           v
      Return value
```

Pseudo-code:

```cpp
value = cache.get(key);

if (value != NOT_FOUND) {
    return value;
}

value = database.get(key);

if (value != NOT_FOUND) {
    cache.put(key, value);
}

return value;
```

### Advantages

- Simple
- Application controls what gets cached
- Cache failure does not necessarily mean application failure
- Only requested data gets populated

---

# 18. Cache Eviction Policies

LRU is one possible eviction policy.

## LRU

Remove the item that has not been used for the longest time.

```text
Good general-purpose policy
```

## LFU

**Least Frequently Used**

Remove the item accessed the fewest times.

Useful when frequency is more important than recency.

## FIFO

**First In, First Out**

Remove the oldest inserted item.

Simple but doesn't consider access patterns.

## Random

Evict a random item.

Very simple and can be useful when maintaining exact LRU is too expensive.

---

# 19. TTL

LRU alone doesn't solve stale-data problems.

Consider:

```text
User profile -> cached forever
```

The database changes, but the cache may continue returning the old value.

Therefore, production caches often support:

```text
TTL = Time To Live
```

Example:

```text
put("user:123", user, TTL = 300 seconds)
```

After 300 seconds, the value expires.

A production cache can therefore use:

```text
LRU + TTL
```

Each entry could conceptually contain:

```text
+----------------+
| key            |
| value          |
| lastAccess     |
| expiryTime     |
+----------------+
```

---

# 20. Thread Safety

The basic C++ implementation is **not thread-safe**.

In a multi-threaded application, multiple threads can simultaneously execute:

```text
get()
put()
```

and modify:

- `unordered_map`
- Linked-list pointers

This can cause data races and memory corruption.

A simple solution is a mutex:

```cpp
std::mutex mutex;
```

Then:

```cpp
int get(int key) {

    std::lock_guard<std::mutex> lock(mutex);

    // existing implementation
}
```

And:

```cpp
void put(int key, int value) {

    std::lock_guard<std::mutex> lock(mutex);

    // existing implementation
}
```

However, one global lock can become a bottleneck under high concurrency.

---

# 21. Improving Concurrency

For higher throughput, we can partition the cache.

For example:

```text
Cache
 |
 +-- Shard 0
 |
 +-- Shard 1
 |
 +-- Shard 2
 |
 +-- Shard 3
```

Each shard has its own:

```text
HashMap
Linked List
Lock
```

A key is mapped to a shard:

```cpp
shard = hash(key) % numberOfShards;
```

Now different threads can operate on different shards concurrently.

This reduces lock contention.

---

# 22. Distributed Cache

When a single machine cannot hold the entire cache, we distribute keys across multiple cache servers.

Example:

```text
              Cache Cluster

        +--------------------+
        |    Cache Node 1    |
        |    keys A - F      |
        +--------------------+

        +--------------------+
        |    Cache Node 2    |
        |    keys G - M      |
        +--------------------+

        +--------------------+
        |    Cache Node 3    |
        |    keys N - Z      |
        +--------------------+
```

The major problem becomes:

> How do we decide which cache node stores a key?

---

# 23. Consistent Hashing

A common solution is **consistent hashing**.

Instead of:

```text
hash(key) % N
```

we use a hash ring.

Conceptually:

```text
                 Node A
                   *
              *         *
           Node D       Node B
              *         *
                   *
                 Node C
```

Keys are hashed onto the ring and assigned to the next node.

### Advantages

- Adding/removing nodes causes less key movement.
- Useful for horizontally scalable cache clusters.

---

# 24. Replication

A cache node can fail.

For example:

```text
Node A
  |
  X  <- failure
```

Without replication, all keys on that node are lost.

We can maintain replicas:

```text
Primary
   |
   +---- Replica 1
   |
   +---- Replica 2
```

If the primary fails, another node can become the primary.

### Trade-offs

Replication introduces:

- More memory usage
- Network overhead
- Consistency complexity
- Failover complexity

---

# 25. Cache Consistency

One of the most important system-design questions is:

> What happens when the database changes?

Suppose:

```text
Database:
user:123 = Alice
```

Cache:

```text
user:123 = Alice
```

Now the database changes:

```text
user:123 = Bob
```

But cache still contains:

```text
user:123 = Alice
```

The application could return stale data.

Possible solutions include:

- Write-through
- Write-around
- Write-back
- Cache invalidation
- TTL

---

# 26. Write-Through Cache

The application writes to the cache and the cache writes to the database.

```text
Application
     |
     v
   Cache
     |
     v
 Database
```

### Advantages

- Cache and database remain more closely synchronized.
- Reads are fast.

### Disadvantages

- Write latency can increase.
- More coupling between cache and database.

---

# 27. Write-Around Cache

Writes go directly to the database.

```text
Application
     |
     v
 Database

Cache is not populated on write.
```

The next read populates the cache.

Useful when data is written frequently but read infrequently.

---

# 28. Write-Back Cache

Writes go to the cache first.

```text
Application
     |
     v
   Cache
     |
     | asynchronous
     v
 Database
```

### Advantages

- Very fast writes.
- Database receives writes asynchronously.

### Disadvantages

- Data-loss risk if the cache fails before persistence.
- More complicated consistency model.

---

# 29. Cache Invalidation

Another common strategy:

```text
UPDATE database
       |
       v
DELETE cache key
```

Then the next read loads the new value:

```text
Cache MISS
    |
    v
Database
    |
    v
Put into cache
```

This is simple and commonly used with cache-aside.

---

# 30. Cache Stampede

Consider a very popular key:

```text
product:123
```

Its cache entry expires.

Suddenly:

```text
10,000 requests
```

arrive simultaneously.

All requests see:

```text
CACHE MISS
```

and all query the database.

Conceptually:

```text
             Cache Miss
                 |
      +----------+----------+
      |          |          |
      v          v          v
     DB         DB         DB
      |          |          |
      +----------+----------+
                 |
             Database
             overload
```

This is called:

- Cache stampede
- Thundering herd

### Solutions

- Request coalescing
- Distributed locking
- Single-flight
- Randomized TTL
- Proactive refresh
- Background refresh

For example:

```text
Request 1 -> DB
Request 2 --+
Request 3 --+--> Wait for Request 1
Request 4 --+
```

Only one request loads the missing value.

---

# 31. Cache Penetration

Another problem occurs when users repeatedly request keys that don't exist.

Example:

```text
GET user:999999
GET user:999999
GET user:999999
...
```

Every request misses the cache and queries the database.

One solution is to cache negative results:

```text
user:999999 -> NOT_FOUND
```

with a short TTL.

---

# 32. Hot Keys

Some keys may receive a disproportionate amount of traffic.

For example:

```text
product:iphone
```

might receive millions of requests.

Even if the cache is distributed, one cache node may receive most of the traffic.

### Solutions

- Replicate hot keys
- Local in-process caching
- Request coalescing
- Load-aware routing

---

# 33. Two-Level Cache

A production system can use:

```text
              Application
                   |
                   v
          +------------------+
          | L1 Local Cache   |
          | Very Fast        |
          +--------+---------+
                   |
                 MISS
                   |
                   v
          +------------------+
          | L2 Cache         |
          | Distributed      |
          +--------+---------+
                   |
                 MISS
                   |
                   v
              Database
```

## L1 Cache

### Advantages

- Extremely low latency
- No network request

### Disadvantages

- Limited memory
- Data can become inconsistent between application instances

## L2 Cache

### Advantages

- Shared across application instances
- Larger capacity

### Disadvantages

- Network latency
- More infrastructure

---

# 34. Observability

A production cache should expose metrics such as:

```text
Cache hit rate
Cache miss rate
Eviction count
Average latency
P50 latency
P95 latency
P99 latency
Memory usage
Number of keys
Request rate
Error rate
Hot keys
Connection count
```

One particularly important metric is:

```text
Hit Rate = Cache Hits / Total Requests
```

For example:

```text
Hits      = 900,000
Requests  = 1,000,000

Hit Rate  = 90%
```

A low hit rate could indicate:

- Cache is too small
- TTL is too short
- Poor key design
- Bad eviction policy
- Working set is larger than cache capacity

---

# 35. Failure Handling

A cache should generally not become a single point of failure for the application.

If:

```text
Cache DOWN
```

the application may fall back to:

```text
Database
```

But this creates another problem:

```text
Cache failure
     |
     v
All traffic goes to DB
     |
     v
DB overload
     |
     v
Application failure
```

Therefore, production systems may use:

- Circuit breakers
- Rate limiting
- Connection limits
- Database protection
- Graceful degradation
- Replicated caches
- Backpressure

---

# 36. Capacity Planning

Suppose:

```text
Number of cached objects = 100 million
Average object size      = 1 KB
```

Raw data size is approximately:

```text
100 million * 1 KB
= 100 GB
```

But actual memory requirements are higher because of:

- Hash-map overhead
- Linked-list node overhead
- Keys
- Pointers
- Allocator overhead
- Metadata
- Replication

Therefore, don't size the cache based only on raw value size.

A useful approximation is:

```text
Required Memory
    =
Raw Data
    +
Metadata
    +
Overhead
    +
Replication
    +
Headroom
```

---

# 37. Serialization

Distributed caches usually store values in a serialized form.

Possible formats include:

```text
JSON
Protocol Buffers
MessagePack
Custom binary format
```

For high-performance systems, binary serialization is often preferred because it can reduce:

- Network bandwidth
- Serialization cost
- Memory usage

Trade-off:

- More complexity
- Less human-readable

---

# 38. Cache Key Design

Good cache keys should be:

- Unique
- Deterministic
- Compact
- Easy to invalidate

Example:

```text
user:123
product:456
order:789
```

For more complex data:

```text
user:123:profile
product:456:recommendations
```

Avoid ambiguous keys:

```text
123
456
789
```

because their meaning is unclear.

---

# 39. Cache Size and Eviction

Suppose capacity is:

```text
1 million entries
```

When the cache reaches capacity, the eviction policy determines which entry is removed.

With LRU:

```text
Most Recently Used
        |
        v
+---+---+---+---+---+
| A | B | C | D | E |
+---+---+---+---+---+
                ^
               LRU
```

If `E` is accessed:

```text
+---+---+---+---+---+
| E | A | B | C | D |
+---+---+---+---+---+
  ^
 MRU               LRU
```

If a new item `F` arrives:

```text
+---+---+---+---+---+
| F | E | A | B | C |
+---+---+---+---+---+
```

`D` is evicted.

---

# 40. Important Interview Trade-offs

## Why LRU?

LRU works well when recently accessed data is likely to be accessed again.

Example:

```text
User recently viewed product A
        |
        v
Likely to view product A again
```

But LRU isn't universally optimal.

If access frequency matters more than recency, LFU may perform better.

---

## Why not store everything?

Memory is expensive and limited.

Caching everything can:

- Increase infrastructure cost
- Increase eviction churn
- Increase memory pressure

We want to cache the **working set**.

---

## Why not use only local memory?

Local cache is extremely fast but:

```text
Server A -> Cache A
Server B -> Cache B
Server C -> Cache C
```

Each server has different cache contents.

A distributed cache provides shared state:

```text
Server A --+
Server B --+--> Distributed Cache
Server C --+
```

---

# 41. System Design Architecture

A strong high-level design could look like:

```text
                         Clients
                            |
                            v
                    +---------------+
                    | Load Balancer |
                    +-------+-------+
                            |
            +---------------+---------------+
            |               |               |
            v               v               v
       App Server      App Server      App Server
            |               |               |
            +---------------+---------------+
                            |
                            v
                 +--------------------+
                 |   L1 Local Cache   |
                 +---------+----------+
                           |
                         MISS
                           |
                           v
                 +--------------------+
                 | Distributed Cache  |
                 |                    |
                 | Node 1             |
                 | Node 2             |
                 | Node 3             |
                 +---------+----------+
                           |
                         MISS
                           |
                           v
                    +------------+
                    |  Database  |
                    +------------+
```

The distributed cache can use:

```text
Consistent Hashing
        +
Replication
        +
LRU / LFU
        +
TTL
```

---

# 42. System Design Clarifying Questions

Before designing the production system, ask:

## Scale

```text
How many requests per second?

How many keys?

How large is each value?

How much total cache memory is required?
```

## Latency

```text
What is the target latency?

P50?

P95?

P99?
```

## Consistency

```text
Can stale data be returned?

How stale can it be?

Is strong consistency required?
```

## Availability

```text
What happens if the cache goes down?

Can the database handle cache misses?
```

## Eviction

```text
LRU?

LFU?

TTL?

Combination?
```

## Data

```text
What types of values are cached?

Are values small or large?

Are values compressible?
```

## Distribution

```text
Single machine or distributed?

How many cache nodes?

Do we need replication?
```

---

# 43. Common Interview Follow-up Questions

## Q1. Why do we need a doubly linked list?

Because we need O(1) removal of an arbitrary node.

---

## Q2. Why store the key in the Node?

During eviction, we have the node but need to remove its key from the hash map:

```cpp
cache.erase(lru->key);
```

---

## Q3. Why move an item on `get()`?

Because accessing an item makes it recently used.

---

## Q4. What happens when an existing key is updated?

Its value is updated and it becomes MRU.

Example:

```text
Before:

HEAD -> 3 -> 2 -> 1 -> TAIL

put(2, newValue)

After:

HEAD -> 2 -> 3 -> 1 -> TAIL
```

---

## Q5. What happens when capacity is zero?

A `put()` immediately results in eviction.

A production implementation may explicitly validate capacity during construction.

---

## Q6. Is `unordered_map` guaranteed O(1)?

No.

It provides O(1) **average** complexity.

Worst-case complexity can degrade because of hash collisions.

---

## Q7. Is the implementation thread-safe?

No.

A mutex or another concurrency mechanism is required.

---

## Q8. How would you distribute the cache?

Use partitioning/sharding, commonly with consistent hashing.

---

## Q9. How do you handle cache failures?

Use:

- Replication
- Failover
- Health checks
- Circuit breakers
- Database fallback
- Graceful degradation

---

## Q10. How do you prevent stale data?

Use:

- TTL
- Cache invalidation
- Write-through
- Write-around
- Write-back
- Event-based invalidation

depending on the consistency requirements.

---

## Q11. How do you handle cache stampede?

Use:

- Request coalescing
- Single-flight
- Distributed locks
- Jittered TTL
- Proactive refresh
- Background refresh

---

## Q12. How do you handle hot keys?

Use:

- Key replication
- Local caching
- Request coalescing
- Load-aware routing

---

# 44. Production-Level Improvements to the C++ Implementation

The basic implementation can be improved for production use.

Potential improvements:

```text
1. Thread safety
2. Generic key/value types
3. TTL support
4. Statistics
5. Custom allocator
6. Sharding
7. Memory limits
8. Exception safety
9. Smart pointers
10. Background expiration
```

For example, instead of:

```cpp
LRUCache
```

we could design:

```cpp
template <typename Key, typename Value>
class LRUCache;
```

This allows:

```cpp
LRUCache<string, User> cache;
```

or:

```cpp
LRUCache<int, string> cache;
```

---

# 45. Testing Strategy

A production implementation should be tested with:

## Basic Tests

```text
get() existing key
get() missing key
put() new key
put() existing key
eviction
capacity = 1
capacity = 0
```

## Ordering Tests

Verify that `get()` updates MRU ordering.

Example:

```text
capacity = 2

put(1)
put(2)
get(1)
put(3)
```

Expected:

```text
2 is evicted
```

---

## Update Tests

```text
put(1, 10)
put(1, 20)
get(1)
```

Expected:

```text
20
```

---

## Stress Tests

Test:

```text
Millions of get()
Millions of put()
Large capacity
High concurrency
Random access patterns
```

---

# 46. Important Edge Cases

## Capacity = 1

```text
put(1)
put(2)
```

Expected:

```text
1 is evicted
2 remains
```

## Missing Key

```cpp
get(999);
```

Expected:

```text
-1
```

## Updating Existing Key

```cpp
put(1, 10);
put(1, 20);
```

Expected:

```text
get(1) == 20
```

## Access Changes Eviction Order

```text
capacity = 2

put(1)
put(2)
get(1)
put(3)
```

Expected:

```text
2 is evicted
```

Not `1`, because `1` was recently accessed.

---

# 47. Mental Model for Interviews

Remember the LRU design as:

```text
                 FAST LOOKUP
                     |
                     v
               Hash Map
             key -> Node*
                     |
                     v
        Doubly Linked List
                     |
        +------------+------------+
        |                         |
       MRU                       LRU
        |                         |
        v                         v
      HEAD                      TAIL
```

When we:

```text
GET
```

we:

```text
1. Find node using hash map
2. Remove node from list
3. Move node to front
4. Return value
```

When we:

```text
PUT existing
```

we:

```text
1. Find node
2. Update value
3. Move node to front
```

When we:

```text
PUT new
```

we:

```text
1. Create node
2. Add to hash map
3. Add to front
4. If capacity exceeded:
       remove node before tail
       erase its key from map
       delete node
```

---

# 48. Final Summary

The canonical LRU cache implementation uses:

```text
Hash Map
    +
Doubly Linked List
```

The hash map provides:

```text
O(1) average lookup
```

The doubly linked list provides:

```text
O(1) insertion
O(1) deletion
O(1) movement
O(1) eviction
```

Therefore:

```text
GET        -> O(1) average
PUT        -> O(1) average
EVICTION   -> O(1)
SPACE      -> O(capacity)
```

For a system-design interview, extend the basic LRU implementation with:

```text
                LRU Cache
                    |
        +-----------+-----------+
        |           |           |
       TTL      Concurrency   Metrics
        |           |           |
        +-----------+-----------+
                    |
              Distributed
                    |
        +-----------+-----------+
        |           |           |
    Sharding   Replication   Failover
        |
 Consistent Hashing
        |
 Cache Consistency
        |
 +------+------+------+
 |      |      |      |
TTL  Invalidate  Write-through
               Write-around
               Write-back
```

The key distinction to communicate in an interview is:

> **The C++ LRU implementation solves the in-memory data-structure problem. A production cache system additionally needs to solve concurrency, distribution, consistency, availability, eviction, expiration, monitoring, and failure-handling problems.**
