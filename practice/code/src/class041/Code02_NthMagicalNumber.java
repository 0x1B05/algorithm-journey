package class041;

public class Code02_NthMagicalNumber {
    public static int nthMagicalNumber(int n, int a, int b) {
        int cnt = 0;
        int cur = 1;
        while (true) {
            if (cur % a == 0 || cur % b == 0) {
                ++cnt;
                ++cur;
                cur = cur % (10 ^ 9 + 7);
            }
            if (cnt == n) {
                break;
            }
        }
        return cnt;
    }

    public static long gcd(long a, long b) {
        return b == 0 ? a : gcd(b, a % b);
    }

    public static long lcm(long a, long b) {
        return (long) a / gcd(a, b) * b;
    }
}
