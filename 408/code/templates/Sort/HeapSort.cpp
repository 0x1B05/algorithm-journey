#include <vector>
#include <iostream>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &nums, int i, int j) {
    // 如果两个位置的元素相等，直接返回
    if (nums[i] == nums[j]) {
        return;
    }
    // 使用异或运算交换元素的值
    nums[i] = nums[i] ^ nums[j];
    nums[j] = nums[i] ^ nums[j];
    nums[i] = nums[i] ^ nums[j];
}

// 堆化函数，用于将 `index` 位置的元素下沉，保持子树为大根堆
void heapify(vector<int> &nums, int index, int heapSize) {
    int parent = index;
    int left = 2 * parent + 1;  // 左孩子下标
    int right = 2 * parent + 2; // 右孩子下标

    // 当左孩子在堆范围内时，继续调整
    while (left < heapSize) {
        // 找到左、右孩子中较大的那个
        int largerChild = (right < heapSize && nums[right] > nums[left]) ? right : left;
        // 在父节点和较大孩子中找出更大的那个
        int max = (nums[largerChild] > nums[parent]) ? largerChild : parent;

        // 如果最大值是父节点，则结束调整
        if (max == parent) {
            break;
        }

        // 否则交换父节点和较大孩子的位置
        swap(nums, parent, max);
        parent = max;
        left = 2 * parent + 1;
        right = 2 * parent + 2;
    }
}

// 堆插入函数，用于在堆的末尾插入一个元素并向上调整
void heapInsert(vector<int> &nums, int index) {
    int parent = (index - 1) / 2;

    // 当插入的元素比父节点大时，交换两者并继续向上调整
    while (index > 0 && nums[index] > nums[parent]) {
        swap(nums, index, parent);
        index = parent;
        parent = (index - 1) / 2;
    }
}

// 堆排序主函数
void heapSort(vector<int> &nums) {
    int len = nums.size();

    // 如果数组为空或者长度小于2，直接返回
    if (nums.empty() || len < 2) {
        return;
    }

    // 堆化：使用 `heapify` 方法对数组进行堆化
    for (int i = len - 1; i >= 0; i--) {
        heapify(nums, i, len);
    }

    int heapSize = len;

    // 进行排序：将最大元素放到数组末尾，并调整剩余元素为大根堆
    for (int i = 0; i < len; i++) {
        swap(nums, 0, --heapSize); // 将堆顶（最大值）放到数组末尾
        heapify(nums, 0, heapSize); // 调整剩余部分为大根堆
    }
}

// 主函数
int main() {
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    heapSort(arr);

    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
