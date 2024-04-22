#import "../template.typ": *
#pagebreak()
= 图

== 建图

- 邻接矩阵(适合点的数量不多的图)
- 邻接表(最常用的方式)
- 链式前向星(空间要求严苛情况下使用。比赛必用，大厂笔试、面试不常用)


#code(caption: [三种方式建图])[
```java
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Code01_CreateGraph
 */
public class Code01_CreateGraph {
    // 点的最大数量
    public static int MAXN = 11;
    // 边的最大数量
    public static int MAXM = 21;

    // 邻接矩阵
    public static int[][] graph1 = new int[MAXN][MAXN];

    // 邻接表
    // 无权图
    // public static ArrayList<ArrayList<Integer>> graph2;
    // 有权图
    public static ArrayList<ArrayList<int[]>> graph2 = new ArrayList<>();

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt = 1;

    // n->节点数量
    public static void build(int n) {
        // 邻接矩阵清空
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                graph1[i][j] = 0;
            }
        }

        // 邻接表清空
        graph2.clear();
        // 要准备n+1个，0 下标不用
        for (int i = 0; i <= n; i++) {
            graph2.add(new ArrayList<>());
        }

        // 链式前向星清空
        cnt = 1;
        Arrays.fill(head, 1, n + 1, 0);
    }
    // 链式前向星加边
    public static void addEdge(int u, int v, int w) {
        // u -> v , 边权重是w
        to[cnt] = v;
        weight[cnt] = w;
        next[cnt] = head[u];
        head[u] = cnt++;
    }

    // 建立有向图带权图
    public static void directGraph(int[][] edges) {
        // edge[i][0]->start edge[i][1]->end edge[i][2]->weight

        // 邻接矩阵加边
        for (int[] edge : edges) {
            graph1[edge[0]][edge[1]] = edge[2];
        }
        // 邻接表加边
        for (int[] edge : edges) {
            // graph2.get(edge[0]).add(edge[1]);
            graph2.get(edge[0]).add(new int[] {edge[1], edge[2]});
        }

        // 链式前向星加边
        for (int[] edge : edges) {
            addEdge(edge[0], edge[1], edge[2]);
        }
    }

    // 建立有向图带权图
    public static void undirectGraph(int[][] edges) {
        // edge[i][0]->start edge[i][1]->end edge[i][2]->weight

        // 邻接矩阵加边
        for (int[] edge : edges) {
            graph1[edge[0]][edge[1]] = edge[2];
            graph1[edge[1]][edge[0]] = edge[2];
        }
        // 邻接表加边
        for (int[] edge : edges) {
            // graph2.get(edge[0]).add(edge[1]);
            // graph2.get(edge[1]).add(edge[0]);
            graph2.get(edge[0]).add(new int[] {edge[1], edge[2]});
            graph2.get(edge[1]).add(new int[] {edge[0], edge[2]});
        }

        // 链式前向星加边
        for (int[] edge : edges) {
            addEdge(edge[0], edge[1], edge[2]);
            addEdge(edge[1], edge[0], edge[2]);
        }
    }
    public static void traversal(int n) {
        System.out.println("邻接矩阵遍历: ");
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                System.out.println(i + "->" + j + " weight:" + graph1[i][j]);
            }
        }
        System.out.println("邻接表遍历: ");
        for (int i = 1; i <= n; i++) {
            for (int[] edge : graph2.get(i)) {
                System.out.println(i + "->" + edge[0] + " weight:" + edge[1]);
            }
        }

        System.out.println("链式前向星遍历: ");
        for (int i = 1; i <= n; i++) {
            for (int ei = head[i]; ei > 0; ei = next[ei]) {
                System.out.println(i + "->" + to[ei] + " weight:" + weight[ei]);
            }
        }
    }

    public static void main(String[] args) {
        // 理解了带权图的建立过程，也就理解了不带权图
        // 点的编号为1...n
        // 例子1自己画一下图，有向带权图，然后打印结果
        int n1 = 4;
        int[][] edges1 = {{1, 3, 6}, {4, 3, 4}, {2, 4, 2}, {1, 2, 7}, {2, 3, 5}, {3, 1, 1}};
        build(n1);
        directGraph(edges1);
        traversal(n1);
        System.out.println("==============================");
        // 例子2自己画一下图，无向带权图，然后打印结果
        int n2 = 5;
        int[][] edges2 = {
            {3, 5, 4}, {4, 1, 1}, {3, 4, 2}, {5, 2, 4}, {2, 3, 7}, {1, 5, 5}, {4, 2, 6}};
        build(n2);
        undirectGraph(edges2);
        traversal(n2);
    }
}
```
]

== 拓扑排序

每个节点的前置节点都在这个节点之前

要求：有向图、没有环

拓扑排序的顺序可能不只一种。拓扑排序也可以用来判断有没有环。

1）在图中找到所有入度为0的点
2）把所有入度为0的点在图中删掉，重点是删掉影响！继续找到入度为0的点并删掉影响
3）直到所有点都被删掉，依次删除的顺序就是正确的拓扑排序结果
4）如果无法把所有的点都删掉，说明有向图里有环

=== 题目1: 拓扑排序模板

==== #link("https://leetcode.cn/problems/course-schedule-ii/")[leetcode模板]
现在你总共有 `numCourses` 门课需要选，记为 `0` 到 `numCourses - 1`。给你一个数组 `prerequisites` ，其中 `prerequisites[i] = [ai, bi]` ，表示在选修课程 `ai` 前 必须 先选修 `bi` 。
例如，想要学习课程 `0` ，你需要先完成课程 `1` ，我们用一个匹配来表示：`[0,1]` 。

返回你为了学完所有课程所安排的学习顺序。可能会有多个正确的顺序，你只要返回 任意一种 就可以了。如果不可能完成所有课程，返回 一个空数组 。

#example("Example")[
- 输入：`numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]`
- 输出：`[0,2,1,3]`
- 解释：总共有 `4` 门课程。要学习课程 `3`，你应该先完成课程 `1` 和课程 `2`。并且课程 `1` 和课程 `2` 都应该排在课程 `0` 之后。因此，一个正确的课程顺序是 `[0,1,2,3]` 。另一个正确的排序是 `[0,2,1,3]` 。
]

#tip("Tip")[
- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= numCourses * (numCourses - 1)`
- `prerequisites[i].length == 2`
- `0 <= ai, bi < numCourses`
- `ai != bi`
- 所有`[ai, bi]` 互不相同
]

#code(caption: [leetcode拓扑排序模板])[
```java
public class Code02_TopoSortDynamicLeetcode {
    public static int[] findOrder(int n, int[][] pre) {
        // pre[i][1] -> pre[i][0]

        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        int[] indegree = new int[n];

        // 初始化
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }

        // 建图
        for (int[] edge : pre) {
            graph.get(edge[1]).add(edge[0]);
            indegree[edge[0]]++;
        }

        // 初始化queue
        int[] queue = new int[n];
        int l = 0, r = 0;

        for (int i = 0; i < n; i++) {
            if (indegree[i] == 0) {
                queue[r++] = i;
            }
        }

        // 逐渐干掉入度为0的节点
        int cnt = 0;
        while (l < r) {
            int cur = queue[l++];
            cnt++;
            for (int next : graph.get(cur)) {
                if (--indegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }

        return cnt==n?queue:new int[0];
    }
}
```
]
==== #link("https://www.nowcoder.com/practice/88f7e156ca7d43a1a535f619cd3f495c")[newcoder模板(邻接表动态)]
给定一个包含`n`个点`m`条边的有向无环图，求出该图的拓扑序。若图的拓扑序不唯一，输出任意合法的拓扑序即可。若该图不能拓扑排序，输出`−1`。

- 输入描述：
  - 第一行输入两个整数`n`,`m`( `1≤n,m≤2*10^5`)，表示点的个数和边的条数。
  - 接下来的m行，每行输入两个整数`ui`,`vi`(`1≤u,v≤n`)，表示`ui`到`vi`之间有一条有向边。
- 输出描述：
  - 若图存在拓扑序，输出一行n个整数，表示拓扑序。否则输出`−1`。

#example("Example")[
- 输入：
  ```
  5 4
  1 2
  2 3
  3 4
  4 5
  ```
- 输出：
  ```
  1 2 3 4 5
  ```
]

#code(caption: [newcoder拓扑排序模板-静态])[
```java
public class Code02_TopoSortDynamicNowcoder {
    public static int MAXN = 200001;
    public static int MAXM = 200001;
    public static int l,r;
    public static int n,m;
    public static int[] indgree = new int[MAXN];
    public static int[] queue = new int[MAXN];

    public static boolean topSort(ArrayList<ArrayList<Integer>> graph) {
        l = 0; r = 0;
        for (int i = 1; i <= n; i++) {
            if(indgree[i]==0){
                queue[r++] = i;
            }
        }

        int cnt = 0;
        while(l<r){
            int cur = queue[l++];
            cnt++;
            for (int next : graph.get(cur)) {
                if(--indgree[next]==0){
                    queue[r++] = next;
                }
            }
        }

        boolean ans = cnt==n?true:false;
        return ans;
    }
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            m = (int) in.nval;
            in.nextToken();

            for (int i = 0; i < m; i++) {
                int from = (int) in.nval;
                in.nextToken();
                int to = (int) in.nval;
                in.nextToken();
                graph.get(from).add(to);
                indgree[to]++;
            }
            if (!topSort(graph)) {
                out.println(-1);
            } else {
                for (int i = 0; i < n-1; i++) {
                    System.out.print(queue[i] + " ");
                }
                out.println(queue[n-1]);
            }
        }
        out.flush();
        out.close();
        br.close();
    }
}
```
]
==== #link("https://www.nowcoder.com/practice/88f7e156ca7d43a1a535f619cd3f495c")[newcoder模板(邻接表静态)]

#code(caption: [newcoder拓扑排序模板-静态])[
```java
public class Code02_TopoSortStaticNowcoder {
    public static int MAXN = 200001;
    public static int MAXM = 200001;
    public static int l,r;
    public static int n,m;

    public static int cnt;
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] indgree = new int[MAXN];

    public static int[] queue = new int[MAXN];

    public static void init(){
        cnt = 1;
        Arrays.fill(head, 0,n+1,0);
        Arrays.fill(indgree, 0,n+1,0);

    }
    public static void addEdge(int from, int t){
        next[cnt] = head[from];
        to[cnt] = t;
        head[from] = cnt++;
    }
    public static boolean topSort() {
        l=0;r=0;
        for (int i = 1; i <= n; i++) {
            if (indgree[i]==0) {
                queue[r++] = i;
            }
        }
        int cnt = 0;
        while(l<r){
            int cur = queue[l++];
            cnt++;
            for (int ei = head[cur]; ei > 0; ei = next[ei]) {
                indgree[to[ei]]--;
                if(indgree[to[ei]]==0){
                    queue[r++] = to[ei];
                }
            }
        }
        return cnt==n;
    }
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            init();

            m = (int) in.nval;
            in.nextToken();

            for (int i = 0; i < m; i++) {
                int from = (int) in.nval;
                in.nextToken();
                int t = (int) in.nval;
                in.nextToken();
                addEdge(from, t);
                indgree[t]++;
            }
            if (!topSort()) {
                out.println(-1);
            } else {
                for (int i = 0; i < n-1; i++) {
                    System.out.print(queue[i] + " ");
                }
                out.println(queue[n-1]);
            }
        }
        out.flush();
        out.close();
        br.close();
    }
}
```
]

==== #link("https://www.luogu.com.cn/problem/U107394")[洛谷模板-字典序最小的拓扑排序]
有向无环图上有`n`个点，`m`条边。求这张图字典序最小的拓扑排序的结果。字典序最小指希望排好序的结果中，比较靠前的数字尽可能小。

- 输入格式
  - 第一行是用空格隔开的两个整数`n`和`m`，表示`n`个点和`m`条边。
  - 接下来是`m`行，每行用空格隔开的两个数`u`和`v`，表示有一条从`u`到`v`的边。
- 输出格式
  - 输出一行，拓扑排序的结果，数字之间用空格隔开

#example("Example")[
- 样例输入 
  ```
  5 3
  1 2
  2 4
  4 3
  ```
- 样例输出 
  ```
  1 2 4 3 5
  ```
]

#tip("Tip")[
- $1 lt.eq n,m lt.eq 10^5$
- 图上可能有重边
]

=== #link("https://leetcode.cn/problems/Jf1JuT/description/")[ 题目2: 火星词典]

现有一种使用英语字母的外星文语言，这门语言的字母顺序与英语顺序不同。 给定一个字符串列表 `words` ，作为这门语言的词典，`words` 中的字符串已经 按这门新语言的字母顺序进行了排序 。 请你根据该词典还原出此语言中已知的字母顺序，并 _按字母递增顺序_ 排列。若不存在合法字母顺序，返回 `""` 。若存在多种可能的合法字母顺序，返回其中 任意一种 顺序即可。

#tip("Tip")[
- 字符串 `s` 字典顺序小于 字符串 `t` 有两种情况：
    - 在第一个不同字母处，如果 `s` 中的字母在这门外星语言的字母顺序中位于 `t` 中字母之前，那么 `s` 的字典顺序小于 `t` 。
    - 如果前面 `min(s.length, t.length)` 字母都相同，那么 `s.length < t.length` 时，`s` 的字典顺序也小于 `t` 。
]

#example("Example")[
- 输入：words = ["wrt","wrf","er","ett","rftt"]
- 输出："wertf"
]

#example("Example")[
- 输入：words = ["z","x"]
- 输出："zx"
]

#example("Example")[
- 输入：words = ["z","x","z"]
- 输出：""
- 解释：不存在合法字母顺序，因此返回 "" 。
]


#tip("Tip")[
- 1 <= `words.length` <= 100
- 1 <= `words[i].length` <= 100
- `words[i]` 仅由小写英文字母组成
]


=== #link("https://leetcode.cn/problems/stamping-the-sequence")[ 题目3: 戳印序列]

你想要用小写字母组成一个目标字符串 `target`。 

开始的时候，序列由 `target.length` 个 `'?' `记号组成。而你有一个小写字母印章 stamp。 在每个回合，你可以将印章放在序列上，并将序列中的每个字母替换为印章上的相应字母。你最多可以进行 `10 * target.length`  个回合。

举个例子，如果初始序列为` "?????"`，而你的印章 `stamp` 是` "abc"`，那么在第一回合，你可以得到 `"abc??"`、`"?abc?"`、`"??abc"`。（请注意，印章必须完全包含在序列的边界内才能盖下去。）

如果可以印出序列，那么返回一个数组，该数组由每个回合中被印下的最左边字母的索引组成。如果不能印出序列，就返回一个空数组。

例如，如果序列是 `"ababc"`，印章是 `"abc"`，那么我们就可以返回与操作 `"?????"` -> `"abc??"` -> `"ababc"` 相对应的答案 `[0, 2]`；

另外，如果可以印出序列，那么需要保证可以在 `10 * target.length` 个回合内完成。任何超过此数字的答案将不被接受。

#example("Example")[
- 输入：stamp = "abc", target = "ababc"
- 输出：[0,2]
- （[1,0,2] 以及其他一些可能的结果也将作为答案被接受）
]

#example("Example")[
- 输入：stamp = "abca", target = "aabcaca"
- 输出：[3,0,1]
]

#tip("Tip")[
- `1 <= stamp.length <= target.length <= 1000`
- `stamp` 和 `target` 只包含小写字母。
]

== 最小生成树

#definition("Definition")[
最小生成树：在 _无向带权图_ 中选择择一些边，在 _保证连通性_ 的情况下，边的总权值最小
]

- 最小生成树可能不只一棵，只要保证边的总权值最小，就都是正确的最小生成树
- 如果无向带权图有`n`个点，那么最小生成树一定有`n-1`条边(多一条会成环，少一条保证不了连通性)

=== Kruskal算法（最常用，不需要建图）

1. 把所有的边，根据权值从小到大排序，从权值小的边开始考虑
2. 如果连接当前的边不会形成环，就选择当前的边
3. 如果连接当前的边会形成环，就不要当前的边
4. 考察完所有边之后/已经够`n-1`条边了，最小生成树的也就得到了

证明略！

时间复杂度`O(m * log m) + O(n) + O(m)`

==== #link("https://www.luogu.com.cn/problem/P3366")[Kruskal 洛谷模板]

=== Prim算法（不算常用）

1. 解锁的点的集合叫`set`（普通集合）、解锁的边的集合叫`heap`（小根堆）。`set`和`heap`都为空。
2. 可从任意点开始，开始点加入到`set`，开始点的所有边加入到`heap`
3. 从`heap`中弹出权值最小的边`e`，查看边`e`所去往的点`x`
   1. 如果`x`已经在`set`中，边`e`舍弃，重复步骤3
   2. 如果`x`不在`set`中，边`e`属于最小生成树，把`x`加入`set`，重复步骤3
4. 当`heap`为空，最小生成树的也就得到了

时间复杂度`O(n + m) + O(m * log m)`

==== Prim算法的优化（比较难，不感兴趣可以跳过）请一定要对堆很熟悉！

1. 小根堆里放(节点，到达节点的花费)，根据 到达节点的花费 来组织小根堆
2. 小根堆弹出(`u`节点，到达`u`节点的花费`y`)，`y`累加到总权重上去，然后考察`u`出发的每一条边
  假设，`u`出发的边，去往`v`节点，权重`w`
  1. 如果`v`已经弹出过了（发现过），忽略该边
  2. 如果`v`从来没有进入过堆，向堆里加入记录`(v, w)`
  3. 如果`v`在堆里，且记录为`(v, x)`
     1. 如果`w < x`，则记录更新成`(v, w)`，然后调整该记录在堆中的位置（维持小根堆）
     2. 如果`w >= x`，忽略该边
3. 重复步骤2，直到小根堆为空

时间复杂度`O(n+m) + O((m+n) * log n)`

==== #link("https://www.luogu.com.cn/problem/P3366")[Prim 洛谷模板]
