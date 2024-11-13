#include <vector>
using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

// 选择排序
void selectSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 遍历数组，i表示当前选择的起始位置
    for (int i = 0; i < len - 1; i++) {
        int minIndex = i; // 假设当前起始位置的元素为最小值
        // 找到从i到数组末尾的最小值的下标
        for (int j = i + 1; j < len; j++) {
            if (arr[j] < arr[minIndex]) { // 如果找到比当前最小值还小的元素
                minIndex = j; // 更新最小值的下标
            }
        }
        // 将最小值放到当前起始位置
        swap(arr, i, minIndex);
    }
}

// 冒泡排序
void bubbleSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 外层循环控制需要排序的趟数，i表示当前比较的最后一个位置
    for (int i = len - 1; i > 0; i--) {
        // 内层循环进行相邻元素的比较和交换
        for (int j = 0; j < i; j++) {
            if (arr[j] > arr[j + 1]) { // 如果前一个元素大于后一个元素
                swap(arr, j, j + 1); // 交换这两个元素的位置
            }
        }
    }
}

// 插入排序
void insertSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 外层循环，i表示当前要插入的元素下标
    for (int i = 0; i < len - 1; i++) {
        // 内层循环，将当前元素插入到前面有序部分的正确位置
        for (int j = i + 1; j > 0 && arr[j - 1] > arr[j]; j--) {
            swap(arr, j, j - 1); // 如果前一个元素大于当前元素，交换位置
        }
    }
}
