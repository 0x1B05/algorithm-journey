#include <iostream>
#include <unordered_map>
#include <unordered_set>
using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// 1. Simple method using a HashMap to store parent information and then finding common ancestors
void fillMap(Node* head, unordered_map<Node*, Node*>& fatherMap) {
    if (head == nullptr) {
        return;
    }
    if (head->left) {
        fatherMap[head->left] = head;
        fillMap(head->left, fatherMap);
    }
    if (head->right) {
        fatherMap[head->right] = head;
        fillMap(head->right, fatherMap);
    }
}
Node* lowestCommonAncestor1(Node* head, Node* o1, Node* o2) {
    unordered_map<Node*, Node*> fatherMap;
    fatherMap[head] = head;

    // Fill the map with parent-child relationships
    fillMap(head, fatherMap);

    unordered_set<Node*> set1;
    Node* cur = o1;

    // Add all ancestors of o1 to the set
    while (cur != fatherMap[cur]) {
        set1.insert(cur);
        cur = fatherMap[cur];
    }
    set1.insert(head); // Add the root node as well

    // Find the common ancestor for o2
    cur = o2;
    while (cur != fatherMap[cur]) {
        cur = fatherMap[cur];
        if (set1.find(cur) != set1.end()) {
            return cur;
        }
    }
    return nullptr;
}


// 2. Optimized version (Recursive solution without using extra space)
Node* lowestCommonAncestor2(Node* root, Node* o1, Node* o2) {
    if (root == nullptr || root == o1 || root == o2) {
        return root;
    }

    // Recursively find LCA in left and right subtrees
    Node* retLeft = lowestCommonAncestor2(root->left, o1, o2);
    Node* retRight = lowestCommonAncestor2(root->right, o1, o2);

    // If both left and right are non-null, the current node is the LCA
    if (retLeft != nullptr && retRight != nullptr) {
        return root;
    }

    // Otherwise, return the non-null subtree's result (either left or right)
    return retLeft != nullptr ? retLeft : retRight;
}

// Main function to test the code
int main() {
    // Example binary tree:
    //         1
    //        / \
    //       2   3
    //      / \ / \
    //     4  5 6  7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    Node* o1 = root->left->left; // Node 4
    Node* o2 = root->left->right; // Node 5

    // Test lowestCommonAncestor1
    Node* lca1 = lowestCommonAncestor1(root, o1, o2);
    if (lca1 != nullptr) {
        cout << "LCA (Method 1): " << lca1->value << endl;
    } else {
        cout << "LCA not found (Method 1)" << endl;
    }

    // Test lowestCommonAncestor2
    Node* lca2 = lowestCommonAncestor2(root, o1, o2);
    if (lca2 != nullptr) {
        cout << "LCA (Method 2): " << lca2->value << endl;
    } else {
        cout << "LCA not found (Method 2)" << endl;
    }

    return 0;
}
