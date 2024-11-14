#include <iostream>

using namespace std;

// 定义包含父节点指针的二叉树节点结构
struct NewNode {
    int value;
    NewNode* left;
    NewNode* right;
    NewNode* parent;

    NewNode(int val) : value(val), left(nullptr), right(nullptr), parent(nullptr) {}
};

/**
 * 获取节点的后继节点（中序遍历下一个节点）
 * @param cur 当前节点
 * @return 返回后继节点
 */
NewNode* getSuccessNode(NewNode* cur) {
    if (cur == nullptr) {
        return nullptr;
    }

    // 情况1：当前节点有右子树时，后继节点为右子树中最左的节点
    if (cur->right != nullptr) {
        NewNode* temp = cur->right;
        // 找到右子树上最左的节点
        while (temp->left != nullptr) {
            temp = temp->left;
        }
        return temp;
    } 
    // 情况2：当前节点没有右子树时，向上找
    else {
        NewNode* parent = cur->parent;
        // 向上查找，直到当前节点是父节点的左子节点
        while (parent != nullptr && parent->left != cur) {
            cur = parent;
            parent = cur->parent;
        }
        return parent;
    }
}

// 用于测试的简单函数
void testGetSuccessorNode() {
    // 构建二叉树
    NewNode* root = new NewNode(5);
    root->left = new NewNode(3);
    root->right = new NewNode(8);
    root->left->parent = root;
    root->right->parent = root;

    root->left->left = new NewNode(2);
    root->left->right = new NewNode(4);
    root->left->left->parent = root->left;
    root->left->right->parent = root->left;

    root->right->left = new NewNode(6);
    root->right->right = new NewNode(10);
    root->right->left->parent = root->right;
    root->right->right->parent = root->right;

    NewNode* testNode = root->left; // 节点3
    NewNode* successor = getSuccessNode(testNode);
    if (successor != nullptr) {
        cout << "节点 " << testNode->value << " 的后继节点是: " << successor->value << endl;
    } else {
        cout << "节点 " << testNode->value << " 没有后继节点" << endl;
    }

    // 释放内存
    delete root->left->left;
    delete root->left->right;
    delete root->left;
    delete root->right->left;
    delete root->right->right;
    delete root->right;
    delete root;
}

int main() {
    testGetSuccessorNode();
    return 0;
}
