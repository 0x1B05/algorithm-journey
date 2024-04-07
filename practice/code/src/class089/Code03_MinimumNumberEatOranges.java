package class089;

import java.util.HashMap;

// 吃掉N个橘子的最少天数
// 厨房里总共有 n 个橘子，你决定每一天选择如下方式之一吃这些橘子
// 1）吃掉一个橘子
// 2) 如果剩余橘子数 n 能被 2 整除，那么你可以吃掉 n/2 个橘子
// 3) 如果剩余橘子数 n 能被 3 整除，那么你可以吃掉 2*(n/3) 个橘子
// 每天你只能从以上 3 种方案中选择一种方案
// 请你返回吃掉所有 n 个橘子的最少天数
// 测试链接 : https://leetcode.cn/problems/minimum-number-of-days-to-eat-n-oranges/
public class Code03_MinimumNumberEatOranges {
    public static HashMap<Integer, Integer> map = new HashMap<>();

    public static int minDays(int n) {
        if (n <= 1) {
            map.put(n, n);
            return n;
        }
        if (map.containsKey(n)) {
            return map.get(n);
        } else {
            int ans = Math.min(n % 2 + 1 + minDays(n / 2), n % 3 + 1 + minDays(n / 3));
            map.put(n, ans);
            return ans;
        }
    }
}
