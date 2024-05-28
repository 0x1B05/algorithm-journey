package class061;

import java.util.Arrays;

/**
 * Code04_CheckingExistenceOfedgesLengthLimit
 */
public class Code04_CheckingExistenceOfEdgeLengthLimit {
    public static int MAXN = 100001;
    public static int[][] questions = new int[MAXN][4];

    public static int[] father = new int[MAXN];
    public static void init(int n){
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
    }
    public static int find(int i){
        if(i!=father[i]){
            father[i] = find(father[i]);
        }
        return father[i];
    }
    public static void union(int x, int y){
        father[find(x)] = find(y);
    }
    public static boolean isSameSet(int x, int y){
        return find(x)==find(y);
    }

    public static boolean[] distanceLimitedPathsExist(int n, int[][] edges, int[][] queries) {
        int m = edges.length;
        int k = queries.length;
        boolean[] ans = new boolean[k];
        init(n);

        for (int i = 0; i < k; i++) {
            questions[i][0] = queries[i][0];
            questions[i][1] = queries[i][1];
            questions[i][2] = queries[i][2];
            questions[i][3] = i;
        }
        Arrays.sort(questions, 0, k, (a, b)->a[2]-b[2]);
        Arrays.sort(edges, (a, b)->a[2]-b[2]);

        // 当前已经连了的节点数量
        int nodeCnt = 0;
        for (int i = 0; i < k; i++) {
            while(nodeCnt<m && edges[nodeCnt][2]<questions[i][2]){
                union(edges[nodeCnt][0], edges[nodeCnt][1]);
                nodeCnt++;
            }
            ans[questions[i][3]] = isSameSet(questions[i][0], questions[i][1]);
        }
        return ans;
    }
}
