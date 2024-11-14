#include <iostream>

struct DoubleNode {
    int val;
    DoubleNode* pre;
    DoubleNode* next;

    DoubleNode(int value) : val(value), pre(nullptr), next(nullptr) {}
};

DoubleNode* reverseDoubleLinkedList(DoubleNode* head) {
    if (head == nullptr) {
        return nullptr;
    }

    DoubleNode* next = nullptr;
    DoubleNode* pre = nullptr;

    while (head != nullptr) {
        // Store the next node
        next = head->next;
        // Swap the next and previous pointers
        head->next = head->pre;
        head->pre = next;
        // Move pre to the current node
        pre = head;
        // Move head to the next node
        head = next;
    }
    head = pre;
    return head;
}

// Helper function to print the list (for testing)
void printList(DoubleNode* head) {
    while (head != nullptr) {
        std::cout << head->val << " ";
        head = head->next;
    }
    std::cout << std::endl;
}

int main() {
    // Create a sample doubly linked list: 1 <-> 2 <-> 3 <-> 4
    DoubleNode* head = new DoubleNode(1);
    head->next = new DoubleNode(2);
    head->next->pre = head;
    head->next->next = new DoubleNode(3);
    head->next->next->pre = head->next;
    head->next->next->next = new DoubleNode(4);
    head->next->next->next->pre = head->next->next;

    std::cout << "Original List: ";
    printList(head);

    head = reverseDoubleLinkedList(head);

    std::cout << "Reversed List: ";
    printList(head);

    return 0;
}
