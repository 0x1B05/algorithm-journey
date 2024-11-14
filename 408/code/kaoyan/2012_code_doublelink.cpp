#include<stdio.h>
#include<stdlib.h>

typedef struct node {
    char data;
    struct node* link;
}Node;

void create(Node* p, char a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (Node*)malloc(sizeof(Node));
        p->link->data = '\0';//用\0作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

Node* getSameNode(Node* a, Node* b) {
    int a_length = 0, b_length = 0;
    Node* a_p = a->link, * b_p = b->link;
    while (a_p->data != '\0') {//统计a的节点数
        a_length++;
        a_p = a_p->link;
    }
    while (b_p->data != '\0') {//统计b的节点数
        b_length++;
        b_p = b_p->link;
    }
    Node* a_scan = a->link, * b_scan = b->link;
    while (a_length < b_length) {//快指针先走
        b_scan = b_scan->link;
        b_length--;
    }
    while (b_length < a_length) {//快指针先走
        a_scan = a_scan->link;
        a_length--;
    }
    while (a_length-- > 0) {
        if (a_scan == b_scan) {
            return a_scan;
        }
        else {
            a_scan = a_scan->link;
            b_scan = b_scan->link;
        }
    }
    return NULL;
}

int main() {
    Node a, b;
    create(&a, "loading", 0, 7);
    create(&b, "being", 0, 5);
    Node* tmp = b.link->link->link;
    b.link->link = a.link->link->link->link;
    free(tmp);
    //两条交叉链构建完毕
    Node a_with_head, b_with_head;
    a_with_head.link = &a;
    b_with_head.link = &b;
    Node* same = getSameNode(&a_with_head, &b_with_head);
    return 0;
}
