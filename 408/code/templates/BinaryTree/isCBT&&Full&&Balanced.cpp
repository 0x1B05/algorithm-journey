#include <iostream>
#include <queue>
#include <cmath>
#include <algorithm>
using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// Function to check if the tree is a Complete Binary Tree (CBT)
bool isCBT(Node* head) {
    if (head == nullptr) {
        return true;
    }
    
    queue<Node*> queue;
    bool leaf = false;  // Whether we have encountered a node with incomplete children
    Node* l = nullptr;
    Node* r = nullptr;
    queue.push(head);

    while (!queue.empty()) {
        head = queue.front();
        queue.pop();
        l = head->left;
        r = head->right;

        // If a leaf node is encountered, no node with children should follow
        if ((leaf && (l != nullptr || r != nullptr)) || (l == nullptr && r != nullptr)) {
            return false;
        }

        if (l != nullptr) {
            queue.push(l);
        }
        if (r != nullptr) {
            queue.push(r);
        }

        // If either left or right child is null, we mark this as a leaf
        if (l == nullptr || r == nullptr) {
            leaf = true;
        }
    }

    return true;
}

// Function to check if the tree is a Full Binary Tree
int findHeight(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    return max(findHeight(root->left), findHeight(root->right)) + 1;
}

int findNodes(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    return findNodes(root->left) + findNodes(root->right) + 1;
}

bool isFull(Node* root) {
    int height = findHeight(root);
    int nodes = findNodes(root);

    return ((1 << height) - 1) == nodes;
}

// Function to check if the tree is a Balanced Binary Tree
bool isBalanced(Node* root) {
    if (root == nullptr) {
        return true;
    }
    return isBalanced(root->left) && isBalanced(root->right) &&
           abs(findHeight(root->left) - findHeight(root->right)) <= 1;
}

// Data structure to hold balance status and height of the subtree
struct ReturnType {
    bool isBalanced;
    int height;
    ReturnType(bool isB, int h) : isBalanced(isB), height(h) {}
};

// Data structure to hold height and node count of the subtree
struct Info {
    int height;
    int nodes;
    Info(int h, int n) : height(h), nodes(n) {}
};

// Method to check if the tree is balanced
ReturnType process(Node* x) {
    if (x == nullptr) {
        return ReturnType(true, 0);  // A null node is balanced with height 0
    }

    // Process left and right subtrees
    ReturnType leftData = process(x->left);
    ReturnType rightData = process(x->right);

    // Height of the current subtree
    int height = max(leftData.height, rightData.height) + 1;

    // The tree is balanced if both subtrees are balanced and the height difference is <= 1
    bool isBalanced = leftData.isBalanced && rightData.isBalanced
                      && abs(leftData.height - rightData.height) <= 1;

    return ReturnType(isBalanced, height);
}

bool isBalanced2(Node* head) {
    return process(head).isBalanced;
}

// Method to check if the tree is full
Info processFull(Node* head) {
    if (head == nullptr) {
        return Info(0, 0);  // A null node has height 0 and 0 nodes
    }

    // Process left and right subtrees
    Info leftData = processFull(head->left);
    Info rightData = processFull(head->right);

    // Height of the current subtree
    int height = max(leftData.height, rightData.height) + 1;

    // Total number of nodes in the current subtree
    int nodes = leftData.nodes + rightData.nodes + 1;

    return Info(height, nodes);
}

bool isFull2(Node* head) {
    if (head == nullptr) {
        return true;  // A null tree is full
    }

    // Get the height and node count of the tree
    Info data = processFull(head);
    
    // A tree is full if the number of nodes equals (2^height - 1)
    return data.nodes == ((1 << (data.height)) - 1);
}

int main() {
    // Example binary tree:
    //         1
    //        / \
    //       2   3
    //      / \   / \
    //     4   5 6   7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    // Test isCBT
    cout << "isCBT: " << (isCBT(root) ? "True" : "False") << endl;

    // Test isFull
    cout << "isFull: " << (isFull(root) ? "True" : "False") << endl;
    // Test isFull2
    cout << "isFull2: " << (isFull2(root) ? "True" : "False") << endl;

    // Test isBalanced
    cout << "isBalanced: " << (isBalanced(root) ? "True" : "False") << endl;

    // Test isBalanced2
    cout << "isBalanced2: " << (isBalanced2(root) ? "True" : "False") << endl;
    return 0;
}
