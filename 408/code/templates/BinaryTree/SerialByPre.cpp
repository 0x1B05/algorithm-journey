#include <iostream>
#include <queue>
#include <sstream>
#include <string>

using namespace std;

// Definition for a binary tree node.
class Node {
public:
    int value;
    Node* left;
    Node* right;
    
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Function to serialize the tree using pre-order traversal.
string serialByPre(Node* root) {
    if (root == nullptr) {
        return "#_";  // Using "#_" to represent null nodes
    }
    stringstream ss;
    ss << root->value << "_";
    ss << serialByPre(root->left);
    ss << serialByPre(root->right);
    return ss.str();
}

// Helper function to deserialize the tree from the string
Node* reconPreOrder(queue<string>& q) {
    string value = q.front();
    q.pop();
    
    if (value == "#") {
        return nullptr;  // Null node
    }
    
    Node* node = new Node(stoi(value));  // Create the node from string value
    node->left = reconPreOrder(q);       // Recursively create the left child
    node->right = reconPreOrder(q);      // Recursively create the right child
    return node;
}

// Function to deserialize the tree from a string.
Node* reconPreString(string preStr) {
    stringstream ss(preStr);
    string value;
    queue<string> q;
    
    while (getline(ss, value, '_')) {
        q.push(value);
    }
    
    return reconPreOrder(q);
}

// Helper function to print the tree (in-order traversal)
void inorder(Node* root) {
    if (root == nullptr) {
        return;
    }
    inorder(root->left);
    cout << root->value << " ";
    inorder(root->right);
}

int main() {
    // Example usage
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);

    // Serialize the tree
    string serializedTree = serialByPre(root);
    cout << "Serialized tree: " << serializedTree << endl;

    // Deserialize the tree
    Node* deserializedTree = reconPreString(serializedTree);
    
    // Print the deserialized tree (in-order traversal)
    cout << "Deserialized tree (in-order traversal): ";
    inorder(deserializedTree);
    cout << endl;

    return 0;
}
