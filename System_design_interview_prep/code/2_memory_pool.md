# C Memory Pool — Interview Implementation

A memory pool pre-allocates a large chunk of memory and divides it
into fixed-size blocks.

Instead of calling malloc/free repeatedly, we reuse these blocks.

---

## Complete Code

    #include <stdio.h>
    #include <stdlib.h>
    #include <stddef.h>

    /*
     * Each free block contains a pointer to the next free block.
     *
     * Important:
     * We reuse the memory of the block itself to store this pointer.
     */
    typedef struct Block {
        struct Block* next;
    } Block;


    /*
     * Memory Pool structure
     */
    typedef struct {
        void* memory;       // Pointer to the entire allocated memory
        Block* freeList;    // First available block
        size_t blockSize;   // Size of each block
        size_t numBlocks;   // Number of blocks
    } MemoryPool;


    /*
     * Create a memory pool.
     *
     * blockSize = size of each block
     * numBlocks = number of blocks
     */
    MemoryPool* pool_create(size_t blockSize, size_t numBlocks)
    {
        /*
         * A free block needs enough space to store
         * the 'next' pointer.
         *
         * Example:
         * If sizeof(Block) = 8 bytes and the user
         * asks for a 4-byte block, we need at least
         * 8 bytes.
         */
        if (blockSize < sizeof(Block)) {
            blockSize = sizeof(Block);
        }


        /*
         * Allocate the MemoryPool structure itself.
         */
        MemoryPool* pool = malloc(sizeof(MemoryPool));

        if (pool == NULL) {
            return NULL;
        }


        /*
         * Allocate one large contiguous memory area.
         *
         * Instead of calling malloc() for every object,
         * we allocate everything upfront.
         */
        pool->memory = malloc(blockSize * numBlocks);

        if (pool->memory == NULL) {
            free(pool);
            return NULL;
        }


        pool->blockSize = blockSize;
        pool->numBlocks = numBlocks;
        pool->freeList = NULL;


        /*
         * Treat the large memory area as a sequence
         * of fixed-size blocks.
         */
        char* current = (char*)pool->memory;


        /*
         * Build the free list.
         *
         * After this loop:
         *
         * freeList
         *     |
         *     v
         *   B1 -> B2 -> B3 -> B4 -> NULL
         */
        for (size_t i = 0; i < numBlocks; i++)
        {
            /*
             * Calculate the address of this block.
             */
            Block* block =
                (Block*)(current + i * blockSize);


            /*
             * Insert the block at the beginning
             * of the free list.
             */
            block->next = pool->freeList;

            pool->freeList = block;
        }


        return pool;
    }


    /*
     * Allocate one block from the memory pool.
     *
     * Time complexity: O(1)
     */
    void* pool_allocate(MemoryPool* pool)
    {
        /*
         * No free blocks available.
         */
        if (pool == NULL || pool->freeList == NULL) {
            return NULL;
        }


        /*
         * Take the first block from the free list.
         */
        Block* block = pool->freeList;


        /*
         * Move freeList to the next available block.
         */
        pool->freeList = block->next;


        /*
         * Return the block to the caller.
         */
        return block;
    }


    /*
     * Return a block to the memory pool.
     *
     * Time complexity: O(1)
     */
    void pool_deallocate(MemoryPool* pool, void* ptr)
    {
        /*
         * Ignore invalid NULL values.
         */
        if (pool == NULL || ptr == NULL) {
            return;
        }


        /*
         * Convert the returned memory back into a Block.
         */
        Block* block = (Block*)ptr;


        /*
         * Add this block to the beginning
         * of the free list.
         */
        block->next = pool->freeList;

        pool->freeList = block;
    }


    /*
     * Destroy the memory pool.
     */
    void pool_destroy(MemoryPool* pool)
    {
        if (pool == NULL) {
            return;
        }


        /*
         * Free the entire memory area at once.
         *
         * Individual blocks are NOT freed separately.
         */
        free(pool->memory);


        /*
         * Finally free the MemoryPool structure.
         */
        free(pool);
    }


    /*
     * Example usage
     */
    int main(void)
    {
        /*
         * Create a pool containing 5 blocks.
         *
         * Each block is large enough to store an int.
         */
        MemoryPool* pool =
            pool_create(sizeof(int), 5);


        if (pool == NULL) {
            printf("Failed to create memory pool\n");
            return 1;
        }


        /*
         * Allocate first block.
         */
        int* a = (int*)pool_allocate(pool);


        /*
         * Allocate second block.
         */
        int* b = (int*)pool_allocate(pool);


        /*
         * Check allocation.
         */
        if (a == NULL || b == NULL) {
            printf("Memory pool is full\n");

            pool_destroy(pool);
            return 1;
        }


        /*
         * Use the allocated memory.
         */
        *a = 10;
        *b = 20;


        printf("a = %d\n", *a);
        printf("b = %d\n", *b);


        /*
         * Return the blocks to the pool.
         *
         * IMPORTANT:
         * The memory is NOT actually freed here.
         *
         * The blocks become available for reuse.
         */
        pool_deallocate(pool, a);
        pool_deallocate(pool, b);


        /*
         * Destroy the entire pool.
         */
        pool_destroy(pool);


        return 0;
    }


---

## How It Works

Initially, the pool looks conceptually like this:

    freeList
       |
       v
    +------+    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  | -> |  B5  |
    +------+    +------+    +------+    +------+    +------+


Each block contains a pointer to the next free block.

The important structure is:

    typedef struct Block {
        struct Block* next;
    } Block;


---

## pool_allocate()

Suppose we have:

    freeList
       |
       v
    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+    +------+


When we call:

    void* ptr = pool_allocate(pool);


B1 is removed:

    freeList
       |
       v
    +------+    +------+    +------+
    |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+

    B1 ---> returned to caller


The important code is:

    Block* block = pool->freeList;
    pool->freeList = block->next;

    return block;


This is O(1).

---

## pool_deallocate()

Suppose B1 is returned:

    pool_deallocate(pool, B1);


Before:

    freeList
       |
       v
    +------+    +------+    +------+
    |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+


After:

    freeList
       |
       v
    +------+    +------+    +------+    +------+
    |  B1  | -> |  B2  | -> |  B3  | -> |  B4  |
    +------+    +------+    +------+    +------+


The important code is:

    block->next = pool->freeList;
    pool->freeList = block;


This is also O(1).

---

## Why Use a Memory Pool?

Without a memory pool:

    malloc()
    malloc()
    malloc()
    free()
    malloc()
    free()


With a memory pool:

    Allocate large memory area once
                |
                v
    +------+------+------+------+------+
    | B1   | B2   | B3   | B4   | B5   |
    +------+------+------+------+------+


Then we simply reuse the blocks.

This can reduce allocation overhead and can provide more
predictable allocation performance.

---

## Complexity

| Operation | Complexity |
|-----------|------------|
| pool_allocate() | O(1) |
| pool_deallocate() | O(1) |
| pool_create() | O(N) |
| pool_destroy() | O(1) |

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

### 1. Why is it faster than malloc/free?

The pool allocates a large memory area once.

Subsequent allocations simply take a block from the free list
instead of asking the general-purpose allocator for memory each
time.


---

### 2. Why is pool_allocate() O(1)?

Because we only remove the first block:

    Block* block = pool->freeList;
    pool->freeList = block->next;


We don't have to search through the pool.


---

### 3. Why is pool_deallocate() O(1)?

Because we insert the returned block at the front:

    block->next = pool->freeList;
    pool->freeList = block;


Again, there is no traversal.


---

### 4. What happens when the pool is full?

pool_allocate() returns NULL:

    if (pool == NULL || pool->freeList == NULL) {
        return NULL;
    }


A production implementation could create another memory chunk.


---

### 5. Can this handle different object sizes?

This implementation uses fixed-size blocks.

For different sizes, we can maintain multiple pools:

    Pool 16 bytes
    Pool 32 bytes
    Pool 64 bytes
    Pool 128 bytes


This is commonly called size classes.


---

### 6. Is this implementation thread-safe?

No.

If multiple threads use the same pool, synchronization is needed.

Possible approaches:

- Mutex
- Spinlock
- Atomic operations
- Thread-local pools


---

### 7. What about alignment?

This is an important C interview follow-up.

A production memory pool must ensure that the returned memory is
properly aligned for the object being stored.

The simplified implementation above is intended for interview
discussion and fixed-size basic types.


---

### 8. What happens if someone calls deallocate() with a pointer
that did not come from the pool?

The simple implementation does not validate this.

A production implementation could check whether the pointer belongs
to the pool before adding it back to the free list.

This also helps detect invalid frees and double frees.


---

## Key Concept

Remember these three steps:

    1. Allocate a large memory area.

    2. Divide it into fixed-size blocks.

    3. Maintain a free list of available blocks.


The most important code is:

    // Allocate
    Block* block = pool->freeList;
    pool->freeList = block->next;

    // Deallocate
    block->next = pool->freeList;
    pool->freeList = block;


If you understand these four lines, you understand the core idea
behind a basic memory pool.

---

## Interview Cheat Sheet

Memory Pool:

- Pre-allocate memory
- Divide memory into fixed-size blocks
- Maintain a free list
- pool_allocate() removes from free list
- pool_deallocate() adds to free list
- pool_allocate() = O(1)
- pool_deallocate() = O(1)
- pool_create() = O(N)
- Good for frequent fixed-size allocations
- Basic version is not thread-safe
- Production version needs alignment
- Production version should validate ownership
- Different sizes can use multiple pools


---

## One-Line Interview Answer

"A memory pool pre-allocates a large chunk of memory and manages
fixed-size blocks using a free list, allowing O(1) allocation and
deallocation without repeatedly calling malloc and free."
