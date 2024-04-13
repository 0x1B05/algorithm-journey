package class067;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

/**
 * Code05_NodenHeightNotLargerThanm
 */
public class Code05_NodenHeightNotLargerThanm {
    public static int MAXN = 51;
    public static int MAXM = 51;
    public static int MOD = 1000000007;
    public static long[][] dp = new long[MAXN][MAXM];
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int n = (int) in.nval;
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0; i < n+1; i++) {
                for (int j = 0; j < m+1; j++) {
                    dp[i][j] = -1;
                }
            }

            out.println(compute(n, m));
        }
        out.flush();
        out.close();
        br.close();
    }
    // n个节点，高度不超过m
    // 记忆化搜索
    public static int compute(int n, int m) {
        if (n == 0) {
            return 1;
        }
        // n>0
        if (m == 0) {
            return 0;
        }
        if (dp[n][m] != -1) {
            return (int) dp[n][m];
        }
        long ans = 0;
        // left 几个 right 几个 头占掉一个
        for (int i = 0; i < n; i++) {
            int left = compute(i, m - 1) % MOD;
            int right = compute(n - i - 1, m - 1) % MOD;
            ans = (ans + ((long) left * right) % MOD) % MOD;
        }
        dp[n][m] = ans;
        return (int) ans;
    }
}
