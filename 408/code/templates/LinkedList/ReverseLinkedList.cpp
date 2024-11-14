#include <iostream>
using namespace std;

// Node definition for singly linked list
struct Node {
    int value;
    Node* next;
    Node(int val) : value(val), next(nullptr) {}
};

Node* reverseLinkedList(Node* head) {
    if (head == nullptr) {
        return head;  // Return if the list is empty
    }
    Node* current = head;
    Node* pre = nullptr;
    Node* next = current->next;
    while (current != nullptr) {
        // Save the next node to avoid losing reference to the rest of the list
        next = current->next;
        // Reverse the current node's pointer
        current->next = pre;
        // Move the pointers forward
        pre = current;
        current = next;
    }

    // When the loop ends, pre points to the new head of the reversed list
    head = pre;
    return head;
}

Node* reverseListTail(Node* pre, Node* cur) {
    if (cur == nullptr) {
        return pre;
    }
    Node* next = cur->next;
    cur->next = pre;
    return reverseListTail(cur, next);
}

Node* reverseList(Node* head) {
    return reverseListTail(nullptr, head);
}

void printList(Node* head) {
    Node* current = head;
    while (current != nullptr) {
        cout << current->value << " -> ";
        current = current->next;
    }
    cout << "nullptr" << endl;
}

int main() {
    // Creating a linked list: 1 -> 2 -> 3 -> 4 -> nullptr
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(4);

    cout << "Original List: ";
    printList(head);

    // Reverse the linked list
    head = reverseList(head);

    cout << "Reversed List: ";
    printList(head);

    return 0;
}
