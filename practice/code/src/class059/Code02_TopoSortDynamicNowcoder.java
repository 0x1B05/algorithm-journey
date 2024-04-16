package class059;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.ArrayList;

/**
 * Code02_TopoSortDynamicNowcoder
 */
public class Code02_TopoSortDynamicNowcoder {
    public static int MAXN = 200001;
    public static int MAXM = 200001;
    public static int l,r;
    public static int n,m;
    public static int[] indgree = new int[MAXN];
    public static int[] queue = new int[MAXN];

    public static boolean topSort(ArrayList<ArrayList<Integer>> graph) {
        l = 0; r = 0;
        for (int i = 1; i <= n; i++) {
            if(indgree[i]==0){
                queue[r++] = i;
            }
        }

        int cnt = 0;
        while(l<r){
            int cur = queue[l++];
            cnt++;
            for (int next : graph.get(cur)) {
                if(--indgree[next]==0){
                    queue[r++] = next;
                }
            }
        }

        boolean ans = cnt==n?true:false;
        return ans;
    }
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            m = (int) in.nval;
            in.nextToken();

            for (int i = 0; i < m; i++) {
                int from = (int) in.nval;
                in.nextToken();
                int to = (int) in.nval;
                in.nextToken();
                graph.get(from).add(to);
                indgree[to]++;
            }
            if (!topSort(graph)) {
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
