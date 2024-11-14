#include <iostream>
#include <stack>
#include <queue>

using namespace std;

/**
 * 二叉树节点结构
 */
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

/**
 * 递归先序遍历
 */
void preOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    cout << head->value << " ";
    preOrderRecur(head->left);
    preOrderRecur(head->right);
}

/**
 * 递归中序遍历
 */
void inOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    inOrderRecur(head->left);
    cout << head->value << " ";
    inOrderRecur(head->right);
}

/**
 * 递归后序遍历
 */
void posOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    posOrderRecur(head->left);
    posOrderRecur(head->right);
    cout << head->value << " ";
}

/**
 * 非递归先序遍历
 */
void preOrderUnRecur(Node* head) {
    cout << "pre-order: ";
    if (head != nullptr) {
        stack<Node*> s;
        s.push(head);
        while (!s.empty()) {
            head = s.top();
            s.pop();
            cout << head->value << " ";
            // 先右再左入栈，保证左子树先遍历
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

/**
 * 非递归中序遍历
 */
void inOrderUnRecur(Node* head) {
    cout << "in-order: ";
    stack<Node*> s;
    while (!s.empty() || head != nullptr) {
        // 遍历左子树，入栈
        if (head != nullptr) {
            s.push(head);
            head = head->left;
        } else {
            // 弹出栈顶元素，访问节点
            head = s.top();
            s.pop();
            cout << head->value << " ";
            // 处理右子树
            head = head->right;
        }
    }
    cout << endl;
}

/**
 * 非递归后序遍历
 */
void posOrderUnRecur(Node* head) {
    cout << "pos-order: ";
    if (head != nullptr) {
        stack<Node*> s1; // 辅助栈
        stack<Node*> s2; // 收集栈
        s1.push(head);
        while (!s1.empty()) {
            head = s1.top();
            s1.pop();
            s2.push(head);
            // 先左后右入栈
            if (head->left != nullptr) {
                s1.push(head->left);
            }
            if (head->right != nullptr) {
                s1.push(head->right);
            }
        }
        // 从收集栈弹出并访问
        while (!s2.empty()) {
            cout << s2.top()->value << " ";
            s2.pop();
        }
    }
    cout << endl;
}

/**
 * 宽度优先遍历（BFS）
 */
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
        // 左子树入队
        if (cur->left != nullptr) {
            q.push(cur->left);
        }
        // 右子树入队
        if (cur->right != nullptr) {
            q.push(cur->right);
        }
    }
    cout << endl;
}

/**
 * 测试代码
 */
int main() {
    // 构建二叉树
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    // 递归遍历
    cout << "Recursive PreOrder: ";
    preOrderRecur(root);
    cout << endl;

    cout << "Recursive InOrder: ";
    inOrderRecur(root);
    cout << endl;

    cout << "Recursive PostOrder: ";
    posOrderRecur(root);
    cout << endl;

    // 非递归遍历
    preOrderUnRecur(root);
    inOrderUnRecur(root);
    posOrderUnRecur(root);

    // 宽度优先遍历
    cout << "BFS: ";
    bfs(root);

    // 释放内存
    delete root->left->left;
    delete root->left->right;
    delete root->right->left;
    delete root->right->right;
    delete root->left;
    delete root->right;
    delete root;

    return 0;
}
