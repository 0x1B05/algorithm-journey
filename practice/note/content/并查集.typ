#import "../template.typ": *
#pagebreak()
= 并查集

并查集的使用是如下的场景

1）一开始每个元素都拥有自己的集合，在自己的集合里只有这个元素自己 2）`find(i)`：查找i所在集合的代表元素，代表元素来代表i所在的集合
3）`boolean isSameSet(a, b)`：判断a和b在不在一个集合里 4）`void union(a, b)`：a所在集合所有元素
与 b所在集合所有元素 合并成一个集合 5）各种操作单次调用的均摊时间复杂度为O(1)
#tip(
  "Tip",
)[
  并查集时间复杂度的理解: 作为如此简单、小巧的结构，
  感性理解单次调用的均摊时间复杂度为O(1)即可，其实为α(n)，阿克曼函数。
  当n=10^80次方即可探明宇宙原子量，α(n)的返回值也不超过6，那就可以认为是O(1)
  并查集的发明者Bernard A. Galler和Michael J.
  Fischer，从1964年证明到1989年才证明完毕，建议记住即可，理解证明难度很大！
]

并查集的两个优化，都发生在`find`方法里

1）扁平化（一定要做） 2）小挂大（可以不做，原论文中是秩的概念，可以理解为
粗略高度 或者 大小）

== 并查集模板

=== #link(
  "https://www.nowcoder.com/practice/e7ed657974934a30b2010046536a5372",
)[ 数组实现 ]
给定一个没有重复值的整形数组`arr`，初始时认为`arr`中每一个数各自都是一个单独的集合。请设计一种叫`UnionFind`的结构，并提供以下两个操作。
- `boolean isSameSet(int a, int b)`: 查询a和b这两个数是否属于一个集合
- `void union(int a, int b)`:
  把a所在的集合与b所在的集合合并在一起，原本两个集合各自的元素以后都算作同一个集合

输入描述：
- 第一行两个整数`N`, `M`。分别表示数组大小、操作次数
- 接下来M行，每行有一个整数opt
  - 若opt = 1，后面有两个数x, y，表示查询(x, y)这两个数是否属于同一个集合
  - 若opt = 2，后面有两个数x, y，表示把x, y所在的集合合并在一起

输出描述： 对于每个`opt = 1`的操作，若为真则输出`Yes`，否则输出`No`

#example("Example")[
输入：
```
4 5
1 1 2
2 2 3
2 1 3
1 1 1
1 2 3
```
输出：
```
No
Yes
Yes
```
说明： 每次2操作后的集合为
```
({1}, {2}, {3}, {4})
({1}, {2, 3}, {4})
({1, 2, 3}, {4})
```
]

#tip("Tip")[
  - 1⩽N,M⩽10^6
  - 保证1⩽x,y⩽N
]

==== 实现

#code(
  caption: [牛客并查集模板],
)[
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

/**
 * Code01_UnionFindNowCoder
 */
public class Code01_UnionFindNowCoder {
    public static int MAXN = 1000001;

    // 数组下标代表元素，数据代表所属集合
    public static int father[] = new int[MAXN];
    public static int size[] = new int[MAXN];
    public static int stack[] = new int[MAXN];

    public static int N;
    public static int M;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            N = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < N; i++) {
                father[i] = i;
            }

            M = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < M; i++) {
                int opt = (int) in.nval;
                in.nextToken();
                int x = (int) in.nval;
                in.nextToken();
                int y = (int) in.nval;
                in.nextToken();
                if (opt == 1) {
                    if (isSameSet(x, y)) {
                        out.println("Yes");
                    } else {
                        out.println("No");
                    }
                } else if (opt == 2) {
                    union(x, y);
                }
            }
        }
        out.flush();
        br.close();
        out.close();
    }

    public static int find(int x) {
        int path_size = 0;

        while(father[x]!=x){
            stack[path_size++] = x;
            x = father[x];
        }

        // 扁平化
        while(path_size!=0){
            int tmp = stack[--path_size];
            father[tmp] = x;
        }

        return x;
    }

    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }
    public static void union(int x, int y) {
        int root_x = find(x);
        int root_y = find(y);
        if (root_x != root_y) {
            if (size[root_x] <= size[root_y]) {
                // x -> y
                father[root_x] = father[root_y];
                size[root_y] += size[root_x];
            } else {
                // y -> x
                father[root_y] = father[root_x];
                size[root_x] += size[root_y];
            }
        }
    }
}
```
]

=== #link("https://www.luogu.com.cn/problem/P3367")[数组实现(省略小挂大优化)]

如题，现在有一个并查集，你需要完成合并和查询操作。

输入格式

第一行包含两个整数 $N,M$ ,表示共有 $N$ 个元素和 $M$ 个操作。 接下来 $M$ 行，每行包含三个整数 $Z_i,X_i,Y_i$ 。
- 当 $Z_i=1$ 时，将 $X_i$ 与 $Y_i$ 所在的集合合并。
- 当 $Z_i=2$ 时，输出 $X_i$ 与 $Y_i$ 是否在同一集合内，是的输出
  `Y` ；否则输出 `N` 。

  输出格式

对于每一个 $Z_i=2$ 的操作，都有一行输出，每行包含一个大写字母，为 `Y` 或者 `N` 。

#example("Example")[
样例输入

```
4 7
2 1 2
1 1 2
2 1 2
1 3 4
2 1 4
1 2 3
2 1 4
```

样例输出

```
N
Y
N
Y
```

]

#tip(
  "Tip",
)[
  - 对于 $30\%$ 的数据，$N lt.eq 10$，$M lt.eq 20$。
  - 对于 $70\%$ 的数据，$N lt.eq 100$，$M lt.eq 10^3$。
  - 对于 $100\%$ 的数据，$1 lt.eq N lt.eq 10^4$, $1lt.eq M lt.eq 2 * 10^5$, $1 lt.eq X_i, Y_i lt.eq N$, $Z_i \in \{ 1, 2 \}$。
]

==== 实现

#code(
  caption: [洛谷并查集模板],
)[
```java
public class Code02_UnionFindLuogu {
    public static int MAXN = 10001;
    public static int[] father = new int[MAXN];
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int N = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < N; i++) {
                father[i] = i;
            }
            int M = (int) in.nval;
            in.nextToken();
            for (int i = 0; i < M; i++) {
                int Z = (int) in.nval;
                in.nextToken();
                int X = (int) in.nval;
                in.nextToken();
                int Y = (int) in.nval;
                in.nextToken();
                if (Z == 1) {
                    union(find(X), find(Y));
                } else if (Z == 2) {
                    out.println(isSameSet(X, Y)?"Y":"N");
                }
            }
        }
        out.flush();
        out.close();
        br.close();
    }
    public static int find(int x) {
        if(x!=father[x]){
            father[x] = find(father[x]);
        }
        return father[x];
    }

    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }
    public static void union(int x, int y) {
        int root_x = find(x);
        int root_y = find(y);
        if (root_x != root_y) {
            father[root_x] = father[root_y];
        }
    }
}
```
]

=== 链表实现

分析:

1. 假设用链表实现,`union`需要 O(1)而`isSameSet`需要 O(n)
2. 假设用哈希表实现,`isSameSet`需要 O(1)而`union`需要 O(n)

问题:如何实现`isSameSet`和`union`都是 O(1)

```java
import java.util.HashMap;
import java.util.List;
import java.util.Stack;

public class UnionFind {
    //样本进来会包一层，叫做元素
    public static class Element<V>{
        public V value;
        public Element(V value){
            this.value = value;
        }
    }
    public static class UnionFindSet<V>{
        public HashMap<V,Element<V>> elementMap;

        //key 某个元素 value 该元素的父亲
        public HashMap<Element<V>,Element<V>> fatherMap;
        //key 某个集合的代表元素，value 该集合的大小
        public HashMap<Element<V>,Integer> sizeMap;
        public UnionFindSetInit(List<V> list){
            elementMap = new HashMap<>();
            fatherMap = new HashMap<>();
            sizeMap = new HashMap<>();
            for (V value : list) {
                Element<V> element = new Element<V>(value);
                elementMap.put(value,element);
                fatherMap.put(element,element);
                sizeMap.put(element,1);
            }
        }

        //给定一个ele，往上一直找，将代表元素返回
        private Element<V> findHead(Element<V> element){
            // path用来存放向上查找的路径
            Stack<Element<V>> path = new Stack<>();
            while (element != fatherMap.get(element)){  // 父是自己为止.
                path.push(element);
                element = fatherMap.get(element);
            }
            //将遍历的整条链的父都设置为找到的代表元素
            //即将其扁平化(向上找优化)
            while (!path.isEmpty()){
                fatherMap.put(path.pop(),element);  // 把途径的元素都直接放在根的下面
            }
            return element;
        }

        public boolean isSameSet(V a,V b){
            if(elementMap.containsKey(a) && elementMap.containsKey(b)){
                return findHead(elementMap.get(a)) == findHead(elementMap.get(b));
            }
            return false;
        }

        public void union(V a,V b){
            if(elementMap.containsKey(a) && elementMap.containsKey(b)){
                Element<V> aF = findHead(elementMap.get(a));
                Element<V> bF = findHead(elementMap.get(b));
                if(aF != bF){
                    Element<V> big = sizeMap.get(aF) >= sizeMap.get(bF) ? aF : bF;
                    Element<V> small = big == aF ? bF : aF;
                    fatherMap.put(small,big);
                    sizeMap.put(big,sizeMap.get(aF) + sizeMap.get(bF));
                    sizeMap.remove(small);
                }
            }
        }
    }
}
```

#tip("Tip")[
`findHead()`用的次数越多则空间复杂度越低,当逼近 O(n)次或大于
O(n)次,可以认为并查集在 O(1)内实现了`isSameSet`,`union`
]

== 题目

=== #link("https://leetcode.cn/problems/couples-holding-hands/")[题目1: 情侣牵手]
`n` 对情侣坐在连续排列的 `2n` 个座位上，想要牵到对方的手。

人和座位由一个整数数组 `row` 表示，其中 `row[i]` 是坐在第 `i` 个座位上的人的
ID。情侣们按顺序编号，第一对是 `(0, 1)`，第二对是 `(2, 3)`，以此类推，最后一对是 `(2n-2, 2n-1)`。

返回 *最少交换座位的次数*，以便每对情侣可以并肩坐在一起。
每次交换可选择任意两人，让他们站起来交换座位。

#example("Example")[
- 输入: `row = [0,2,1,3]`
- 输出: `1`
- 解释: 只需要交换`row[1]`和`row[2]`的位置即可。
]

#tip("Tip")[
  - 2n == row.length
  - 2 <= n <= 30
  - n 是偶数
  - 0 <= row[i] < 2n
  - row 中所有元素均无重复
]

=== 解答

混在一起的情侣有`k`对，那就要交换`k-1`次.(必然有一个出走来成全其他的所有情侣。)

#three-line-table[
  |couple ID|couple| | - | - | |0 | 0 1| |1 | 2 3| |2 | 3 4| |3 | 4 5| |4 | 5 6|
]

couple ID = ID/2

#example("Example")[
row = [6,0,8,9,1,7,3,4,5,2]
算法： 
```
ID       : 6,0|8,9|1,7|3,4|5,2
couple ID: 3,0|4,4|0,3|1,2|2,1
```
集合{0, 3}(交换1次), {1, 2}(交换1次), {4} -> 2次
]

#example("Example")[
row = [6,0,1,5,2,3,8,4,7,9]
算法： 
```
ID       : 6,0|1,5|2,3|8,4|7,9
couple ID: 3,0|0,2|1,1|4,2|3,4
```
集合{0, 2, 3, 4}(交换3次), {1}(交换0次) -> 3次

怎么换？举例让0出走(每次出走都要成全一对)
```
6,0|1,5|2,3|8,4|7,9
3,0|0,2|1,1|4,2|3,4

7,6|1,5|2,3|8,4|0,9
3,3|0,2|1,1|4,2|0,4


7,6|1,5|2,3|0,4|8,9
3,3|0,2|1,1|0,2|4,4

7,6|0,1|2,3|5,4|8,9
3,3|0,0|1,1|2,2|4,4
```
]

#tip("Tip")[
    集合大小大于2，每次出走只能成全一对(像个循环链表)，除了最后一次，其他情况不可能一次成全两对，否则集合只会是2。
]

优化:

一共n个人，假设有三个集合大小分别为a,b,c
- 最终的交换次数实际上是(a-1)+(b-1)+(c-1)=a+b+c-3
- 故而实际上就是`情侣对数-集合数`


#code(caption: [题目1: 情侣牵手])[
```java
public class Code03_CouplesHoldingHands {
	public static int minSwapsCouples(int[] row) {
		int n = row.length;
		build(n / 2);
		for (int i = 0; i < n; i += 2) {
			union(row[i] / 2, row[i + 1] / 2);
		}
		return n / 2 - setNum;
	}

	public static int MAXN = 31;
	public static int[] couple = new int[MAXN];
	public static int setNum;

	public static void build(int m) {
		for (int i = 0; i < m; i++) {
			couple[i] = i;
		}
		setNum = m;
	}

	public static int find(int i) {
		if (i != couple[i]) {
			couple[i] = find(couple[i]);
		}
		return couple[i];
	}

	public static void union(int x, int y) {
		int fx = find(x);
		int fy = find(y);
		if (fx != fy) {
			couple[fx] = fy;
			setNum--;
		}
	}
}
```
]
=== #link(
  "https://leetcode.cn/problems/similar-string-groups/",
)[题目2: 相似字符串组]

=== #link("https://leetcode.cn/problems/number-of-islands/")[题目3: 岛问题]

一个矩阵中只有 0 和 1
两种值，每个位置都可以和自己的上下左右四个位置相连，如果有一片 1
连在一起，这个部分叫做一个岛，求一个矩阵上有多少个岛.

#example("Example")[
```
001010
111010
100100
000000
```
这个矩阵有 3 个岛
]

==== 洪水填充

#code(caption: [题目3: 岛问题-洪水填充])[
```java
public static int countIslands(int[][] m) {
    if (m == null || m[0] == null) {
        return 0;
    }
    int N = m.length;
    int M = m[0].length;
    int res = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            if (m[i][j] == 1) {
                res++;
                infect(m, i, j, N, M);
            }
        }
    }
    return res;
}

// 递归进行感染
public static void infect(int[][] m, int i, int j, int N, int M) {
    if (i < 0 || i >= N || j < 0 || j >= M || m[i][j] != 1) {
        return;
    }
    //i,j没有越界，且当前位置值为1
    m[i][j] = 2;
    //修改当前值之后再递归，不会导致无限循环
    infect(m, i + 1, j, N, M);
    infect(m, i - 1, j, N, M);
    infect(m, i, j + 1, N, M);
    infect(m, i, j - 1, N, M);
}
```
]

时间复杂度 O(m \* n)


