#import "../template.typ": *

#pagebreak()
= 贪心

- 狭义的贪心
  - 每一步都做出在当前状态下最好或最优的选择，从而希望最终的结果是最好或最优的算法
- 广义的贪心
  - 通过分析题目自身的特点和性质，只要发现让求解答案的过程得到加速的结论，都算广义的贪心


== 专题 1

有关贪心的若干现实 & 提醒

1. 不要去纠结严格证明，每个题都去追求严格证明，浪费时间、收益很低，而且千题千面。玄学！
2. 一定要掌握用对数器验证的技巧，这是解决贪心问题的关键
3. 解法几乎只包含贪心思路的题目，代码量都不大
4. 大量累积贪心的经验，重点不是证明，而是题目的特征，以及贪心方式的特征，做好总结方便借鉴
5. 关注题目数据量，题目的解可能来自贪心，也很可能不是，如果数据量允许，能不用贪心就不用（稳）
6. 贪心在笔试中出现概率不低，但是面试中出现概率较低，原因是 淘汰率 vs 区分度
7. 广义的贪心无所不在，可能和别的思路结合，一般都可以通过自然智慧想明白，依然不纠结证明

=== 经典题目

`strs` 中全是非空字符串，要把所有字符串拼接起来，形成字典序最小的结果

```java
// 暴力方法, 为了验证
// 生成所有可能的排列
// 其中选出字典序最小的结果
public static String way1(String[] strs) {
    ArrayList<String> ans = new ArrayList<>();
    f(strs, 0, ans);
    ans.sort((a, b) -> a.compareTo(b));
    return ans.get(0);
}

// 全排列代码，讲解038，常见经典递归过程解析
public static void f(String[] strs, int i, ArrayList<String> ans) {
    if (i == strs.length) {
        StringBuilder path = new StringBuilder();
        for (String s : strs) {
            path.append(s);
        }
        ans.add(path.toString());
    } else {
        for (int j = i; j < strs.length; j++) {
            swap(strs, i, j);
            f(strs, i + 1, ans);
            swap(strs, i, j);
        }
    }
}

public static void swap(String[] strs, int i, int j) {
    String tmp = strs[i];
    strs[i] = strs[j];
    strs[j] = tmp;
}

// strs中全是非空字符串，要把所有字符串拼接起来，形成字典序最小的结果
// 正式方法
// 时间复杂度O(n*logn)
public static String way2(String[] strs) {
    Arrays.sort(strs, (a, b) -> (a + b).compareTo(b + a));
    StringBuilder path = new StringBuilder();
    for (int i = 0; i < strs.length; i++) {
        path.append(strs[i]);
    }
    return path.toString();
}

// 为了验证
// 生成长度1~n的随机字符串数组
public static String[] randomStringArray(int n, int m, int v) {
    String[] ans = new String[(int) (Math.random() * n) + 1];
    for (int i = 0; i < ans.length; i++) {
        ans[i] = randomString(m, v);
    }
    return ans;
}

// 为了验证
// 生成长度1~m，字符种类有v种，随机字符串
public static String randomString(int m, int v) {
    int len = (int) (Math.random() * m) + 1;
    char[] ans = new char[len];
    for (int i = 0; i < len; i++) {
        ans[i] = (char) ('a' + (int) (Math.random() * v));
    }
    return String.valueOf(ans);
}

// 为了验证
// 对数器
public static void main(String[] args) {
    int n = 8; // 数组中最多几个字符串
    int m = 5; // 字符串长度最大多长
    int v = 4; // 字符的种类有几种
    int testTimes = 2000;
    System.out.println("测试开始");
    for (int i = 1; i <= testTimes; i++) {
        String[] strs = randomStringArray(n, m, v);
        String ans1 = way1(strs);
        String ans2 = way2(strs);
        if (!ans1.equals(ans2)) {
            // 如果出错了
            // 可以增加打印行为找到一组出错的例子
            // 然后去debug
            System.out.println("出错了！");
        }
        if (i % 100 == 0) {
            System.out.println("测试到第" + i + "组");
        }
    }
    System.out.println("测试结束");
}
```

其中暴力方法的解析, 见#link("经典递归流程.md")[经典递归流程]

=== #link("https://leetcode.cn/problems/largest-number/")[ 最大数 ]

给定一组非负整数 nums，重新排列每个数的顺序（每个数不可拆分）使之组成一个最大的整数。

> 输出结果可能非常大，所以你需要返回一个字符串而不是整数。

```java
// 测试链接 : https://leetcode.cn/problems/largest-number/
public static String largestNumber(int[] nums) {
    int n = nums.length;
    String[] strs = new String[n];
    for (int i = 0; i < n; i++) {
        strs[i] = String.valueOf(nums[i]);
    }
    Arrays.sort(strs, (a, b) -> (b + a).compareTo(a + b));
    if (strs[0].equals("0")) {
        return "0";
    }
    StringBuilder path = new StringBuilder();
    for (String s : strs) {
        path.append(s);
    }
    return path.toString();
}
```

=== #link("https://leetcode.cn/problems/two-city-scheduling/")[ 两地调度 ]

公司计划面试 `2n` 人。给你一个数组 `costs` ，其中 `costs[i] = [aCosti, bCosti]` 。第 `i` 人飞往 `a` 市的费用为 `aCosti` ，飞往 `b` 市的费用为 `bCosti` 。

返回将每个人都飞到 `a` 、`b` 中某座城市的最低费用，要求每个城市都有 `n` 人抵达。

示例 1：

输入：`costs = [[10,20],[30,200],[400,50],[30,20]]`
输出：`110`
解释：
第一个人去 a 市，费用为 10。
第二个人去 a 市，费用为 30。
第三个人去 b 市，费用为 50。
第四个人去 b 市，费用为 20。

思路, 先让所有人都去 a, 接着算 a 改到 b 的差值, 差值最小的前 n 个去 b.

```java
public static int twoCitySchedCost(int[][] costs) {
    int n = costs.length;
    int[] arr = new int[n];
    int sum = 0;
    for (int i = 0; i < n; i++) {
        arr[i] = costs[i][1] - costs[i][0];
        sum += costs[i][0];
    }
    Arrays.sort(arr);
    int m = n / 2;
    for (int i = 0; i < m; i++) {
        sum += arr[i];
    }
    return sum;
}
```

> 这里面先算都去 a, 再进行修正的技巧值得学习.

=== #link("https://leetcode.cn/problems/minimum-number-of-days-to-eat-n-oranges/")[ 吃掉 N 个橘子的最少天数 ]

厨房里总共有 n 个橘子，你决定每一天选择如下方式之一吃这些橘子：

- 吃掉一个橘子。
- 如果剩余橘子数 n 能被 2 整除，那么你可以吃掉 n/2 个橘子。
- 如果剩余橘子数 n 能被 3 整除，那么你可以吃掉 2\*(n/3) 个橘子。

请你返回吃掉所有 n 个橘子的最少天数。

=== 示例 1：

> 输入：n = 10
> 输出：4
> 解释：你总共有 10 个橘子。
> 第 1 天：吃 1 个橘子，剩余橘子数 10 - 1 = 9。
> 第 2 天：吃 6 个橘子，剩余橘子数 9 - 2*(9/3) = 9 - 6 = 3。（9 可以被 3 整除）
> 第 3 天：吃 2 个橘子，剩余橘子数 3 - 2*(3/3) = 3 - 2 = 1。
> 第 4 天：吃掉最后 1 个橘子，剩余橘子数 1 - 1 = 0。
> 你需要至少 4 天吃掉 10 个橘子。

=== 解法

1. 吃掉一个橘子
2. 如果 n 能被 2 整除，吃掉一半的橘子，剩下一半
3. 如果 n 能被 3 正数，吃掉三分之二的橘子，剩下三分之一

因为方法 2 和 3，是按比例吃橘子，所以必然会非常快, 所以，决策如下：

- 可能性 1：为了使用 2 方法，先把橘子吃成 2 的整数倍，然后直接干掉一半，剩下的 n/2 调用递归, 即，`n % 2 + 1 + minDays(n/2)`
- 可能性 2：为了使用 3 方法，先把橘子吃成 3 的整数倍，然后直接干掉三分之二，剩下的 n/3 调用递归, 即，`n % 3 + 1 + minDays(n/3)`

这两个中选择一个最小的.

至于方法 1，完全是为了这两种可能性服务的，因为能按比例吃，肯定比一个一个吃快(显而易见的贪心)

```java
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
```

复杂度分析.

log2(n)+log3(n)

牛逼!!!

=== #link("https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37")[最多线段重合问题]

每一个线段都有 `start` 和 `end` 两个数据项，表示这条线段在 X 轴上从 `start` 位置开始到 `end` 位置结束。给定一批线段，求所有重合区域中最多重合了几个线段，首尾相接的线段不算重合。
例如：线段`[1,2]`和线段`[2.3]`不重合。 线段`[1,3]`和线段`[2,3]`重合

- 输入描述：
  - 第一行一个数`N`，表示有`N`条线段
  - 接下来`N`行每行`2`个数，表示线段起始和终止位置
- 输出描述：
  - 输出一个数，表示同一个位置最多重合多少条线段

=== 解法

```java

```

=== #link("https://leetcode.cn/problems/course-schedule-iii/")[ 课程表 III ]

这里有 `n` 门不同的在线课程，按从 `1` 到 `n` 编号。给你一个数组 `courses` ，其中 `courses[i] = [durationi, lastDayi]` 表示第 `i` 门课将会持续上 `durationi` 天课，并且必须在不晚于 `lastDayi` 的时候完成。你的学期从第 1 天开始。且不能同时修读两门及两门以上的课程。

返回你最多可以修读的课程数目。

#example("Example")[
- 输入：`courses = [[100, 200], [200, 1300], [1000, 1250], [2000, 3200]]`
- 输出：`3`
- 解释：
  - 这里一共有 4 门课程，但是你最多可以修 3 门：
  - 首先，修第 1 门课，耗费 100 天，在第 100 天完成，在第 101 天开始下门课。
  - 第二，修第 3 门课，耗费 1000 天，在第 1100 天完成，在第 1101 天开始下门课程。
  - 第三，修第 2 门课，耗时 200 天，在第 1300 天完成。
  - 第 4 门课现在不能修，因为将会在第 3300 天完成它，这已经超出了关闭日期。
]

=== 解法

早结束的课程,优先考虑. 晚结束的课程, 后面考虑.

当前时间+代价<=截止日期


