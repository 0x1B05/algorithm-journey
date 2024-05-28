package class061;

import java.util.Arrays;

/**
 * Code03_OptimizeWaterDistribution
 */
public class Code03_OptimizeWaterDistribution {
    public static int MAXN = 10001;
    // edge[cnt][0] -> 起始点
    // edge[cnt][1] -> 结束点
    // edge[cnt][2] -> 代价
    public static int[][] edge = new int[MAXN << 1][3];
    // cnt代表边的编号
    public static int cnt;
    public static int[] father = new int[MAXN];

    public static void init(int n){
        cnt = 0;
        for (int i = 0; i <= n; i++) {
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

    public static int minCostToSupplyWater(int n, int[] wells, int[][] pipes) {
        init(n);

        for (int i = 0; i < n; i++, cnt++) {
            edge[cnt][0] = 0;
            edge[cnt][1] = i+1;
            edge[cnt][2] = wells[i];
        }
        for (int i = 0; i < pipes.length; i++, cnt++) {
            edge[cnt][0] = pipes[i][0];
            edge[cnt][1] = pipes[i][1];
            edge[cnt][2] = pipes[i][2];
        }

        Arrays.sort(edge,(a, b)->a[2]-b[2]);
        int ans = 0;
        for(int i = 0; i < cnt; i++){
            if(union(edge[i][0], edge[i][1])){
                ans += edge[i][2];
            }
        }
        return ans;
    }
}
