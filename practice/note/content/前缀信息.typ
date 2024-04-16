#import "../template.typ": *
#pagebreak()

= 构建前缀信息的技巧-解决子数组相关问题
解决如下问题，时间复杂度O(n)

== #link(
  "https://leetcode.cn/problems/range-sum-query-immutable/description/",
)[题目1: 子数组范围求和]
给定一个整数数组 `nums`，处理以下类型的多个查询:

- 计算索引 `left` 和 `right` （包含 `left` 和 `right`）之间的 `nums` 元素的 和
  ，其中 `left` <= `right`

- 实现 `NumArray` 类：
  - `NumArray(int[] nums)` 使用数组 `nums` 初始化对象
  - `int sumRange(int i, int j)` 返回数组 `nums` 中索引 `left` 和 `right` 之间的元素的
    总和 ，包含 `left` 和 `right` 两点（也就是 `nums[left] + nums[left + 1] + ... + nums[right]` )

  #example("Example")[

  输入：
  ```
  ["NumArray", "sumRange", "sumRange", "sumRange"]
  [[[-2, 0, 3, -5, 2, -1]], [0, 2], [2, 5], [0, 5]]
  ```
  输出：
  ```
  [null, 1, -1, -3]
  ```

  解释：
  ```java
  NumArray numArray = new NumArray([-2, 0, 3, -5, 2, -1]);
  numArray.sumRange(0, 2); // return 1 ((-2) + 0 + 3)
  numArray.sumRange(2, 5); // return -1 (3 + (-5) + 2 + (-1))
  numArray.sumRange(0, 5); // return -3 ((-2) + 0 + 3 + (-5) + 2 + (-1))
  ```
  ]

== #link(
  "https://www.nowcoder.com/practice/36fb0fd3c656480c92b569258a1223d5",
)[题目2 : 未排序数组中累加和为给定值的最长子数组长度 ]
给定一个无序数组`arr`, 其中元素可正、可负、可0。给定一个整数`k`，求`arr`所有子数组中累加和为`k`的最长子数组长度

输入描述： 第一行两个整数`N`, `k`。`N`表示数组长度，`k`的定义已在题目描述中给出
第二行`N`个整数表示数组内的数

输出描述： 输出一个整数表示答案

#example("Example")[
输入：
```
5 0
1 -2 1 1 1
```
输出：
```
3
```
]

#tip("Tip")[
  - $1⩽N⩽10^5$
  - $−10^9⩽k⩽10^9$
  - $−100⩽"arr"_i⩽100$
]

== #link(
  "https://leetcode.cn/problems/subarray-sum-equals-k/",
)[ 题目3: 和为 `aim` 的子数组 ]

构建 前缀和 出现的次数。返回 无序数组中 累加和为给定值的 子数组数量
#code(caption: [ 题目3: 和为 `aim` 的子数组 ])[
```java
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
```
]

== #link(
  "https://www.nowcoder.com/practice/545544c060804eceaed0bb84fcd992fb",
)[ 题目4: 正数与负数个数相等的最长子数组 ]

构建 前缀和 最早出现的位置。返回 无序数组中 正数和负数个数相等的 最长子数组长度
#code(
  caption: [ 题目4: 正数与负数个数相等的最长子数组 ],
)[
```java
public class Code04_PositivesEqualsNegtivesLongestSubarray {
    public static int MAXN = 100001;
    public static int n;

    public static int[] arr = new int[MAXN];
    public static HashMap<Integer, Integer> map = new HashMap<>();

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0, num; i < n; i++) {
                in.nextToken();
                num = (int) in.nval;
                arr[i] = num != 0 ? (num > 0 ? 1 : -1) : 0;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int compute() {
        map.clear();
        map.put(0, -1);
        int ans = 0;
        for (int i = 0, sum = 0; i < n; i++) {
            sum += arr[i];
            if (map.containsKey(sum)) {
                ans = Math.max(ans, i - map.get(sum));
            } else {
                map.put(sum, i);
            }
        }
        return ans;
    }
}
```
]

== #link(
  "https://leetcode.cn/problems/longest-well-performing-interval/",
)[ 题目5: 表现良好时间段的最大长度 ]
构建 前缀和 最早出现的位置。表现良好的最长时间段问题

#code(caption: [ 题目5: 表现良好时间段的最大长度 ])[
```java
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
```
]

== 题目6 :
构建 前缀和余数
最晚出现的位置。移除的最短子数组长度，使得剩余元素的累加和能被p整除

== 题目7 :
构建 前缀奇偶状态 最早出现的位置。每个元音包含偶数次的 最长子串长度
