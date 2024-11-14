#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    int data;
    struct node* link;
}Node;

void create(Node* p, int a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (Node*)malloc(sizeof(Node));
        p->link->data = INT_MIN;//用INT_MIN作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

void deleteNode(Node* p, int n, int length) {
    int* a = (int*)malloc(sizeof(int) * (n + 1));
    memset(a, 0, sizeof(int) * (n + 1));
    Node* pHead = p, * q;
    a[p->data > 0 ? p->data : -p->data] = 1;
    while (p->link != NULL && p->link->data != INT_MIN) {
        int t = (p->link->data) > 0 ? p->link->data : -p->link->data;
        if (a[t] == 1) {
            q = p->link;
            p->link = q->link;
            free(q);
        }
        else {
            a[t] = 1;
            p = p->link;
        }
    }
}

int main() {
    int a[] = { -5,5,9,17,5,5,5,-3,2,5 };
    Node pStart;
    create(&pStart, a, 0, 10);
    deleteNode(&pStart, 100, 10);
    return 0;
}
