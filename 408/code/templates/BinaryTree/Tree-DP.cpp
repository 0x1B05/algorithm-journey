#include <iostream>
#include <algorithm>
#include <cmath>
using namespace std;

// 定义二叉树节点
struct Node {
    int value;
    Node* left;
    Node* right;
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// 1. 判断是否为二叉搜索树 (BST)
struct ReturnTypeBST {
    int max;
    int min;
    bool isBST;
    ReturnTypeBST(int mx, int mn, bool isB) : max(mx), min(mn), isBST(isB) {}
};

// 判断二叉树是否为二叉搜索树
ReturnTypeBST* processBST(Node* root) {
    if (root == nullptr) return nullptr;

    ReturnTypeBST* left = processBST(root->left);
    ReturnTypeBST* right = processBST(root->right);

    int min = root->value;
    int max = root->value;

    // 更新当前节点的最小值和最大值
    if (left != nullptr) {
        min = std::min(min, left->min);
        max = std::max(max, left->max);
    }
    if (right != nullptr) {
        min = std::min(min, right->min);
        max = std::max(max, right->max);
    }

    // 判断是否为BST
    bool isBST = (left == nullptr || (left->isBST && left->max < root->value)) &&
                 (right == nullptr || (right->isBST && right->min > root->value));

    return new ReturnTypeBST(max, min, isBST);
}

bool isBST3(Node* root) {
    if (root == nullptr) return true;
    ReturnTypeBST* result = processBST(root);
    return result->isBST;
}

// 2. 判断二叉树是否为平衡树 (Balanced)
struct ReturnTypeBalanced {
    bool isBalanced;
    int height;
    ReturnTypeBalanced(bool isB, int h) : isBalanced(isB), height(h) {}
};

// 判断二叉树是否平衡
ReturnTypeBalanced* processBalanced(Node* x) {
    if (x == nullptr) {
        return new ReturnTypeBalanced(true, 0);
    }

    ReturnTypeBalanced* leftData = processBalanced(x->left);
    ReturnTypeBalanced* rightData = processBalanced(x->right);

    int height = std::max(leftData->height, rightData->height) + 1;
    bool isBalanced = leftData->isBalanced && rightData->isBalanced &&
                      std::abs(leftData->height - rightData->height) < 2;

    return new ReturnTypeBalanced(isBalanced, height);
}

bool isBalanced2(Node* head) {
    return processBalanced(head)->isBalanced;
}

// 3. 判断二叉树是否为满二叉树 (Full)
struct InfoFull {
    int height;
    int nodes;
    InfoFull(int h, int n) : height(h), nodes(n) {}
};

// 判断二叉树是否为满二叉树
InfoFull* processFull(Node* head) {
    if (head == nullptr) {
        return new InfoFull(0, 0);
    }

    InfoFull* leftData = processFull(head->left);
    InfoFull* rightData = processFull(head->right);

    int height = std::max(leftData->height, rightData->height) + 1;
    int nodes = leftData->nodes + rightData->nodes + 1;

    return new InfoFull(height, nodes);
}

bool isFull2(Node* head) {
    if (head == nullptr) return true;
    InfoFull* data = processFull(head);
    return data->nodes == (1 << (data->height - 1));
}

// 测试函数
void testFunctions() {
    Node* root = new Node(5);
    root->left = new Node(3);
    root->right = new Node(8);
    root->left->left = new Node(2);
    root->left->right = new Node(4);
    root->right->left = new Node(6);
    root->right->right = new Node(10);

    cout << "Is BST: " << (isBST3(root) ? "Yes" : "No") << endl;
    cout << "Is Balanced: " << (isBalanced2(root) ? "Yes" : "No") << endl;
    cout << "Is Full: " << (isFull2(root) ? "Yes" : "No") << endl;

    delete root->left->left;
    delete root->left->right;
    delete root->left;
    delete root->right->left;
    delete root->right->right;
    delete root->right;
    delete root;
}

int main() {
    testFunctions();
    return 0;
}
