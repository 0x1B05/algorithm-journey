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

=== #link("https://leetcode.cn/problems/Jf1JuT/description/")[题目2: 火星词典]

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

贪心策略，证明略！

==== #link("https://www.luogu.com.cn/problem/P3366")[最小生成树洛谷模板]

给出一个无向图，求出最小生成树，如果该图不连通，则输出 `orz`。

- 输入格式
  - 第一行包含两个整数 `N`,`M`，表示该图共有 `N` 个结点和 `M` 条无向边。
  - 接下来 `M` 行每行包含三个整数 `Xi`,`Yi`,`Zi`表示有一条长度为 `Zi` 的无向边连接结点 `Xi`,`Yi`。
- 输出格式
  - 如果该图连通，则输出一个整数表示最小生成树的各边的长度之和。如果该图不连通则输出 `orz`。

#example("Example")[
- 输入
  ```
  4 5
  1 2 2
  1 3 2
  1 4 3
  2 3 4
  3 4 3
  ```
- 输出:`7`
]

#tip("Tip")[
- `1≤N≤5000`
- `1≤M≤2×10^5`
- `1≤Zi≤10^4`
]

#code(caption: [Kruskal])[
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

/**
 * Code01_Kruskal
 */
public class Code01_Kruskal {
    public static int MAXN = 5001;
    public static int MAXM = 200001;
    public static int n, m;
    public static int[][] edges = new int[MAXM][3];
    public static int[] father = new int[MAXN];
    public static int ans = 0;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            init();
            m = (int) in.nval;
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            out.println(compute() ? ans : "orz");
        }
        out.flush();
        out.close();
        br.close();
    }
    public static void init() {
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }
    public static boolean union(int x, int y) {
        int fx = find(x);
        int fy = find(y);

        if (fx != fy) {
            father[fx] = fy;
            return true;
        } else {
            return false;
        }
    }
    public static int find(int x) {
        if (father[x] != x) {
            father[x] = find(father[x]);
        }
        return father[x];
    }

    public static boolean compute() {
        Arrays.sort(edges, 0, m, (a, b) -> (a[2] - b[2]));
        int edgeCnt = 0;
        for (int[] edge : edges) {
            if (union(edge[0], edge[1])) {
                ans += edge[2];
                edgeCnt++;
            }
        }
        return edgeCnt == n - 1;
    }
}
```
]

时间复杂度`O(m * log m) + O(n) + O(m)`
- 排序`O(m * log m)`
- 建立并查集`O(n)`
- 遍历所有的边`O(m)`

=== Prim算法（不算常用）

1. 解锁的点的集合叫`set`（普通集合）、解锁的边的集合叫`heap`（小根堆）。`set`和`heap`都为空。
2. 可从任意点开始，开始点加入到`set`，开始点的所有边加入到`heap`
3. 从`heap`中弹出权值最小的边`e`，查看边`e`所去往的点`x`
   1. 如果`x`已经在`set`中，边`e`舍弃，重复步骤3
   2. 如果`x`不在`set`中，边`e`属于最小生成树，把`x`加入`set`，重复步骤3
4. 当`heap`为空，最小生成树的也就得到了

贪心策略，证明略！

==== #link("https://www.luogu.com.cn/problem/P3366")[最小生成树洛谷模板]

#code(caption: [Prim])[
```java
public class Code02_PrimDynamic {
    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            ArrayList<ArrayList<int[]>> graph = new ArrayList<>();
            int n = (int) in.nval;
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0, from, to, weight; i < m; i++) {
                in.nextToken();
                from = (int) in.nval;
                in.nextToken();
                to = (int) in.nval;
                in.nextToken();
                weight = (int) in.nval;
                graph.get(from).add(new int[]{to,weight});
                graph.get(to).add(new int[]{from,weight});
            }
            int ans = prim(graph);
            out.println(ans == -1 ? "orz":ans);
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int prim(ArrayList<ArrayList<int[]>> graph) {
        int n = graph.size()-1;
        int nodeCnt = 0;
        int ans = 0;

        boolean[] set = new boolean[n+1];
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b)->(a[1]-b[1]));

        for (int[] e : graph.get(1)) {
            heap.add(e);
        }
        set[1] = true;
        nodeCnt++;

        while(!heap.isEmpty()){
            int[] top = heap.poll();
            int to = top[0];
            int weight = top[1];
            if(!set[to]){
                ans+=weight;
                nodeCnt++;
                set[to]=true;
                for (int[] e : graph.get(to)) {
                    heap.add(e);
                }
            }
        }
        return nodeCnt == n ? ans:-1;
    }
}
```
]

时间复杂度`O(n + m) + O(m * log m)`
- 建图`O(n + m)`
- 堆的操作，每次`2m`条边弹出，`2m`条边加入`O(m * log m)`

==== Prim算法的优化（比较难，不感兴趣可以跳过）

1. 小根堆里放(节点，到达节点的花费)，根据 到达节点的花费 来组织小根堆
2. 小根堆弹出(`u`节点，到达`u`节点的花费`y`)，`y`累加到总权重上去，然后考察`u`出发的每一条边
  假设，`u`出发的边，去往`v`节点，权重`w`
  1. 如果`v`已经弹出过了（发现过），忽略该边
  2. 如果`v`从来没有进入过堆，向堆里加入记录`(v, w)`
  3. 如果`v`在堆里，且记录为`(v, x)`
     1. 如果`w < x`，则记录更新成`(v, w)`，然后调整该记录在堆中的位置（维持小根堆）
     2. 如果`w >= x`，忽略该边
3. 重复步骤2，直到小根堆为空

#tip("Tip")[
- 同一个节点的记录不重复入堆！这样堆时间复杂度只和节点数有关。
- 反向索引表的用处，已知某边的大小要改变，要在堆里找到这个边。
]

时间复杂度`O(n+m) + O((m+n) * log n)`

==== #link("https://www.luogu.com.cn/problem/P3366")[Prim 洛谷模板]

#code(caption: [Prim - 反向索引堆])[
```java
public class Code02_PrimStatic {
    public static int MAXN = 5001;
    public static int MAXM = 400001;
    public static int n,m;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] to = new int[MAXM];
    public static int[] next = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // 反向索引堆
    public static int[][] heap = new int[MAXN][2];
    // where[v] = -1，表示v这个节点，从来没有进入过堆
    // where[v] = -2，表示v这个节点，已经弹出过了
    // where[v] = i(>=0)，表示v这个节点，在堆上的i位置
    public static int[] where = new int[MAXN];
    public static int heapSize;

    // 最小生成树已经找到的节点数
    public static int nodeCnt;
    // 最小生成树的权重和
    public static int ans;

    public static void build(){
        cnt = 1;
        heapSize = 0;
        nodeCnt = 0;
        Arrays.fill(head, 1, n+1, 0);
        Arrays.fill(where, 1, n+1, -1);
    }

    public static void addEdge(int f, int t, int w){
        to[cnt] = t;
        weight[cnt] = w;
        next[cnt] = head[f];
        head[f] = cnt++;
    }

    // 当前处于cur,向上调整成堆
    public static void heapInsert(int cur){
        int parent = (cur-1)/2;
        while(heap[parent][1]>heap[cur][1]){
            swap(parent, cur);
            cur = parent;
            parent = (cur-1)/2;
        }
    }

    // 当前处于cur,向下调整成堆
    public static void heapify(int cur){
        int left = 2*cur+1;
        while(left<heapSize){
            int right = left+1;
            int minChild = (right<heapSize && heap[right][1]<heap[left][1])?right:left;
            int min = heap[minChild][1]<heap[cur][1]?minChild:cur;
            if(min==cur){
                break;
            }else{
                swap(minChild, cur);
                cur = minChild;
                left = 2*cur+1;
            }
        }
    }

    // 堆上i位置与j位置交换
    public static void swap(int i, int j){
        // where的交换
        int a = heap[i][0];
        int b = heap[j][0];
        where[a] = j;
        where[b] = i;

        // 元素的交换
        int[] tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static boolean isEmpty(){
        return heapSize==0 ? true:false;
    }

    public static int popTo, popWeight;
    public static void pop(){
        popTo = heap[0][0];
        popWeight = heap[0][1];
        swap(0, --heapSize);
        heapify(0);
        where[popTo] = -2;
        nodeCnt++;
    }

    // 点在堆上的记录要么新增，要么更新，要么忽略
    // 当前处理编号为cur的边
    public static void addOrUpdateOrIgnore(int cur){
        int t = to[cur];
        int w = weight[cur];
        if(where[t]==-1){
            // 从来没进入过
            heap[heapSize][0] = t;
            heap[heapSize][1] = w;
            where[t] = heapSize++;
            heapInsert(where[t]);
        }else if(where[t]>=0){
            // 已经在堆里
            // 谁小留谁
            heap[where[t]][1] = Math.min(heap[where[t]][1], w);
            heapInsert(where[t]);
        }
    }

    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build();
            for (int i = 0, f, t, w; i < m; i++) {
                in.nextToken();
                f = (int) in.nval;
                in.nextToken();
                t = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                addEdge(f, t, w);
                addEdge(t, f, w);
            }
            int ans = prim();
            out.println(nodeCnt == n ? ans : "orz");
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int prim(){
        // 从1节点出发
        nodeCnt = 1;
        where[1] = -2;
        for (int ei = head[1]; ei > 0; ei=next[ei]) {
            addOrUpdateOrIgnore(ei);
        }

        while(!isEmpty()){
            pop();
            ans += popWeight;
            for (int ei = head[popTo]; ei > 0; ei=next[ei]) {
                addOrUpdateOrIgnore(ei);
            }
        }
        return ans;
    }
}
```
]

=== #link("https://leetcode.cn/problems/optimize-water-distribution-in-a-village/")[题目3: 水资源分配优化]

村里面一共有 `n` 栋房子。我们希望通过建造水井和铺设管道来为所有房子供水。
对于每个房子 `i`，我们有两种可选的供水方案：
- 一种是直接在房子内建造水井: 成本为 `wells[i - 1]` （注意 `-1` ，因为 索引从`0`开始 ）
- 另一种是从另一口井铺设管道引水，数组 `pipes` 给出了在房子间铺设管道的成本， 其中每个 `pipes[j] = [house1j, house2j, costj]` 代表用管道将 `house1j` 和 `house2j`连接在一起的成本。连接是双向的。

请返回 为所有房子都供水的最低总成本

#example("Example")[
- 输入: `n = 3`, `wells = [1,2,2]`, `pipes = [[1,2,1],[2,3,1]]`
- 输出: `3`
- 解释: 最好的策略是在第一个房子里建造水井（成本为1），然后将其他房子铺设管道连起来（成本为2），所以总成本为3。
]

#tip("Tip")[
- `1 <= n <= 10000`
- `wells.length == n`
- `0 <= wells[i] <= 10^5`
- `1 <= pipes.length <= 10000`
- `1 <= pipes[i][0], pipes[i][1] <= n`
- `0 <= pipes[i][2] <= 10^5`
- `pipes[i][0] != pipes[i][1]`
]

==== 解答:

*假设有一个水源地，所谓的村庄打井的代价相当于从村庄到水源地的管道的代价。*

#code(caption: [水资源分配优化 - 解答])[
```java
public class Code03_OptimizeWaterDistribution {
    public static int MAXN = 10001;
    // edge[cnt][0] -> 起始点
    // edge[cnt][1] -> 结束点
    // edge[cnt][2] -> 代价
    public static int[][] edge = new int[MAXN << 1][3];
    // cnt代表边的编号
    public static int cnt;
    public static int[] father = new int[MAXN];

    public static void init(int n){
        cnt = 0;
        for (int i = 0; i <= n; i++) {
            father[i] = i;
        }
    }

    public static int find(int i){
        if(i!=father[i]){
            father[i] = find(father[i]);
        }
        return father[i];
    }
    public static boolean union(int x, int y){
        int fx = find(x);
        int fy = find(y);
        if(fx!=fy){
            father[fx] = fy;
            return true;
        }else{
            return false;
        }
    }

    public static int minCostToSupplyWater(int n, int[] wells, int[][] pipes) {
        init(n);

        for (int i = 0; i < n; i++, cnt++) {
            edge[cnt][0] = 0;
            edge[cnt][1] = i+1;
            edge[cnt][2] = wells[i];
        }
        for (int i = 0; i < pipes.length; i++, cnt++) {
            edge[cnt][0] = pipes[i][0];
            edge[cnt][1] = pipes[i][1];
            edge[cnt][2] = pipes[i][2];
        }

        Arrays.sort(edge,(a, b)->a[2]-b[2]);
        int ans = 0;
        for(int i = 0; i < cnt; i++){
            if(union(edge[i][0], edge[i][1])){
                ans += edge[i][2];
            }
        }
        return ans;
    }
}
```
]

=== #link("https://leetcode.cn/problems/checking-existence-of-edge-length-limited-paths/")[题目4: 检查边长度限制的路径是否存在]

给你一个 `n` 个点组成的无向图边集 `edgeList` ，其中 `edgeList[i] = [ui, vi, disi]` 表示点 `ui` 和点 `vi` 之间有一条长度为 `disi` 的边。请注意，两个点之间可能有 超过一条边 。

给你一个查询数组`queries` ，其中 `queries[j] = [pj, qj, limitj]` ，你的任务是对于每个查询 `queries[j]` ，判断是否存在从 `pj` 到 `qj` 的路径，且这条路径上的每一条边都 严格小于 `limitj` 。

请你返回一个 布尔数组 `answer` ，其中 `answer.length == queries.length` ，当 `queries[j]` 的查询结果为 `true` 时， `answer` 第 `j` 个值为 `true` ，否则为 `false` 。

#example("Example")[
- 输入：`n = 3`, `edgeList = [[0,1,2],[1,2,4],[2,0,8],[1,0,16]]`, `queries = [[0,1,2],[0,2,5]]`
- 输出：`[false,true]`
- 解释：上图为给定的输入数据。注意到 `0` 和 `1` 之间有两条重边，分别为 `2` 和 `16` 。
  - 对于第一个查询，`0` 和 `1` 之间没有小于 `2` 的边，所以我们返回 `false` 。
  - 对于第二个查询，有一条路径（`0` -> `1` -> `2`）两条边都小于 `5` ，所以这个查询我们返回 `true` 
]

#tip("Tip")[
- `2 <= n <= 10^5`
- `1 <= edgeList.length, queries.length <= 10^5`
- `edgeList[i].length == 3`
- `queries[j].length == 3`
- `0 <= ui, vi, pj, qj <= n - 1`
- `ui != vi`
- `pj != qj`
- `1 <= disi, limitj <= 10^9`
]
==== 解答

#code(caption: [检查边长度限制的路径是否存在 - 解答])[
```java
public class Code04_CheckingExistenceOfEdgeLengthLimit {
    public static int MAXN = 100001;
    public static int[][] questions = new int[MAXN][4];

    public static int[] father = new int[MAXN];
    public static void init(int n){
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
    }
    public static int find(int i){
        if(i!=father[i]){
            father[i] = find(father[i]);
        }
        return father[i];
    }
    public static void union(int x, int y){
        father[find(x)] = find(y);
    }
    public static boolean isSameSet(int x, int y){
        return find(x)==find(y);
    }

    public static boolean[] distanceLimitedPathsExist(int n, int[][] edges, int[][] queries) {
        int m = edges.length;
        int k = queries.length;
        boolean[] ans = new boolean[k];
        init(n);

        for (int i = 0; i < k; i++) {
            questions[i][0] = queries[i][0];
            questions[i][1] = queries[i][1];
            questions[i][2] = queries[i][2];
            questions[i][3] = i;
        }
        Arrays.sort(questions, 0, k, (a, b)->a[2]-b[2]);
        Arrays.sort(edges, (a, b)->a[2]-b[2]);

        // 当前已经连了的节点数量
        int nodeCnt = 0;
        for (int i = 0; i < k; i++) {
            while(nodeCnt<m && edges[nodeCnt][2]<questions[i][2]){
                union(edges[nodeCnt][0], edges[nodeCnt][1]);
                nodeCnt++;
            }
            ans[questions[i][3]] = isSameSet(questions[i][0], questions[i][1]);
        }
        return ans;
    }
}
```
]


=== #link("https://www.luogu.com.cn/problem/P2330")[题目5: 繁忙的都市 ]

#definition("Definition")[
- 瓶颈生成树: 无向图 $G$ 的瓶颈生成树是这样的一个生成树，它的最大的边权值在 $G$ 的所有生成树中最小。
- 性质: 最小生成树是瓶颈生成树的充分不必要条件。 即最小生成树一定是瓶颈生成树，而瓶颈生成树不一定是最小生成树。
  - 反证法证明：我们设最小生成树中的最大边权为 $w$ ，如果最小生成树不是瓶颈生成树的话，则瓶颈生成树的所有边权都小于 $w$ ，我们只需删去原最小生成树中的最长边，用瓶颈生成树中的一条边来连接删去边后形成的两棵树，得到的新生成树一定比原最小生成树的权值和还要小，这样就产生了矛盾。
]

城市 C 是一个非常繁忙的大都市，城市中的道路十分的拥挤，于是市长决定对其中的道路进行改造。城市 C 的道路是这样分布的：城市中有 $n$ 个交叉路口，有些交叉路口之间有道路相连，两个交叉路口之间最多有一条道路相连接。这些道路是双向的，且把所有的交叉路口直接或间接的连接起来了。每条道路都有一个分值，分值越小表示这个道路越繁忙，越需要进行改造。但是市政府的资金有限，市长希望进行改造的道路越少越好，于是他提出下面的要求：

+ 改造的那些道路能够把所有的交叉路口直接或间接的连通起来。
+ 在满足要求 1 的情况下，改造的道路尽量少。
+ 在满足要求 1、2 的情况下，改造的那些道路中分值最大的道路分值尽量小。

任务：作为市规划局的你，应当作出最佳的决策，选择哪些道路应当被修建。

- 输入格式
  - 第一行有两个整数 $n,m$ 表示城市有 $n$ 个交叉路口，$m$ 条道路。接下来 $m$ 行是对每条道路的描述，$u, v, c$ 表示交叉路口 $u$ 和 $v$ 之间有道路相连，分值为 $c$。
- 输出格式
  - 两个整数 $s, "max"$，表示你选出了几条道路，分值最大的那条道路的分值是多少。

#example("Example")[
- 样例输入

```
4 5
1 2 3
1 4 5
2 4 7
2 3 6
3 4 8
```

- 输出

```
3 6
```
]

#tip("Tip")[
对于全部数据，满足 $1 <= n <= 300$，$1 <= c <= 10^4$，$1 <= m <= 8000$。
]

==== 解答

#code(caption: [繁忙的都市 - 解答])[
```java
public class Code05_BusyCities {
    public static int MAXN = 301;
    public static int MAXM = 8001;
    public static int n,m;
    public static int[][] edges = new int[MAXM][3];

    public static int[] father = new int[MAXN];
    public static void init(){
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }
    public static int find(int i){
        if(i!=father[i]){
            father[i] = find(father[i]);
        }
        return father[i];
    }
    public static boolean union(int x, int y){
        int fx = find(x);
        int fy = find(y);
        if(fx!=fy){
            father[fx] = fy;
            return true;
        }else{
            return false;
        }
    }
    public static boolean isSameSet(int x, int y){
        return find(x)==find(y);
    }

    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            n = (int)in.nval;
            in.nextToken();
            m = (int)in.nval;
            init();
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            Arrays.sort(edges, 0, m, (a, b)->a[2]-b[2]);
            int ans = 0;
            int edgeCnt = 0;
            for (int[] edge : edges) {
                if(union(edge[0], edge[1])){
                    edgeCnt++;
                    ans = Math.max(ans, edge[2]);
                }
                if(edgeCnt==n-1){
                    break;
                }
            }
            out.println((n - 1) + " " + ans);
        }
        out.flush();
        out.close();
        br.close();
    }
}
```
]
