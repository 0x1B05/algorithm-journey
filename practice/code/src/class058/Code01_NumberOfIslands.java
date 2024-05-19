package class058;

public class Code01_NumberOfIslands {
    public static int numIslands(char[][] grid) {
        int num = 0;
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j]=='1') {
                    ++num;
                    infect(grid,i,j);
                }
            }
        }

        return num;
    }

    public static void infect(char[][] grid, int i, int j){
        if( i < 0 || i >= grid.length || j < 0 || j >= grid[0].length || grid[i][j] != '1' ){
            return;
        }
        // 标记走过的点为0
        grid[i][j] = 0;
        infect(grid, i-1, j);
        infect(grid, i+1, j);
        infect(grid, i, j+1);
        infect(grid, i, j-1);
    }
}
