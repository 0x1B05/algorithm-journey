#include <iostream>
#include <unordered_set>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

// Helper function to detect if there is a loop in a linked list using a HashSet
Node* existLoop1(Node* head) {
    std::unordered_set<Node*> nodeSet;
    Node* temp = head;
    while (temp != nullptr) {
        if (nodeSet.find(temp) == nodeSet.end()) {
            nodeSet.insert(temp);
            temp = temp->next;
        } else {
            return temp;
        }
    }
    return nullptr;
}

// Helper function to detect loop using slow and fast pointers
Node* existLoop2(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return nullptr;
    }
    Node* slow = head;
    Node* fast = head;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next; // slow pointer moves 1 step
        fast = fast->next->next; // fast pointer moves 2 steps
        if (slow == fast) {
            fast = head; // Move fast pointer to the head to find the entrance to the loop
            while (slow != fast) {
                slow = slow->next;
                fast = fast->next;
            }
            return slow; // The node where they meet is the entrance to the loop
        }
    }
    return nullptr; // No loop
}

// Case 1: No loops in both lists
// Method 1: Use HashSet to find intersection
Node* noLoop1(Node* head1, Node* head2) {
    std::unordered_set<Node*> nodeSet;
    Node* p1 = head1;
    Node* p2 = head2;

    // Add nodes of first list to the HashSet
    while (p1 != nullptr) {
        nodeSet.insert(p1);
        p1 = p1->next;
    }

    // Check if any node of the second list is present in the HashSet
    while (p2 != nullptr) {
        if (nodeSet.find(p2) != nodeSet.end()) {
            return p2; // Intersection node found
        }
        p2 = p2->next;
    }

    return nullptr; // No intersection
}

// Method 2: Use two pointers, adjusting for the length difference
Node* noLoop2(Node* head1, Node* head2, Node* tail1, Node* tail2) {
    if (head1 == nullptr || head2 == nullptr) {
        return nullptr;
    }

    Node* p1 = head1;
    Node* p2 = head2;
    int d_value = 0;

    // Calculate length difference between the two lists
    while (p1->next != tail1) {
        ++d_value;
        p1 = p1->next;
    }

    while (p2->next != tail2) {
        --d_value;
        p2 = p2->next;
    }

    // If tail nodes are not the same, the lists do not intersect
    if (p1 != p2) {
        return nullptr;
    }

    p1 = head1;
    p2 = head2;

    // Adjust the longer list to have the same length as the shorter list
    if (d_value < 0) {
        while (d_value != 0) {
            ++d_value;
            p2 = p2->next;
        }
    } else {
        while (d_value != 0) {
            --d_value;
            p1 = p1->next;
        }
    }

    // Traverse both lists to find the intersection node
    while (p1 != p2) {
        p1 = p1->next;
        p2 = p2->next;
    }

    return p1; // Intersection node found
}

// Case 2: One list has a loop, the other does not
// Case 3: Both lists have a loop (with or without intersection)
Node* bothLoop(Node* head1, Node* head2) {
    Node* loop1 = existLoop2(head1);
    Node* loop2 = existLoop2(head2);

    if (loop1 == loop2) {
        return noLoop2(head1, head2, loop1, loop2);
    } else {
        // If both loops are different, no intersection
        Node* p1 = loop1->next;
        while (p1 != loop1) {
            if (p1 == loop2) {
                return loop2; // Intersection node within the loop
            }
            p1 = p1->next;
        }
        return nullptr; // No intersection in the loop
    }
}

// Main function to get the intersection node of two linked lists
Node* getIntersectNode(Node* head1, Node* head2) {
    if (head1 == nullptr || head2 == nullptr) {
        return nullptr;
    }

    // Check if both lists have loops
    Node* loop1 = existLoop2(head1);
    Node* loop2 = existLoop2(head2);

    // If both lists have no loops
    if (loop1 == nullptr && loop2 == nullptr) {
        return noLoop2(head1, head2, nullptr, nullptr);
    }

    // If both lists have loops
    if (loop1 != nullptr && loop2 != nullptr) {
        return bothLoop(head1, head2);
    }

    // If one list has a loop and the other does not, they cannot intersect
    return nullptr;
}

int main() {
    // Create sample linked lists
    Node* head1 = new Node(1);
    head1->next = new Node(2);
    head1->next->next = new Node(3);
    Node* head2 = new Node(4);
    head2->next = new Node(5);
    head2->next->next = head1->next; // Intersection at node with value 2

    Node* intersection = getIntersectNode(head1, head2);
    if (intersection != nullptr) {
        std::cout << "Intersection node: " << intersection->value << std::endl;
    } else {
        std::cout << "No intersection" << std::endl;
    }

    return 0;
}
