package class067;

/**
 * Code04_LongestPalindromicSubsequence
 */
public class Code04_LongestPalindromicSubsequence {
    public static int longestPalindromeSubseq1(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        int ans = f1(s, 0, n - 1, dp);
        return ans;
    }
    // l...r 最长回文子序列
    public static int f1(char[] s, int l, int r, int[][] dp) {
        if (l == r) {
            return 1;
        }
        if (l + 1 == r) {
            return s[l] == s[r] ? 2 : 1;
        }
        if (dp[l][r] != 0) {
            return dp[l][r];
        }
        int ans;
        if (s[l] == s[r]) {
            ans = 2 + f(s, l + 1, r - 1, dp);
        } else {
            ans = Math.max(f(s, l + 1, r, dp), f(s, l, r - 1, dp));
        }
        dp[l][r] = ans;
        return ans;
    }
    // 严格表结构
    public static int longestPalindromeSubseq3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];


        // l为行，r为列 -> r >= l
        for (int l = n - 1; l >= 0; l--) {
            // l=r 对角线是1
            dp[l][l] = 1;

            // l+1 = r
            if (l + 1 < n) {
                dp[l][l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }

            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = 2 + dp[l - 1][r - 1];
                } else {
                    dp[l][r] = Math.max(dp[l - 1][r], dp[l][r - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }

    // 严格表结构, 空间压缩
    public static int longestPalindromeSubseq3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n];

        // l为行，r为列 -> r >= l
        for (int l = n - 1; l >= 0; l--) {
            // l=r 对角线是1
            dp[l][l] = 1;

            // l+1 = r
            if (l + 1 < n) {
                dp[l][l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }

            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = 2 + dp[l - 1][r - 1];
                } else {
                    dp[l][r] = Math.max(dp[l - 1][r], dp[l][r - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }

}

