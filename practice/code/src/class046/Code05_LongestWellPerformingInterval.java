package class046;

import java.util.HashMap;

/**
 * Code05_LongestWellPerformingInterval
 */
public class Code05_LongestWellPerformingInterval {
    public static int longestWPI(int[] hours) {
        // 某个前缀和，最早出现的位置
        HashMap<Integer, Integer> map = new HashMap<>();
        // 0这个前缀和，最早出现在-1，一个数也没有的时候
        map.put(0, -1);
        int ans = 0;
        for (int i = 0, sum = 0; i < hours.length; i++) {
            sum += hours[i] > 8 ? 1 : -1;
            if (sum > 0) {
                ans = i + 1;
            } else {
                // sum <= 0
                if (map.containsKey(sum - 1)) {
                    ans = Math.max(ans, i - map.get(sum - 1));
                }
            }
            if (!map.containsKey(sum)) {
                map.put(sum, i);
            }
        }
        return ans;
    }
}
