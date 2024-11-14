#include <iostream>
#include <stack>
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

// 全局变量 minValue, 用于记录中序遍历的前一个节点值
int minValue = INT_MIN;

/**
 * 使用递归的中序遍历判断是否为二叉搜索树
 */
bool isBST1(Node* root) {
    if (root == nullptr) {
        return true;
    }

    // 检查左子树是否为二叉搜索树
    if (!isBST1(root->left)) {
        return false;
    }

    // 检查当前节点是否大于中序遍历的前一个节点值
    if (root->value <= minValue) {
        return false;
    } else {
        // 更新 minValue 为当前节点值
        minValue = root->value;
    }

    // 检查右子树是否为二叉搜索树
    return isBST1(root->right);
}

/**
 * 使用迭代的中序遍历判断是否为二叉搜索树
 */
bool isBST2(Node* root) {
    stack<Node*> stack;
    Node* temp = root;
    int minValue = INT_MIN; // 迭代方法中使用局部变量 minValue

    while (temp != nullptr || !stack.empty()) {
        // 将左子树节点依次入栈
        while (temp != nullptr) {
            stack.push(temp);
            temp = temp->left;
        }

        // 获取栈顶节点
        temp = stack.top();
        stack.pop();

        // 判断是否符合升序（BST 性质）
        if (temp->value <= minValue) {
            return false;
        } else {
            // 更新 minValue
            minValue = temp->value;
        }

        // 遍历右子树
        temp = temp->right;
    }

    return true;
}

/**
 * 测试代码
 */
int main() {
    // 构建二叉树
    Node* root = new Node(5);
    root->left = new Node(3);
    root->right = new Node(7);
    root->left->left = new Node(2);
    root->left->right = new Node(4);
    root->right->left = new Node(6);
    root->right->right = new Node(8);

    // 使用递归方法判断
    minValue = INT_MIN; // 重置 minValue
    bool result1 = isBST1(root);
    cout << "Is the tree a BST (Recursive)? " << (result1 ? "Yes" : "No") << endl;

    // 使用迭代方法判断
    bool result2 = isBST2(root);
    cout << "Is the tree a BST (Iterative)? " << (result2 ? "Yes" : "No") << endl;

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
