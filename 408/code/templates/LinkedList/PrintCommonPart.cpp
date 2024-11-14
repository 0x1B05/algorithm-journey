#include <iostream>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

void printCommonPart(Node* head1, Node* head2) {
    Node* p1 = head1;
    Node* p2 = head2;

    // Traverse the lists until the values are equal
    while (p1 != nullptr && p2 != nullptr && p1->value != p2->value) {
        if (p1->value < p2->value) {
            p1 = p1->next;
        } else {
            p2 = p2->next;
        }
    }

    // Print the common part while both nodes are not null and have equal values
    while (p1 != nullptr && p2 != nullptr && p1->value == p2->value) {
        std::cout << p1->value << std::endl;
        p1 = p1->next;
        p2 = p2->next;
    }
}

int main() {
    // Create two sample linked lists: 1->2->3->4 and 2->3->4->5
    Node* head1 = new Node(1);
    head1->next = new Node(2);
    head1->next->next = new Node(3);
    head1->next->next->next = new Node(4);

    Node* head2 = new Node(2);
    head2->next = new Node(3);
    head2->next->next = new Node(4);
    head2->next->next->next = new Node(5);

    std::cout << "Common part: " << std::endl;
    printCommonPart(head1, head2);

    return 0;
}
