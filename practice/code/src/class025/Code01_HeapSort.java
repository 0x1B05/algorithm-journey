package class025;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
/**
 * Code01_HeapSort
 */
public class Code01_HeapSort {
    public static int MAXN = 100001;
    public static int[] nums = new int[MAXN];
    public static int n;

    // i位置的数，变大了，又想维持大根堆结构
    // 向上调整大根堆
    public static void heapInsert(int cur) {
        int parent = (cur - 1) / 2;
        while (nums[cur] > nums[parent]) {
            swap(cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    // i位置的数，变小了，又想维持大根堆结构
    // 向下调整大根堆
    // 当前堆的大小为size
    public static void heapify(int cur, int size) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int maxChild = right < size && nums[right] > nums[left] ? right : left;
            int max = nums[maxChild] > nums[cur] ? maxChild : cur;
            if (max == cur) {
                break;
            } else {
                swap(max, cur);
                cur = max;
                left = 2 * cur + 1;
            }
        }
    }

    // 从顶到底建立大根堆，O(n * logn)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort1() {
        // 每个节点向上移动形成大根堆
        for (int cur = 1; cur < n; cur++) {
            heapInsert(cur);
        }
        int size = n;
        while (size > 0) {
            swap(0, --size);
            heapify(0, size);
        }
    }

    // 从底到顶建立大根堆，O(n)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort2() {
        for (int cur = n - 1; cur >= 0; cur--) {
            heapify(cur, n);
        }
        int size = n;
        while (size > 1) {
            swap(0, --size);
            heapify(0, size);
        }
    }

    public static void swap(int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        n = (int) in.nval;
        for (int i = 0; i < n; i++) {
            in.nextToken();
            nums[i] = (int) in.nval;
        }
        // heapSort1();
        heapSort2();
        for (int i = 0; i < n - 1; i++) {
            out.print(nums[i] + " ");
        }
        out.println(nums[n - 1]);
        out.flush();
        out.close();
        br.close();
    }
}
