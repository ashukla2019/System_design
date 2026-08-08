# C++ Memory Pool — Interview Implementation

A memory pool pre-allocates a large chunk of memory and divides it
into fixed-size blocks.

Instead of calling new/delete repeatedly, we reuse these blocks.

---

## Complete Code

    #include <iostream>
    #include <cstddef>

    class MemoryPool {
    private:

        // Each free block stores a pointer to the next free block.
        //
        // We reuse the block's own memory to store this pointer.
        struct Block {
            Block* next;
        };

        // Pointer to the beginning of the entire memory pool.
        void* memory;

        // Points to the first available/free block.
        Block* freeList;

        // Size of each block in bytes.
        size_t blockSize;

        // Number of blocks in the pool.
        size_t numBlocks;

    public:

        // Constructor
        //
        // blockSize = size of each block
        // numBlocks = number of blocks in the pool
        MemoryPool(size_t blockSize, size_t numBlocks)
            : blockSize(blockSize), numBlocks(numBlocks) {

            // A free block needs enough space to store
            // the 'next' pointer.
            if (blockSize < sizeof(Block)) {
                this->blockSize = sizeof(Block);
            }

            // Allocate one large contiguous memory area.
            //
            // We allocate everything upfront instead of
            // calling new every time allocate() is called.
            memory = ::operator new(this->blockSize * numBlocks);

            // Initially, the free list is empty.
            freeList = nullptr;

            // Treat the large memory area as a sequence of blocks.
            char* current = static_cast<char*>(memory);

            // Build the free list.
            for (size_t i = 0; i < numBlocks; ++i) {

                // Calculate the address of the current block.
                Block* block =
                    reinterpret_cast<Block*>(
                        current + i * this->blockSize
                    );

                // Insert this block at the beginning
                // of the free list.
                block->next = freeList;

                freeList = block;
            }
        }

        // Allocate one block from the pool.
        void* allocate() {

            // No blocks available.
            if (freeList == nullptr) {
                return nullptr;
            }

            // Take the first free block.
            Block* block = freeList;

            // Move freeList to the next free block.
            freeList = freeList->next;

            // Return the memory to the caller.
            return block;
        }

        // Return a block back to the pool.
        void deallocate(void* ptr) {

            // Ignore nullptr.
            if (ptr == nullptr) {
                return;
            }

            // Convert the memory back into a Block.
            Block* block = static_cast<Block*>(ptr);

            // Put this block at the beginning
            // of the free list.
            block->next = freeList;

            freeList = block;
        }

        // Destructor
        ~MemoryPool() {

            // Release the entire memory pool at once.
            //
            // Individual blocks are NOT deleted.
            ::operator delete(memory);
        }
    };


    int main() {

        // Create a memory pool containing 5 blocks.
        //
        // Each block is large enough to store an int.
        MemoryPool pool(sizeof(int), 5);

        // Allocate the first block.
        int* a = static_cast<int*>(pool.allocate());

        // Allocate the second block.
        int* b = static_cast<int*>(pool.allocate());

        // Use the allocated memory.
        *a = 10;
        *b = 20;

        std::cout << *a << " " << *b << '\n';

        // Return the blocks to the pool.
        //
        // The memory is NOT freed here.
        // The blocks simply become available for reuse.
        pool.deallocate(a);
        pool.deallocate(b);

        return 0;
    }


---

## How It Works

The pool initially looks like:

    freeList
       |
       v
    +------+    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  | -> |  B5  |
    +------+    +------+    +------+    +------+    +------+

Each block is part of the same large memory allocation.

The free list keeps track of which blocks are currently available.

---

## allocate()

When we call:

    void* ptr = pool.allocate();

The first free block is removed from the free list.

Before:

    freeList
       |
       v
    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+    +------+

After:

    freeList
       |
       v
    +------+    +------+    +------+
    |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+

    B1 ---> returned to caller

The important code is:

    Block* block = freeList;
    freeList = freeList->next;

    return block;

This is O(1).

---

## deallocate()

When we call:

    pool.deallocate(ptr);

The block is added back to the front of the free list.

Before:

    freeList
       |
       v
    +------+    +------+    +------+
    |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+

After returning B1:

    freeList
       |
       v
    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+    +------+

The important code is:

    block->next = freeList;
    freeList = block;

This is also O(1).

---

## Why Use a Memory Pool?

Normal allocation may repeatedly do:

    new
    new
    new
    delete
    new
    delete

A memory pool allocates a large memory area once:

    Allocate large memory area
                |
                v
    +------+------+------+------+------+
    | B1   | B2   | B3   | B4   | B5   |
    +------+------+------+------+------+

Then the blocks are reused.

This can reduce allocation overhead and provide predictable
allocation/deallocation performance.

---

## Complexity

| Operation | Complexity |
|-----------|------------|
| allocate() | O(1) |
| deallocate() | O(1) |
| Pool creation | O(N) |
| Pool destruction | O(1) |

Where N is the number of blocks.

---

## Interview Explanation

A good interview answer:

"I pre-allocate a contiguous chunk of memory and divide it into
fixed-size blocks. I maintain a singly linked free list containing
all currently available blocks. Allocation removes the first block
from the free list, while deallocation adds the block back to the
front. Therefore both operations are O(1)."

---

## Common Interview Follow-up Questions

### 1. Why is it faster than new/delete?

Because the pool allocates a large chunk of memory upfront.

Subsequent allocations simply take an already available block from
the free list.

There is no need to ask the general-purpose heap allocator for
memory on every allocation.

---

### 2. Why is allocate() O(1)?

Because we only remove the first node from the free list:

    Block* block = freeList;
    freeList = freeList->next;

No traversal is required.

---

### 3. Why is deallocate() O(1)?

Because we insert the returned block at the front:

    block->next = freeList;
    freeList = block;

Again, no traversal is required.

---

### 4. What happens when the pool is full?

allocate() returns nullptr:

    if (freeList == nullptr) {
        return nullptr;
    }

A production implementation could create another memory chunk or
pool instead.

---

### 5. Can this handle different object sizes?

This implementation is designed for fixed-size blocks.

For different sizes, we could maintain multiple pools:

    Pool: 16 bytes
    Pool: 32 bytes
    Pool: 64 bytes
    Pool: 128 bytes

This approach is commonly called size classes.

---

### 6. Is this implementation thread-safe?

No.

If multiple threads access the same pool, synchronization would be
required.

Possible approaches include:

- Mutex
- Spinlock
- Atomic free list
- Thread-local pools

---

### 7. What about alignment?

A production memory pool must ensure that returned memory has the
correct alignment for the object being stored.

This is an important point to mention in a C++ systems interview.

---

### 8. What about constructors and destructors?

A memory pool manages raw memory.

Allocating raw memory does not automatically construct a C++ object.

For real objects, we can use placement new:

    new (memory) MyObject();

And explicitly call the destructor:

    object->~MyObject();

---

## Key Concept to Remember

Remember these three steps:

    1. Allocate a large memory area.

    2. Divide it into fixed-size blocks.

    3. Maintain a free list of available blocks.

The most important code is:

    // Allocate
    Block* block = freeList;
    freeList = freeList->next;

    // Deallocate
    block->next = freeList;
    freeList = block;

If you understand these four lines, you understand the core idea
behind a basic memory pool.

---

## Interview Cheat Sheet

Memory Pool:

- Pre-allocate memory
- Divide memory into fixed-size blocks
- Maintain a free list
- allocate() removes from free list
- deallocate() adds to free list
- allocate() = O(1)
- deallocate() = O(1)
- Pool creation = O(N)
- Good for frequent fixed-size allocations
- Basic version is not thread-safe
- Production version needs alignment and ownership checks
- For objects, consider construction/destruction separately

---

## One-Line Interview Answer

"A memory pool pre-allocates a large chunk of memory and manages
fixed-size blocks using a free list, allowing O(1) allocation and
deallocation without repeatedly calling the general-purpose heap
allocator."
