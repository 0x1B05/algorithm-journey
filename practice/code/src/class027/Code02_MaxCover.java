package class027;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;
import java.util.PriorityQueue;

public class Code02_MaxCover {
    public static int MAXN = 10001;
    public static int n;
    public static int[][] line = new int[MAXN][2];

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                line[i][0] = (int) in.nval;
                in.nextToken();
                line[i][1] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int[] heap = new int[MAXN];
    public static int size = 0;

    public static void heapInsert(int cur) {
        int parent = (cur - 1) / 2;
        while (heap[cur] < heap[parent]) {
            swap(cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static void heapify(int cur) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int minChild = right < size && heap[right] < heap[left] ? right : left;
            int min = heap[minChild] < heap[cur] ? minChild : cur;
            if (min == cur) {
                break;
            } else {
                swap(cur, min);
                cur = min;
                left = 2 * cur + 1;
            }
        }
    }
    public static void add(int num) {
        int cur = size++;
        heap[cur] = num;
        heapInsert(cur);
    }

    public static void pop() {
        swap(0, --size);
        heapify(0);
    }

    public static int compute() {
        int max = 0;
        Arrays.sort(line, 0, n, (a, b) -> a[0] - b[0]);

        for (int i = 0; i < n; i++) {
            while (size > 0 && heap[0] <= line[i][0]) pop();
            add(line[i][1]);
            max = Math.max(max, size);
        }

        return max;
    }
}
