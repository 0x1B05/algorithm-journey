public class Code01_SumRanger {
    /**
     * Your NumArray object will be instantiated and called as such:
     * NumArray obj = new NumArray(nums);
     * int param_1 = obj.sumRange(left,right);
     */
    public int[] sum ;

    public void NumArray(int[] nums) {
        int n = nums.length;
        sum = new int[n+1];
        for (int i = 0; i < n; i++) {
            sum[i+1] = sum[i]+nums[i];
        }
    }

    public int sumRange(int left, int right) {
        return sum[right+1]-sum[left];
    }
}
