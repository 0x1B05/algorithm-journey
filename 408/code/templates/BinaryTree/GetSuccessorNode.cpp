#include <iostream>
using namespace std;

// Definition for a binary tree node.
struct NewNode {
    int value;
    NewNode* left;
    NewNode* right;
    NewNode* parent;

    NewNode(int val) : value(val), left(nullptr), right(nullptr), parent(nullptr) {}
};

// Function to find the in-order successor of a given node in the binary tree
NewNode* getSuccessorNode(NewNode* cur) {
    if (cur == nullptr) {
        return nullptr;
    }

    // Case 1: Node has a right child
    if (cur->right != nullptr) {
        NewNode* temp = cur->right;
        // Traverse to the leftmost node in the right subtree
        while (temp->left != nullptr) {
            temp = temp->left;
        }
        return temp;
    }
    
    // Case 2: Node does not have a right child, find the first ancestor for which the current node is in the left subtree
    NewNode* parent = cur->parent;
    while (parent != nullptr && parent->left != cur) {
        cur = parent;  // Move up the tree
        parent = cur->parent;  // Continue searching upwards
    }
    return parent;  // Return the parent (successor)
}

int main() {
    // Example: Create a sample tree
    //       20
    //      /  \
    //    10    30
    //   /  \   /  \
    //  5   15 25   35

    NewNode* root = new NewNode(20);
    NewNode* node10 = new NewNode(10);
    NewNode* node30 = new NewNode(30);
    NewNode* node5 = new NewNode(5);
    NewNode* node15 = new NewNode(15);
    NewNode* node25 = new NewNode(25);
    NewNode* node35 = new NewNode(35);

    // Connect nodes
    root->left = node10;
    root->right = node30;
    node10->parent = root;
    node30->parent = root;

    node10->left = node5;
    node10->right = node15;
    node5->parent = node10;
    node15->parent = node10;

    node30->left = node25;
    node30->right = node35;
    node25->parent = node30;
    node35->parent = node30;

    // Test getSuccessorNode function
    NewNode* successor = getSuccessorNode(node10);
    if (successor != nullptr) {
        cout << "Successor of node " << node10->value << " is node " << successor->value << endl;
    } else {
        cout << "No successor found for node " << node10->value << endl;
    }

    return 0;
}
