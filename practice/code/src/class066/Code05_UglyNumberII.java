package class066;

public class Code05_UglyNumberII {
    public static int nthUglyNumber(int n) {
        int[] uglyNums = new int[n + 1];
        uglyNums[1] = 1;
        // p2 p3 p5分别对应*2 *3 *5的指针分别停在什么下标
        int p2 = 1, p3 = 1, p5 = 1;
        for (int i = 2; i <= n; i++) {
            int a = uglyNums[p2] * 2;
            int b = uglyNums[p3] * 3;
            int c = uglyNums[p5] * 5;
            // 当前的丑数
            int cur = Math.min(Math.min(a, b), c);
            if (cur == a) {
                ++p2;
            }
            if (cur == b) {
                ++p3;
            }
            if (cur == c) {
                ++p5;
            }
            uglyNums[i] = cur;
        }
        return uglyNums[n];
    }
}
