package class056;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

/**
 * Code02_UnionFindLuogu
 */
public class Code02_UnionFindLuogu {
    public static int MAXN = 10001;
    public static int[] father = new int[MAXN];
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int N = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < N; i++) {
                father[i] = i;
            }
            int M = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < M; i++) {
                int Z = (int) in.nval;
                in.nextToken();
                int X = (int) in.nval;
                in.nextToken();
                int Y = (int) in.nval;
                in.nextToken();
                if (Z == 1) {
                    union(find(X), find(Y));
                } else if (Z == 2) {
                    out.println(isSameSet(X, Y)?"Y":"N");
                }
            }
        }
        out.flush();
        out.close();
        br.close();
    }
    public static int find(int x) {
        if(x!=father[x]){
            father[x] = find(father[x]);
        }
        return father[x];
    }

    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }
    public static void union(int x, int y) {
        int root_x = find(x);
        int root_y = find(y);
        if (root_x != root_y) {
            father[root_x] = father[root_y];
        }
    }
}
