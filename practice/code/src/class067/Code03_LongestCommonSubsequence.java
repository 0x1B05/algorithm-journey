package class067;

public class Code03_LongestCommonSubsequence {
    public static int longestCommonSubsequence(String text1, String text2) {
        char[] t1 = text1.toCharArray();
        char[] t2 = text2.toCharArray();
        return f(t1, t2, t1.length - 1, t2.length - 1);
    }

    // t1[0..p1] 与 t2[0...p2] 公共子序列的长度
    public static int f(char[] t1, char[] t2, int i1, int i2) {
        if (i1 < 0 || i2 < 0) {
            return 0;
        }
        // 公共子串不包含结尾
        int p1 = f(t1, t2, i1 - 1, i2 - 1);
        // 要一个结尾,不要另一个
        int p2 = f(t1, t2, i1, i2 - 1);
        int p3 = f(t1, t2, i1 - 1, i2);
        // 两个结尾都要
        int p4 = t1[i1] == t2[i2] ? (p1 + 1) : 0;
        return Math.max(Math.max(p1, p2), Math.max(p3, p4));
    }
}
