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
        heap[cur] = num;
        // heapInsert
        while (heap[cur] < heap[(cur - 1) / 2]) {
            swap(cur, (cur - 1) / 2);
            cur = (cur - 1) / 2;
        }
    }
    // 小根堆里弹出最小值
    public static int pop() {
        int ret = heap[0];
        heap[0] = heap[--heapSize];
        // heapify
        int cur = 0;
        int left = 2 * cur + 1;
        while (left < heapSize) {
            int right = left + 1;
            int minChild = right < heapSize && heap[left] > heap[right] ? right : left;
            int min = heap[minChild] < heap[cur] ? minChild : cur;
            if (min == cur) {
                break;
            } else {
                swap(minChild, cur);
                cur = minChild;
                left = 2 * cur + 1;
            }
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

    public static void topSort() {
        for (int i = 1; i <= n; i++) {
            if (indegree[i] == 0) {
                push(i);
            }
        }
        int fill = 0;
        while (!isEmpty()) {
            int cur = pop();
            ans[fill++] = cur;
            for (int ei = head[cur]; ei != 0; ei = next[ei]) {
                if (--indegree[to[ei]] == 0) {
                    push(to[ei]);
                }
            }
        }
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
            topSort();
            for (int i = 0; i < n - 1; i++) {
                System.out.print(ans[i] + " ");
            }
            out.println(ans[n - 1]);
        }
        out.flush();
        out.close();
        br.close();
    }
}
