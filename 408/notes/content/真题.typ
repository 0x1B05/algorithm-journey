#import "../template.typ": *
#pagebreak()

= 真题

#figure(caption: [2009])[
```c
#include<stdio.h>
#include<stdlib.h>

typedef struct node {
    int data;
    struct node* link;
}NODE;

void create(NODE* p, int a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (NODE*)malloc(sizeof(NODE));
        p->link->data = NULL;//用0作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

int getLastK(NODE* p, int k) {
    NODE* p_fast = p, * p_slow = p;
    while (--k && p_fast->link != NULL)p_fast = p_fast->link;
    p_fast = p_fast->link;
    while (p_fast->data) {
        p_slow = p_slow->link;
        p_fast = p_fast->link;
    }
    return p_slow->data;
}

int main() {
    NODE p;
    int a[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    create(&p, a, 0, 10);
    int ret = getLastK(&p, 7);
    return 0;
}
```
]

#pagebreak()
#figure(caption: [2010])[
```c
#include<stdio.h>
#include<stdlib.h>

void reverse(int a[], int start, int end) {
    //逆置start～end之间的所有数
    int i = 0;
    while (start + i < end - i) {
        int tmp = a[start + i];
        a[start + i] = a[end - i];
        a[end - i] = tmp;
        i++;
    }
}

void move(int a[], int p, int length) {
    reverse(a, 0, p - 1);
    reverse(a, p, length - 1);
    reverse(a, 0, length - 1);
}

int main() {
    int a[] = { 1,2,3,4,5,6,7,8,9,10 };
    move(a, 7, 10);
    return 0;
}
```
]

#pagebreak()
#figure(caption: [2011])[
```c
#include<stdio.h>
#include<stdlib.h>

typedef struct node {
    char data;
    struct node* link;
}NODE;

void create(NODE* p, char a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (NODE*)malloc(sizeof(NODE));
        p->link->data = '\0';//用\0作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

NODE* getSameNode(NODE* a, NODE* b) {
    int a_length = 0, b_length = 0;
    NODE* a_p = a->link, * b_p = b->link;
    while (a_p->data != '\0') {//统计a的节点数
        a_length++;
        a_p = a_p->link;
    }
    while (b_p->data != '\0') {//统计b的节点数
        b_length++;
        b_p = b_p->link;
    }
    NODE* a_scan = a->link, * b_scan = b->link;
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
    NODE a, b;
    create(&a, "loading", 0, 7);
    create(&b, "being", 0, 5);
    NODE* tmp = b.link->link->link;
    b.link->link = a.link->link->link->link;
    free(tmp);
    //两条交叉链构建完毕
    NODE a_with_head, b_with_head;
    a_with_head.link = &a;
    b_with_head.link = &b;
    NODE* same = getSameNode(&a_with_head, &b_with_head);
    return 0;
}
```
]

#pagebreak()
#figure(caption: [2012])[
```c
#include<stdio.h>
#include<stdlib.h>

typedef struct node {
    char data;
    struct node* link;
}NODE;

void create(NODE* p, char a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (NODE*)malloc(sizeof(NODE));
        p->link->data = '\0';//用\0作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

NODE* getSameNode(NODE* a, NODE* b) {
    int a_length = 0, b_length = 0;
    NODE* a_p = a->link, * b_p = b->link;
    while (a_p->data != '\0') {//统计a的节点数
        a_length++;
        a_p = a_p->link;
    }
    while (b_p->data != '\0') {//统计b的节点数
        b_length++;
        b_p = b_p->link;
    }
    NODE* a_scan = a->link, * b_scan = b->link;
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
    NODE a, b;
    create(&a, "loading", 0, 7);
    create(&b, "being", 0, 5);
    NODE* tmp = b.link->link->link;
    b.link->link = a.link->link->link->link;
    free(tmp);
    //两条交叉链构建完毕
    NODE a_with_head, b_with_head;
    a_with_head.link = &a;
    b_with_head.link = &b;
    NODE* same = getSameNode(&a_with_head, &b_with_head);
    return 0;
}
```
]

#pagebreak()
#figure(caption: [2013])[
```c
#include<stdio.h>
#include<stdlib.h>

int majority(int A[], int length) {
    int p = 0;
    int start = 0, count = 0;
    for (int j = 0;j < length;j++) {
        if (A[start] == A[j]) count++;
        else count--;
        if (count == 0 && j < length - 1) {
            start = ++j;
            count = 1;
        }
    }
    int mainElement = A[start];
    int countElement = 0;
    for (int j = 0;j < length;j++) {
        if (A[j] == mainElement)countElement++;
    }
    return countElement > length / 2 ? 1 : 0;
}

int main() {
    int A[] = { 1,1,0,0,0,1,1,1,0 };
    int isMajority = majority(A, 9);
    if (isMajority)printf("有主元素");
    else printf("没有主元素");
}
```
]
#pagebreak()
#figure(caption: [2014])[
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct treeNode {
    int weight;
    struct treeNode* left, * right;
}TNode;

/**
 * 创建二叉树
 */
void create(TNode* node, int c[], int pos, int length) {
    if (pos < length) {//填入数据
        node->weight = c[pos];
        if (pos * 2 + 1 < length) node->left = (TNode*)malloc(sizeof(TNode));
        if (pos * 2 + 2 < length) node->right = (TNode*)malloc(sizeof(TNode));
        create(node->left, c, pos * 2 + 1, length);
        create(node->right, c, pos * 2 + 2, length);
    }
}

int getWPL(TNode* root, int depth) {
    if (root != NULL) {
        int leftWeight = 0;
        int rightWeight = 0;
        if (root->left != NULL)leftWeight = getWPL(root->left, depth + 1);
        if (root->right != NULL)rightWeight = getWPL(root->right, depth + 1);
        return depth * root->weight + leftWeight + rightWeight;
    }
    else return 0;
}

int main() {
    TNode* t = (TNode*)malloc(sizeof(TNode));
    int c[] = { 54,4654,7565,234,436546,876876,353,757,2,345,23,445,1,235,0,6346 };
    create(t, c, 0, 16);
    int i = getWPL(t, 0);
    printf("%d", i);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2015])[
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct node {
    int data;
    struct node* link;
}NODE;

void create(NODE* p, int a[], int pos, int length) {
    if (pos < length) {
        p->data = a[pos];
        p->link = (NODE*)malloc(sizeof(NODE));
        p->link->data = INT_MIN;//用INT_MIN作为结束标志
        create(p->link, a, pos + 1, length);
    }
}

void deleteNode(NODE* p, int n, int length) {
    int* a = (int*)malloc(sizeof(int) * (n + 1));
    memset(a, 0, sizeof(int) * (n + 1));
    NODE* pHead = p, * q;
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
    NODE pStart;
    create(&pStart, a, 0, 10);
    deleteNode(&pStart, 100, 10);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2016])[
```c
#include <stdio.h>
#include <stdlib.h>
#include <cstring>

void printArr(int a[], int n) {
	for (int i = 0; i < n; i++) {
		printf("%d ", a[i]);
	}
}

int Partition(int A[], int low, int high) {
	//¿ìËÙÅÅÐò
	int pivot = A[low]; //Ñ¡È¡µÚÒ»¸ö×÷ÎªÊàÖá
	while (low < high) {
		while (low < high && A[high] >= pivot)
			high--;
		A[low] = A[high];
		while (low < high && A[low] <= pivot)
			low++;
		A[high] = A[low];
	}
	A[low] = pivot;
	return low;
}
void QuickDivideSort(int A[], int low, int high, int n) {
	if (low < high) {
		int pivot = Partition(A, low, high);
		if (pivot < n / 2)//»®·Ö³ön/2µÄÎ»ÖÃ
			QuickDivideSort(A, pivot + 1, high, n);
		else
			QuickDivideSort(A, low, pivot - 1, n);
	}
}

int main() {
	int sort[] = { 2, 3, 3, 5, 6, 7, 1, 1, 1, 1, 1 };
	int n = sizeof(sort) / 4;
	QuickDivideSort(sort, 0, n - 1, n);
	printArr(sort, 11);
	return 0;
}
```
]
#pagebreak()
#figure(caption: [2017])[
```c
#include<stdio.h>
#include <stdlib.h>

typedef struct node {
    char data[10];
    struct node* left, * right;
}BTree;

void midQuation(BTree* T) {
    if (T != NULL && T->data[0] != '@') {
        char t = T->data[0];
        bool flag = false;
        flag = (t == '+' || t == '-' || t == '*' || t == '/');
        if (flag)printf("(");
        if (T->left != NULL)midQuation(T->left);//左子树递归
        printf("%c", T->data[0]);//打印当前节点
        if (T->right != NULL)midQuation(T->right);//右子树递归
        if (flag)printf(")");
    }
}

/**
 * 创建二叉树
 */
void createTree(BTree* node, char c[], int pos, int length) {
    if (pos < length) {//填入数据
        node->data[0] = c[pos];
        node->data[1] = '\0';
        node->left = (BTree*)malloc(sizeof(BTree));
        node->right = (BTree*)malloc(sizeof(BTree));
        createTree(node->left, c, pos * 2 + 1, length);
        createTree(node->right, c, pos * 2 + 2, length);
    }
}

int main() {
    BTree* a = (BTree*)malloc(sizeof(BTree));
    // createTree(a, "*+*abc-@@@@@@@d@@@@@@@@@@@@@@@@", 0, 31);//用@表示空节点
    createTree(a, "+*-ab@-@@@@@@cd@@@@@@@@@@@@@@@@", 0, 31);//用@表示空节点
    midQuation(a);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2018])[
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void min_integer(int a[], int n) {
    int* tmp = (int*)malloc(4 * n);//动态分配数组空间
    memset(tmp, 0, n * 4);//空间置0
    int i;
    for (i = 0;i < n;i++) {
        if (a[i] <= n && a[i] > 0) {
            tmp[a[i] - 1] = 1;//将对应map位的元素置为1
        }
    }
    for (i = 0;i < n;i++) {//遍历得到第一个缺失的正整数
        if (tmp[i] == 0)break;
    }
    printf("%d", i + 1);
}

int main() {
    int a[] = { -5,3,2,3 };
    min_integer(a, sizeof(a) / 4);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2019])[
```c
#include<stdio.h>
#include<stdlib.h>

typedef struct node {
    int data;
    struct node* next;
} NODE;

//通过数组创建链表
void create(node* n, int length, int pos, int data[]) {
    if (pos < length) {
        n->data = data[pos];//赋给struct中的data
        node* next = (node*)malloc(sizeof(node));//动态分配下一个节点地址
        n->next = next;//对下一个节点采用递归构建
        create(n->next, length, pos + 1, data);//递归，pos位置+1
    }
    else {
        n->data = -1;//最后一个节点使用-1作为标识
    }
}

void cross_sort(node* n, int length) {
    //对后半部分就地逆置
    node* mid = n;
    node* start = n;
    int i;
    for (i = 0;i < length / 2;i++)mid = mid->next;//找到中间节点
    //从中间开始逆置链表
    node* s, * t;
    s = mid->next;
    mid->next = NULL;
    while (s->data != -1) {
        //将s节点摘下来
        t = s;
        s = s->next;
        //将摘下来的节点头插到mid节点之后
        t->next = mid->next;
        mid->next = t;
    }
    node* tmp = mid;
    mid = mid->next;//后移
    tmp->next = NULL;
    i++;
    while (i++ < length && mid != NULL) {
        node* p, * q;
        //使用p、q暂存start和mid节点
        p = start->next;
        q = mid->next;
        //将mid指针所指节点单独摘下来，注意：要将尾巴(next)甩掉，不然结果不对
        mid->next = NULL;
        //插到start节点后面
        start->next = mid;
        mid->next = p;
        //同时移动start和end指针
        start = p;
        mid = q;
    }
    mid = NULL;
}

int main() {
    node* a = (node*)malloc(sizeof(node));
    int d[] = { 1,2,3,4,5,6,7,8 };
    create(a, 8, 0, d);
    cross_sort(a, 8);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2020])[
```c
#include<stdio.h>
#include<stdlib.h>

//获取三个数的绝对值距离
int getDis(int a, int b, int c) {
    int ab = (a - b) > 0 ? (a - b) : (b - a);
    int bc = (b - c) > 0 ? (b - c) : (c - b);
    int ac = (a - c) > 0 ? (a - c) : (c - a);
    if (ab >= bc && ab >= ac)return ab * 2;
    if (bc >= ab && bc >= ac)return bc * 2;
    if (ac >= ab && ac >= bc)return ac * 2;
}

//获取三个数中的最小值
int getMin(int a, int b, int c) {
    if (a <= b && a <= c)return 0;
    if (b <= c && b <= a)return 1;
    if (c <= a && c <= b)return 2;
}

void getAbsDis(int s1[], int s2[], int s3[], int l1, int l2, int l3) {
    int min = INT_MAX;
    int p1 = 0, p2 = 0, p3 = 0;
    while (p1 < l1 && p2 < l2 && p3 < l3) {
        int a = s1[p1], b = s2[p2], c = s3[p3];
        if (min > getDis(a, b, c)) {
            min = getDis(a, b, c);
        }
        int flag = getMin(a, b, c);
        if (flag == 0)p1++;
        if (flag == 1)p2++;
        if (flag == 2)p3++;
    }
    printf("最小值为:%d", min);
}

int main() {
    int s1[] = { -1,0,9 };
    int s2[] = { -25,-10,9,11 };
    int s3[] = { 2,9,17,30,41 };
    getAbsDis(s1, s2, s3, 3, 4, 5);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2021])[
```c
#include <stdio.h>
#include <stdlib.h>
#define MAXV 5
typedef struct {
    int numVertices, numEdges;
    char VerticesList[MAXV];
    int Edge[MAXV][MAXV];
}MGraph;
int IsExistEL(MGraph G) {
    int oddCount = 0;
    for (int i = 0;i < G.numVertices;i++) {
        int tmpOdd = 0;
        for (int j = 0;j < G.numVertices;j++) {//遍历每一行，将个数统计出来
            tmpOdd += G.Edge[i][j];
        }
        if (tmpOdd % 2 == 1) {//如果个数是奇数，就将oddCount+1
            oddCount++;
            if (oddCount > 2) {
                return 0;
            }
        }
    }
    if (oddCount == 0 || oddCount == 2)return 1;
    else return 0;
}
void setG(MGraph* g, int a[]) {
    for (int i = 0;i < MAXV * MAXV;i++) {
        g->Edge[i / 5][i % 5] = a[i];
    }
}
int main() {
    MGraph G;
    G.numVertices = 5;
    int a[] = {
        1,1,0,0,1,//
        1,0,1,0,1,//
        0,1,0,1,1,//
        0,0,1,0,1,//
        0,0,0,1,0,//
    };
    setG(&G, a);
    int i = IsExistEL(G);
    printf("%d", i);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2022])[
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MaxSize 100

typedef struct {
    int Sqlistdata[MaxSize];
    int num;
} Sqlist;

bool T = true;
void inorder(Sqlist a, int i) {
    if (i >= a.num || a.Sqlistdata[i] == -1 || !T) {
        return;
    }
    int k = a.Sqlistdata[i];
    inorder(a, i * 2 + 1);
    if (k < a.Sqlistdata[i * 2 + 1]) {
        T = false;
        return;
    }
    inorder(a, i * 2 + 2);
}

int main() {
    Sqlist s = Sqlist();
    int a[] = {4, 2, 6, 1, 3, 5, 7};  //高度为3的满二叉排序树
    s.num = 7;
    for (int i = 0; i < s.num; i++) {
        s.Sqlistdata[i] = a[i];
    }
    inorder(s, 0);
    printf(T ? "是二叉搜索树" : "不是二叉搜索树");
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2023])[
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXV 4

typedef struct {                // 图的定义
    int numVertices, numEdges;  // 图中实际的顶点数和边数
    char VerticesList[MAXV];    // 顶点表，MAXV为已定义常量
    int Edge[MAXV][MAXV];       // 邻接矩阵
} MGraph;

int printVertices(MGraph* G) {
    int count = 0, indegree = 0, outdegree = 0;
    // 遍历无向图统计所有点的出度和入度
    for (int i = 0; i < G->numVertices; i++) {
        indegree = 0;   // i的入度
        outdegree = 0;  // i的出度
        for (int j = 0; j < G->numVertices; j++) {
            outdegree += G->Edge[i][j];
            indegree += G->Edge[j][i];
        }
        if (outdegree > indegree) {
            printf("K顶点的个数为：%d\n", i);
            count++;
        }
    }
    return count;
}

int main() {
    MGraph* m = new MGraph();
    m->numVertices = 4;
    m->numEdges = 5;
    for (int i = 0; i < 4; i++) {
        m->VerticesList[i] = 'a' + i;
    }
    /**
     * m->Edge
     * [0,1,0,1]
     * [0,0,1,1]
     * [0,0,0,1]
     * [0,0,0,0]
    */
    m->Edge[0][1] = 1;
    m->Edge[0][3] = 1;
    m->Edge[1][2] = 1;
    m->Edge[1][3] = 1;
    m->Edge[2][3] = 1;
    printVertices(m);
    return 0;
}
```
]
#pagebreak()
#figure(caption: [2024])[
```c
#include <iostream>
#include <queue>
#include <vector>

#define MAXV 100 // 假设最大顶点数为100

typedef struct {
    int numberVertices, numberEdges; // 图的顶点数和边数
    char VerticesList[MAXV];         // 顶点表
    int edge[MAXV][MAXV];            // 邻接矩阵
} MGraph;

// 判断图是否有唯一的拓扑序列
int intquely(MGraph G) {
    std::vector<int> inDegree(G.numberVertices, 0);
    std::queue<int> q;

    // 计算每个顶点的入度
    for (int i = 0; i < G.numberVertices; ++i) {
        for (int j = 0; j < G.numberVertices; ++j) {
            if (G.edge[i][j] != 0) {
                inDegree[j]++;
            }
        }
    }

    // 找到所有入度为0的顶点并加入队列
    for (int i = 0; i < G.numberVertices; ++i) {
        if (inDegree[i] == 0) {
            q.push(i);
        }
    }

    std::vector<int> topoOrder;

    while (!q.empty()) {
        if (q.size() > 1) { // 入度为0的顶点不唯一
            return 0;
        }
        
        int v = q.front();
        q.pop();
        topoOrder.push_back(v);

        for (int i = 0; i < G.numberVertices; ++i) {
            if (G.edge[v][i] != 0) {
                inDegree[i]--;
                if (inDegree[i] == 0) {
                    q.push(i);
                }
            }
        }
    }

    // 若拓扑排序包含了所有顶点，则说明图有唯一的拓扑序列
    return (topoOrder.size() == G.numberVertices) ? 1 : 0;
}
```
]
