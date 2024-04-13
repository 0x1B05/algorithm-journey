package class068;

/**
 * Code01_DistinctSubsequences
 */
public class Code01_DistinctSubsequences {
    // 直接动态规划
    public static int numDistinct(String s, String t) {
        int MOD = 1000000007;
        char[] s1 = s.toCharArray();
        char[] s2 = t.toCharArray();
        int len1 = s1.length;
        int len2 = s2.length;
        // 表示前缀长度(使用下标会有很多边界情况的讨论)
        int[][] dp = new int[len1 + 1][len2 + 1];
        // 尝试: s1[...p1] 已经匹配了x个 s2[...p2]

        // s1[0] -> s2[0] = 1 s2[1....] 0
        // s2[0] -> s1[0] = 1 s1[1....] 1 (子序列生成的空集)
        for (int i = 0; i < dp.length; i++) {
            dp[i][0] = 1;
        }

        // 按照末尾讨论可能性,s1[...p1] s2[...p2]
        // 不要s1的最后一个, 就要s1[...p1-1] s2[...p2]
        // 对应 dp[p1-1][p2](上)
        // 要s1的最后一个，就要要求s1[p1] == s2[p2], 接下来s1[...p1-1] s2[...p2-1]
        // 对应dp[p1-1][p2-1](左上)
        // 以上两种可能性相加

        // -------->填表
        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                int p1 = dp[i-1][j]%MOD;
                // 因为代表长度所以在下标的时候要-1，不然会越界
                int p2 = s1[i-1]==s2[j-1]?( dp[i-1][j-1]%MOD ):0;
                dp[i][j] = (p1+p2)%MOD;
            }
        }

        return dp[len1][len2];
    }

    // 空间压缩
    public static int numDistinct2(String str, String target){
        int MOD = 1000000007;
        char[] s1 = s.toCharArray();
        char[] s2 = t.toCharArray();
        int len1 = s1.length;
        int len2 = s2.length;
        // 表示前缀长度(使用下标会有很多边界情况的讨论)
        int[] dp = new int[len2 + 1];
        dp[0] = 1;

        // -------->填表
        for (int i = 1; i <= len1; i++) {
            int leftUp = 1, backup;
            for (int j = 1; j <= len2; j++) {
                backup = dp[j];
                // 上
                int p1 = dp[j]%MOD;
                // 左上
                int p2 = s1[i-1]==s2[j-1]?( leftUp%MOD ):0;
                // 当前
                dp[j] = (p1+p2)%MOD;
                leftUp = backup;
            }
        }

        return dp[len2];
    }
}
