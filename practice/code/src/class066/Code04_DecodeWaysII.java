package class066;

import java.util.Arrays;

public class Code04_DecodeWaysII {
    public static int numDecodings(String s) {
        long[] dp = new long[s.length() + 1];
        Arrays.fill(dp, -1);
        long ans = f(s, 0, dp);
        return (int) ans;
    }

    public static long MOD = 1000000007;

    // s[cur...]有多少种编码方法.
    public static long f(String s, int cur, long[] dp) {
        if (cur == s.length()) {
            return 1;
        }
        if (dp[cur] != -1) {
            return dp[cur];
        }

        long ans = 0;
        // 选当前的
        if (s.charAt(cur) == '0') {
            return 0;
        } else {
            // 当前不是0, 有几种情况.
            // 仅选当前位(可能是数字或者*).
            // 选当前位以及下一位, 第一位是1/2 或者 *, 第二位是0-6或者, 第二位是*

            // 仅选当前位, 区分普通和*
            int cur_char = s.charAt(cur) - '0';
            if (cur_char > 0 && cur_char < 10) {
                // 是普通数字
                ans += f(s, cur + 1, dp);
            } else {
                // 是*
                ans += 9 * f(s, cur + 1, dp);
            }

            // 选当前以及下一位
            boolean oneOr2 = cur_char == 1 || cur_char == 2;
            boolean curStar = cur_char == ('*' - '0');
            if (cur + 1 < s.length()) {
                // 第一位是1/2, 第二个是 0-6 / *
                int next_char = s.charAt(cur + 1) - '0';
                boolean isNum = next_char >= 0 && next_char <= 9;
                boolean lessThan6 = isNum && next_char <= 6;
                boolean nextStar = next_char == ('*' - '0');
                if (oneOr2) {
                    if ((cur_char == 2 && lessThan6)
                            || (cur_char == 1 && isNum)) {
                        ans += f(s, cur + 2, dp);
                    } else if (nextStar) {
                        if (cur_char == 1) {
                            ans += 9 * f(s, cur + 2, dp);
                        } else if (cur_char == 2) {
                            ans += 6 * f(s, cur + 2, dp);
                        }
                    }
                    // 第一位是*(代表1/2), 第二位可能是数字或者*
                } else if (curStar) {
                    if (isNum) {
                        if (lessThan6) {
                            ans += 2 * f(s, cur + 2, dp);
                        } else {
                            ans += f(s, cur + 2, dp);
                        }
                    } else if (nextStar) {
                        ans += 15 * f(s, cur + 2, dp);
                    }
                }
            }
        }

        ans = (ans + MOD) % MOD;
        dp[cur] = ans;
        return ans;
    }

    public static int numDecodings2(String s) {
        int n = s.length();
        long[] dp = new long[n + 1];
        Arrays.fill(dp, 0);

        dp[n] = 1;
        for (int cur = n - 1; cur >= 0; cur--) {
            if (s.charAt(cur) == '0') {
                dp[cur] = 0;
            } else {
                // 当前不是0, 有几种情况.
                // 仅选当前位(可能是数字或者*).
                // 选当前位以及下一位, 第一位是1/2 或者 *, 第二位是0-6或者, 第二位是*

                // 仅选当前位, 区分数字和*
                int cur_char = s.charAt(cur) - '0';
                if (cur_char > 0 && cur_char < 10) {
                    // 是普通数字
                    dp[cur] += dp[cur + 1];
                } else {
                    // 是*
                    dp[cur] += 9 * dp[cur + 1];
                }

                // 选当前以及下一位
                boolean oneOr2 = cur_char == 1 || cur_char == 2;
                boolean curStar = cur_char == ('*' - '0');
                if (cur + 1 < s.length()) {
                    // 第一位是1/2, 第二个是 0-6 / *
                    int next_char = s.charAt(cur + 1) - '0';
                    boolean isNum = next_char >= 0 && next_char <= 9;
                    boolean lessThan6 = isNum && next_char <= 6;
                    boolean nextStar = next_char == ('*' - '0');
                    if (oneOr2) {
                        if ((cur_char == 2 && lessThan6)
                                || (cur_char == 1 && isNum)) {
                            dp[cur] += dp[cur + 2];
                        } else if (nextStar) {
                            if (cur_char == 1) {
                                dp[cur] += 9 * dp[cur + 2];
                            } else if (cur_char == 2) {
                                dp[cur] += 6 * dp[cur + 2];
                            }
                        }
                        // 第一位是*(代表1/2), 第二位可能是数字或者*
                    } else if (curStar) {
                        if (isNum) {
                            if (lessThan6) {
                                dp[cur] += 2 * dp[cur + 2];
                            } else {
                                dp[cur] += dp[cur + 2];
                            }
                        } else if (nextStar) {
                            dp[cur] += 15 * dp[cur + 2];
                        }
                    }
                }
            }

            dp[cur] = (dp[cur] + MOD) % MOD;
            dp[cur] = dp[cur];
        }

        return (int) dp[0];
    }

    public static void main(String[] args) {
        String s = "2*";
        numDecodings(s);
    }
}
