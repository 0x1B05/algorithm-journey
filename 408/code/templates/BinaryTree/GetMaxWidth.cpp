#include <iostream>
#include <queue>
#include <climits> // 用于 INT_MIN

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
 * 获取二叉树的最大宽度
 */
int getMaxWidth(Node* root) {
    if (root == nullptr) {
        return 0;
    }

    // 使用 C++ 标准库的 queue 进行层序遍历
    queue<Node*> q;
    q.push(root);

    int maxWidth = INT_MIN; // 初始化为最小整数

    // 进行层序遍历
    while (!q.empty()) {
        // 获取当前层的节点数量
        int levelSize = q.size();
        // 更新最大宽度
        maxWidth = max(maxWidth, levelSize);

        // 遍历当前层的所有节点
        for (int i = 0; i < levelSize; i++) {
            Node* temp = q.front();
            q.pop();

            // 将左子节点加入队列
            if (temp->left != nullptr) {
                q.push(temp->left);
            }
            // 将右子节点加入队列
            if (temp->right != nullptr) {
                q.push(temp->right);
            }
        }
    }

    return maxWidth;
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

    // 获取最大宽度
    int maxWidth = getMaxWidth(root);
    cout << "Maximum Width of the Binary Tree: " << maxWidth << endl;

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
