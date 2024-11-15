#include <iostream>
#include <vector>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &arr, int i, int j) {
    // 如果两个位置的元素相等，直接返回
    if (arr[i] == arr[j]) {
        return;
    }
    // 使用异或运算交换元素的值
    arr[i] = arr[i] ^ arr[j];
    arr[j] = arr[i] ^ arr[j];
    arr[i] = arr[i] ^ arr[j];
}

// 递归处理函数，用于进行分区和排序
void process(vector<int> &arr, int l, int r) {
    // 当左边界大于等于右边界时，递归终止
    if (l >= r) {
        return;
    }
    // 随机选择一个位置的元素作为基准，并与最后一个元素交换
    swap(arr, l + rand() % (r - l + 1), r); // 利用随机数避免最坏情况
    int less = l - 1;     // `less` 指向小于基准元素区域的右边界
    int more = r + 1;     // `more` 指向大于基准元素区域的左边界
    int num = arr[r];     // 选择最右边的元素作为基准
    int p = l;            // `p` 为当前遍历指针

    // 遍历数组，进行分区操作
    while (p < more) {
        if (arr[p] < num) {
            // 当前元素小于基准，放入`less`区，并右移`less`和`p`
            swap(arr, ++less, p++);
        } else if (arr[p] > num) {
            // 当前元素大于基准，放入`more`区，左移`more`，但`p`位置不变，重新检查
            swap(arr, --more, p);
        } else {
            // 当前元素等于基准，直接移动`p`
            p++;
        }
    }

    // 递归处理左半部分和右半部分
    process(arr, l, less);
    process(arr, more, r);
}

// 快速排序主函数
void quickSort(vector<int> &arr) {
    // 调用递归处理函数，对整个数组进行排序
    process(arr, 0, arr.size() - 1);
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
    quickSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
