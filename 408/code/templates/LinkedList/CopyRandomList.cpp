#include <iostream>
#include <unordered_map>

using namespace std;

struct Node {
    int value;
    Node* next;
    Node* random;

    Node(int v) : value(v), next(nullptr), random(nullptr) {}
};

// Method 1: Using a HashMap to map old nodes to their copied nodes
Node* copyRandomList1(Node* head) {
    if (head == nullptr) return nullptr;

    unordered_map<Node*, Node*> map;

    // First pass: Create a copy of each node and store it in the map
    Node* temp = head;
    while (temp != nullptr) {
        map[temp] = new Node(temp->value);
        temp = temp->next;
    }

    // Second pass: Set the next and random pointers of the copied nodes
    temp = head;
    while (temp != nullptr) {
        map[temp]->next = map[temp->next];
        map[temp]->random = map[temp->random];
        temp = temp->next;
    }

    return map[head];
}

// Method 2: Without extra space, directly modify the list and split it at the end
Node* copyRandomList2(Node* head) {
    if (head == nullptr) return nullptr;

    // Step 1: Create the copy nodes and interlace them with the original list
    Node* temp = head;
    while (temp != nullptr) {
        Node* tempCopy = new Node(temp->value);
        Node* nextTemp = temp->next;
        temp->next = tempCopy;
        tempCopy->next = nextTemp;
        temp = nextTemp;
    }

    // Step 2: Copy the random pointers
    temp = head;
    while (temp != nullptr) {
        if (temp->random != nullptr) {
            temp->next->random = temp->random->next;
        }
        temp = temp->next->next;
    }

    // Step 3: Separate the copied list from the original list
    temp = head;
    Node* headCopy = head->next;
    while (temp != nullptr) {
        Node* tempCopy = temp->next;
        temp->next = temp->next->next;
        if (tempCopy->next != nullptr) {
            tempCopy->next = tempCopy->next->next;
        }
        temp = temp->next;
    }

    return headCopy;
}

int main() {
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);

    head->random = head->next->next; // 1's random points to 3
    head->next->random = head; // 2's random points to 1
    head->next->next->random = head->next; // 3's random points to 2

    Node* copiedList1 = copyRandomList1(head);
    Node* copiedList2 = copyRandomList2(head);

    // Output copied list from method 1
    cout << "Copied List 1 (Method 1):" << endl;
    Node* temp = copiedList1;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    // Output copied list from method 2
    cout << "Copied List 2 (Method 2):" << endl;
    temp = copiedList2;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    return 0;
}
