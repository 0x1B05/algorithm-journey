#include <iostream>
#include <stack>
#include <climits>

using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// Helper structure for ReturnType in method 3
struct ReturnType {
    int max;
    int min;
    bool isBST;

    ReturnType(int m, int n, bool bst) : max(m), min(n), isBST(bst) {}
};

// Global variable for method 1 and 2 to track the minimum value during traversal
int minValue = INT_MIN;

// Method 1: Recursively check if the tree is a BST using in-order traversal
bool isBST1(Node* root) {
    if (root == nullptr) {
        return true;
    }
    
    // Check the left subtree
    bool isLeftBst = isBST1(root->left);
    if (!isLeftBst) {
        return false;
    }

    // If the current node is not greater than the minimum value, return false
    if (root->value <= minValue) {
        return false;
    } else {
        // Update minValue
        minValue = root->value;
    }

    // Check the right subtree
    return isBST1(root->right);
}

// Method 2: Iterative in-order traversal to check if the tree is a BST
bool isBST2(Node* root) {
    stack<Node*> stack;
    Node* temp = root;

    while (temp != nullptr || !stack.empty()) {
        while (temp != nullptr) {
            stack.push(temp);
            temp = temp->left;
        }
        temp = stack.top();
        stack.pop();

        // If the current node is not greater than the minimum value, return false
        if (temp->value <= minValue) {
            return false;
        } else {
            // Update minValue
            minValue = temp->value;
        }
        temp = temp->right;
    }

    return true;
}

// Method 3: Check if the tree is a BST using post-order traversal
ReturnType process(Node* root) {
    if (root == nullptr) {
        return ReturnType(INT_MIN, INT_MAX, true);
    }

    ReturnType left = process(root->left);
    ReturnType right = process(root->right);

    int min = root->value;
    int max = root->value;

    if (left.isBST) {
        min = std::min(min, left.min);
        max = std::max(max, left.max);
    }

    if (right.isBST) {
        min = std::min(min, right.min);
        max = std::max(max, right.max);
    }

    bool isBST = (left.isBST && left.max < root->value) && 
                 (right.isBST && right.min > root->value);

    return ReturnType(max, min, isBST);
}

bool isBST3(Node* root) {
    return process(root).isBST;
}

int main() {
    // Example binary tree:
    //         4
    //        / \
    //       2   6
    //      / \   / \
    //     1   3 5   7
    Node* root = new Node(4);
    root->left = new Node(2);
    root->right = new Node(6);
    root->left->left = new Node(1);
    root->left->right = new Node(3);
    root->right->left = new Node(5);
    root->right->right = new Node(7);

    // Test isBST1
    cout << "isBST1: " << (isBST1(root) ? "True" : "False") << endl;

    // Reset minValue for method 2
    minValue = INT_MIN;

    // Test isBST2
    cout << "isBST2: " << (isBST2(root) ? "True" : "False") << endl;

    // Test isBST3
    cout << "isBST3: " << (isBST3(root) ? "True" : "False") << endl;

    return 0;
}
