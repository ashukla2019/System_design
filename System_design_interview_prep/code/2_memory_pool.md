# C++ Memory Pool — Interview Notes

## 1. What is a Memory Pool?

A memory pool allocates a **large chunk of memory once** and divides it into fixed-size blocks.

Instead of repeatedly doing:

```text
new → allocate from heap
delete → return to heap
```

we do:

```text
Allocate large memory
        ↓
Divide into blocks
        ↓
allocate() → take a free block
deallocate() → return block to pool
```

### Benefits

* O(1) allocation
* O(1) deallocation
* Less allocator overhead
* Predictable memory usage
* Reduced fragmentation
* Useful in high-performance systems, networking, games, embedded systems, etc.

---

# 2. Basic Memory Pool

```cpp
#include <iostream>
#include <cstddef>

class MemoryPool
{
private:

    // Every free block stores a pointer
    // to the next free block.
    struct Block
    {
        Block* next;
    };

    void* memory;       // Entire memory allocated for pool
    Block* freeList;    // First free block

    std::size_t blockSize;
    std::size_t blockCount;

public:

    MemoryPool(std::size_t blockSize,
               std::size_t blockCount)
        : memory(nullptr),
          freeList(nullptr),
          blockSize(blockSize),
          blockCount(blockCount)
    {
        // A block must be large enough to store
        // the next pointer.
        if (blockSize < sizeof(Block))
            blockSize = sizeof(Block);

        // Allocate one large raw memory area.
        memory = ::operator new(blockSize * blockCount);

        // Divide memory into blocks.
        char* current = static_cast<char*>(memory);

        for (std::size_t i = 0; i < blockCount; ++i)
        {
            Block* block =
                reinterpret_cast<Block*>(
                    current + i * blockSize
                );

            // Insert block into free list.
            block->next = freeList;
            freeList = block;
        }
    }

    ~MemoryPool()
    {
        ::operator delete(memory);
    }

    void* allocate()
    {
        if (freeList == nullptr)
            return nullptr;

        // Take first free block.
        Block* block = freeList;

        // Move freeList to next block.
        freeList = freeList->next;

        return block;
    }

    void deallocate(void* ptr)
    {
        if (ptr == nullptr)
            return;

        Block* block = static_cast<Block*>(ptr);

        // Put block back into free list.
        block->next = freeList;
        freeList = block;
    }
};


int main()
{
    MemoryPool pool(sizeof(int), 5);

    int* a = static_cast<int*>(pool.allocate());
    int* b = static_cast<int*>(pool.allocate());

    *a = 10;
    *b = 20;

    std::cout << *a << '\n';
    std::cout << *b << '\n';

    pool.deallocate(a);
    pool.deallocate(b);

    return 0;
}
```

---

# 3. How the Memory Looks

Suppose:

```text
blockSize  = 16 bytes
blockCount = 4
```

The pool allocates:

```text
┌────────────┬────────────┬────────────┬────────────┐
│  Block 0   │  Block 1   │  Block 2   │  Block 3   │
│  16 bytes  │  16 bytes  │  16 bytes  │  16 bytes  │
└────────────┴────────────┴────────────┴────────────┘
```

Initially all blocks are free:

```text
freeList
   │
   ▼
Block 3 → Block 2 → Block 1 → Block 0 → nullptr
```

The order is reversed because each new block is inserted at the front.

---

# 4. The Important Trick

A free block uses **its own memory** to store the linked-list pointer.

```text
Free Block

┌──────────────────────┐
│ Block* next          │
└──────────────────────┘
```

For example:

```text
Block 3
   │
   ▼
Block 2
   │
   ▼
Block 1
   │
   ▼
Block 0
   │
   ▼
nullptr
```

Once a block is allocated, the `next` pointer is no longer needed.

That same memory becomes available to the caller:

```text
Free block:

┌──────────────┐
│ next pointer │
└──────────────┘

        ↓ allocate()

Allocated block:

┌──────────────┐
│ user data    │
└──────────────┘
```

---

# 5. How `allocate()` Works

Code:

```cpp
Block* block = freeList;
freeList = freeList->next;

return block;
```

Suppose:

```text
freeList
   │
   ▼
Block A → Block B → Block C
```

After:

```cpp
Block* block = freeList;
```

we have:

```text
block
  │
  ▼
Block A

freeList
  │
  ▼
Block A → Block B → Block C
```

Then:

```cpp
freeList = freeList->next;
```

becomes:

```text
block
  │
  ▼
Block A

freeList
  │
  ▼
Block B → Block C
```

Return:

```cpp
return block;
```

So allocation is:

```text
1. Take first free block
2. Move freeList to next block
3. Return old block
```

### Complexity

```text
O(1)
```

---

# 6. How `deallocate()` Works

Code:

```cpp
block->next = freeList;
freeList = block;
```

Suppose:

```text
freeList
   │
   ▼
Block B → Block C
```

We return Block A.

First:

```cpp
block->next = freeList;
```

Now:

```text
Block A → Block B → Block C
```

Then:

```cpp
freeList = block;
```

Now:

```text
freeList
   │
   ▼
Block A → Block B → Block C
```

So deallocation is:

```text
1. Convert returned memory to Block*
2. Point it to current freeList
3. Make it the new freeList head
```

### Complexity

```text
O(1)
```

---

# 7. Why `::operator new`?

The memory pool uses:

```cpp
memory = ::operator new(blockSize * blockCount);
```

because we need **raw, uninitialized memory**.

We don't want to construct an object for every block immediately.

---

# 8. `new` vs `::operator new`

Normal C++:

```cpp
MyClass* p = new MyClass;
```

does two things:

```text
new MyClass
    │
    ├── allocate memory
    │
    └── call MyClass constructor
```

But:

```cpp
::operator new(size);
```

only allocates raw storage:

```text
::operator new(size)
        │
        ▼
   raw memory
        │
        └── NO constructor
```

This is useful for memory pools.

---

# 9. Why the `::`?

```cpp
::operator new(...)
```

The `::` means **global scope**.

It explicitly asks for the global allocation function.

This avoids accidentally using a class-specific overloaded `operator new`.

For a memory pool, this makes the intention clear:

```cpp
::operator new(size);
```

means:

> Give me raw memory from the global allocation mechanism.

---

# 10. `::operator new` vs `malloc`

Both can allocate raw memory.

### C style

```cpp
void* memory = malloc(size);

free(memory);
```

### C++ style

```cpp
void* memory = ::operator new(size);

::operator delete(memory);
```

The C++ version matches the C++ allocation/deallocation mechanism.

For a C++ memory pool, this is often preferable.

---

# 11. `::operator new` + Placement New

This distinction is very important.

```cpp
::operator new(sizeof(MyClass));
```

only allocates storage.

It does **not** construct `MyClass`.

We can construct the object separately using placement new:

```cpp
void* memory = ::operator new(sizeof(MyClass));

MyClass* obj = new (memory) MyClass();
```

Flow:

```text
::operator new()
        ↓
Allocate raw memory
        ↓
Placement new
        ↓
Construct MyClass
```

When finished:

```cpp
obj->~MyClass();

::operator delete(memory);
```

Flow:

```text
Destroy object
     ↓
Release raw memory
```

---

# 12. Complete Memory-Pool Flow

```text
              MemoryPool
                  │
                  ▼
       ::operator new(large_size)
                  │
                  ▼
          Large raw memory
                  │
                  ▼
        Divide into blocks
                  │
                  ▼
          Build freeList
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
    allocate()          deallocate()
        │                   │
        ▼                   ▼
 remove head            add to head
        │                   │
        ▼                   ▼
    O(1)                O(1)
```

---

# 13. Interview Mental Model

Remember these five points:

```text
1. Allocate a large memory area once.

2. Divide it into fixed-size blocks.

3. Link free blocks using a freeList.

4. allocate()
      → remove head
      → O(1)

5. deallocate()
      → add block to head
      → O(1)
```

### Most important concept

```text
Free block
    ↓
uses its own memory to store `next`

Allocated block
    ↓
same memory becomes user data
```

### Interview answer

> A memory pool pre-allocates a large chunk of raw memory and divides it into fixed-size blocks. Free blocks are maintained in a linked list. Allocation removes the head of the free list and deallocation adds the block back to the head, giving O(1) allocation and deallocation. `::operator new` is used to obtain raw storage without constructing objects.
