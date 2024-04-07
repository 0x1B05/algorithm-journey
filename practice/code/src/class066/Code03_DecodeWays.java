package class066;

import java.util.Arrays;

public class Code03_DecodeWays {
    public static int numDecodings(String s) {
        int[] dp = new int[s.length() + 1];
        Arrays.fill(dp, -1);
        int ans = f(s, 0, dp);
        return ans;
    }

    // s[cur...有多少种编码方法.
    public static int f(String s, int cur, int[] dp) {
        if (cur == s.length()) {
            return 1;
        }
        if (dp[cur] != -1) {
            return dp[cur];
        }

        int ans = 0;
        // 选当前的
        if (s.charAt(cur) == '0') {
            return 0;
        } else {
            ans += f(s, cur + 1, dp);
            // 选当前的以及下一个(要求要小于26)
            if (cur + 1 < s.length() && ((s.charAt(cur) - '0') * 10 + (s.charAt(cur + 1) - '0')) <= 26) {
                ans += f(s, cur + 2, dp);
            }
        }

        dp[cur] = ans;
        return ans;
    }

    public static int numDecodings2(String s) {
        int n = s.length();
        int[] dp = new int[n + 1];
        Arrays.fill(dp, 0);

        dp[n] = 1;
        for (int cur = n - 1; cur >= 0; cur--) {
            if (s.charAt(cur) == '0') {
                dp[cur] = 0;
            } else {
                dp[cur] += dp[cur + 1];
                // 选当前的以及下一个(要求要小于26)
                if (cur + 1 < n && ((s.charAt(cur) - '0') * 10 + (s.charAt(cur + 1) - '0')) <= 26) {
                    dp[cur] += dp[cur + 2];
                }
            }

        }

        return dp[0];
    }

    public static int numDecodings3(String s) {
        // dp[i+1]
        int next = 1;
        // dp[i+2]
        int nextNext = 0;
        for (int i = s.length() - 1, cur; i >= 0; i--) {
            if (s.charAt(i) == '0') {
                cur = 0;
            } else {
                cur = next;
                if (i + 1 < s.length() && ((s.charAt(i) - '0') * 10 + s.charAt(i + 1) - '0') <= 26) {
                    cur += nextNext;
                }
            }
            nextNext = next;
            next = cur;
        }
        return next;
    }
}
