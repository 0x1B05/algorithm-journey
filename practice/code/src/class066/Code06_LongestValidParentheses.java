package class066;

public class Code06_LongestValidParentheses {
    public static int longestValidParentheses(String str) {
        char[] s = str.toCharArray();
        // dp[0...n-1]
        // dp[i]: 子串必须以i结尾, 往左最多推多远能有效?
        int[] dp = new int[s.length];
        if (s.length > 0) {
            dp[0] = 0;
        }
        int ans = 0;

        // 必须要')'才可能有值, 不然
        // cur 看 cur-1, 如果有且为x,则看cur-x-1位置,如果匹配当前
        for (int cur = 1; cur < dp.length; cur++) {
            if (s[cur] == ')') {
                int tmp = cur - dp[cur - 1] - 1;
                if (tmp >= 0 && s[tmp] == '(') {
                    dp[cur] = dp[cur - 1] + 2 + (tmp > 0 ? dp[tmp - 1] : 0);
                } else {
                    dp[cur] = 0;
                }
            } else {
                dp[cur] = 0;
            }
            ans = Math.max(dp[cur], ans);
        }
        return ans;
    }

}
