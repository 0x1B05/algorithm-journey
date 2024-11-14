#include <iostream>
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
 * 判断二叉树是否为完全二叉树 (CBT)
 */
bool isCBT(Node* head) {
    if (head == nullptr) {
        return true;
    }

    queue<Node*> queue;
    bool leaf = false; // 是否遇到左右孩子节点不全的节点
    Node* l = nullptr;
    Node* r = nullptr;
    queue.push(head);

    while (!queue.empty()) {
        head = queue.front();
        queue.pop();

        l = head->left;
        r = head->right;

        // 情况 1: 遇到左右孩子节点不全的节点后, 又遇到不是叶子节点的情况
        // 情况 2: 存在右子树而没有左子树
        if ((leaf && (l != nullptr || r != nullptr)) || (l == nullptr && r != nullptr)) {
            return false;
        }

        // 左子树不为空时入队
        if (l != nullptr) {
            queue.push(l);
        }

        // 右子树不为空时入队
        if (r != nullptr) {
            queue.push(r);
        }

        // 当遇到左子树为空或者右子树为空时，标记为叶子节点阶段
        if (l == nullptr || r == nullptr) {
            leaf = true;
        }
    }

    return true;
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

    // 检查是否为完全二叉树
    bool result = isCBT(root);
    cout << "Is the tree a Complete Binary Tree? " << (result ? "Yes" : "No") << endl;

    // 释放内存
    delete root->left->left;
    delete root->left->right;
    delete root->right->left;
    delete root->left;
    delete root->right;
    delete root;

    return 0;
}
