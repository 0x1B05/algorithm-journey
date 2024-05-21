package class069;

/**
 * Code01_OnesAndZeroes
 */
public class Code01_OnesAndZeroes {
    public static int zeros;
    public static int ones;

    public static void count(String str){
        zeros = 0;
        ones = 0;
        for (int i = 0; i < str.length(); i++) {
            if(str.charAt(i)=='0'){
                zeros++;
            }else if(str.charAt(i)=='1'){
                ones++;
            }
        }
    }

    public static int findMaxForm1(String[] strs, int m, int n) {
        return f1(strs, 0, m, n);
    }

    // strs[i...] 自由选择，0的数量不超过z，1的数量不超过o
    // 最多能选择多少字符串
    public static int f1(String[] strs, int cur, int z, int o){
        if(cur==strs.length){
            return 0;
        }

        // 不选择当前字符串
        int p1 = f1(strs, cur+1, z, o);
        // 选择当前字符串
        int p2 = 0;
        count(strs[cur]);
        if(zeros<=z && ones<=o){
            p2 = 1 + f1(strs, cur+1, z-zeros, o-ones);
        }

        return Math.max(p1, p2);
    }

    // 记忆化搜索
    public static int findMaxForm2(String[] strs, int m, int n) {
        int[][][] dp = new int[strs.length][m+1][n+1];
        for (int i = 0; i < dp.length; i++) {
            for (int j = 0; j < dp[0].length; j++) {
                for (int k = 0; k < dp[0][0].length; k++) {
                    dp[i][j][k] = -1;
                }
            }
        }
        return f2(dp, strs, 0, m, n);
    }
    public static int f2(int[][][] dp, String[] strs, int cur, int z, int o){
        if(cur==strs.length){
            return 0;
        }

        if(dp[cur][z][o]!=-1){
            return dp[cur][z][o];
        }

        // 不选择当前字符串
        int p1 = f2(dp, strs, cur+1, z, o);
        // 选择当前字符串
        int p2 = 0;
        count(strs[cur]);
        if(zeros<=z && ones<=o){
            p2 = 1 + f2(dp, strs, cur+1, z-zeros, o-ones);
        }
        dp[cur][z][o] = Math.max(p1, p2);

        return dp[cur][z][o];
    }

    // 严格表依赖
    public static int findMaxForm3(String[] strs, int m, int n) {
        int len = strs.length;
        // 来到 strs[cur...]，要0的数量<=m，1的数量<=n 的最大长度
        int[][][] dp = new int[len+1][m+1][n+1];
        // base case: dp[len][..][..]=0
        // 每一层依赖上一层
        for (int cur = len-1; cur >= 0; cur--) {
            count(strs[cur]);
            for (int z = 0; z <= m; z++) {
                for (int o = 0; o <= n; o++) {
                    int p1 = dp[cur+1][z][o];
                    int p2 = 0;
                    if(z>=zeros && o >=ones){
                        p2 = 1 + dp[cur+1][z-zeros][o-ones];
                    }
                    dp[cur][z][o] = Math.max(p1, p2);
                }
            }
        }

        return dp[0][m][n];
    }

    // 空间压缩
    public static int findMaxForm4(String[] strs, int m, int n) {
        // 代表cur==len
        int[][] dp = new int[m+1][n+1];
        // 第i层依赖第i+1层当前位置，以及左下角某个值
        // 从右上到左下进行空间压缩
        for (String s : strs) {
            // 每个字符串逐渐遍历即可
            // 更新每一层的表
            // 和之前的遍历没有区别
            count(s);
            for (int z = m; z >= zeros; z--) {
                for (int o = n; o >= ones; o--) {
                    dp[z][o] = Math.max(dp[z][o], 1 + dp[z - zeros][o - ones]);
                }
            }
        }
        return dp[m][n];
    }
}
