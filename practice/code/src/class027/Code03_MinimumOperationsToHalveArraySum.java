package class027;

import java.util.PriorityQueue;

/**
 * Code03_MinimumOperationsToHalveArraySum
 */
public class Code03_MinimumOperationsToHalveArraySum {
    public static int halveArray(int[] nums) {
        PriorityQueue<Double> heap = new PriorityQueue<>((a, b) -> b.compareTo(a));
        double sum = 0;
        for (int i = 0; i < nums.length; i++) {
            heap.add((double) nums[i]);
            sum += nums[i];
        }
        double target = sum / 2;

        int ans = 0;
        double cur = 0;
        for (double minus = 0; minus < target; minus += cur) {
            cur = heap.poll() / 2;
            heap.add(cur);
            ans++;
        }
        return ans;
    }

    public static int MAXN = 100001;

    public static long[] heap = new long[MAXN];

    public static int size;

    public static int halveArray2(int[] nums) {
        size = nums.length;
        long sum = 0;
        for (int i = size - 1; i >= 0; i--) {
            heap[i] = (long) nums[i] << 20;
            sum += heap[i];
            heapify(i);
        }
        sum /= 2;
        int ans = 0;
        for (long minus = 0; minus < sum; ans++) {
            heap[0] /= 2;
            minus += heap[0];
            heapify(0);
        }
        return ans;
    }

    public static void heapify(int i) {
        int l = i * 2 + 1;
        while (l < size) {
            int best = l + 1 < size && heap[l + 1] > heap[l] ? l + 1 : l;
            best = heap[best] > heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(best, i);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static void swap(int i, int j) {
        long tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }
}
