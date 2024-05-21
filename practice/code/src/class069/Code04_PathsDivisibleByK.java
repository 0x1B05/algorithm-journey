package class069;

/**
 * Code04_PathsDivisibleByK
 */
public class Code04_PathsDivisibleByK {
    public static int MOD = 1000000007;

    public static int numberOfPaths1(int[][] grid, int k) {
        return f1(grid, k, 0, 0, 0);
    }

    // 从(i,j)出发，最终一定要走到右下角(n-1,m-1)，有多少条路径，累加和%k是r
    public static int f1(int[][] grid, int k, int x, int y, int r){
        int n = grid.length;
        int m = grid[0].length;
        if (x==n-1 && y==m-1) {
            return grid[x][y]%k==r?1:0;
        }
        int ans = 0;
        int need = (k+r-(grid[x][y]%k))%k;
        int p1=0, p2=0;
        // 向下走
        if(x+1<n){
            p1 = f1(grid, k, x+1, y, need);
        }
        // 向右走
        if(y+1<n){
            p2 = f1(grid, k, x+1, y, need);
        }
        ans = (p1+p2)%MOD;
        return ans;
    }

    public static int numberOfPaths2(int[][] grid, int k) {
        int n = grid.length;
        int m = grid[0].length;
        int[][][] dp = new int[k][n][m];

        for (int r = 0; r < k; r++) {
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    dp[r][i][j] = -1;
                }
            }
        }

        return f2(dp, grid, k, 0, 0, 0);
    }

    // 从(i,j)出发，最终一定要走到右下角(n-1,m-1)，有多少条路径，累加和%k是r
    public static int f2(int[][][] dp, int[][] grid, int k, int x, int y, int r){
        int n = grid.length;
        int m = grid[0].length;

        if(dp[r][x][y]!=-1){
            return dp[r][x][y];
        }

        if (x==n-1 && y==m-1) {
            return grid[x][y]%k==r?1:0;
        }
        int need = (k+r-grid[x][y]%k)%k;
        int p1=0, p2=0;

        // 向下走
        if(x+1<n){
            p1 = f2(dp, grid, k, x+1, y, need);
        }
        // 向右走
        if(y+1<m){
            p2 = f2(dp, grid, k, x, y+1, need);
        }
        dp[r][x][y] = (p1+p2)%MOD;
        return dp[r][x][y];
    }

    public static int numberOfPaths3(int[][] grid, int k) {
        int n = grid.length;
        int m = grid[0].length;
        // 从(i,j)出发，最终一定要走到右下角(n-1,m-1)，有多少条路径，累加和%k是r
        int[][][] dp = new int[n][m][k];
        dp[n-1][m-1][grid[n-1][m-1]%k] = 1;

        // 最后一列，从下到上依赖
        for (int i = n-2; i >= 0; i--) {
            for (int r = 0; r < k; r++) {
                int need = (k+r-grid[i][m-1]%k)%k;
                dp[i][m-1][r] = dp[i+1][m-1][need];
            }
        }

        // 最后一行，从右到左依赖
        for (int j = m-2; j >= 0; j--) {
            for (int r = 0; r < k; r++) {
                int need = (k+r-grid[n-1][j]%k)%k;
                dp[n-1][j][r] = dp[n-1][j+1][need];
            }
        }

        for (int i = n-2; i >= 0; i--) {
            for (int j = m-2; j >= 0; j--) {
                for (int r = 0; r < k; r++) {
                    int need = (k+r-grid[i][j]%k)%k;
                    // 依赖右边
                    int p1 = dp[i][j+1][need];
                    // 依赖下边
                    int p2 = dp[i+1][j][need];
                    dp[i][j][r] = (p1+p2)%MOD;
                }
            }
        }

        return dp[0][0][0];
    }
}
