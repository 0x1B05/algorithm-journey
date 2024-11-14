#include <iostream>
#include <cmath> // 使用abs函数计算绝对值

using namespace std;

// 定义树节点结构体
struct Node {
    int value;
    Node* left;
    Node* right;
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

/**
 * 计算二叉树的高度
 * @param root 当前子树的根节点
 * @return 返回该子树的高度
 */
int findHeight(Node* root) {
    if (root == nullptr) {
        return 0; // 空节点高度为0
    }
    // 返回左右子树中较大的高度 + 1
    return max(findHeight(root->left), findHeight(root->right)) + 1;
}

/**
 * 判断二叉树是否为平衡二叉树
 * @param root 当前子树的根节点
 * @return 如果是平衡二叉树返回true，否则返回false
 */
bool isBalanced1(Node* root) {
    if (root == nullptr) {
        return true; // 空树是平衡二叉树
    }

    // 检查左子树和右子树是否为平衡二叉树
    bool leftBalanced = isBalanced1(root->left);
    bool rightBalanced = isBalanced1(root->right);

    // 计算左右子树的高度差
    int heightDifference = abs(findHeight(root->left) - findHeight(root->right));

    // 当前节点的平衡性检查: 左右子树都必须是平衡二叉树，并且高度差不超过1
    return leftBalanced && rightBalanced && (heightDifference <= 1);
}

int main() {
    // 创建简单测试用例
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);

    // 检查树是否为平衡二叉树
    if (isBalanced1(root)) {
        cout << "树是平衡二叉树" << endl;
    } else {
        cout << "树不是平衡二叉树" << endl;
    }

    // 释放内存(手动清理)
    delete root->left->left;
    delete root->left->right;
    delete root->left;
    delete root->right;
    delete root;

    return 0;
}
