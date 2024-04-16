package class046;

/**
 * Code03_Code03_NumberOfSubarraySumEqualsAim
 */
public class Code03_Code03_NumberOfSubarraySumEqualsAim {
    public static int subarraySum(int[] nums, int aim) {
        HashMap<Integer, Integer> map = new HashMap<>();
        // 0这个前缀和，在没有任何数字的时候，已经有1次了
        map.put(0, 1);
        int ans = 0;
        for (int i = 0, sum = 0; i < nums.length; i++) {
            // sum : 0...i前缀和
            sum += nums[i];
            ans += map.getOrDefault(sum - aim, 0);
            map.put(sum, map.getOrDefault(sum, 0) + 1);
        }
        return ans;
    }
}
