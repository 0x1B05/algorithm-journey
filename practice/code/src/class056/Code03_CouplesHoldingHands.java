package class056;

/**
 * Code03_CouplesHoldingHands
 */
public class Code03_CouplesHoldingHands {
    public static int MAXN = 31;
    public static int[] couple = new int[MAXN];
    public static int setNum = 0;

    public static int minSwapsCouples(int[] row) {
        int n = row.length;

        int m = n/2;
        for (int i = 0; i < m; i++) {
            couple[i] = i;
        }
        setNum=m;

        for (int i = 0; i < n; i+=2) {
            union(row[i]/2, row[i+1]/2);
        }

        return m - setNum;
    }
    public static int find(int x) {
        if (x != couple[x]) {
            couple[x] = find(couple[x]);
        }
        return couple[x];
    }
    public static void union(int x, int y) {
        int root_x = find(x);
        int root_y = find(y);
        if (root_x!=root_y) {
            couple[root_x] = root_y;
            setNum--;
        }
    }
}
