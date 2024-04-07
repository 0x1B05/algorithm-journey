#import "../template.typ": *

#pagebreak()
= 经典递归流程解析

== #link("https://www.nowcoder.com/practice/92e6247998294f2c933906fdedbc6e6a")[ 字符串的全部子序列 ]

返回字符串全部子序列，子序列要求去重。时间复杂度$O(n * 2^n)$


#code(caption: [解答])[
```java
public static String[] generatePermutation1(String str) {
    char[] s = str.toCharArray();
    HashSet<String> set = new HashSet<>();
    f1(s, 0, new StringBuilder(), set);
    int m = set.size();
    String[] ans = new String[m];
    int i = 0;
    for (String cur : set) {
        ans[i++] = cur;
    }
    return ans;
}

// s[i...]，之前决定的路径path，set收集结果时去重
public static void f1(char[] s, int i, StringBuilder path, HashSet<String> set) {
    if (i == s.length) {
        set.add(path.toString());
    } else {
        path.append(s[i]); // 加到路径中去
        f1(s, i + 1, path, set);
        path.deleteCharAt(path.length() - 1); // 从路径中移除
        f1(s, i + 1, path, set);
    }
}
```
]

== #link("https://leetcode.cn/problems/subsets-ii/")[ 子集 II ]

返回数组的所有组合，可以无视元素顺序。时间复杂度 $O(n * 2^n)$

== #link("https://leetcode.cn/problems/permutations/")[ 全排列 ]

返回没有重复值数组的全部排列。时间复杂度 O(n! \* n)

#code(caption: [解答])[
```java
public static List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> res = new ArrayList<List<Integer>>();
    f(nums, 0, res);
    return res;
}
public static void f(int[] nums, int cur, List<List<Integer>> res) {
    if (cur == nums.length - 1) {
        List<Integer> ans = new ArrayList<>();
        for (int num : nums) {
            ans.add(num);
        }
        res.add(ans);
    } else {
        for (int i = cur; i < nums.length; i++) {
            swap(nums, cur, i);
            f(nums, cur+1, res);
            swap(nums, cur, i);
        }
    }
}

public static void swap(int[] nums, int i, int j) {
    if (i == j) {
        return;
    }
    nums[i] = nums[i] ^ nums[j];
    nums[j] = nums[i] ^ nums[j];
    nums[i] = nums[i] ^ nums[j];
}
```
]

=== 解释

n 的全排列以这种视角理解:

- 两个数:
  - `12` <-> `21`
- 三个数:
  - `123` <-> `132`
  - `213` <-> `231`
  - `321` <-> `312`

== 题目 4

返回可能有重复值数组的全部排列，排列要求去重。时间复杂度 $O(n * n!)$

== 题目 5

用递归逆序一个栈。时间复杂度 $O(2^n)$

== 题目 6

用递归排序一个栈。时间复杂度 $O(2^n)$

== 题目 7

打印 n 层汉诺塔问题的最优移动轨迹。时间复杂度 $O(2^n)$
