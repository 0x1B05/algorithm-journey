package class056;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

/**
 * Code01_UnionFindNowCoder
 */
public class Code01_UnionFindNowCoder {
    public static int MAXN = 1000001;

    // 数组下标代表元素，数据代表所属集合
    public static int father[] = new int[MAXN];
    public static int size[] = new int[MAXN];
    public static int stack[] = new int[MAXN];

    public static int N;
    public static int M;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            N = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < N; i++) {
                father[i] = i;
            }

            M = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < M; i++) {
                int opt = (int) in.nval;
                in.nextToken();
                int x = (int) in.nval;
                in.nextToken();
                int y = (int) in.nval;
                in.nextToken();
                if (opt == 1) {
                    out.println(isSameSet(X, Y)?"Y":"N");
                } else if (opt == 2) {
                    union(x, y);
                }
            }
        }
        out.flush();
        br.close();
        out.close();
    }

    public static int find(int x) {
        int path_size = 0;

        while(father[x]!=x){
            stack[path_size++] = x;
            x = father[x];
        }

        // 扁平化
        while(path_size!=0){
            int tmp = stack[--path_size];
            father[tmp] = x;
        }

        return x;
    }

    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }
    public static void union(int x, int y) {
        int root_x = find(x);
        int root_y = find(y);
        if (root_x != root_y) {
            if (size[root_x] <= size[root_y]) {
                // x -> y
                father[root_x] = father[root_y];
                size[root_y] += size[root_x];
            } else {
                // y -> x
                father[root_y] = father[root_x];
                size[root_x] += size[root_y];
            }
        }
    }
}
