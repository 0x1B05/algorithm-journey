#include <iostream>
#include <stack>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

// Method 1: Use stack to store all elements and compare them with the original list
// Time complexity: O(n), Space complexity: O(n)
bool isPalindrome1(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    std::stack<Node*> stack;
    Node* cur = head;

    // Push all elements into the stack
    while (cur != nullptr) {
        stack.push(cur);
        cur = cur->next;
    }

    // Compare elements from the stack with the list
    while (head != nullptr) {
        if (head->value != stack.top()->value) {
            return false;
        }
        stack.pop();
        head = head->next;
    }

    return true;
}

// Method 2: Use stack to store the second half of the list, and compare it with the first half
// Time complexity: O(n), Space complexity: O(n/2)
bool isPalindrome2(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    Node* slow = head;
    Node* fast = head;

    // Use slow and fast pointers to find the middle of the list
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // Push the second half of the list into the stack
    std::stack<Node*> stack;
    while (slow != nullptr) {
        stack.push(slow);
        slow = slow->next;
    }

    // Compare the first half with the second half from the stack
    while (!stack.empty()) {
        if (head->value != stack.top()->value) {
            return false;
        }
        stack.pop();
        head = head->next;
    }

    return true;
}

// Method 3: Reverse the second half of the list and compare it with the first half
// Time complexity: O(n), Space complexity: O(1)

Node* reverseList(Node* head) {
    Node* prev = nullptr;
    Node* curr = head;

    while (curr != nullptr) {
        Node* next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }

    return prev;
}

bool isPalindrome3(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    Node* slow = head;
    Node* fast = head;

    // Use slow and fast pointers to find the middle of the list
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // Reverse the second half of the list
    Node* secondHalf = reverseList(slow);
    Node* firstHalf = head;

    // Compare the first half with the reversed second half
    while (secondHalf != nullptr) {
        if (firstHalf->value != secondHalf->value) {
            return false;
        }
        firstHalf = firstHalf->next;
        secondHalf = secondHalf->next;
    }

    return true;
}

// Helper function to print the list (for testing)
void printList(Node* head) {
    while (head != nullptr) {
        std::cout << head->value << " ";
        head = head->next;
    }
    std::cout << std::endl;
}

int main() {
    // Create a sample linked list: 1 -> 2 -> 3 -> 2 -> 1
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(2);
    head->next->next->next->next = new Node(1);

    std::cout << "Is Palindrome (Method 1): " << isPalindrome1(head) << std::endl;
    std::cout << "Is Palindrome (Method 2): " << isPalindrome2(head) << std::endl;
    std::cout << "Is Palindrome (Method 3): " << isPalindrome3(head) << std::endl;

    return 0;
}
