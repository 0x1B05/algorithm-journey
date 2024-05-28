package class061;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.ArrayList;
import java.util.PriorityQueue;

/**
 * Code02_PrimDynamic
 */
public class Code02_PrimDynamic {
    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            ArrayList<ArrayList<int[]>> graph = new ArrayList<>();
            int n = (int) in.nval;
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0, from, to, weight; i < m; i++) {
                in.nextToken();
                from = (int) in.nval;
                in.nextToken();
                to = (int) in.nval;
                in.nextToken();
                weight = (int) in.nval;
                graph.get(from).add(new int[]{to,weight});
                graph.get(to).add(new int[]{from,weight});
            }
            int ans = prim(graph);
            out.println(ans == -1 ? "orz":ans);
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int prim(ArrayList<ArrayList<int[]>> graph) {
        int n = graph.size()-1;
        int nodeCnt = 0;
        int ans = 0;

        boolean[] set = new boolean[n+1];
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b)->(a[1]-b[1]));

        for (int[] e : graph.get(1)) {
            heap.add(e);
        }
        set[1] = true;
        nodeCnt++;

        while(!heap.isEmpty()){
            int[] top = heap.poll();
            int to = top[0];
            int weight = top[1];
            if(!set[to]){
                ans+=weight;
                nodeCnt++;
                set[to]=true;
                for (int[] e : graph.get(to)) {
                    heap.add(e);
                }
            }
        }
        return nodeCnt == n ? ans:-1;
    }
}
