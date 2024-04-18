package class025;

/**
 * Code02_HeapSort
 */
public class Code02_HeapSort {
    // i位置的数，变小了，又想维持大根堆结构
    // 向下调整大根堆
    // 当前堆的大小为size
    public static void heapify(int[] nums, int cur, int size) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int maxChild = right < size && nums[right] > nums[left] ? right : left;
            int max = nums[maxChild] > nums[cur] ? maxChild : cur;
            if (max == cur) {
                break;
            } else {
                swap(nums, max, cur);
                cur = max;
                left = 2 * cur + 1;
            }
        }
    }

    // i位置的数，变大了，又想维持大根堆结构
    // 向上调整大根堆
    public static void heapInsert(int[] nums, int cur) {
        int parent = (cur - 1) / 2;

        while (nums[cur] > nums[parent]) {
            swap(nums, cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    // 从顶到底建立大根堆，O(n * logn)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort1(int[] nums) {
        int n = nums.length;
        // 每个节点向上移动形成大根堆
        for (int i = 0; i < n; i++) {
            heapInsert(nums, i);
        }

        int size = n;
        while (size > 1) {
            swap(nums, 0, --size);
            heapify(nums, 0, size);
        }
    }

    // 从底到顶建立大根堆，O(n)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort2(int[] nums) {
        int n = nums.length;
        for (int cur = n - 1; cur >= 0; cur--) {
            heapify(nums, cur, n);
        }
        int size = n;
        while (size > 1) {
            swap(nums, 0, --size);
            heapify(nums, 0, size);
        }
    }
    public static void swap(int[] nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }

    public static int[] sortArray(int[] nums) {
        if (nums.length > 1) {
            // heapSort1为从顶到底建堆然后排序
            // heapSort2为从底到顶建堆然后排序
            // 用哪个都可以
            // heapSort1(nums);
            heapSort2(nums);
        }
        return nums;
    }
}
