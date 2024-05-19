package class058;

/**
 * Code03_MakingLargeIsland
 */
public class Code03_MakingLargeIsland {

    public int largestIsland(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;

        int id = 2;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if(grid[i][j]==1){
                    infect(grid, i, j, id++);
                }
            }
        }

        int ans = 0;
        int[] size = new int[id];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if(grid[i][j] > 1){
                    ans = Math.max(ans, ++size[grid[i][j]]);
                }
            }
        }


        boolean[] visited = new boolean[id];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if(grid[i][j]==0){
                    int left = j-1>=0?grid[i][j-1]:0;
                    int right = j+1<m?grid[i][j+1]:0;
                    int up = i+1<n?grid[i+1][j]:0;
                    int down = i-1>=0?grid[i-1][j]:0;

                    int area = size[left]+1;
                    visited[left] = true;
                    if(visited[right]==false){
                        area+=size[right];
                        visited[right] = true;
                    }
                    if(visited[down]==false){
                        area+=size[down];
                        visited[down] = true;
                    }
                    if(visited[up]==false){
                        area+=size[up];
                        visited[up] = true;
                    }
                    ans = Math.max(ans, area);
                    visited[up] = false;
                    visited[down] = false;
                    visited[left] = false;
                    visited[right] = false;
                }
            }
        }

        return ans;
    }

    public static void infect(int[][] grid, int i, int j, int id){
        if( i < 0 || i >= grid.length || j < 0 || j >= grid[0].length || grid[i][j] != 1){
            return;
        }
        // 标记走过的点为0
        grid[i][j] = id;
        infect(grid, i-1, j, id);
        infect(grid, i+1, j, id);
        infect(grid, i, j+1, id);
        infect(grid, i, j-1, id);
    }
}
