#include <vector>
#include <iostream>

using namespace std;

// 合并函数，用于将两个有序部分合并为一个有序数组
void merge(vector<int> &arr, int L, int M, int R) {
    // 创建一个临时数组用于存放合并后的结果
    vector<int> container(R - L + 1);
    int i = 0;
    int p1 = L, p2 = M + 1; // p1指向左半部分的起始，p2指向右半部分的起始

    // 当左右两部分都有剩余元素时，进行比较并放入容器
    while (p1 <= M && p2 <= R) {
        // 将较小的元素放入容器，并移动指针
        container[i++] = (arr[p1] <= arr[p2]) ? arr[p1++] : arr[p2++];
    }

    // 如果左半部分还有剩余元素，直接加入容器
    while (p1 <= M) {
        container[i++] = arr[p1++];
    }

    // 如果右半部分还有剩余元素，直接加入容器
    while (p2 <= R) {
        container[i++] = arr[p2++];
    }

    // 将容器中的元素复制回原数组相应位置
    for (i = 0; i < container.size(); i++) {
        arr[L + i] = container[i];
    }
}

// 递归处理函数，用于将数组分割并排序
void process(vector<int> &arr, int L, int R) {
    // 当左右边界相等时，不需要继续分割
    if (L == R) {
        return;
    }
    // 计算中间位置，避免直接加法导致的溢出
    int mid = L + ((R - L) >> 1);
    // 对左半部分进行递归排序
    process(arr, L, mid);
    // 对右半部分进行递归排序
    process(arr, mid + 1, R);
    // 合并已经排好序的左右两部分
    merge(arr, L, mid, R);
}

// 归并排序
void mergeSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 调用递归排序处理函数，初始范围为整个数组
    process(arr, 0, len - 1);
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    mergeSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
