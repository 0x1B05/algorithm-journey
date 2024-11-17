#include <iostream>
#include <queue>
#include <algorithm>

using namespace std;

class Node {
public:
    int value;       // 节点的值
    Node* left;      // 左子节点
    Node* right;     // 右子节点
    // 构造函数初始化节点
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// 获取二叉树最大宽度的函数
int getMaxWidth(Node* root) {
    if (root == nullptr) {  // 如果树为空，返回宽度为0
        return 0;
    }

    queue<Node*> q;    // 队列用于进行层次遍历
    q.push(root);       // 将根节点加入队列
    int maxWidth = 0;   // 记录树的最大宽度

    while (!q.empty()) {  // 队列不为空时继续遍历
        int levelSize = q.size();  // 获取当前层的节点数
        maxWidth = max(maxWidth, levelSize);  // 更新最大宽度

        for (int i = 0; i < levelSize; i++) {  // 遍历当前层的所有节点
            Node* temp = q.front();  // 获取队列中的第一个节点
            q.pop();  // 弹出队列中的第一个节点

            // 如果当前节点有左子节点，将左子节点加入队列
            if (temp->left != nullptr) {
                q.push(temp->left);
            }
            // 如果当前节点有右子节点，将右子节点加入队列
            if (temp->right != nullptr) {
                q.push(temp->right);
            }
        }
    }

    return maxWidth;  // 返回树的最大宽度
}

int main() {
    // 示例二叉树：
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

    cout << "二叉树的最大宽度为: " << getMaxWidth(root) << endl;

    return 0;
}
