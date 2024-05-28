package class061;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

/**
 * Code05_BusyCities
 */
public class Code05_BusyCities {
    public static int MAXN = 301;
    public static int MAXM = 8001;
    public static int n,m;
    public static int[][] edges = new int[MAXM][3];

    public static int[] father = new int[MAXN];
    public static void init(){
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }
    public static int find(int i){
        if(i!=father[i]){
            father[i] = find(father[i]);
        }
        return father[i];
    }
    public static boolean union(int x, int y){
        int fx = find(x);
        int fy = find(y);
        if(fx!=fy){
            father[fx] = fy;
            return true;
        }else{
            return false;
        }
    }
    public static boolean isSameSet(int x, int y){
        return find(x)==find(y);
    }

    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            n = (int)in.nval;
            in.nextToken();
            m = (int)in.nval;
            init();
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            Arrays.sort(edges, 0, m, (a, b)->a[2]-b[2]);
            int ans = 0;
            int edgeCnt = 0;
            for (int[] edge : edges) {
                if(union(edge[0], edge[1])){
                    edgeCnt++;
                    ans = Math.max(ans, edge[2]);
                }
                if(edgeCnt==n-1){
                    break;
                }
            }
            out.println((n - 1) + " " + ans);
        }
        out.flush();
        out.close();
        br.close();
    }
}
