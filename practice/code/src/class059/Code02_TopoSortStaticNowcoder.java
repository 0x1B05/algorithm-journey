package class059;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Code02_TopoSortStaticNowcoder
 */
public class Code02_TopoSortStaticNowcoder {
    public static int MAXN = 200001;
    public static int MAXM = 200001;
    public static int l,r;
    public static int n,m;

    public static int cnt;
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] indgree = new int[MAXN];

    public static int[] queue = new int[MAXN];

    public static void init(){
        cnt = 1;
        Arrays.fill(head, 0,n+1,0);
        Arrays.fill(indgree, 0,n+1,0);

    }
    public static void addEdge(int from, int t){
        next[cnt] = head[from];
        to[cnt] = t;
        head[from] = cnt++;
    }
    public static boolean topSort() {
        l=0;r=0;
        for (int i = 1; i <= n; i++) {
            if (indgree[i]==0) {
                queue[r++] = i;
            }
        }
        int cnt = 0;
        while(l<r){
            int cur = queue[l++];
            cnt++;
            for (int ei = head[cur]; ei > 0; ei = next[ei]) {
                indgree[to[ei]]--;
                if(indgree[to[ei]]==0){
                    queue[r++] = to[ei];
                }
            }
        }
        return cnt==n;
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
                int from = (int) in.nval;
                in.nextToken();
                int t = (int) in.nval;
                in.nextToken();
                addEdge(from, t);
                indgree[t]++;
            }
            if (!topSort()) {
                out.println(-1);
            } else {
                for (int i = 0; i < n-1; i++) {
                    System.out.print(queue[i] + " ");
                }
                out.println(queue[n-1]);
            }
        }
        out.flush();
        out.close();
        br.close();
    }
}
