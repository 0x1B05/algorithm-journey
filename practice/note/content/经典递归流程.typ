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

==== 解答
#code(caption: [岛屿数目 - 解答])[
```java
public class Code01_NumberOfIslands {
    public static int numIslands(char[][] grid) {
        int num = 0;
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j]=='1') {
                    ++num;
                    infect(grid,i,j);
                }
            }
        }

        return num;
    }

    public static void infect(char[][] grid, int i, int j){
        if( i < 0 || i >= grid.length || j < 0 || j >= grid[0].length || grid[i][j] != '1' ){
            return;
        }
        // 标记走过的点为0
        grid[i][j] = 0;
        infect(grid, i-1, j);
        infect(grid, i+1, j);
        infect(grid, i, j+1);
        infect(grid, i, j-1);
    }
}
```
]

#tip("Tip")[
- 时间复杂度: O(n\*m)。 想一个格子会被谁调用(上下左右邻居，最多被访问4次，但是这么多邻居调用都会直接退出，每次都是O(1))。
  - 大流程，每个格子访问1次O(n\*m)
  - 总共的 infect 每个格子最多访问4次O(n\*m)
  - O(n\*m)+O(n\*m)
- 和并查集一样，但是常数时间会更好。
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

==== 解答
把边界的`'O'`进行感染，把`'O'`->`'F'`，然后遍历矩阵，把`'O'`->`'X'`，最后把`'F'`->`'O'`。

#code(caption: [被围绕的区域 - 解答])[
```java
class Code02_SurroundedRegions {
    public void solve(char[][] board) {
        int n = board.length;
        int m = board[0].length;

        for (int i = 0; i < n; i++) {
            if(board[i][0]=='O'){
                infect(board, i, 0, 'O', 'F');
            }
            if(board[i][m-1]=='O'){
                infect(board, i, m-1, 'O', 'F');
            }
        }

        for (int j = 1; j < m-1; j++) {
            if(board[0][j]=='O'){
                infect(board, 0, j, 'O', 'F');
            }
            if(board[n-1][j]=='O'){
                infect(board, n-1, j, 'O', 'F');
            }
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j]=='O') {
                    board[i][j] = 'X';
                }
                if (board[i][j]=='F') {
                    board[i][j] = 'O';
                }
            }
        }
    }

    public static void infect(char[][] board, int i, int j, char dest, char infected){
        if( i < 0 || i >= board.length || j < 0 || j >= board[0].length || board[i][j] != dest ){
            return;
        }

        board[i][j] = infected;
        infect(board, i-1, j, dest, infected);
        infect(board, i+1, j, dest, infected);
        infect(board, i, j+1, dest, infected);
        infect(board, i, j-1, dest, infected);
    }
}
```
]

#tip("Tip")[
注意什么时候只要用循环就可以了。有时不需要感染。
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

==== 解答
#code(caption: [最大人工岛 - 解答])[
```java
public class Code03_MakingLargeIsland {

    public static int largestIsland(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;

        int id = 2;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 1) {
                    infect(grid, i, j, id++);
                }
            }
        }

        int ans = 0;
        int[] sizes = new int[id];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] > 1) {
                    ans = Math.max(ans, ++sizes[grid[i][j]]);
                }
            }
        }

        // 讨论所有的0，变成1，能带来的最大岛的大小
        boolean[] visited = new boolean[id];
        int up, down, left, right, merge;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 0) {
                    up = i > 0 ? grid[i - 1][j] : 0;
                    down = i + 1 < n ? grid[i + 1][j] : 0;
                    left = j > 0 ? grid[i][j - 1] : 0;
                    right = j + 1 < m ? grid[i][j + 1] : 0;
                    visited[up] = true;
                    merge = 1 + sizes[up];
                    if (!visited[down]) {
                        merge += sizes[down];
                        visited[down] = true;
                    }
                    if (!visited[left]) {
                        merge += sizes[left];
                        visited[left] = true;
                    }
                    if (!visited[right]) {
                        merge += sizes[right];
                        visited[right] = true;
                    }
                    ans = Math.max(ans, merge);
                    visited[up] = false;
                    visited[down] = false;
                    visited[left] = false;
                    visited[right] = false;
                }
            }
        }
        return ans;
    }

    public static void infect(int[][] grid, int i, int j, int id) {
        if (i < 0 || i == n || j < 0 || j == m || grid[i][j] != 1) {
            return;
        }

        grid[i][j] = id;
        dfs(grid, i - 1, j, id);
        dfs(grid, i + 1, j, id);
        dfs(grid, i, j - 1, id);
        dfs(grid, i, j + 1, id);
    }
}
```
]

#tip("Tip")[
时间复杂度：O(n\*m)
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

==== 解答
1. 炮位-1
2. 天花板感染
3. 时光倒流处理炮弹(炮弹逆着看，加上去看看天花板上面的砖块数量是否有变化)

#code(caption: [打砖块 - 解答])[
```java
public class Code04_BricksFallingWhenHit {
    public int[] hitBricks(int[][] grid, int[][] hits) {
        int n = grid.length;
        int m = grid[0].length;
        int[] ans = new int[hits.length];
        // 只有一行
        if (n==1){
            return ans;
        }

        for (int[] hit : hits) {
            grid[hit[0]][hit[1]]--;
        }

        for (int j = 0; j < m; j++) {
            if(grid[0][j]==1){
                infect(grid, 0, j);
            }
        }

        // 时光倒流
        for (int cur = hits.length-1; cur >= 0; cur--) {
            int x = hits[cur][0];
            int y = hits[cur][1];
            grid[x][y]++;

            // 当前是1
            // 上下左右存在2 或者 当前是第一行
            boolean worth = grid[x][y] == 1 && (
                x == 0
                || (x-1 >= 0 && grid[x - 1][y] == 2)
                || (x+1 < n && grid[x + 1][y] == 2)
                || (y-1 >= 0 && grid[x][y - 1] == 2)
                || (y+1 < m && grid[x][y + 1] == 2)
            );
            if(worth){
                int infected = infect(grid, x, y);
                ans[cur] = infected-1;
            }
        }
        return ans;
    }

    // 感染数量
    public static int infect(int[][] grid, int i, int j){
        if( i < 0 || i >= grid.length || j < 0 || j >= grid[0].length || grid[i][j] != 1){
            return 0;
        }

        grid[i][j] = 2;
        return 1 + infect(grid, i-1, j) + infect(grid, i+1, j) + infect(grid, i, j+1) + infect(grid, i, j-1);
    }
}
```
]

#tip("Tip")[
可以用并查集，但是洪水填充最快。
]
