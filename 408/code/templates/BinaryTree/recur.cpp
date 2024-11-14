#include <iostream>
#include <stack>
#include <queue>

using namespace std;

class Node {
public:
    int value;
    Node* left;
    Node* right;
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Pre-order recursion (Root -> Left -> Right)
void preOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    cout << head->value << " ";
    preOrderRecur(head->left);
    preOrderRecur(head->right);
}

// In-order recursion (Left -> Root -> Right)
void inOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    inOrderRecur(head->left);
    cout << head->value << " ";
    inOrderRecur(head->right);
}

// Post-order recursion (Left -> Right -> Root)
void posOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    posOrderRecur(head->left);
    posOrderRecur(head->right);
    cout << head->value << " ";
}

// Pre-order non-recursion (Root -> Left -> Right)
void preOrderUnRecur(Node* head) {
    cout << "pre-order: ";
    if (head != nullptr) {
        stack<Node*> s;
        s.push(head);
        while (!s.empty()) {
            head = s.top();
            s.pop();
            cout << head->value << " ";
            if (head->right != nullptr) {
                s.push(head->right);
            }
            if (head->left != nullptr) {
                s.push(head->left);
            }
        }
    }
    cout << endl;
}

// In-order non-recursion (Left -> Root -> Right)
void inOrderUnRecur(Node* head) {
    cout << "in-order: ";
    if (head != nullptr) {
        stack<Node*> s;
        while (!s.empty() || head != nullptr) {
            if (head != nullptr) {
                s.push(head);
                head = head->left;
            } else {
                head = s.top();
                s.pop();
                cout << head->value << " ";
                head = head->right;
            }
        }
    }
    cout << endl;
}

// Post-order non-recursion (Left -> Right -> Root)
void posOrderUnRecur(Node* head) {
    cout << "pos-order: ";
    if (head != nullptr) {
        stack<Node*> s1, s2;
        s1.push(head);
        while (!s1.empty()) {
            head = s1.top();
            s1.pop();
            s2.push(head);
            if (head->left != nullptr) {
                s1.push(head->left);
            }
            if (head->right != nullptr) {
                s1.push(head->right);
            }
        }
        while (!s2.empty()) {
            cout << s2.top()->value << " ";
            s2.pop();
        }
    }
    cout << endl;
}

// Breadth-First Search (Level-order traversal)
void bfs(Node* head) {
    if (head == nullptr) {
        return;
    }
    queue<Node*> q;
    q.push(head);
    while (!q.empty()) {
        Node* cur = q.front();
        q.pop();
        cout << cur->value << " ";
        if (cur->left != nullptr) {
            q.push(cur->left);
        }
        if (cur->right != nullptr) {
            q.push(cur->right);
        }
    }
    cout << endl;
}

// Main function for testing
int main() {
    // Example tree:
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

    // Testing all traversal methods
    cout << "Pre-order Recursive: ";
    preOrderRecur(root);
    cout << endl;

    cout << "In-order Recursive: ";
    inOrderRecur(root);
    cout << endl;

    cout << "Post-order Recursive: ";
    posOrderRecur(root);
    cout << endl;

    preOrderUnRecur(root);
    inOrderUnRecur(root);
    posOrderUnRecur(root);

    cout << "Breadth-First Search: ";
    bfs(root);
    return 0;
}
