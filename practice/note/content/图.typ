#import "../template.typ": *
#pagebreak()
= 图

== 图结构

图有很多种存储方式, 主要有邻接表和邻接矩阵两种. 邻接表以点集为单位,
邻接矩阵以边集为单位. 以下以邻接表为例

=== 图的大结构

```java
import java.util.HashMap;
import java.util.HashSet;

public class Graph {
    public HashMap<Integer, Node> nodes; // 点集
    // Integer代表这个点的编号, Node是点的实际结构
    public HashSet<Edge> edges; // 边集

    public Graph() {
        nodes = new HashMap<>();
        edges = new HashSet<>();
    }
}
```

=== 边结构

```java
public class Edge {
    public int value;
    public Node from;
    public Node to;

    public Edge(int weight, Node from, Node to) {
        this.value = weight;
        this.from = from;
        this.to = to;
    }
}
```

=== 点结构

```java
import java.util.ArrayList;

public class Node {
    public int value;// 点的编号
    public int in;// 入度, 有多少点指向该点
    public int out;// 出度, 有多少点从该点指出
    public ArrayList<Node> nexts;// 由Node点指向的其他Node有哪些
    public ArrayList<Edge> edges;// Node点指向其他Node形成的边

    public Node(int value) {
        this.value = value;
        this.in = 0;
        this.out = 0;
        this.nexts = new ArrayList<>();
        this.edges = new ArrayList<>();
    }
}
```

== 图结构的转换

可以平时用自己熟悉的图结构来实现图的算法, 因为算法都是一样的,
所以考试时可以写接口将不同的图结构转换成自己熟悉的图结构, 来实现算法.

- 转换接口例子：用一个二维数组来表示图, 格式为:
  `权值 = matrix[0][0]` `from点 = matrix[0][1]` `to点 = matrix[0][2]`

```java
public class TransferExample {
    public static Graph transGraph(int[][] matrix) {
        Graph graph = new Graph();
        for (int i = 0; i < matrix.length; i++) {
            // 先从数组中获得form点、to点、权值的值
            Integer weight = matrix[i][0];
            Integer from = matrix[i][1];
            Integer to = matrix[i][2];

            // 将from点和to点加到图里
            if (!graph.nodes.containsKey(from)) {
                graph.nodes.put(from, new Node(from));
            }
            if (!graph.nodes.containsKey(from)) {
                graph.nodes.put(to, new Node(to));
            }
            // 获取from点和to点
            Node fromNode = graph.nodes.get(from);
            Node toNode = graph.nodes.get(to);
            // form点、to点和权重组成一条边
            Edge newEdge = new Edge(weight, fromNode, toNode);
            // from点的邻接点集加入to点
            fromNode.nexts.add(toNode);
            // from点出度加一
            fromNode.out++;
            // to点出度加一
            toNode.in++;
            // 将这条边加入form点属于的边集里
            fromNode.edges.add(newEdge);
            // 将这条边加入图的边集里.value
            graph.edges.add(newEdge);
        }
        return graph;
    }
}
```

== 图的遍历

=== 宽度优先遍历(BFS)

1. 利用队列实现
2. 从源节点开始一次按照宽度进队, 然后弹出
3. 每弹出一个点, 就把该节点所有的没有进过队列的直接邻接节点放进队列
4. 一直弹出直到队列为空

```java
public static void bfs(Node node){
    if(head == null){
        return;
    }
    Queue<Node> queue = new LinkedList<>();
    HashSet<Node> set = new HashSet<>();
    queue.add(node);
    set.add(node);
    while(!queue.isEmpty()){
        Node cur = queue.poll();
        System.out.println(cur.value);
        for(Node next : cur.nexts){
            if(!set.contains(next)){
                queue.add(next);
                set.add(next);
            }
        }
    }
}
```

=== 深度优先遍历(DFS)

1. 利用栈实现
2. 从源节点开始把节点按照深度方式放进栈中, 打印, 然后弹出
3. 每弹出一个节点, 把该节点下一个没有进过栈的邻接节点放进栈中, 打印, 弹出
4. 重复上述过程, 直到栈变空

```java
public static void dfs(Node node){
    if(node == null){
        return;
    }
    Stack<Node> stack = new Stack<>();
    HashSet<Node> set = new HashSer<>();
    stack.add(node);
    set.add(node);
    System.out.println(node.value);
    while(!stack.isEmpty()){
        //弹出栈顶节点
        Node cur = stack.pop();
        //从栈顶节点的邻接节点集中寻找未遍历的next节点
        for(Node next : cur.nexts){
            if(!set.contains(next)){
                //找到后, 先将刚刚弹出的节点重新压回栈中, 再将next节点放进栈中
                //这样做到原因是每次一条路走到底之后, 往回走时, 检查是否还有没有走过的路径
                stack.push(cur);
                stack.push(next);
                //set里加入next节点, 表示已遍历此节点
                set.add(next);
                //next点加入后打印
                System.out.println(next.value);
                //找到一个节点后就break, 直接走下一个节点
                break;
            }
        }
    }
}
```

== 图的拓扑排序

=== 什么是拓扑排序

对一个有向无环图(Directed Acyclic Graph 简称 DAG)G 进行拓扑排序, 是将 G
中所有顶点排成一个线性序列, 使得图中任意一对顶点 u 和 v, 若边(u,v)∈E(G), 则 u
在线性序列中出现在 v 之前. 通常, 这样的线性序列称为满足拓扑次序(Topological
Order)的序列, 简称拓扑序列. 简单的说,
由某个集合上的一个偏序得到该集合上的一个全序, 这个操作称之为拓扑排序.
无向图和有环的有向图没有拓扑排序拓扑排序其实就是离散上的偏序关系的一个应用.

> 最常见的应用就是编译顺序. 一张有向图,
怎么确定编译的顺序让所有的依赖环境都具备.

=== 拓扑排序的步骤：

1. 按照一定的顺序进行构造有向图, 记录后个节点的入度;
2. 从图中选择一个入度为 0 的顶点,输出该顶点;
3. 从图中删除该顶点及所有与该顶点相连的边;
4. 重复上述两步, 直至所有顶点输出;
5. 或者当前图中不存在入度为 0 的顶点为止. 此时可说明图中有环;
6. 因此, 也可以通过拓扑排序来判断一个图是否有环.

=== 代码

```java
// 适用范围：要求有向无环图, 且有入度为0的节点
// 有向无环图中所以节点的线性序列满足下列要求:
// 1.每个节点出现且只出现一次
// 2.若存在一条A->B的边, 则在排序序列中, 节点A排在节点B前面

// 算法步骤：
// 1.先找入度为0的点, 加入result集
// 2.消除入度为0的点的影响（属于的边和点）
// 3.寻找下一个入度为0的点, 重复以上过程
public static List<Node> sortedTopology(Graph graph) {
    // 用hashmap存节点和入度
    // key：代表某个节点 value：代表该节点剩余入度
    HashMap<Node, Integer> inMap = new HashMap<>();
    // 存入度为0的节点的队列
    Queue<Node> zeroInQueue = new LinkedList<>();
    // 遍历图集中的点集, 将点和其入度存进inMap
    for (Node node : graph.nodes.values()) {
        inMap.put(node, node.in);
        // 如果遇到入度为0的node, 加入
        if (node.in == 0) {
            zeroInQueue.add(node);
        }
    }
    // 拓扑排序结果依次, 存入result
    List<Node> result = new ArrayList<>();
    while (!zeroInQueue.isEmpty()) {
        // 弹出入度为空节点的队列的一个节点到result里
        Node cur = zeroInQueue.poll();
        result.add(cur);
        // 遍历该节点的邻接节点集
        for (Node next : cur.nexts) {
            // 消除cur节点的影响, 即其next节点们的入度都要减一
            inMap.put(next, inMap.get(next) - 1);
            // 如果next节点的入度更新为0, 则加入队列
            if (inMap.get(next) == 0) {
                zeroInQueue.add(next);
            }
        }
        return result;
    }
}
```

== 图生成最小生成树

=== 关于图的几个概念定义：

- 连通图：在无向图中, 若任意两个顶点$v_i$与$v_j$都有路径相通,
  则称该无向图为连通图.
- 强连通图：在有向图中, 若任意两个顶点$v_i$与$v_j$都有路径相通,
  则称该有向图为强连通图.
- 连通网：在连通图中, 若图的边具有一定的意义, 每一条边都对应着一个数,
  称为权；权代表着连接连个顶点的代价, 称这种连通图叫做连通网.
- 生成树：一个连通图的生成树是指一个连通子图, 它含有图中全部 n 个顶点,
  但只有足以构成一棵树的 n-1 条边. 一颗有 n 个顶点的生成树有且仅有 n-1 条边,
  如果生成树中再添加一条边, 则必定成环.
- 最小生成树：在连通网的所有生成树中, 所有边的代价和最小的生成树, 称为最小生成树.

=== 求最小生成树的两种算法

==== Kruskal 算法

此算法可以称为“加边法”, 初始最小生成树边数为 0,
每迭代一次就选择一条满足条件的最小代价边, 加入到最小生成树的边集合里.
具体：从边角度出发, 依次选择最小的边, 如果加上这条边会形成环, 则不加这条边,
如果不会形成环, 则加上这条边

```java
public class Kruskal {
    public static class MySets {
        // List代表点的集合
        public HashMap<Node, List<Node>> setsMap;

        public MySets(){

        }
        // nodes代表图中所有节点, 构造方法要给每个节点一个集合
        public MySets(List<Node> nodes) {
            for (Node node : nodes) {
                // 创建集合
                List<Node> set = new ArrayList<>();
                // 将节点加入新建集合中
                set.add(node);
                // 建立节点和集合的对应关系
                setsMap.put(node, set);
            }
        }

        public boolean isSameSet(Node from, Node to) {
            // 获取from节点和to节点对应的集合
            List<Node> fromSet = setsMap.get(from);
            List<Node> toSet = setsMap.get(to);
            return fromSet == toSet;
        }

        public void union(Node from, Node to) {
            // 将to节点加入到from的集合当中
            List<Node> fromSet = setsMap.get(from);
            List<Node> toSet = setsMap.get(to);
            for (Node node : toSet) {
                fromSet.add(node);
                setsMap.put(node, fromSet);
            }
        }
    }

    public static class EdgeComparator implements Comparator<Edge> {
        public int compare(Edge e1,Edge e2){
            return e1.weight-e2.weight;
        }
    }

    public static Set<Edge> kruskalMST(Graph graph){
        // 创建我的集合存储节点和对应节点的集合
        @SuppressWarnings("unchecked")
        MySets mySets = new MySets((List)graph.nodes.values());
        // 利用小根堆对边从小到大排序
        PriorityQueue<Edge> priorityQueue = new PriorityQueue<>(new EdgeComparator());
        for (Edge edge : graph.edges) {
            priorityQueue.add(edge);
        }
        Set<Edge> res = new HashSet<>();
        for (Edge edge : priorityQueue) {
            // 如果边的两个节点不在同一个集合
            if(!mySets.isSameSet(edge.from,edge.to)){
                // 将边两边的对应集合进行合并
                mySets.union(edge.from, edge.to);
                // 将该边加入到结果中
                res.add(edge);
            }
        }
        return res;
    }
}
```

==== Prim 算法

此算法可以称为“加点法”, 每次迭代选择代价最小的边对应的点, 加入到最小生成树中.
算法从某一个顶点 s 开始, 逐渐长大覆盖整个连通网的所有顶点. 具体：从一个点出发,
从他的边集里解锁边, 再从这些边里挑选权值最小的边, 然后解锁下一个节点,
再从边集里解锁并挑选权值最小的边（包括之前解锁的边）, 如果边的 to
点是已经解锁的节点, 则不要这条边, 然后重复上述过程, 最后形成最小生成树

```java
public class Prim {
    // 比较器
    public static class EdgeComparator implements Comparator<Edge> {
        @Override
        public int compare(Edge o1, Edge o2) {
            return o1.weight - o2.weight;
        }
    }

    public static Set<Edge> primMST(Graph graph) {
        // 解锁的所有边都放进小根堆排序
        PriorityQueue<Edge> priorityQueue = new PriorityQueue<>(new EdgeComparator());
        // 解锁过的点都放进set集里
        HashSet<Node> set = new HashSet<>();
        // 选择后的边都放进result里
        Set<Edge> result = new HashSet<>();
        // 遍历所有点集是要防止森林的情况, 每一次从一个点出发只会形成一棵树
        for (Node node : graph.nodes.values()) {
            if (!set.contains(node)) {
                // 将解锁了的node放进set里记录
                set.add(node);
                // 将node属于的所有边放进优先级队列里排序
                for (Edge edge : node.edges) {
                    priorityQueue.add(edge);
                }
                while (!priorityQueue.isEmpty()) {
                    // 从优先级队列里弹出最小的边
                    Edge edge = priorityQueue.poll();
                    // 获得node的边的to节点
                    Node toNode = edge.to;
                    // 如果set里没有to节点, 则解锁to节点
                    if (!set.contains(toNode)) {
                        // 将解锁的to节点放到set里
                        set.add(toNode);
                        // result集里加入node和to这条最短的边
                        result.add(edge);
                        // 再将to节点解锁的所有边放进优先级队列, 继续根据队列里最小的边解锁下一个节点和其边集
                        for (Edge nextEdge : toNode.edges) {
                            priorityQueue.add(nextEdge);
                        }
                    }
                }
            }
        }
        return result;
    }
}
```

=== 图中求单元最短路径（Dijkstra 算法）

求从出发节点到其他节点的最短路径

> 适用范围：没有累加和为负数的环

```java
import java.util.HashMap;
import java.util.HashSet;

public class Dijkstra {
    public static HashMap<Node, Integer> dijkstra(Node start) {
        // hashmap表记录从head出发到所有点的最小距离
        // key:从head出发到达的点 value:从head出发到达key的最小距离
        // 如果在hashmap中, 没有Node的记录, 含义是从head到T这个点的距离为+∞
        HashMap<Node, Integer> distanceMap = new HashMap<>();
        distanceMap.put(start, 0);
        // 已经锁住, 确定求得最短距离的节点, 存在selectedNodes里
        HashSet<Node> selectedNodes = new HashSet<>();
        // 从distanceMap里找没有被锁住并且离head最小距离的节点记录
        Node minNode = getMinDistanceAndUnselectedNode(distanceMap, selectedNodes);
        while (minNode != null) {
            // 先拿到head到minNode的距离
            int distance = distanceMap.get(minNode);
            // 遍历minNode的边集
            for (Edge edge : minNode.edges) {
                // 拿到minNode的边的to点
                Node toNode = edge.to;
                // 如果toNode没有记录的话, 相当于原先距离是+∞, 那么就更新为当前的距离
                if (!distanceMap.containsKey(toNode)) {
                    distanceMap.put(toNode, distance + edge.weight);
                } else {// 否则有记录的话, 将原先的记录大小和目前的的距离比较, 选择最小的那个
                    distanceMap.put(edge.to, Math.min(distanceMap.get(toNode), distance + edge.weight));
                }

            }
            // 更新完minNode的所有路径距离后, 将minNode锁住
            selectedNodes.add(minNode);
            // 继续从distanceMap里找一个没有被锁住并且离head最小距离的节点来继续遍历
            minNode = getMinDistanceAndUnselectedNode(distanceMap, selectedNodes);
        }

        return distanceMap;
    }

    // 从距离记录表中寻找一条从start到Node的最短距离, 且Node点是还没有被锁住的, 返回Node
    private static Node getMinDistanceAndUnselectedNode(HashMap<Node, Integer> distanceMap,
            HashSet<Node> selectedNodes) {
        // 最短距离的节点
        Node minNode = null;
        // 最短距离
        int minDistance = Integer.MAX_VALUE;
        // 遍历距离记录表
        for (Node node : distanceMap.keySet()) {
            if (!selectedNodes.contains(node)) {// 如果没有被锁的话
                int distance = distanceMap.get(node);// 得到当前节点的距离值
                if (distance < minDistance) {// 当前节点的距离值和目前最小的作比较, 若更小就更新
                    minDistance = distance;
                    minNode = node;
                }
            }
        }
        return minNode;
    }

}
```

==== 小根堆改进

```java
// 改进后的dijkstra算法
public static HashMap<Node, Integer> dijkstra2(Node head, int size) {
    NodeHeap nodeHeap = new NodeHeap(size);
    nodeHeap.addOrUpdateOrIgnore(head, 0);
    HashMap<Node, Integer> result = new HashMap<>();
    while (!nodeHeap.isEmpty()) {
        // 弹出小根堆堆顶的节点
        NodeRecord record = nodeHeap.pop();
        // 获得节点
        Node cur = record.node;
        // 获得节点到head的距离
        int distance = record.distance;
        // 遍历节点的边, 将to节点到head的距离进行添加、更新或忽略操作
        for (Edge edge : cur.edges) {
            nodeHeap.addOrUpdateOrIgnore(edge.to, edge.weight + distance);
        }
        // 遍历完该节点的所有to节点, 锁住该节点放进result
        result.put(cur, distance);
    }
    return result;
}

// 节点记录
public static class NodeRecord {
    public Node node;
    public int distance;

    public NodeRecord(Node node, int distance) {
        this.node = node;
        this.distance = distance;
    }
}

// 堆结构
public static class NodeHeap {
    // 所有节点放在数组（堆的底层是数组）
    private Node[] nodes;
    // 节点在堆上的位置
    private HashMap<Node, Integer> heapIndexMap;
    // 节点到head的目前的最短距离表
    private HashMap<Node, Integer> distanceMap;
    // 目前堆上一共有多少个节点
    private int size;

    public NodeHeap(int size) {
        nodes = new Node[size];
        heapIndexMap = new HashMap<>();
        distanceMap = new HashMap<>();
        this.size = 0;
    }

    // 判断堆是否为空
    public boolean isEmpty() {
        return size == 0;
    }

    // 添加、更新或忽略操作
    public void addOrUpdateOrIgnore(Node node, int distance) {
        // 如果节点在堆里, 更新
        if (inHeap(node)) {
            distanceMap.put(node, Math.min(distanceMap.get(node), distance));
            insertHeapify(node, heapIndexMap.get(node));
        }
        // 如果节点没进过堆, 添加
        if (!isEntered(node)) {
            // 数组末尾添加节点
            nodes[size] = node;
            heapIndexMap.put(node, size);
            distanceMap.put(node, distance);
            // 向上调整, 保持堆结构
            insertHeapify(node, size++);
        }
        // 进过堆, 但不在堆上了（poll的节点）, 啥也不干
    }

    // 弹出方法
    public NodeRecord pop() {
        NodeRecord nodeRecord = new NodeRecord(nodes[0], distanceMap.get(nodes[0]));
        // 末尾节点和堆顶交换
        swap(0, size - 1);
        // 这时堆顶节点来到末尾
        heapIndexMap.put(nodes[size - 1], -1);
        distanceMap.remove(nodes[size - 1]);
        // 节点标空
        nodes[size - 1] = null;
        // 从头开始向下堆化, 保持堆结构
        heapify(0, --size);
        return nodeRecord;
    }

    // 节点是否进过堆
    private boolean isEntered(Node node) {
        return heapIndexMap.containsKey(node);
    }

    // 节点是否还在堆上
    private boolean inHeap(Node node) {
        // 进过堆并且indexmap上的value不为-1 , 返回true, 因为弹出节点时它在indexmap上的value会标为-1
        return isEntered(node) && heapIndexMap.get(node) != -1;
    }

    // 交换
    private void swap(int index1, int index2) {
        heapIndexMap.put(nodes[index1], index2);
        heapIndexMap.put(nodes[index2], index1);
        Node tmp = nodes[index1];
        nodes[index1] = nodes[index2];
        nodes[index2] = tmp;
    }

    // 小根堆向上调整
    private void insertHeapify(Node node, int index) {
        while (distanceMap.get(nodes[index]) < distanceMap.get(nodes[(index - 1) / 2])) {
            swap(index, (index - 1) / 2);
            index = (index - 1) / 2;
        }
    }

    // 小根堆向下堆化, 保持整体堆结构
    private void heapify(int index, int size) {
        int left = index * 2 + 1;
        while (left < size) {
            int smallest = left + 1 < size && distanceMap.get(nodes[left + 1]) < distanceMap.get(nodes[left])
                    ? left + 1
                    : left;
            smallest = distanceMap.get(nodes[smallest]) < distanceMap.get(nodes[index]) ? smallest : index;
            if (smallest == index) {
                break;
            }
            swap(smallest, index);
            index = smallest;
            left = index * 2 + 1;
        }
    }
}
```

=== 前缀树

一个字符串类型的数组 arr1, 另一个字符串类型的数组 arr2. arr2 中有哪些字符, 是
arr1 中出现的? 请打印. arr2 中有哪些字符, 是作为 arr1 中某个字符串前缀出现?
请打印. arr2 中有哪些字符, 是作为 arr1 中某个字符串前缀出现的? 请打印 arr2
中出现次数最多的前缀.

```java
// 前缀树节点
public static class TrieNode {
    public int pass; // 经过节点的次数
    public int end; // 作为字符串尾节点的次数
    public TrieNode[] nexts; // 节点next节点们的集合(字符种类多时, 用HashMap<char, Node> nexts;
    public TrieNode() {
        pass = 0;
        end = 0;
        nexts = new TrieNode[26];
        // 每个节点后都有26条路, 连向26个字母, 一开始全为null, next[0]代表a字母, next[1]代表b字母....
        // nexts[0] == null 没有走向‘a’的路
        // next[1] != null 有走向‘a’的路
    }
    // 建立前缀树
    public static class Trie {
        // 根节点
        private TrieNode root;
        public Trie() {
            root = new TrieNode();
        }
        // 将word单词插进前缀树中
        public void insert(String word) {
            if (word == null) {
                return;
            }
            // 分割字符串
            char[] chs = word.toCharArray();
            // 标志节点指向根节点
            TrieNode node = root;
            // 根节点的pass++
            node.pass++;
            // index代表nexts[index]中的下标
            int index = 0;
            for (int i = 0; i < chs.length; i++) {
                // 用ASCII来计算下一条路的下标, 如‘a’-‘a’=0, 则选next[0]的路
                index = chs[i] - 'a';
                // 如果当前节点没有去nexts[index]的路, 新建一条
                if (node.nexts[index] == null) {
                    node.nexts[index] = new TrieNode();
                }
                // 然后node；来到下一个节点, 即nexts[index]
                node = node.nexts[index];
                // pass++,继续循环遍历
                node.pass++;
            }
            // 遍历完字符串则end++
            node.end++;
        }
        // 查询word这个单词加入过前缀树几次
        public int search(String word) {
            if (word == null) {
                return 0;
            }
            // 分割字符串
            char[] chs = word.toCharArray();
            // 从根节点开始遍历
            TrieNode node = root;
            int index = 0;
            for (int i = 0; i < chs.length; i++) {
                index = chs[i] - 'a';
                // 如果出现有一个字符串没有路, 则没有出现过这个word, 直接返回0
                if (node.nexts[index] == null) {
                    return 0;
                }
                // node不断指向下一条路
                node = node.nexts[index];
            }
            // 遍历完字符串后返回的end节点就是出现的次数
            return node.end;
        }
        // 求所有加入的字符串中, 有几个是以pre这个字符串作为前缀出现的
        public int prefixNumber(String pre) {
            if (pre == null) {
                return 0;
            }
            char[] chs = pre.toCharArray();
            TrieNode node = root;
            int index = 0;
            for (int i = 0; i < chs.length; i++) {
                index = chs[i] - 'a';
                if (node.nexts[index] == null) {
                    return 0;
                }
                node = node.nexts[index];
            }
            return node.pass;
        }
        // 删除word字符串
        public void delete(String word) {
            if (search(word) != 0) {
                char[] chs = word.toCharArray();
                TrieNode node = root;
                node.pass--;
                int index = 0;
                for (int i = 0; i < chs.length; i++) {
                    index = chs[i] - 'a';
                    if (--node.nexts[index].pass == 0) {
                        // 只有java能这样 c++要析构来释放内存
                        // 遇到pass--后变0的节点, 直接标空, 后面的节点自动释放
                        node.nexts[index] = null;
                        return;
                    }
                    // 没遇到就继续遍历, 继续--node.pass
                    node = node.nexts[index];
                }
                // 删除完整个字符串后end要--
                node.end--;
            }
        }
    }
}
```
