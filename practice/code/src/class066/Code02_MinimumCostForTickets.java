package class066;

import java.util.Arrays;

public class Code02_MinimumCostForTickets {
    // dp缓存
    public static int mincostTickets(int[] days, int[] costs) {
        int[] dp = new int[days.length + 1];
        for (int i = 0; i < dp.length; i++) {
            dp[i] = Integer.MAX_VALUE;
        }
        int ans = f1(days, costs, 0, dp);

        return ans;
    }

    // 当前位于days[cur...], 要接着完成days的最低消费
    public static int f1(int[] days, int[] costs, int cur, int[] dp) {
        // 后续已经没有旅行了
        if (cur >= days.length) {
            return 0;
        }
        if (dp[cur] < Integer.MAX_VALUE) {
            return dp[cur];
        }
        int ans = Integer.MAX_VALUE;
        for (int k = 0; k < costs.length; k++) {
            // 如果costs[0] 1天 ->
            // 如果costs[1] 7天 -> f(days,costs,cur+?);要看days[cur]+7 恰好<days[i] -> f(days,
            // costs, i)
            // 如果costs[2] 30天 -> f(days,costs,cur+?);要看days[cur]+30 恰好<days[i] -> f(days,
            // costs, i)
            if (k == 0) {
                // 1天
                ans = Math.min(ans, costs[0] + f1(days, costs, cur + 1, dp));
            } else if (k == 1) {
                // 7天
                int i = 0;
                for (i = cur + 1; i < days.length && days[i] < days[cur] + 7; i++)
                    ;
                ans = Math.min(ans, costs[1] + f1(days, costs, i, dp));
            } else {
                // 30天票
                int i = 0;
                for (i = cur + 1; i < days.length && days[i] < days[cur] + 30; i++)
                    ;
                ans = Math.min(ans, costs[2] + f1(days, costs, i, dp));
            }
        }
        dp[cur] = ans;
        return ans;
    }

    // 表依赖
    public static int MAX_DAYS = 366;

    public static int mincostTickets2(int[] days, int[] costs) {
        int n = days.length;
        int[] dp = new int[n + 1];
        Arrays.fill(dp, 0, n + 1, Integer.MAX_VALUE);
        dp[n] = 0;

        for (int cur = n - 1; cur >= 0; cur--) {
            for (int k = 0; k < costs.length; k++) {
                if (k == 0) {
                    // 1天
                    dp[cur] = Math.min(dp[cur], costs[0] + dp[cur + 1]);
                } else if (k == 1) {
                    // 7天
                    int i = 0;
                    for (i = cur + 1; i < days.length && days[i] < days[cur] + 7; i++)
                        ;
                    dp[cur] = Math.min(dp[cur], costs[1] + dp[i]);
                } else {
                    // 30天票
                    int i = 0;
                    for (i = cur + 1; i < days.length && days[i] < days[cur] + 30; i++)
                        ;
                    dp[cur] = Math.min(dp[cur], costs[2] + dp[i]);
                }
            }
        }
        return dp[0];
    }
}