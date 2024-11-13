package class073;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

/**
 * Code01_01Knapsack
 */
public class Code01_01Knapsack {
    public static int MAXM = 101;
    public static int MAXT = 1001;
    public static int[] cost = new int[MAXM];
    public static int[] val = new int[MAXM];
    public static int[] dp = new int[MAXT];
    public static int t, n;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            t = (int) in.nval;
            in.nextToken();
            n = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                cost[i] = (int) in.nval;
                in.nextToken();
                val[i] = (int) in.nval;
            }
            out.println(compute2());
        }
        out.flush();
        out.close();
        br.close();
    }

    // 严格位置依赖的动态规划
    // n个物品编号1~n，第i号物品的花费cost[i]、价值val[i]
    // cost、val数组是全局变量，已经把数据读入了
    public static int compute1() {
        int[][] dp = new int[n + 1][t + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= t; j++) {
                // 不要i号物品
                int p1 = dp[i - 1][j];
                // 要i号物品
                int p2 = j - cost[i] >= 0? dp[i - 1][j - cost[i]] + val[i]:0;
                dp[i][j] = Math.max(p1, p2);
            }
        }
        return dp[n][t];
    }

    // 空间压缩
    public static int compute2() {
        Arrays.fill(dp, 0, t + 1, 0);
        for (int i = 1; i <= n; i++) {
            for (int j = t; j >= cost[i]; j--) {
                // 不要i号物品
                int p1 = dp[j];
                // 要i号物品
                int p2 = j - cost[i] >= 0? dp[j - cost[i]] + val[i]:0;
                dp[j] = Math.max(p1, p2);
            }
        }
        return dp[t];
    }
}
