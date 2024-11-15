#include <iostream>
#include <algorithm>

using namespace std;

const int MAXN = 10001;
int line[MAXN][2];
int heap[MAXN];
int heapSize = 0;

void heapInsert(int cur) {
    int parent = (cur - 1) / 2;
    while (heap[cur] < heap[parent]) {
        swap(heap[cur], heap[parent]);
        cur = parent;
        parent = (cur - 1) / 2;
    }
}

void swap(int i, int j) {
    int tmp = heap[i];
    heap[i] = heap[j];
    heap[j] = tmp;
}

void heapify(int cur) {
    int left = 2 * cur + 1;
    while (left < heapSize) {
        int right = left + 1;
        int minChild = (right < heapSize && heap[right] < heap[left]) ? right : left;
        int min = (heap[minChild] < heap[cur]) ? minChild : cur;
        if (min == cur) {
            break;
        } else {
            swap(cur, min);
            cur = min;
            left = 2 * cur + 1;
        }
    }
}

void add(int num) {
    int cur = heapSize++;
    heap[cur] = num;
    heapInsert(cur);
}

void pop() {
    swap(0, --heapSize);
    heapify(0);
}

int compute(int n) {
    int max = 0;
    sort(line, line + n, [](const int a[2], const int b[2]) {
        return a[0] - b[0];
    });

    for (int i = 0; i < n; i++) {
        while (heapSize > 0 && heap[0] <= line[i][0]) pop();
        add(line[i][1]);
        max = max > heapSize ? max : heapSize;
    }

    return max;
}


int main() {
    int n = 5; // Sample input
    // Example input for `line` array
    line[0][0] = 1; line[0][1] = 5;
    line[1][0] = 2; line[1][1] = 6;
    line[2][0] = 3; line[2][1] = 7;
    line[3][0] = 4; line[3][1] = 8;
    line[4][0] = 5; line[4][1] = 9;

    int result = compute(n);
    cout << "Max cover: " << result << endl;

    return 0;
}
