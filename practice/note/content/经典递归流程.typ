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

== 洪水填充

=== #link("https://leetcode.cn/problems/number-of-islands/")[题目1: 岛屿数目]

给你一个由 `'1'`（陆地）和 `'0'`（水）组成的的二维网格，请你计算网格中岛屿的数量。岛屿总是被水包围，并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成。此外，你可以假设该网格的四条边均被水包围。

#example("Example")[
- 输入：
```
grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
```
- 输出：`3`
]

#tip("Tip")[
- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` 的值为 `'0'` 或 `'1'`
]

=== #link("https://leetcode.cn/problems/surrounded-regions/")[题目2: 被围绕的区域]

给你一个 `m x n` 的矩阵 board ，由若干字符 `'X'` 和 `'O'` ，找到所有被 `'X'` 围绕的区域，并将这些区域里所有的 `'O'` 用 `'X'` 填充。

#example("Example")[
- 输入：
```
board = [
  ["X","X","X","X"],
  ["X","O","O","X"],
  ["X","X","O","X"],
  ["X","O","X","X"]
]
```
- 输出：
```
[
  ["X","X","X","X"],
  ["X","X","X","X"],
  ["X","X","X","X"],
  ["X","O","X","X"]
]
```
- 解释：被围绕的区间不会存在于边界上，换句话说，任何边界上的 `'O'` 都不会被填充为 `'X'`。 任何不在边界上，或不与边界上的 `'O'` 相连的 `'O'` 最终都会被填充为 `'X'`。如果两个元素在水平或垂直方向相邻，则称它们是“相连”的。
]
#tip("Tip")[
- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 200`
- `board[i][j]` 为 `'X'` 或 `'O'`
]


=== #link("https://leetcode.cn/problems/making-a-large-island/")[题目3: 最大人工岛]

给你一个大小为 `n x n` 二进制矩阵 `grid` 。最多 只能将一格 `0` 变成 `1` 。返回执行此操作后，`grid` 中最大的岛屿面积是多少(岛屿 由一组上、下、左、右四个方向相连的 1 形成)？

#example("Example")[
- 输入: grid = [[1, 0], [0, 1]]
- 输出: 3
- 解释: 将一格0变成1，最终连通两个小岛得到面积为 3 的岛屿。
]

#example("Example")[
- 输入: grid = [[1, 1], [1, 0]]
- 输出: 4
- 解释: 将一格0变成1，岛屿的面积扩大为 4。
]

#example("Example")[
- 输入: grid = [[1, 1], [1, 1]]
- 输出: 4
- 解释: 没有0可以让我们变成1，面积依然为 4。
]

#tip("Tip")[
- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 500`
- `grid[i][j] 为 0 或 1`
]

=== #link("https://leetcode.cn/problems/bricks-falling-when-hit/")[题目4: 打砖块]

有一个 `m x n` 的二元网格 `grid` ，其中 `1` 表示砖块，`0` 表示空白。砖块 稳定（不会掉落）的前提是：

- 一块砖直接连接到网格的顶部，或者
- 至少有一块相邻（4 个方向之一）砖块 稳定 不会掉落时

给你一个数组 `hits` ，这是需要依次消除砖块的位置。每当消除 `hits[i] = (rowi, coli)` 位置上的砖块时，对应位置的砖块（若存在）会消失，然后其他的砖块可能因为这一消除操作而 掉落 。一旦砖块掉落，它会 立即 从网格 `grid` 中消失（即，它不会落在其他稳定的砖块上）。

返回一个数组 `result` ，其中 `result[i]` 表示第 `i` 次消除操作对应掉落的砖块数目。

#example("Example")[
- 输入：`grid = [[1,0,0,0],[1,1,1,0]], hits = [[1,0]]`
- 输出：`[2]`
- 解释：网格开始为：
  ```
  [[1,0,0,0]，
  [1,1,1,0]]
  ```
  消除 (1,0) 处加粗的砖块，得到网格：
  ```
  [[1,0,0,0]
  [0,1,1,0]]
  ```
  两个加粗的砖不再稳定，因为它们不再与顶部相连，也不再与另一个稳定的砖相邻，因此它们将掉落。得到网格：
  ```
  [[1,0,0,0],
  [0,0,0,0]]
  ```
  因此，结果为 `[2]` 。
]

#tip("Tip")[
注意，消除可能指向是没有砖块的空白位置，如果发生这种情况，则没有砖块掉落。
]

#tip("Tip")[
- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `grid[i][j]` 为 `0` 或 `1`
- `1 <= hits.length <= 4 * 10^4`
- `hits[i].length == 2`
- `0 <= xi <= m - 1`
- `0 <= yi <= n - 1`
- 所有 `(xi, yi)` 互不相同
]

