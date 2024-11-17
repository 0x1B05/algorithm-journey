#include <iostream>
#include <stack>

using namespace std;

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

// 方法 1：使用栈存储所有元素，并与原链表进行比较
// 时间复杂度：O(n)，空间复杂度：O(n)
bool isPalindrome1(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;  // 空链表或只有一个节点的链表，直接返回 true
    }

    stack<Node*> stack;
    Node* cur = head;

    // 将所有节点压入栈中
    while (cur != nullptr) {
        stack.push(cur);
        cur = cur->next;
    }

    // 从栈中弹出元素并与链表进行比较
    while (head != nullptr) {
        if (head->value != stack.top()->value) {
            return false;  // 如果发现不相等，返回 false
        }
        stack.pop();
        head = head->next;
    }

    return true;  // 如果遍历完都没有发现不同，返回 true
}

// 方法2: 用栈只存储链表一半的元素（中间位置到最后）,最后依次弹出并与链表的前半部分比较
// 时间复杂度：O(n)，空间复杂度：O(n/2)
bool isPalindrome2(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;  // 空链表或只有一个节点的链表，直接返回 true
    }

    // 用快慢指针来确定中间位置
    // 快指针一次走两步,慢指针一次走一步
    // 快指针走完时,慢指针刚好来到右部分第一个节点上
    Node* slow = head; // 慢指针,若元素个数为偶数时,最后指向中间位置的后一个位置
    Node* fast = head; // 快指针

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // 把从慢指针即中间位置开始的右部分元素放进栈中
    stack<Node*> stack;
    while (slow != nullptr) {
        stack.push(slow);
        slow = slow->next;
    }

    // 从栈中弹出元素并与链表前半部分进行比较
    while (!stack.empty()) {
        if (head->value != stack.top()->value) {
            return false;  // 如果发现不相等，返回 false
        }
        stack.pop();
        head = head->next;
    }

    return true;  // 如果遍历完都没有发现不同，返回 true
}

// 方法 3：将链表对折,后半部分的链表反转与前半部分链表进行比较
// 时间复杂度：O(n)，空间复杂度：O(1)
Node* reverseList(Node* head) {
    Node* prev = nullptr;
    Node* cur = head;

    // 反转链表
    while (cur != nullptr) {
        // 存储原来next节点
        Node* next = cur->next;
        // next节点指向上一个节点
        cur->next = prev;
        // 下一个节点的上一个节点就是当前节点
        prev = cur;
        // 向后推进一个节点
        cur = next;
    }

    return prev;  // 返回反转后的链表头
}

bool isPalindrome3(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;  // 空链表或只有一个节点的链表，直接返回 true
    }

    Node* slow = head;
    Node* fast = head;

    // 元素总个数为奇数时,慢指针最后指向中间位置,若为偶数,则走到中间位置的前一位
    // 注意: 在向后遍历的时候,需要判断快指针指向的节点是否为空,不然会出现异常
    // 若quick.next != null,那么说明这是偶数个,quick.next.next != null,说明是奇数个
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // slow来的中点位置,反转后半部分,反转后中点指向null
    Node* secondHalf = reverseList(slow);
    Node* firstHalf = head;

    // 将前半部分和后半部分进行对比
    // 前半部分从cur即head开始,后半部分从quick即end开始
    while (secondHalf != nullptr) {
        if (firstHalf->value != secondHalf->value) {
            return false;  // 如果发现不相等，返回 false
        }
        firstHalf = firstHalf->next;
        secondHalf = secondHalf->next;
    }

    // 不能改变原有的数据结构,所以还要把后半部分反转回去
    // 遍历完cur来到中间位置,接上反转回来的后半部分头节点
    slow = reverseSingleList(secondHalf);
    return true;  // 如果遍历完都没有发现不同，返回 true
}

// 辅助函数：打印链表（用于测试）
void printList(Node* head) {
    while (head != nullptr) {
        cout << head->value << " ";
        head = head->next;
    }
    cout << endl;
}

int main() {
    // 创建一个示例链表：1 -> 2 -> 3 -> 2 -> 1
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(2);
    head->next->next->next->next = new Node(1);

    cout << "Is Palindrome (Method 1): " << isPalindrome1(head) << endl;
    cout << "Is Palindrome (Method 2): " << isPalindrome2(head) << endl;
    cout << "Is Palindrome (Method 3): " << isPalindrome3(head) << endl;

    return 0;
}
