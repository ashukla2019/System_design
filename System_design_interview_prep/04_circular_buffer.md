# Circular Buffer Design

## System Design Interview Notes

---

# 1. Problem Statement

Design a circular buffer (ring buffer) that stores data in a fixed-size memory area.

When the buffer reaches the end of its allocated memory, insertion continues from the beginning.

Circular buffers are widely used for:

- Network packet queues
- Audio/video streaming
- Producer-consumer systems
- Device drivers
- IO pipelines

---

# 2. Why Circular Buffer?

A normal array queue has a problem.

Example:

```
Size = 5


[ ][ ][ ][ ][ ]

```

After adding and removing elements:

```
[ ][ ][C][D][E]

```

Space at the beginning cannot be reused easily.

Circular buffer solves this by wrapping around.

---

# 3. Example

Buffer size:

```
5

```

Initial state:

```
+---+---+---+---+---+
|   |   |   |   |   |
+---+---+---+---+---+

 ^
 |
head

 ^
 |
tail

```

Insert:

```
A B C

```

State:

```
+---+---+---+---+---+
| A | B | C |   |   |
+---+---+---+---+---+

```

Remove A:

```
+---+---+---+---+---+
|   | B | C |   |   |
+---+---+---+---+---+

```

Insert D and E:

```
+---+---+---+---+---+
|   | B | C | D | E |
+---+---+---+---+---+

```

Next insert wraps to beginning.

---

# 4. Requirements

## Functional Requirements

Support:

```
init()

push()

pop()

is_empty()

is_full()

```

---

## Non Functional Requirements

Need:

- O(1) insertion
- O(1) deletion
- Fixed memory usage
- Thread safety option
- Low latency

---

# 5. High Level Architecture

Components:

1. Data array
2. Head index
3. Tail index
4. Capacity information


Architecture:

```
              Circular Buffer


+----+----+----+----+----+

|    |    |    |    |    |

+----+----+----+----+----+

 ^
 |
head


 ^
 |
tail


```

---

# 6. Data Structure

```c
typedef struct
{

    int *buffer;


    int capacity;


    int head;


    int tail;


    int count;


}CircularBuffer;

```

---

# 7. Index Calculation

When moving forward:

```
index = (index + 1) % capacity

```

Example:

Capacity:

```
5

```

Current index:

```
4

```

Next:

```
(4+1)%5

=0

```

Wraps to beginning.

---

# 8. Insert Operation

Algorithm:

1. Check if full.
2. Store element at tail.
3. Move tail.
4. Increase count.


Flow:

```
push(data)

     |

Buffer full?

     |

No

     |

store at tail

     |

move tail

     |

increment count

```

---

Implementation:

```c
int push(
CircularBuffer *cb,
int value)
{

    if(cb->count == cb->capacity)
        return -1;


    cb->buffer[cb->tail] = value;


    cb->tail =
    (cb->tail + 1)
    % cb->capacity;


    cb->count++;


    return 0;

}

```

---

# 9. Remove Operation

Algorithm:

1. Check empty.
2. Read from head.
3. Move