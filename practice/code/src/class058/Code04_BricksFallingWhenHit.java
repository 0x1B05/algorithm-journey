package class058;

/**
 * Code04_BricksFallingWhenHit
 */
public class Code04_BricksFallingWhenHit {
    public int[] hitBricks(int[][] grid, int[][] hits) {
        int n = grid.length;
        int m = grid[0].length;
        int[] ans = new int[hits.length];
        // 只有一行
        if (n==1){
            return ans;
        }

        for (int[] hit : hits) {
            grid[hit[0]][hit[1]]--;
        }

        for (int j = 0; j < m; j++) {
            if(grid[0][j]==1){
                infect(grid, 0, j);
            }
        }

        // 时光倒流
        for (int cur = hits.length-1; cur >= 0; cur--) {
            int x = hits[cur][0];
            int y = hits[cur][1];
            grid[x][y]++;

            // 当前是1
            // 上下左右存在2 或者 当前是第一行
            boolean worth = grid[x][y] == 1 && (
                x == 0
                || (x-1 >= 0 && grid[x - 1][y] == 2)
                || (x+1 < n && grid[x + 1][y] == 2)
                || (y-1 >= 0 && grid[x][y - 1] == 2)
                || (y+1 < m && grid[x][y + 1] == 2)
            );
            if(worth){
                int infected = infect(grid, x, y);
                ans[cur] = infected-1;
            }
        }
        return ans;
    }

    // 感染数量
    public static int infect(int[][] grid, int i, int j){
        if( i < 0 || i >= grid.length || j < 0 || j >= grid[0].length || grid[i][j] != 1){
            return 0;
        }

        grid[i][j] = 2;
        return 1 + infect(grid, i-1, j) + infect(grid, i+1, j) + infect(grid, i, j+1) + infect(grid, i, j-1);
    }
}
