#include <iostream>
#include <unordered_map>

using namespace std;

struct Node {
    int value;  // 节点的值
    Node* next; // 指向下一个节点的指针
    Node* random; // 指向随机节点的指针

    Node(int v) : value(v), next(nullptr), random(nullptr) {}
};

// 方法1：使用哈希表将原节点映射到其复制节点
Node* copyRandomList1(Node* head) {
    if (head == nullptr) return nullptr;

    unordered_map<Node*, Node*> map; // 哈希表，用于保存原节点与新节点的映射关系

    // 第一次遍历：创建每个节点的复制品，并将其保存在哈希表中
    Node* temp = head;
    while (temp != nullptr) {
        map[temp] = new Node(temp->value);  // 创建新节点并保存到哈希表中
        temp = temp->next;
    }

    // 第二次遍历：设置复制节点的 next 和 random 指针
    temp = head;
    while (temp != nullptr) {
        map[temp]->next = map[temp->next];  // 设置 next 指针
        map[temp]->random = map[temp->random];  // 设置 random 指针
        temp = temp->next;
    }

    return map[head];  // 返回复制链表的头节点
}

// 方法2：不使用额外空间，直接修改原链表，并在最后拆分
Node* copyRandomList2(Node* head) {
    if (head == nullptr) return nullptr;

    // 第一步：创建复制节点，并将其与原链表交织在一起
    Node* temp = head;
    while (temp != nullptr) {
        Node* tempCopy = new Node(temp->value);  // 创建一个新节点
        Node* nextTemp = temp->next;  // 保存原节点的 next 指针
        temp->next = tempCopy;  // 将原节点的 next 指向新节点
        tempCopy->next = nextTemp;  // 新节点的 next 指向原节点的下一个节点
        temp = nextTemp;  // 移动到下一个原节点
    }

    // 第二步：复制 random 指针
    temp = head;
    while (temp != nullptr) {
        if (temp->random != nullptr) {
            temp->next->random = temp->random->next;  // 设置复制节点的 random 指针
        }
        temp = temp->next->next;  // 移动到下一个原节点
    }

    // 第三步：分离原链表和复制链表
    temp = head;
    Node* headCopy = head->next;  // 复制链表的头节点
    while (temp != nullptr) {
        Node* tempCopy = temp->next;  // 获取复制节点
        temp->next = temp->next->next;  // 恢复原链表的 next 指针
        if (tempCopy->next != nullptr) {
            tempCopy->next = tempCopy->next->next;  // 设置复制节点的 next 指针
        }
        temp = temp->next;  // 移动到下一个原节点
    }

    return headCopy;  // 返回复制链表的头节点
}

int main() {
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);

    head->random = head->next->next; // 1 的 random 指针指向 3
    head->next->random = head; // 2 的 random 指针指向 1
    head->next->next->random = head->next; // 3 的 random 指针指向 2

    Node* copiedList1 = copyRandomList1(head);  // 使用方法1复制链表
    Node* copiedList2 = copyRandomList2(head);  // 使用方法2复制链表

    // 输出使用方法1复制的链表
    cout << "Copied List 1 (Method 1):" << endl;
    Node* temp = copiedList1;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    // 输出使用方法2复制的链表
    cout << "Copied List 2 (Method 2):" << endl;
    temp = copiedList2;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    return 0;
}
