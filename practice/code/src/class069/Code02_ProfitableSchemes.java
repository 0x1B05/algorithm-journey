package class069;

/**
 * Code02_ProfitableSchemes
 */
public class Code02_ProfitableSchemes {
   public static int MOD = 1000000007;

    public int profitableSchemes1(int n, int minProfit, int[] group, int[] profit) {
        return f1(0, group, profit,n, minProfit);
    }
    // 来到第job份工作,要求剩下的工作n个人至少产生minProfit的利润
    // 返回方案数
    public static int f1(int job, int[] group, int[] profit,int n, int minProfit){
        int len = profit.length;

        // 如果没人了或者工作选完了
        if(n < 0 || job==len){
            return minProfit > 0 ? 0:1;
        }
        // 不做当前这份工作
        int p1 = f1(job+1, group, profit, n, minProfit);
        // 做当前这份工作
        int p2 = 0;
        if(n-group[job]>=0){
            p2= f1(job+1, group, profit, n-group[job], minProfit-profit[job]);
        }
        return p1+p2;
    }

    public int profitableSchemes2(int n, int minProfit, int[] group, int[] profit) {
        int len = profit.length;
        int[][][] dp = new int[len+1][n+1][minProfit+1];
        for (int i = 0; i < dp.length; i++) {
            for (int j = 0; j < dp[0].length; j++) {
                for (int k = 0; k < dp[0][0].length; k++) {
                    dp[i][j][k] = -1;
                }
            }
        }
        return f2(dp, 0, group, profit,n, minProfit);
    }

    public static int f2(int[][][] dp, int job, int[] group, int[] profit,int n, int minProfit){
        int len = profit.length;

        // 如果没人了或者工作选完了
        if(n < 0 || job==len){
            return minProfit > 0 ? 0:1;
        }

        if(dp[job][n][minProfit]!=-1){
            return dp[job][n][minProfit];
        }

        // 不做当前这份工作
        int p1 = f2(dp, job+1, group, profit, n, minProfit);
        // 做当前这份工作
        int p2 = 0;
        if(n-group[job]>=0){
            p2= f2(dp, job+1, group, profit, n-group[job], Math.max(0,minProfit-profit[job]));
        }
        dp[job][n][minProfit] = (p1+p2) % MOD;
        return dp[job][n][minProfit];
    }

    // 严格表结构+空间压缩
    public int profitableSchemes3(int n, int minProfit, int[] group, int[] profit) {
        int len = profit.length;
        // i = 没有工作的时候，i == g.length
        int[][] dp = new int[n + 1][minProfit + 1];

        // 工作选完之后，还有人但是已经不用再盈利
        for (int person = 0; person <= n; person++) {
            dp[person][0] = 1;
        }

        for (int job = len-1; job >= 0; job--) {
            for (int person = n; person >= 0; person--) {
                for (int prof = minProfit; prof >= 0; prof--) {
                    int p1 = dp[person][prof];
                    int p2 = 0;
                    if((person-group[job])>=0){
                        p2 = dp[person-group[job]][Math.max(0,prof-profit[job])];
                    }
                    dp[person][prof] = (p1+p2)%MOD;
                }
            }
        }
        return dp[n][minProfit];
    }
}
