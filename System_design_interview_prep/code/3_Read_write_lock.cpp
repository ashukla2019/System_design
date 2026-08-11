#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>

class RWLock
{
private:
    std::mutex mtx;
    std::condition_variable cv;

    int readers = 0;       // Active readers
    int writers = 0;       // Active writers: 0 or 1
    int waitingWriters = 0;

public:

    // -------------------------
    // Reader Lock
    // -------------------------
    void lock_read()
    {
        std::unique_lock<std::mutex> lock(mtx);

        // Block readers if:
        // 1. A writer is active
        // 2. A writer is waiting
        //
        // Giving priority to waiting writers
        // prevents writer starvation.
        cv.wait(lock, [&] {
            return writers == 0 && waitingWriters == 0;
        });

        ++readers;
    }

    void unlock_read()
    {
        std::unique_lock<std::mutex> lock(mtx);

        --readers;

        // If this was the last reader,
        // wake up a waiting writer.
        if (readers == 0)
            cv.notify_all();
    }

    // -------------------------
    // Writer Lock
    // -------------------------
    void lock_write()
    {
        std::unique_lock<std::mutex> lock(mtx);

        ++waitingWriters;

        // Writer waits until:
        // 1. No readers are active
        // 2. No other writer is active
        cv.wait(lock, [&] {
            return readers == 0 && writers == 0;
        });

        --waitingWriters;
        writers = 1;
    }

    void unlock_write()
    {
        std::unique_lock<std::mutex> lock(mtx);

        writers = 0;

        // Wake readers/writers waiting on the condition.
        cv.notify_all();
    }
};
