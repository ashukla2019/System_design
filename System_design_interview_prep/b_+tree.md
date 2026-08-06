# 09. B+ Tree

## 1. Problem Statement

Storage systems need efficient ways to store and retrieve large amounts of data.

Examples:

- Database indexes
- File system metadata
- Key-value stores
- Storage engines

A simple binary search tree has problems when data does not fit in memory.

Example:

```
Millions of Records

        |
        v

    Disk Storage
```

Disk access is expensive.

A good storage data structure should:

- Minimize disk reads
- Support fast search
- Support inserts and deletes
- Work efficiently with large datasets

B+ Tree is designed for this purpose.

---

# 2. What Is a B+ Tree?

A B+ Tree is a balanced tree data structure optimized for storage systems.

Properties:

- All data is stored in leaf nodes.
- Internal nodes store only keys and pointers.
- All leaves are at the same level.
- Leaf nodes are linked for fast range queries.

Example:

```
              Root

          [20 | 40]

          /    |    \

       /       |      \

 [5 10]    [25 30]   [45 50]

 Leaf Nodes
```

---

# 3. Why B+ Tree Is Used in Databases

Databases store data on disk.

Disk access pattern:

```
CPU
 |
Memory
 |
Disk
```

Disk access is slow.

B+ Tree reduces disk operations by increasing the branching factor.

Example:

Binary Tree:

```
       10

      /  \

     5    20
```

B+ Tree:

```
        [10|20|30|40]

       /   |   |   |   \

     Many children
```

One node can point to thousands of records.

---

# 4. B+ Tree Structure

A B+ Tree has three components.

## Root Node

Starting point of search.

Example:

```
        [50]
       /    \
```

---

## Internal Nodes

Store:

- Keys
- Child pointers

Example:

```
[20 | 40 | 60]

 |     |     |

Child Child Child
```

They guide navigation.

---

## Leaf Nodes

Store:

- Actual records
- Record pointers

Example:

```
[10,15,18] → [22,25,30] → [40,45,50]
```

Leaf nodes are connected using linked lists.

---

# 5. Search Operation

Example:

Find key:

```
35
```

Tree:

```
              [30 | 60]

             /     \

        [10,20]   [35,40,50]
```

Steps:

```
1. Start at root

2. Compare key

3. Follow child pointer

4. Reach leaf node

5. Search record
```

Complexity:

```
O(log N)
```

---

# 6. Range Query Support

One major advantage of B+ Tree is efficient range scanning.

Example:

Query:

```
Find users
where id between 100 and 500
```

Leaf nodes:

```
100
 |
120
 |
150
 |
200
 |
300
 |
500
```

Because leaves are linked:

```
Leaf A → Leaf B → Leaf C
```

The database can scan sequentially.

---

# 7. Insert Operation

Example:

Insert:

```
25
```

Steps:

```
1. Search correct leaf

2. Insert key

3. Check node capacity

4. Split if full
```

Before:

```
[10 20 30]
```

Insert 25:

```
[10 20 25 30]
```

If capacity exceeded:

```
Before:

[10 20 25 30 40]


Split:


[10 20]

[25 30 40]
```

Parent is updated.

---

# 8. Node Split

When a node becomes full:

```
          Parent

             |

     [10 20 30 40]
```

Split:

```
          Parent

        /       \

 [10 20]      [30 40]
```

Advantages:

- Tree remains balanced.
- Search performance stays O(log N).

---

# 9. Delete Operation

Deleting a key:

Example:

```
Delete 20
```

Steps:

```
1. Find leaf

2. Remove key

3. Check minimum capacity

4. Merge or redistribute if required
```

---

# 10. Node Merge

If a node has too few keys:

Before:

```
[10]

[20 30]
```

Merge:

```
[10 20 30]
```

Parent is updated.

---

# 11. B+ Tree in Storage Engines

Databases store B+ Tree nodes as pages.

Example:

```
Disk

+-----------+
| Page 1    | Root
+-----------+

+-----------+
| Page 2    | Internal
+-----------+

+-----------+
| Page 3    | Leaf
+-----------+
```

Each node usually maps to one disk page.

---

# 12. Buffer Pool Interaction

Databases keep frequently accessed pages in memory.

Flow:

```
Query

 |
 v

B+ Tree

 |
 v

Buffer Pool

 |
 v

Disk Page
```

If page exists in memory:

```
Fast Access
```

Otherwise:

```
Disk Read
```

---

# 13. B+ Tree Concurrency Control

Multiple transactions may access the tree.

Example:

```
Transaction A

Search Key


Transaction B

Insert Key
```

Need synchronization.

Common techniques:

## Node Latches

Lock individual pages.

Example:

```
Node A → Read Lock

Node B → Write Lock
```

---

## Lock Coupling

During traversal:

```
Lock Parent

Move to Child

Lock Child

Release Parent
```

Allows concurrency.

---

# 14. B+ Tree vs Hash Index

| Feature | B+ Tree | Hash Index |
|-|-|-|
| Point Lookup | Good | Excellent |
| Range Query | Excellent | Poor |
| Ordered Data | Yes | No |
| Disk Friendly | Yes | Limited |

Use B+ Tree when:

- Sorting needed
- Range queries required

---

# 15. B+ Tree vs LSM Tree

| Feature | B+ Tree | LSM Tree |
|-|-|-|
| Write Performance | Good | Excellent |
| Read Performance | Excellent | Good |
| Storage Pattern | Random | Sequential |
| Compaction | No | Required |

B+ Tree:

- Traditional databases

LSM Tree:

- Write-heavy systems

---

# 16. Real World Usage

B+ Trees are used in:

- MySQL InnoDB indexes
- PostgreSQL indexes
- File system metadata
- Storage engines
- Embedded databases

---

# 17. Design Considerations

Choose B+ Tree when:

- Need ordered data
- Need range scans
- Data exceeds memory
- Disk access matters

Avoid when:

- Only key lookup is needed
- Write throughput is the highest priority

---

# 18. Interview Questions

## Q1. Why are all records stored in leaf nodes?

To simplify range queries and maintain sequential access.

---

## Q2. Why are B+ Trees better than binary trees for disks?

They have higher fan-out, reducing the number of disk accesses.

---

## Q3. Why are leaf nodes linked?

To support efficient range scans.

---

## Q4. How does B+ Tree maintain balance?

Node split and merge operations keep all leaves at the same depth.

---

## Q5. Where is B+ Tree used?

Examples:

- Database indexes
- File systems
- Storage engines

---

# Summary

A B+ Tree is a disk-friendly balanced tree used as a fundamental indexing structure in storage systems.

Key properties:
