#include <iostream>
#include <queue>
#include <algorithm>

using namespace std;

class Node {
public:
    int value;
    Node* left;
    Node* right;
    
    // Constructor to initialize node
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Function to get the maximum width of the binary tree
int getMaxWidth1(Node* root) {
    if (root == nullptr) {
        return 0;
    }

    queue<Node*> q;    // Queue to perform level-order traversal
    q.push(root);       // Start with the root node
    int maxWidth = 0;   // Variable to store the maximum width

    while (!q.empty()) {
        int levelSize = q.size();  // Get the number of nodes at the current level
        maxWidth = max(maxWidth, levelSize);  // Update the maximum width if needed

        for (int i = 0; i < levelSize; i++) {
            Node* temp = q.front();  // Get the front node of the queue
            q.pop();

            // Add the left and right children to the queue if they exist
            if (temp->left != nullptr) {
                q.push(temp->left);
            }
            if (temp->right != nullptr) {
                q.push(temp->right);
            }
        }
    }

    return maxWidth;  // Return the maximum width of the tree
}

// Main function to test the getMaxWidth1 method
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

    cout << "Maximum Width of the Tree: " << getMaxWidth1(root) << endl;

    return 0;
}
