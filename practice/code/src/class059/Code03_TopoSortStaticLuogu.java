package class059;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

/**
 * Code03_TopoSortStaticLuogu
 */
public class Code03_TopoSortStaticLuogu {
    public static int MAXN = 100001;
    public static int MAXM = 100001;
    public static int n, m;

    public static int cnt;
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];

    // 入度
    public static int[] indegree = new int[MAXN];
    // 小根堆来控制大小
    public static int[] heap = new int[MAXN];
    public static int heapSize;
    // 拓扑排序的结果
    public static int[] ans = new int[MAXN];

    // 小根堆里加入数字
    public static void push(int num) {
        int cur = heapSize++;
        heap[i] = num;
        // heapInsert
        while (heap[i] < heap[(i - 1) / 2]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }
    // 小根堆里弹出最小值
    public static int pop() {
        int ret = heap[0];
        heap[0] = heap[--heapSize];
        // heapify
        int cur = 0;
        int left = 2 * cur + 1;
        int right = left + 1;
        while (left < heapSize) {
            int min = Math.min(heap[cur], Math.min(heap[left], heap[right]));

            if (min = heap[cur]) {
                break;
            } else if (min == heap[left]) {
                swap(cur, left);
                cur = left;
            } else if (min == heap[right]) {
                swap(cur, right);
                cur = right;
            }
            left = 2 * cur + 1;
            right = left + 1;
        }

        return ret;
    }

    // 判断小根堆是否为空
    public static boolean isEmpty() {
        return heapSize == 0;
    }

    // 交换堆上两个位置的数字
    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static void init() {
        cnt = 1;
        heapSize = 0;
        Arrays.fill(head, 0, n + 1, 0);
        Arrays.fill(indegree, 0, n + 1, 0);
    }
    public static void addEdge(int f, int t) {
        next[cnt] = head[f];
        to[cnt] = t;
        indegree[t]++;
        head[f] = cnt++;
    }
    public static boolean topSort() {
        int l = 0, r = 0;
        boolean ans = true;
        for (int i = 1; i <= n; i++) {
            if (indegree[i] == 0) {
                // 这里应该用小根堆
                // queue[r++] = i;
            }
        }
        int cnt = 0;
        while (l < r) {
        }
        return ans;
    }
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            init();
            m = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < m; i++) {
                int f = (int) in.nval;
                in.nextToken();
                int t = (int) in.nval;
                in.nextToken();
                addEdge(f, t);
            }
            if (topSort()) {
                for (int i = 0; i < n - 1; i++) {
                    System.out.print(queue[i] + " ");
                }
                out.println(queue[n - 1]);
            }
        }
        out.flush();
        out.close();
        br.close();
    }
}
