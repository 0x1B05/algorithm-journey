package class067;

import java.util.Arrays;

public class Code01_MinimumPathSum {
    public static int minPathSum(int[][] grid) {
        int m = grid.length;
        int n = grid[0].length;
        int[][] dp = new int[m][n];
        for (int i = 0; i < m; i++) {
            Arrays.fill(dp[i], -1);
        }
        int ans = f(grid, m - 1, n - 1, dp);
        return ans;
    }

    public static int f(int[][] grid, int x, int y, int[][] dp) {
        if (x == 0 && y == 0) {
            dp[0][0] = grid[0][0];
            return dp[0][0];
        }

        if (dp[x][y] != -1) {
            return dp[x][y];
        }

        if (x == 0) {
            dp[x][y] = f(grid, x, y - 1, dp) + grid[x][y];
        } else if (y == 0) {
            dp[x][y] = f(grid, x - 1, y, dp) + grid[x][y];
            ;
        } else {
            dp[x][y] = Math.min(f(grid, x - 1, y, dp), f(grid, x, y - 1, dp)) + grid[x][y];
            ;
        }

        return dp[x][y];
    }

    public static int minPathSum2(int[][] grid) {
        int m = grid.length;
        int n = grid[0].length;
        int[][] dp = new int[m][n];
        dp[0][0] = grid[0][0];

        // 初始化第一行和第一列
        for (int i = 1; i < m; i++) {
            dp[i][0] = dp[i - 1][0] + grid[i][0];
        }
        for (int j = 1; j < n; j++) {
            dp[0][j] = dp[0][j - 1] + grid[0][j];
        }

        // 计算其余位置的最小路径和
        for (int i = 1; i < m; i++) {
            for (int j = 1; j < n; j++) {
                dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j];
            }
        }
        return dp[m - 1][n - 1];
    }

    // 空间压缩
    public static int minPathSum3(int[][] grid) {
        int m = grid.length;
        int n = grid[0].length;
        int[] dp = new int[n];
        dp[0] = grid[0][0];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j == 0) {
                    continue;
                }
                if (i == 0 && j != 0) {
                    dp[j] = dp[j - 1] + grid[i][j];
                } else {
                    if (j == 0) {
                        dp[j] = dp[j] + grid[i][j];
                    } else {
                        dp[j] = Math.min(dp[j - 1], dp[j]) + grid[i][j];
                    }
                }
            }
        }
        return dp[n - 1];
    }
}
