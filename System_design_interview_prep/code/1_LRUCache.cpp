#include<iostream>
#include<unordered_map>
using namespace std;

class LRUCache
{
	//Node for DL: to insert/delete
	struct Node
	{
		int key;
		int value;
		Node* prev;
		Node* next;
		Node(int key, int val):key(key),value(val)
		{}
	};
	int capacity;
	unordered_map<int, Node*>cache;
	Node* head; //MRU side
	Node* tail; //LRU side
	
	//delete node:
	void removeNode(Node* node)
	{
		node->prev->next = node->next;
		node->next->prev = node->prev;
	}
	void addToFront(Node* node)
	{
		node->next = head->next;
		head->next->prev = node;
		head->next = node;
		node->prev = head;
	}
	
public:
	LRUCache(int cap):capacity(cap)
	{
		head = new Node(-1, -1);
		tail = new Node(-1, -1);
		head->next = tail;
		tail->prev = head;
	}
	int get(int key)
	{
		//Check if key not present, return -1;
		auto it = cache.find(key);
		if(it == cache.end())
		{
			return -1;
			
		}
		Node* node = it->second;
		//move this node to MRU:
		removeNode(node);
		addToFront(node);
		return node->value;
	}
	void put(int key, int val)
	{
		//Check if present in cache:
		auto it = cache.find(key);
		if(it != cache.end())
		{
			Node* node = it->second;
			node->value = val;
			// Updated key becomes MRU.
            removeNode(node);	
            addToFront(node);
            return ;
		}
		//Key is not present, so add it:
		Node* node = new Node(key, val);
		
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
};

int main()
{
	LRUCache lc(5);
	lc.put(2, 20);
	lc.put(3, 14);
	cout<<lc.get(2)<<endl;
	return 0;
}


