#include <iostream>
#include <unordered_map>
#include <unordered_set>

using namespace std;

// 定义二叉树节点结构
struct Node {
    int value;
    Node* left;
    Node* right;
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

/**
 * 存储每个节点的父节点信息
 * @param head 当前节点
 * @param fatherMap 父节点哈希表
 */
void fillMap(Node* head, unordered_map<Node*, Node*>& fatherMap) {
    if (head == nullptr) {
        return;
    }
    if (head->left != nullptr) {
        fatherMap[head->left] = head; // 左子节点的父节点为当前节点
        fillMap(head->left, fatherMap);
    }
    if (head->right != nullptr) {
        fatherMap[head->right] = head; // 右子节点的父节点为当前节点
        fillMap(head->right, fatherMap);
    }
}

/**
 * 使用哈希表寻找两个节点的最近公共祖先
 * @param head 二叉树的根节点
 * @param o1 节点1
 * @param o2 节点2
 * @return 返回最近公共祖先节点
 */
Node* lowestCommonAncestor1(Node* head, Node* o1, Node* o2) {
    if (head == nullptr) {
        return nullptr;
    }

    // 哈希表存储父节点信息
    unordered_map<Node*, Node*> fatherMap;
    fatherMap[head] = head; // 根节点的父节点为自己
    fillMap(head, fatherMap);

    // 存储o1节点的所有祖先节点
    unordered_set<Node*> set1;
    Node* cur = o1;

    // 将o1的所有祖先节点存入集合set1
    while (cur != fatherMap[cur]) {
        set1.insert(cur);
        cur = fatherMap[cur];
    }
    set1.insert(head); // 最后将根节点放入集合

    // 查找o2的祖先节点中与o1的祖先节点重合的第一个节点
    cur = o2;
    while (cur != fatherMap[cur]) {
        if (set1.count(cur)) {
            return cur; // 找到公共祖先
        }
        cur = fatherMap[cur];
    }

    return head; // 若没有重合，返回根节点
}

/**
 * 精简版本：递归查找最近公共祖先
 * @param root 当前子树的根节点
 * @param o1 节点1
 * @param o2 节点2
 * @return 返回最近公共祖先节点
 */
Node* lowestCommonAncestor2(Node* root, Node* o1, Node* o2) {
    if (root == nullptr || root == o1 || root == o2) {
        return root; // 如果当前节点是空，或者为o1或o2之一，则直接返回
    }

    // 在左、右子树中递归查找
    Node* retLeft = lowestCommonAncestor2(root->left, o1, o2);
    Node* retRight = lowestCommonAncestor2(root->right, o1, o2);

    // 左右子树都找到o1或o2时，说明当前节点为最近公共祖先
    if (retLeft != nullptr && retRight != nullptr) {
        return root;
    }

    // 返回非空的子树节点
    return retLeft != nullptr ? retLeft : retRight;
}

int main() {
    // 创建测试二叉树
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    Node* o1 = root->left->left;  // 节点4
    Node* o2 = root->left->right; // 节点5

    // 使用方法1寻找最近公共祖先
    Node* lca1 = lowestCommonAncestor1(root, o1, o2);
    if (lca1 != nullptr) {
        cout << "方法1：最近公共祖先节点值为: " << lca1->value << endl;
    }

    // 使用方法2寻找最近公共祖先
    Node* lca2 = lowestCommonAncestor2(root, o1, o2);
    if (lca2 != nullptr) {
        cout << "方法2：最近公共祖先节点值为: " << lca2->value << endl;
    }

    // 释放内存
    delete root->left->left;
    delete root->left->right;
    delete root->left;
    delete root->right->left;
    delete root->right->right;
    delete root->right;
    delete root;

    return 0;
}
