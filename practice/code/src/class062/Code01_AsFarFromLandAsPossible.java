package class062;

/**
 * Code01_AsFarFromLandAsPossible
 */
public class Code01_AsFarFromLandAsPossible {
    public static int MAXN = 101;
    public static int MAXM = 101;

    public static int[][] queue = new int[MAXN * MAXM][2];
    public static int l,r;
    public static boolean[][] visited = new boolean[MAXN][MAXM];

    // 0:上，1:右，2:下，3:左
    public static int[] move = new int[] {-1, 0, 1, 0, -1};
    //                                     0  1  2  3   4
    //                                              i
    // (x,y)  i来到0位置 : x + move[i], y + move[i+1] -> x - 1, y
    // (x,y)  i来到1位置 : x + move[i], y + move[i+1] -> x, y + 1
    // (x,y)  i来到2位置 : x + move[i], y + move[i+1] -> x + 1, y
    // (x,y)  i来到3位置 : x + move[i], y + move[i+1] -> x, y - 1

    public static int maxDistance(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        l = r = 0;
        int seas = 0;
        // 先把陆地加入队列
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if(grid[i][j]==1){
                    visited[i][j] = true;
                    queue[r][0] = i;
                    queue[r][1] = j;
                    r++;
                }else{
                    visited[i][j] = false;
                    seas++;
                }
            }
        }
        if (seas == 0 || seas == n * m) {
            return -1;
        }

        int level = 0;
        while(l < r){
            level++;
            int size = r-l;
            for (int i = 0, x, y, nx, ny; i < size; i++) {
                x = queue[l][0];
                y = queue[l++][1];
                for (int j = 0; j < 4; j++) {
                    nx = x+move[j];
                    ny = y+move[j+1];
                    if(nx >= 0 && nx < n && ny >= 0 && ny < m && !visited[nx][ny]){
                        visited[nx][ny] = true;
                        queue[r][0] = nx;
                        queue[r++][1] = ny;
                    }
                }
            }
        }
        return level-1;
    }
}
