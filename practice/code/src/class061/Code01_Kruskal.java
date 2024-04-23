package class061;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

/**
 * Code01_Kruskal
 */
public class Code01_Kruskal {
    public static int MAXN = 5001;
    public static int MAXM = 200001;
    public static int n, m;
    public static int[][] edges = new int[MAXM][3];
    public static int[] father = new int[MAXN];
    public static int ans = 0;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            init();
            m = (int) in.nval;
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            out.println(compute() ? ans : "orz");
        }
        out.flush();
        out.close();
        br.close();
    }
    public static void init() {
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }
    public static boolean union(int x, int y) {
        int fx = find(x);
        int fy = find(y);

        if (fx != fy) {
            father[fx] = fy;
            return true;
        } else {
            return false;
        }
    }
    public static int find(int x) {
        if (father[x] != x) {
            father[x] = find(father[x]);
        }
        return father[x];
    }

    public static boolean compute() {
        Arrays.sort(edges, 0, m, (a, b) -> (a[2] - b[2]));
        int edgeCnt = 0;
        for (int[] edge : edges) {
            if (union(edge[0], edge[1])) {
                ans += edge[2];
                edgeCnt++;
            }
        }
        return edgeCnt == n - 1;
    }
}
