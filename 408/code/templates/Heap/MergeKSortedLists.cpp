#include <iostream>
#include <vector>
#include <queue>

using namespace std;

class ListNode {
public:
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

class Code01_MergeKSortedLists {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        // Priority queue (min-heap) to store the nodes based on their values
        auto comp = [](ListNode* a, ListNode* b) { return a->val > b->val; };
        priority_queue<ListNode*, vector<ListNode*>, decltype(comp)> heap(comp);

        // Add the head of each non-null list into the heap
        for (ListNode* listNode : lists) {
            if (listNode != nullptr) {
                heap.push(listNode);
            }
        }

        // If the heap is empty, return null (no lists to merge)
        if (heap.empty()) {
            return nullptr;
        }

        // Initialize the merged list's head and tail
        ListNode* head = heap.top();
        heap.pop();
        ListNode* tail = head;

        // If the first node has a next node, add it to the heap
        if (tail->next != nullptr) {
            heap.push(tail->next);
        }

        // Process the rest of the nodes in the heap
        while (!heap.empty()) {
            ListNode* cur = heap.top();
            heap.pop();
            tail->next = cur;  // Append the current node to the merged list
            tail = cur;        // Move the tail pointer to the current node
            if (cur->next != nullptr) {
                heap.push(cur->next);  // If the current node has a next, add it to the heap
            }
        }

        // Return the merged list
        return head;
    }
};

int main() {
    // Example usage
    Code01_MergeKSortedLists solution;

    // Creating example linked lists
    ListNode* list1 = new ListNode(1);
    list1->next = new ListNode(4);
    list1->next->next = new ListNode(5);

    ListNode* list2 = new ListNode(1);
    list2->next = new ListNode(3);
    list2->next->next = new ListNode(4);

    ListNode* list3 = new ListNode(2);
    list3->next = new ListNode(6);

    vector<ListNode*> lists = {list1, list2, list3};

    // Merging the k sorted lists
    ListNode* mergedList = solution.mergeKLists(lists);

    // Printing the merged list
    ListNode* current = mergedList;
    while (current != nullptr) {
        cout << current->val << " ";
        current = current->next;
    }

    return 0;
}
