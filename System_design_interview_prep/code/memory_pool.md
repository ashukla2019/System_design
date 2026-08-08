#include <iostream>
#include <cstddef>

class MemoryPool {
private:

    // Each free block uses its own memory to store
    // a pointer to the next free block.
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
    // Creates a pool containing 'numBlocks' blocks,
    // each of size 'blockSize' bytes.
    MemoryPool(size_t blockSize, size_t numBlocks)
        : blockSize(blockSize), numBlocks(numBlocks) {

        // A free block needs enough space to store
        // the 'next' pointer.
        if (blockSize < sizeof(Block)) {
            this->blockSize = sizeof(Block);
        }

        // Allocate one large contiguous memory area.
        //
        // Instead of calling new every time we need an object,
        // we allocate all the memory upfront.
        memory = ::operator new(this->blockSize * numBlocks);

        // Initially, there is no free-list head.
        freeList = nullptr;

        // Treat the large memory area as a sequence of blocks.
        char* current = static_cast<char*>(memory);

        // Create the free list.
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

        // If freeList is nullptr, there are
        // no blocks left.
        if (freeList == nullptr) {
            return nullptr;
        }

        // Take the first free block.
        Block* block = freeList;

        // Move freeList to the next available block.
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

        // Convert the returned memory back into a Block.
        Block* block = static_cast<Block*>(ptr);

        // Put this block back at the beginning
        // of the free list.
        block->next = freeList;

        freeList = block;
    }

    // Destructor
    ~MemoryPool() {

        // Release the entire memory pool at once.
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
    // The memory is NOT actually freed.
    // It becomes available for reuse.
    pool.deallocate(a);
    pool.deallocate(b);


    return 0;
}
