#import "../template.typ": *
#pagebreak()

= 模板

== 堆

=== 堆排序

#figure(
```cpp
#include <vector>
#include <iostream>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &nums, int i, int j) {
    // 如果两个位置的元素相等，直接返回
    if (nums[i] == nums[j]) {
        return;
    }
    // 使用异或运算交换元素的值
    nums[i] = nums[i] ^ nums[j];
    nums[j] = nums[i] ^ nums[j];
    nums[i] = nums[i] ^ nums[j];
}

// 堆化函数，用于将 `index` 位置的元素下沉，保持子树为大根堆
void heapify(vector<int> &nums, int index, int heapSize) {
    int parent = index;
    int left = 2 * parent + 1;  // 左孩子下标
    int right = 2 * parent + 2; // 右孩子下标

    // 当左孩子在堆范围内时，继续调整
    while (left < heapSize) {
        // 找到左、右孩子中较大的那个
        int largerChild = (right < heapSize && nums[right] > nums[left]) ? right : left;
        // 在父节点和较大孩子中找出更大的那个
        int max = (nums[largerChild] > nums[parent]) ? largerChild : parent;

        // 如果最大值是父节点，则结束调整
        if (max == parent) {
            break;
        }

        // 否则交换父节点和较大孩子的位置
        swap(nums, parent, max);
        parent = max;
        left = 2 * parent + 1;
        right = 2 * parent + 2;
    }
}

// 堆插入函数，用于在堆的末尾插入一个元素并向上调整
void heapInsert(vector<int> &nums, int index) {
    int parent = (index - 1) / 2;

    // 当插入的元素比父节点大时，交换两者并继续向上调整
    while (index > 0 && nums[index] > nums[parent]) {
        swap(nums, index, parent);
        index = parent;
        parent = (index - 1) / 2;
    }
}

// 堆排序主函数
void heapSort(vector<int> &nums) {
    int len = nums.size();

    // 如果数组为空或者长度小于2，直接返回
    if (nums.empty() || len < 2) {
        return;
    }

    // 堆化：使用 `heapify` 方法对数组进行堆化
    for (int i = len - 1; i >= 0; i--) {
        heapify(nums, i, len);
    }

    int heapSize = len;

    // 进行排序：将最大元素放到数组末尾，并调整剩余元素为大根堆
    for (int i = 0; i < len; i++) {
        swap(nums, 0, --heapSize); // 将堆顶（最大值）放到数组末尾
        heapify(nums, 0, heapSize); // 调整剩余部分为大根堆
    }
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    heapSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
```,
caption: [堆排序]
)

=== #link(
  "https://www.nowcoder.com/practice/65cfde9e5b9b4cf2b6bafa5f3ef33fa6",
)[题目1: 合并K个有序链表]

合并 `k` 个升序的链表并将结果作为一个升序的链表返回其头节点。

#example("Example")[
- 输入： `[L{1,2,3},{4,5,6,7}]`
- 返回值：`{1,2,3,4,5,6,7}`
]
#tip("Tip")[
- 节点总数 `0≤n≤5000`
- 每个节点的`val`满足 `∣val∣<=1000`
- 要求：时间复杂度 `O(nlogn)`
]

==== 解答

k个链表；n个节点。

暴力解法复杂度分析： 把所有节点加入一个大容器，然后再排序。
- 空间O(n)
- 时间O(n)+O(nlogn)

堆结构复杂度分析：
- 空间O(k)
- 时间O(nlogk)

#figure(
```cpp
#include <iostream>
#include <vector>
#include <queue>

using namespace std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

ListNode* mergeKLists(vector<ListNode*>& lists) {
    // Priority queue (min-heap) to store the nodes based on their values
    auto comp = [](ListNode* a, ListNode* b) { return a->val > b->val; };
    priority_queue<ListNode*, vector<ListNode*>, decltype(comp)> heap(comp);

    // Add the head of each non-null list into the heap
    for (ListNode* listNode : lists) {
        if (listNode != nullptr) {
            heap.push(listNode);
        }
    }

    // If the heap is empty, return null (no lists to merge)
    if (heap.empty()) {
        return nullptr;
    }

    // Initialize the merged list's head and tail
    ListNode* head = heap.top();
    heap.pop();
    ListNode* tail = head;

    // If the first node has a next node, add it to the heap
    if (tail->next != nullptr) {
        heap.push(tail->next);
    }

    // Process the rest of the nodes in the heap
    while (!heap.empty()) {
        ListNode* cur = heap.top();
        heap.pop();
        tail->next = cur;  // Append the current node to the merged list
        tail = cur;        // Move the tail pointer to the current node
        if (cur->next != nullptr) {
            heap.push(cur->next);  // If the current node has a next, add it to the heap
        }
    }

    // Return the merged list
    return head;
}

int main() {
    // Example usage
    // Creating example linked lists
    ListNode* list1 = new ListNode(1);
    list1->next = new ListNode(4);
    list1->next->next = new ListNode(5);

    ListNode* list2 = new ListNode(1);
    list2->next = new ListNode(3);
    list2->next->next = new ListNode(4);

    ListNode* list3 = new ListNode(2);
    list3->next = new ListNode(6);

    vector<ListNode*> lists = {list1, list2, list3};

    // Merging the k sorted lists
    ListNode* mergedList = mergeKLists(lists);

    // Printing the merged list
    ListNode* current = mergedList;
    while (current != nullptr) {
        cout << current->val << " ";
        current = current->next;
    }

    return 0;
}
```,
caption: [合并K个有序链表]
)

=== #link(
  "https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37",
)[题目2: 最多线段重合问题]

每一个线段都有 `start` 和 `end` 两个数据项，表示这条线段在 X 轴上从 `start` 位置开始到 `end` 位置结束。给定一批线段，求所有重合区域中最多重合了几个线段，首尾相接的线段不算重合。
例如：线段`[1,2]`和线段`[2,3]`不重合。 线段`[1,3]`和线段`[2,3]`重合

- 输入描述：
  - 第一行一个数`N`，表示有`N`条线段
  - 接下来`N`行每行`2`个数，表示线段起始和终止位置
- 输出描述：
  - 输出一个数，表示同一个位置最多重合多少条线段

#example("Example")[
输入：
```
  3
  1 2
  2 3
  1 3
  ```
输出：`2`
]

#tip("Tip")[
  - $N≤10^4$
  - $1≤"start","end"≤10^5$
]

==== 解答

重合区域的左边界一定是某个线段的左边界。

先按照开始位置从小到大排序. 接着把结束位置放到小根堆里. 来到`[x,y]`,
把小根堆里面小于等于`x`的弹出, 把`y`放到小根堆, 看小根堆里有几个, 即当前`[x,y]`线段的答案.

解释： 以`x`为重合区域左边界，有多少线段(包括自身)能到达`x`的右边，因为左边的线段开始位置比`x`早，结束位置又在`x`之后，那就是算一次重合(结束位置在`x`之前的已经被弹出)。
#figure(
```cpp
#include <iostream>
#include <algorithm>

using namespace std;

const int MAXN = 10001;
int line[MAXN][2];
int heap[MAXN];
int heapSize = 0;

void heapInsert(int cur) {
    int parent = (cur - 1) / 2;
    while (heap[cur] < heap[parent]) {
        swap(heap[cur], heap[parent]);
        cur = parent;
        parent = (cur - 1) / 2;
    }
}

void swap(int i, int j) {
    int tmp = heap[i];
    heap[i] = heap[j];
    heap[j] = tmp;
}

void heapify(int cur) {
    int left = 2 * cur + 1;
    while (left < heapSize) {
        int right = left + 1;
        int minChild = (right < heapSize && heap[right] < heap[left]) ? right : left;
        int min = (heap[minChild] < heap[cur]) ? minChild : cur;
        if (min == cur) {
            break;
        } else {
            swap(cur, min);
            cur = min;
            left = 2 * cur + 1;
        }
    }
}

void add(int num) {
    int cur = heapSize++;
    heap[cur] = num;
    heapInsert(cur);
}

void pop() {
    swap(0, --heapSize);
    heapify(0);
}

int compute(int n) {
    int max = 0;
    sort(line, line + n, [](const int a[2], const int b[2]) {
        return a[0] - b[0];
    });

    for (int i = 0; i < n; i++) {
        while (heapSize > 0 && heap[0] <= line[i][0]) pop();
        add(line[i][1]);
        max = max > heapSize ? max : heapSize;
    }

    return max;
}


int main() {
    int n = 5; // Sample input
    // Example input for `line` array
    line[0][0] = 1; line[0][1] = 5;
    line[1][0] = 2; line[1][1] = 6;
    line[2][0] = 3; line[2][1] = 7;
    line[3][0] = 4; line[3][1] = 8;
    line[4][0] = 5; line[4][1] = 9;

    int result = compute(n);
    cout << "Max cover: " << result << endl;

    return 0;
}
```,
caption: [最多线段重合问题]
)

=== #link(
  "https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/",
)[题目3: 将数组和减半的最少操作次数]

给你一个正整数数组 `nums` 。每一次操作中，你可以从 `nums` 中选择 任意
一个数并将它减小到 *恰好*
一半。（注意，在后续操作中你可以对减半过的数继续执行操作）

请你返回将 `nums` 数组和 至少 减少一半的 最少 操作数。

#example(
  "Example",
)[
- 输入：`nums = [5,19,8,1]`
- 输出：`3`
- 解释：初始 nums 的和为 `5 + 19 + 8 + 1 = 33` 。
  以下是将数组和减少至少一半的一种方法：
  - 选择数字 `19` 并减小为 `9.5` 。
  - 选择数字 `9.5` 并减小为 `4.75` 。
  - 选择数字 `8` 并减小为 `4` 。
  - 最终数组为 `[5, 4.75, 4, 1]` ，和为 `5 + 4.75 + 4 + 1 = 14.75` 。
  - `nums` 的和减小了 `33 - 14.75 = 18.25` ，减小的部分超过了初始数组和的一半，`18.25 >= 33/2 = 16.5` 。
  - 我们需要 `3` 个操作实现题目要求，所以返回 `3` 。
  - 可以证明，无法通过少于 `3` 个操作使数组和减少至少一半。
]

#tip("Tip")[
`1 <= nums.length <= 10^5`
`1 <= nums[i] <= 10^7`
]

==== 解答

#figure(
```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

// First approach using priority queue (max-heap)
int halveArray(vector<int>& nums) {
    priority_queue<double> heap;
    double sum = 0;
    for (int num : nums) {
        heap.push((double)num);
        sum += num;
    }
    double target = sum / 2;
    int ans = 0;
    double cur = 0;
    while (sum > target) {
        cur = heap.top() / 2;
        heap.pop();
        heap.push(cur);
        sum -= cur;  // Subtract the halved value from sum
        ans++;
    }
    return ans;
}

// Heapify function for custom heap implementation
void heapify(vector<long>& heap, int i, int size) {
    int left = 2 * i + 1;
    while (left < size) {
        int right = left + 1;
        int best = (right < size && heap[right] > heap[left]) ? right : left;
        best = heap[best] > heap[i] ? best : i;
        if (best == i) {
            break;
        }
        swap(heap[best], heap[i]);
        i = best;
        left = 2 * i + 1;
    }
}

// Second approach using custom heap
int halveArray2(vector<int>& nums) {
    int size = nums.size();
    vector<long> heap(size);
    long sum = 0;

    // Build the heap with scaled values (shifting to avoid float)
    for (int i = 0; i < size; i++) {
        heap[i] = (long)nums[i] << 20;  // Multiply by 2^20 to keep precision
        sum += heap[i];
    }

    sum /= 2;  // Target is half of the sum
    int ans = 0;
    while (sum > 0) {
        heapify(heap, 0, size);
        heap[0] /= 2;
        sum -= heap[0];  // Decrease sum by halved value
        ans++;
    }
    return ans;
}

int main() {
    // Example usage
    vector<int> nums = {5, 10, 7};
    cout << "Minimum operations (priority queue approach): " 
         << halveArray(nums) << endl;

    cout << "Minimum operations (custom heap approach): " 
         << halveArray2(nums) << endl;

    return 0;
}
```,
caption: [将数组和减半的最少操作次数]
)

== 图

=== bfs && dfs

#figure(
```cpp
#include <iostream>
#include <queue>
#include <stack>
#include <vector>
#include <climits>

#define MAXV 100   // 假设最大顶点数为 100

using namespace std;

// 图的定义
typedef struct {
    int numVertices, numEdges;  // 图中实际的顶点数和边数
    char VerticesList[MAXV];    // 顶点表
    int Edge[MAXV][MAXV];       // 邻接矩阵
} MGraph;

// 初始化图
void initializeGraph(MGraph& graph, int numVertices) {
    graph.numVertices = numVertices;
    graph.numEdges = 0;
    for (int i = 0; i < numVertices; ++i) {
        for (int j = 0; j < numVertices; ++j) {
            graph.Edge[i][j] = (i == j) ? 0 : INT_MAX; // 初始化为无穷大
        }
    }
}

// 广度优先搜索 (BFS)
void bfs(const MGraph& graph, int start) {
    vector<bool> visited(graph.numVertices, false); // 访问标记数组
    queue<int> q;                                   // 定义队列

    // 从起始点开始
    q.push(start);
    visited[start] = true;
    cout << "BFS: ";

    while (!q.empty()) {
        int cur = q.front();
        q.pop();
        cout << graph.VerticesList[cur] << " "; // 输出当前访问的顶点

        // 遍历所有相邻顶点
        for (int i = 0; i < graph.numVertices; ++i) {
            if (graph.Edge[cur][i] != INT_MAX && !visited[i]) {
                q.push(i);             // 将未访问的相邻顶点加入队列
                visited[i] = true;     // 标记为已访问
            }
        }
    }
    cout << endl;
}

// 深度优先搜索 (DFS)
void dfs(const MGraph& graph, int start) {
    vector<bool> visited(graph.numVertices, false); // 访问标记数组
    stack<int> s;                                  // 定义栈

    s.push(start);
    visited[start] = true;
    cout << "DFS: ";
    cout << graph.VerticesList[start] << " "; // 输出起始点

    while (!s.empty()) {
        int cur = s.top();
        s.pop();

        // 寻找未访问的邻接点
        for (int i = 0; i < graph.numVertices; ++i) {
            if (graph.Edge[cur][i] != INT_MAX && !visited[i]) {
                s.push(cur);              // 重新压回当前节点
                s.push(i);                // 压入未访问的邻接节点
                visited[i] = true;        // 标记为已访问
                cout << graph.VerticesList[i] << " "; // 输出访问的节点
                break;                    // 找到一个未访问节点后立即跳出
            }
        }
    }
    cout << endl;
}

int main() {
    // 初始化图
    MGraph graph;
    initializeGraph(graph, 5);

    // 顶点赋值
    graph.VerticesList[0] = 'A';
    graph.VerticesList[1] = 'B';
    graph.VerticesList[2] = 'C';
    graph.VerticesList[3] = 'D';
    graph.VerticesList[4] = 'E';

    // 添加边
    graph.Edge[0][1] = 10;
    graph.Edge[0][2] = 6; 
    graph.Edge[0][3] = 1; 
    graph.Edge[1][3] = 15;
    graph.Edge[2][3] = 4; 
    graph.Edge[3][2] = 4; 
    graph.Edge[1][2] = 25;
    graph.Edge[3][4] = 2; 

    // 统计边数
    graph.numEdges = 7;

    // 执行 BFS，从顶点 'A' 开始
    cout << "Running BFS starting from vertex 'A':\n";
    bfs(graph, 0);

    // 执行 DFS，从顶点 'A' 开始
    cout << "Running DFS starting from vertex 'A':\n";
    dfs(graph, 0);

    return 0;
}
```,
caption: [bfs && dfs]
)

=== dijkstra

#figure(
```cpp
#include <iostream>
#include <vector>
#include <climits>

#define MAXV 100   // 假设最大顶点数为 100

using namespace std;

// 图的定义
typedef struct {
    int numVertices, numEdges;  // 图中实际的顶点数和边数
    char VerticesList[MAXV];    // 顶点表
    int Edge[MAXV][MAXV];       // 邻接矩阵
} MGraph;

// 初始化图
void initializeGraph(MGraph& graph, int numVertices) {
    graph.numVertices = numVertices;
    graph.numEdges = 0;
    for (int i = 0; i < numVertices; ++i) {
        for (int j = 0; j < numVertices; ++j) {
            graph.Edge[i][j] = (i == j) ? 0 : INT_MAX; // 初始化为无穷大
        }
    }
}

// Dijkstra算法求最短路径
vector<int> dijkstra(const MGraph& graph, int start) {
    vector<int> dist(graph.numVertices, INT_MAX); // 距离数组，初始为无穷大
    vector<bool> visited(graph.numVertices, false); // 访问标记数组
    dist[start] = 0; // 起点到自己的距离为 0

    for (int i = 0; i < graph.numVertices; ++i) {
        // 寻找未访问的距离最小的顶点
        int minDist = INT_MAX;
        int minIndex = -1;
        for (int j = 0; j < graph.numVertices; ++j) {
            if (!visited[j] && dist[j] < minDist) {
                minDist = dist[j];
                minIndex = j;
            }
        }

        if (minIndex == -1) break; // 无法找到更小的距离，结束算法

        visited[minIndex] = true; // 标记为已访问

        // 更新相邻顶点的距离
        for (int j = 0; j < graph.numVertices; ++j) {
            if (graph.Edge[minIndex][j] != INT_MAX && !visited[j]) {
                int newDist = dist[minIndex] + graph.Edge[minIndex][j];
                if (newDist < dist[j]) {
                    dist[j] = newDist;
                }
            }
        }
    }

    return dist;
}

// 打印最短路径结果
void printShortestPaths(const MGraph& graph, int start, const vector<int>& dist) {
    cout << "Dijkstra's shortest paths from vertex " << graph.VerticesList[start] << ":\n";
    for (int i = 0; i < graph.numVertices; ++i) {
        cout << "To " << graph.VerticesList[i] << ": ";
        if (dist[i] == INT_MAX) {
            cout << "∞ (unreachable)";
        } else {
            cout << dist[i];
        }
        cout << endl;
    }
}

int main() {
    // 初始化图
    MGraph graph;
    initializeGraph(graph, 5);

    // 顶点赋值
    graph.VerticesList[0] = 'A';
    graph.VerticesList[1] = 'B';
    graph.VerticesList[2] = 'C';
    graph.VerticesList[3] = 'D';
    graph.VerticesList[4] = 'E';

    // 添加边
    graph.Edge[0][1] = 10;
    graph.Edge[0][2] = 6; 
    graph.Edge[0][3] = 1; 
    graph.Edge[1][3] = 15;
    graph.Edge[2][3] = 4; 
    graph.Edge[3][2] = 4; 
    graph.Edge[1][2] = 25;
    graph.Edge[3][4] = 2; 


    // 统计边数
    graph.numEdges = 7;

    // 执行 Dijkstra 算法，从顶点 'A' 开始
    cout << "\nRunning Dijkstra's algorithm starting from vertex 'A':\n";
    vector<int> shortestPaths = dijkstra(graph, 0);
    printShortestPaths(graph, 0, shortestPaths);

    return 0;
}
```,
caption: [dijkstra]
)

=== kruskal

#figure(
```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

const int MAXV = 100; // 最大顶点数
const int INF = 1e9;  // 无穷大，表示无法到达的距离

// 图的结构定义
typedef struct {
    int numberVertices, numberEdges;   // 顶点数和边数
    char VerticesList[MAXV];           // 顶点列表（用字符表示）
    int edge[MAXV][MAXV];              // 邻接矩阵
} MGraph;

// 并查集数据结构
int father[MAXV];  // 并查集的父节点数组

// 初始化并查集
void init(int n) {
    for (int i = 0; i < n; i++) {
        father[i] = i;  // 每个节点的父节点指向自己
    }
}

// 查找节点x所在集合的代表元素（根）
int find(int x) {
    if (father[x] != x) {
        father[x] = find(father[x]);  // 路径压缩
    }
    return father[x];
}

// 合并x和y所在的集合
bool union_sets(int x, int y) {
    int fx = find(x);
    int fy = find(y);
    if (fx != fy) {
        father[fx] = fy;  // 合并两个集合
        return true;
    }
    return false;
}

// Kruskal算法，找到最小生成树（MST）
int kruskal(MGraph *G) {
    int n = G->numberVertices;
    vector<vector<int>> edges;

    // 从邻接矩阵中收集所有边
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (G->edge[i][j] != 0) {
                edges.push_back({i, j, G->edge[i][j]});
            }
        }
    }

    // 按边的权重进行升序排序
    sort(edges.begin(), edges.end(), [](const vector<int>& a, const vector<int>& b) {
        return a[2] < b[2];  // 按权重比较
    });

    init(n);  // 初始化并查集
    int ans = 0;
    int edgeCnt = 0;

    // 处理每一条边，使用并查集构建最小生成树
    for (const auto& edge : edges) {
        if (union_sets(edge[0], edge[1])) {
            ans += edge[2];  // 将边的权重加到结果中
            edgeCnt++;
        }
        if (edgeCnt == n - 1) break;  // 已经添加了n-1条边，最小生成树完成
    }

    return (edgeCnt == n - 1) ? ans : -1;  // 返回最小生成树的权值，若无法生成则返回-1
}

int main() {
    MGraph *G = new MGraph();

    G->numberVertices = 5;
    G->numberEdges = 7;

    for (int i = 0; i < 5; i++) {
        G->VerticesList[i] = 'a' + i;
    }

    // 初始化邻接矩阵（边和权重）
    G->edge[0][1] = 10;
    G->edge[0][2] = 6;
    G->edge[0][3] = 5;
    G->edge[1][3] = 15;
    G->edge[2][3] = 4;
    G->edge[1][2] = 25;
    G->edge[3][4] = 2;

    // 运行Kruskal算法
    int result = kruskal(G);
    if (result == -1) {
        cout << "orz" << endl;
    } else {
        cout << "Kruskal算法得到的最小生成树的权值为: " << result << endl;
    }

    return 0;
}
```,
caption: [kruskal]
)

=== prim

#figure(
```cpp
#include <iostream>
#include <queue>
#include <vector>

using namespace std;

const int MAXV = 100; // 最大顶点数
const int INF = 1e9;  // 无穷大，表示无法到达的距离

// 图的结构定义
typedef struct {
    int numberVertices, numberEdges;   // 顶点数和边数
    char VerticesList[MAXV];           // 顶点列表（用字符表示）
    int edge[MAXV][MAXV];              // 邻接矩阵
} MGraph;

// Prim算法，找到最小生成树（MST）
int prim(MGraph *G) {
    int n = G->numberVertices;
    int nodeCnt = 0;
    int ans = 0;

    vector<bool> set(n+1, false);  // 用于跟踪某个顶点是否已经包含在MST中
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> heap;

    // 将顶点0（从第一个顶点开始）所有的边加入到优先队列中
    for (int i = 0; i < n; i++) {
        if (G->edge[0][i] != 0) {
            heap.push({i, G->edge[0][i]});
        }
    }
    set[0] = true;  // 将起始顶点标记为已包含
    nodeCnt++;

    while (!heap.empty()) {
        pair<int, int> top = heap.top();
        heap.pop();
        int to = top.first;
        int weight = top.second;

        if (!set[to]) {  // 如果该顶点还没有被包含在MST中
            ans += weight;
            nodeCnt++;
            set[to] = true;

            // 将包含顶点的所有边加入到优先队列中
            for (int i = 0; i < n; i++) {
                if (G->edge[to][i] != 0 && !set[i]) {
                    heap.push({i, G->edge[0][i]});
                }
            }
        }
    }

    return nodeCnt == n ? ans : -1;  // 返回最小生成树的权值，若无法生成则返回-1
}

int main() {
    MGraph *G = new MGraph();

    G->numberVertices = 5;
    G->numberEdges = 7;

    for (int i = 0; i < 5; i++) {
        G->VerticesList[i] = 'a' + i;
    }

    // 初始化邻接矩阵（边和权重）
    G->edge[0][1] = 10;
    G->edge[0][2] = 6;
    G->edge[0][3] = 5;
    G->edge[1][3] = 15;
    G->edge[2][3] = 4;
    G->edge[1][2] = 25;
    G->edge[3][4] = 2;

    // 运行Prim算法
    int result = prim(G);
    if (result == -1) {
        cout << "orz" << endl;
    } else {
        cout << "Prim算法得到的最小生成树的权值为: " << result << endl;
    }

    return 0;
}
```,
caption: [prim]
)

== 排序

=== 快速排序
#figure(
```cpp
#include <iostream>
#include <vector>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &arr, int i, int j) {
    // 如果两个位置的元素相等，直接返回
    if (arr[i] == arr[j]) {
        return;
    }
    // 使用异或运算交换元素的值
    arr[i] = arr[i] ^ arr[j];
    arr[j] = arr[i] ^ arr[j];
    arr[i] = arr[i] ^ arr[j];
}

// 递归处理函数，用于进行分区和排序
void process(vector<int> &arr, int l, int r) {
    // 当左边界大于等于右边界时，递归终止
    if (l >= r) {
        return;
    }
    // 随机选择一个位置的元素作为基准，并与最后一个元素交换
    swap(arr, l + rand() % (r - l + 1), r); // 利用随机数避免最坏情况
    int less = l - 1;     // `less` 指向小于基准元素区域的右边界
    int more = r + 1;     // `more` 指向大于基准元素区域的左边界
    int num = arr[r];     // 选择最右边的元素作为基准
    int p = l;            // `p` 为当前遍历指针

    // 遍历数组，进行分区操作
    while (p < more) {
        if (arr[p] < num) {
            // 当前元素小于基准，放入`less`区，并右移`less`和`p`
            swap(arr, ++less, p++);
        } else if (arr[p] > num) {
            // 当前元素大于基准，放入`more`区，左移`more`，但`p`位置不变，重新检查
            swap(arr, --more, p);
        } else {
            // 当前元素等于基准，直接移动`p`
            p++;
        }
    }

    // 递归处理左半部分和右半部分
    process(arr, l, less);
    process(arr, more, r);
}

// 快速排序主函数
void quickSort(vector<int> &arr) {
    // 调用递归处理函数，对整个数组进行排序
    process(arr, 0, arr.size() - 1);
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    quickSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
```,
caption: [快速排序]
)

=== 归并排序

#figure(
```cpp
#include <vector>
#include <iostream>

using namespace std;

// 合并函数，用于将两个有序部分合并为一个有序数组
void merge(vector<int> &arr, int L, int M, int R) {
    // 创建一个临时数组用于存放合并后的结果
    vector<int> container(R - L + 1);
    int i = 0;
    int p1 = L, p2 = M + 1; // p1指向左半部分的起始，p2指向右半部分的起始

    // 当左右两部分都有剩余元素时，进行比较并放入容器
    while (p1 <= M && p2 <= R) {
        // 将较小的元素放入容器，并移动指针
        container[i++] = (arr[p1] <= arr[p2]) ? arr[p1++] : arr[p2++];
    }

    // 如果左半部分还有剩余元素，直接加入容器
    while (p1 <= M) {
        container[i++] = arr[p1++];
    }

    // 如果右半部分还有剩余元素，直接加入容器
    while (p2 <= R) {
        container[i++] = arr[p2++];
    }

    // 将容器中的元素复制回原数组相应位置
    for (i = 0; i < container.size(); i++) {
        arr[L + i] = container[i];
    }
}

// 递归处理函数，用于将数组分割并排序
void process(vector<int> &arr, int L, int R) {
    // 当左右边界相等时，不需要继续分割
    if (L == R) {
        return;
    }
    // 计算中间位置，避免直接加法导致的溢出
    int mid = L + ((R - L) >> 1);
    // 对左半部分进行递归排序
    process(arr, L, mid);
    // 对右半部分进行递归排序
    process(arr, mid + 1, R);
    // 合并已经排好序的左右两部分
    merge(arr, L, mid, R);
}

// 归并排序
void mergeSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 调用递归排序处理函数，初始范围为整个数组
    process(arr, 0, len - 1);
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    mergeSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
```,
caption: [归并排序]
)

=== 堆排序

#figure(
```cpp
#include <vector>
#include <iostream>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &nums, int i, int j) {
    // 如果两个位置的元素相等，直接返回
    if (nums[i] == nums[j]) {
        return;
    }
    // 使用异或运算交换元素的值
    nums[i] = nums[i] ^ nums[j];
    nums[j] = nums[i] ^ nums[j];
    nums[i] = nums[i] ^ nums[j];
}

// 堆化函数，用于将 `index` 位置的元素下沉，保持子树为大根堆
void heapify(vector<int> &nums, int index, int heapSize) {
    int parent = index;
    int left = 2 * parent + 1;  // 左孩子下标
    int right = 2 * parent + 2; // 右孩子下标

    // 当左孩子在堆范围内时，继续调整
    while (left < heapSize) {
        // 找到左、右孩子中较大的那个
        int largerChild = (right < heapSize && nums[right] > nums[left]) ? right : left;
        // 在父节点和较大孩子中找出更大的那个
        int max = (nums[largerChild] > nums[parent]) ? largerChild : parent;

        // 如果最大值是父节点，则结束调整
        if (max == parent) {
            break;
        }

        // 否则交换父节点和较大孩子的位置
        swap(nums, parent, max);
        parent = max;
        left = 2 * parent + 1;
        right = 2 * parent + 2;
    }
}

// 堆插入函数，用于在堆的末尾插入一个元素并向上调整
void heapInsert(vector<int> &nums, int index) {
    int parent = (index - 1) / 2;

    // 当插入的元素比父节点大时，交换两者并继续向上调整
    while (index > 0 && nums[index] > nums[parent]) {
        swap(nums, index, parent);
        index = parent;
        parent = (index - 1) / 2;
    }
}

// 堆排序主函数
void heapSort(vector<int> &nums) {
    int len = nums.size();

    // 如果数组为空或者长度小于2，直接返回
    if (nums.empty() || len < 2) {
        return;
    }

    // 堆化：使用 `heapify` 方法对数组进行堆化
    for (int i = len - 1; i >= 0; i--) {
        heapify(nums, i, len);
    }

    int heapSize = len;

    // 进行排序：将最大元素放到数组末尾，并调整剩余元素为大根堆
    for (int i = 0; i < len; i++) {
        swap(nums, 0, --heapSize); // 将堆顶（最大值）放到数组末尾
        heapify(nums, 0, heapSize); // 调整剩余部分为大根堆
    }
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    heapSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
```,
caption: [堆排序]
)

=== 简单排序

#figure(
```cpp
#include <iostream>
#include <vector>

using namespace std;

// 交换函数，用于交换数组中的两个元素
void swap(vector<int> &arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

// 选择排序
void selectSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 遍历数组，i表示当前选择的起始位置
    for (int i = 0; i < len - 1; i++) {
        int minIndex = i; // 假设当前起始位置的元素为最小值
        // 找到从i到数组末尾的最小值的下标
        for (int j = i + 1; j < len; j++) {
            if (arr[j] < arr[minIndex]) { // 如果找到比当前最小值还小的元素
                minIndex = j; // 更新最小值的下标
            }
        }
        // 将最小值放到当前起始位置
        swap(arr, i, minIndex);
    }
}

// 冒泡排序
void bubbleSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 外层循环控制需要排序的趟数，i表示当前比较的最后一个位置
    for (int i = len - 1; i > 0; i--) {
        // 内层循环进行相邻元素的比较和交换
        for (int j = 0; j < i; j++) {
            if (arr[j] > arr[j + 1]) { // 如果前一个元素大于后一个元素
                swap(arr, j, j + 1); // 交换这两个元素的位置
            }
        }
    }
}

// 插入排序
void insertSort(vector<int> &arr) {
    int len = arr.size();
    // 如果数组为空或者长度小于2，直接返回
    if (arr.empty() || len < 2) {
        return;
    }
    // 外层循环，i表示当前要插入的元素下标
    for (int i = 0; i < len - 1; i++) {
        // 内层循环，将当前元素插入到前面有序部分的正确位置
        for (int j = i + 1; j > 0 && arr[j - 1] > arr[j]; j--) {
            swap(arr, j, j - 1); // 如果前一个元素大于当前元素，交换位置
        }
    }
}

// 主函数
int main() {
    // 测试用例
    vector<int> arr = {3, 6, 8, 10, 1, 2, 1};

    // 输出排序前的数组
    cout << "排序前: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    // 调用快速排序函数
    insertSort(arr);

    // 输出排序后的数组
    cout << "排序后: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    return 0;
}
```,
caption: [简单排序]
)

== KMP

#figure(
```cpp
#include <vector>
#include <string>

using namespace std;

// Get the next array
vector<int> nextArray(const string &s, int m) {
    if (m == 1) {
        return {-1};
    }
    vector<int> next(m);
    next[0] = -1;
    next[1] = 0;
    // i indicates the current position to get the next value
    // cn is the index to compare with the previous character
    int i = 2, cn = 0;
    while (i < m) {
        if (s[i - 1] == s[cn]) {
            next[i++] = ++cn;
        } else if (cn > 0) {
            cn = next[cn];
        } else {
            next[i++] = 0;
        }
    }
    return next;
}

// KMP algorithm
int kmp(const string &s1, const string &s2) {
    // s1: the main string
    // s2: the pattern string
    int n = s1.length(), m = s2.length(), x = 0, y = 0;
    // O(m)
    vector<int> next = nextArray(s2, m);
    // O(n)
    while (x < n && y < m) {
        if (s1[x] == s2[y]) {
            x++;
            y++;
        } else if (y == 0) {
            x++;
        } else {
            y = next[y];
        }
    }
    return y == m ? x - y : -1;
}
```,
caption: [KMP]
)

== 二叉树

=== 遍历

#figure(
```cpp
#include <iostream>
#include <stack>
#include <queue>

using namespace std;

class Node {
public:
    int value;
    Node* left;
    Node* right;
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Pre-order recursion (Root -> Left -> Right)
void preOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    cout << head->value << " ";
    preOrderRecur(head->left);
    preOrderRecur(head->right);
}

// In-order recursion (Left -> Root -> Right)
void inOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    inOrderRecur(head->left);
    cout << head->value << " ";
    inOrderRecur(head->right);
}

// Post-order recursion (Left -> Right -> Root)
void posOrderRecur(Node* head) {
    if (head == nullptr) {
        return;
    }
    posOrderRecur(head->left);
    posOrderRecur(head->right);
    cout << head->value << " ";
}

// Pre-order non-recursion (Root -> Left -> Right)
void preOrderUnRecur(Node* head) {
    cout << "pre-order: ";
    if (head != nullptr) {
        stack<Node*> s;
        s.push(head);
        while (!s.empty()) {
            head = s.top();
            s.pop();
            cout << head->value << " ";
            if (head->right != nullptr) {
                s.push(head->right);
            }
            if (head->left != nullptr) {
                s.push(head->left);
            }
        }
    }
    cout << endl;
}

// In-order non-recursion (Left -> Root -> Right)
void inOrderUnRecur(Node* head) {
    cout << "in-order: ";
    if (head != nullptr) {
        stack<Node*> s;
        while (!s.empty() || head != nullptr) {
            if (head != nullptr) {
                s.push(head);
                head = head->left;
            } else {
                head = s.top();
                s.pop();
                cout << head->value << " ";
                head = head->right;
            }
        }
    }
    cout << endl;
}

// Post-order non-recursion (Left -> Right -> Root)
void posOrderUnRecur(Node* head) {
    cout << "pos-order: ";
    if (head != nullptr) {
        stack<Node*> s1, s2;
        s1.push(head);
        while (!s1.empty()) {
            head = s1.top();
            s1.pop();
            s2.push(head);
            if (head->left != nullptr) {
                s1.push(head->left);
            }
            if (head->right != nullptr) {
                s1.push(head->right);
            }
        }
        while (!s2.empty()) {
            cout << s2.top()->value << " ";
            s2.pop();
        }
    }
    cout << endl;
}

// Breadth-First Search (Level-order traversal)
void bfs(Node* head) {
    if (head == nullptr) {
        return;
    }
    queue<Node*> q;
    q.push(head);
    while (!q.empty()) {
        Node* cur = q.front();
        q.pop();
        cout << cur->value << " ";
        if (cur->left != nullptr) {
            q.push(cur->left);
        }
        if (cur->right != nullptr) {
            q.push(cur->right);
        }
    }
    cout << endl;
}

// Main function for testing
int main() {
    // Example tree:
    //         1
    //        / \
    //       2   3
    //      / \   / \
    //     4   5 6   7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    // Testing all traversal methods
    cout << "Pre-order Recursive: ";
    preOrderRecur(root);
    cout << endl;

    cout << "In-order Recursive: ";
    inOrderRecur(root);
    cout << endl;

    cout << "Post-order Recursive: ";
    posOrderRecur(root);
    cout << endl;

    preOrderUnRecur(root);
    inOrderUnRecur(root);
    posOrderUnRecur(root);

    cout << "Breadth-First Search: ";
    bfs(root);
    return 0;
}
```,
caption: [遍历]
)

=== 最大宽度

#figure(
```cpp
#include <iostream>
#include <queue>
#include <algorithm>

using namespace std;

class Node {
public:
    int value;
    Node* left;
    Node* right;
    
    // Constructor to initialize node
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Function to get the maximum width of the binary tree
int getMaxWidth1(Node* root) {
    if (root == nullptr) {
        return 0;
    }

    queue<Node*> q;    // Queue to perform level-order traversal
    q.push(root);       // Start with the root node
    int maxWidth = 0;   // Variable to store the maximum width

    while (!q.empty()) {
        int levelSize = q.size();  // Get the number of nodes at the current level
        maxWidth = max(maxWidth, levelSize);  // Update the maximum width if needed

        for (int i = 0; i < levelSize; i++) {
            Node* temp = q.front();  // Get the front node of the queue
            q.pop();

            // Add the left and right children to the queue if they exist
            if (temp->left != nullptr) {
                q.push(temp->left);
            }
            if (temp->right != nullptr) {
                q.push(temp->right);
            }
        }
    }

    return maxWidth;  // Return the maximum width of the tree
}

// Main function to test the getMaxWidth1 method
int main() {
    // Example binary tree:
    //         1
    //        / \
    //       2   3
    //      / \   / \
    //     4   5 6   7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    cout << "Maximum Width of the Tree: " << getMaxWidth1(root) << endl;

    return 0;
}
```,
caption: [二叉树的最大宽度]
)

=== 后继节点

#figure(
```cpp
#include <iostream>
using namespace std;

// Definition for a binary tree node.
struct NewNode {
    int value;
    NewNode* left;
    NewNode* right;
    NewNode* parent;

    NewNode(int val) : value(val), left(nullptr), right(nullptr), parent(nullptr) {}
};

// Function to find the in-order successor of a given node in the binary tree
NewNode* getSuccessorNode(NewNode* cur) {
    if (cur == nullptr) {
        return nullptr;
    }

    // Case 1: Node has a right child
    if (cur->right != nullptr) {
        NewNode* temp = cur->right;
        // Traverse to the leftmost node in the right subtree
        while (temp->left != nullptr) {
            temp = temp->left;
        }
        return temp;
    }
    
    // Case 2: Node does not have a right child, find the first ancestor for which the current node is in the left subtree
    NewNode* parent = cur->parent;
    while (parent != nullptr && parent->left != cur) {
        cur = parent;  // Move up the tree
        parent = cur->parent;  // Continue searching upwards
    }
    return parent;  // Return the parent (successor)
}

int main() {
    // Example: Create a sample tree
    //       20
    //      /  \
    //    10    30
    //   /  \   /  \
    //  5   15 25   35

    NewNode* root = new NewNode(20);
    NewNode* node10 = new NewNode(10);
    NewNode* node30 = new NewNode(30);
    NewNode* node5 = new NewNode(5);
    NewNode* node15 = new NewNode(15);
    NewNode* node25 = new NewNode(25);
    NewNode* node35 = new NewNode(35);

    // Connect nodes
    root->left = node10;
    root->right = node30;
    node10->parent = root;
    node30->parent = root;

    node10->left = node5;
    node10->right = node15;
    node5->parent = node10;
    node15->parent = node10;

    node30->left = node25;
    node30->right = node35;
    node25->parent = node30;
    node35->parent = node30;

    // Test getSuccessorNode function
    NewNode* successor = getSuccessorNode(node10);
    if (successor != nullptr) {
        cout << "Successor of node " << node10->value << " is node " << successor->value << endl;
    } else {
        cout << "No successor found for node " << node10->value << endl;
    }

    return 0;
}
```,
caption: [二叉树的后继节点]
)

=== 搜索二叉树判断

#figure(
```cpp
#include <iostream>
#include <stack>
#include <climits>

using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// Helper structure for ReturnType in method 3
struct ReturnType {
    int max;
    int min;
    bool isBST;

    ReturnType(int m, int n, bool bst) : max(m), min(n), isBST(bst) {}
};

// Global variable for method 1 and 2 to track the minimum value during traversal
int minValue = INT_MIN;

// Method 1: Recursively check if the tree is a BST using in-order traversal
bool isBST1(Node* root) {
    if (root == nullptr) {
        return true;
    }
    
    // Check the left subtree
    bool isLeftBst = isBST1(root->left);
    if (!isLeftBst) {
        return false;
    }

    // If the current node is not greater than the minimum value, return false
    if (root->value <= minValue) {
        return false;
    } else {
        // Update minValue
        minValue = root->value;
    }

    // Check the right subtree
    return isBST1(root->right);
}

// Method 2: Iterative in-order traversal to check if the tree is a BST
bool isBST2(Node* root) {
    stack<Node*> stack;
    Node* temp = root;

    while (temp != nullptr || !stack.empty()) {
        while (temp != nullptr) {
            stack.push(temp);
            temp = temp->left;
        }
        temp = stack.top();
        stack.pop();

        // If the current node is not greater than the minimum value, return false
        if (temp->value <= minValue) {
            return false;
        } else {
            // Update minValue
            minValue = temp->value;
        }
        temp = temp->right;
    }

    return true;
}

// Method 3: Check if the tree is a BST using post-order traversal
ReturnType process(Node* root) {
    if (root == nullptr) {
        return ReturnType(INT_MIN, INT_MAX, true);
    }

    ReturnType left = process(root->left);
    ReturnType right = process(root->right);

    int min = root->value;
    int max = root->value;

    if (left.isBST) {
        min = std::min(min, left.min);
        max = std::max(max, left.max);
    }

    if (right.isBST) {
        min = std::min(min, right.min);
        max = std::max(max, right.max);
    }

    bool isBST = (left.isBST && left.max < root->value) && 
                 (right.isBST && right.min > root->value);

    return ReturnType(max, min, isBST);
}

bool isBST3(Node* root) {
    return process(root).isBST;
}

int main() {
    // Example binary tree:
    //         4
    //        / \
    //       2   6
    //      / \   / \
    //     1   3 5   7
    Node* root = new Node(4);
    root->left = new Node(2);
    root->right = new Node(6);
    root->left->left = new Node(1);
    root->left->right = new Node(3);
    root->right->left = new Node(5);
    root->right->right = new Node(7);

    // Test isBST1
    cout << "isBST1: " << (isBST1(root) ? "True" : "False") << endl;

    // Reset minValue for method 2
    minValue = INT_MIN;

    // Test isBST2
    cout << "isBST2: " << (isBST2(root) ? "True" : "False") << endl;

    // Test isBST3
    cout << "isBST3: " << (isBST3(root) ? "True" : "False") << endl;

    return 0;
}
```,
caption: [判断搜索二叉树]
)

=== 平衡二叉树&&完全二叉树判断

#figure(
```cpp
#include <iostream>
#include <queue>
#include <cmath>
#include <algorithm>
using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// Function to check if the tree is a Complete Binary Tree (CBT)
bool isCBT(Node* head) {
    if (head == nullptr) {
        return true;
    }
    
    queue<Node*> queue;
    bool leaf = false;  // Whether we have encountered a node with incomplete children
    Node* l = nullptr;
    Node* r = nullptr;
    queue.push(head);

    while (!queue.empty()) {
        head = queue.front();
        queue.pop();
        l = head->left;
        r = head->right;

        // If a leaf node is encountered, no node with children should follow
        if ((leaf && (l != nullptr || r != nullptr)) || (l == nullptr && r != nullptr)) {
            return false;
        }

        if (l != nullptr) {
            queue.push(l);
        }
        if (r != nullptr) {
            queue.push(r);
        }

        // If either left or right child is null, we mark this as a leaf
        if (l == nullptr || r == nullptr) {
            leaf = true;
        }
    }

    return true;
}

// Function to check if the tree is a Full Binary Tree
int findHeight(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    return max(findHeight(root->left), findHeight(root->right)) + 1;
}

int findNodes(Node* root) {
    if (root == nullptr) {
        return 0;
    }
    return findNodes(root->left) + findNodes(root->right) + 1;
}

bool isFull(Node* root) {
    int height = findHeight(root);
    int nodes = findNodes(root);

    return ((1 << height) - 1) == nodes;
}

// Function to check if the tree is a Balanced Binary Tree
bool isBalanced(Node* root) {
    if (root == nullptr) {
        return true;
    }
    return isBalanced(root->left) && isBalanced(root->right) &&
           abs(findHeight(root->left) - findHeight(root->right)) <= 1;
}

// Data structure to hold balance status and height of the subtree
struct ReturnType {
    bool isBalanced;
    int height;
    ReturnType(bool isB, int h) : isBalanced(isB), height(h) {}
};

// Data structure to hold height and node count of the subtree
struct Info {
    int height;
    int nodes;
    Info(int h, int n) : height(h), nodes(n) {}
};

// Method to check if the tree is balanced
ReturnType process(Node* x) {
    if (x == nullptr) {
        return ReturnType(true, 0);  // A null node is balanced with height 0
    }

    // Process left and right subtrees
    ReturnType leftData = process(x->left);
    ReturnType rightData = process(x->right);

    // Height of the current subtree
    int height = max(leftData.height, rightData.height) + 1;

    // The tree is balanced if both subtrees are balanced and the height difference is <= 1
    bool isBalanced = leftData.isBalanced && rightData.isBalanced
                      && abs(leftData.height - rightData.height) <= 1;

    return ReturnType(isBalanced, height);
}

bool isBalanced2(Node* head) {
    return process(head).isBalanced;
}

// Method to check if the tree is full
Info processFull(Node* head) {
    if (head == nullptr) {
        return Info(0, 0);  // A null node has height 0 and 0 nodes
    }

    // Process left and right subtrees
    Info leftData = processFull(head->left);
    Info rightData = processFull(head->right);

    // Height of the current subtree
    int height = max(leftData.height, rightData.height) + 1;

    // Total number of nodes in the current subtree
    int nodes = leftData.nodes + rightData.nodes + 1;

    return Info(height, nodes);
}

bool isFull2(Node* head) {
    if (head == nullptr) {
        return true;  // A null tree is full
    }

    // Get the height and node count of the tree
    Info data = processFull(head);
    
    // A tree is full if the number of nodes equals (2^height - 1)
    return data.nodes == ((1 << (data.height)) - 1);
}

int main() {
    // Example binary tree:
    //         1
    //        / \
    //       2   3
    //      / \   / \
    //     4   5 6   7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    // Test isCBT
    cout << "isCBT: " << (isCBT(root) ? "True" : "False") << endl;

    // Test isFull
    cout << "isFull: " << (isFull(root) ? "True" : "False") << endl;
    // Test isFull2
    cout << "isFull2: " << (isFull2(root) ? "True" : "False") << endl;

    // Test isBalanced
    cout << "isBalanced: " << (isBalanced(root) ? "True" : "False") << endl;

    // Test isBalanced2
    cout << "isBalanced2: " << (isBalanced2(root) ? "True" : "False") << endl;
    return 0;
}
```,
caption: [平衡二叉树&&完全二叉树&&满二叉树]
)

=== 最低公共祖先

#figure(
```cpp
#include <iostream>
#include <unordered_map>
#include <unordered_set>
using namespace std;

// Definition for a binary tree node.
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int x) : value(x), left(nullptr), right(nullptr) {}
};

// 1. Simple method using a HashMap to store parent information and then finding common ancestors
void fillMap(Node* head, unordered_map<Node*, Node*>& fatherMap) {
    if (head == nullptr) {
        return;
    }
    if (head->left) {
        fatherMap[head->left] = head;
        fillMap(head->left, fatherMap);
    }
    if (head->right) {
        fatherMap[head->right] = head;
        fillMap(head->right, fatherMap);
    }
}
Node* lowestCommonAncestor1(Node* head, Node* o1, Node* o2) {
    unordered_map<Node*, Node*> fatherMap;
    fatherMap[head] = head;

    // Fill the map with parent-child relationships
    fillMap(head, fatherMap);

    unordered_set<Node*> set1;
    Node* cur = o1;

    // Add all ancestors of o1 to the set
    while (cur != fatherMap[cur]) {
        set1.insert(cur);
        cur = fatherMap[cur];
    }
    set1.insert(head); // Add the root node as well

    // Find the common ancestor for o2
    cur = o2;
    while (cur != fatherMap[cur]) {
        cur = fatherMap[cur];
        if (set1.find(cur) != set1.end()) {
            return cur;
        }
    }
    return nullptr;
}


// 2. Optimized version (Recursive solution without using extra space)
Node* lowestCommonAncestor2(Node* root, Node* o1, Node* o2) {
    if (root == nullptr || root == o1 || root == o2) {
        return root;
    }

    // Recursively find LCA in left and right subtrees
    Node* retLeft = lowestCommonAncestor2(root->left, o1, o2);
    Node* retRight = lowestCommonAncestor2(root->right, o1, o2);

    // If both left and right are non-null, the current node is the LCA
    if (retLeft != nullptr && retRight != nullptr) {
        return root;
    }

    // Otherwise, return the non-null subtree's result (either left or right)
    return retLeft != nullptr ? retLeft : retRight;
}

// Main function to test the code
int main() {
    // Example binary tree:
    //         1
    //        / \
    //       2   3
    //      / \ / \
    //     4  5 6  7
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);
    root->right->left = new Node(6);
    root->right->right = new Node(7);

    Node* o1 = root->left->left; // Node 4
    Node* o2 = root->left->right; // Node 5

    // Test lowestCommonAncestor1
    Node* lca1 = lowestCommonAncestor1(root, o1, o2);
    if (lca1 != nullptr) {
        cout << "LCA (Method 1): " << lca1->value << endl;
    } else {
        cout << "LCA not found (Method 1)" << endl;
    }

    // Test lowestCommonAncestor2
    Node* lca2 = lowestCommonAncestor2(root, o1, o2);
    if (lca2 != nullptr) {
        cout << "LCA (Method 2): " << lca2->value << endl;
    } else {
        cout << "LCA not found (Method 2)" << endl;
    }

    return 0;
}
```,
caption: [最低公共祖先]
)

=== 二叉树的序列化

#figure(
```cpp
#include <iostream>
#include <queue>
#include <sstream>
#include <string>

using namespace std;

// Definition for a binary tree node.
class Node {
public:
    int value;
    Node* left;
    Node* right;
    
    Node(int val) : value(val), left(nullptr), right(nullptr) {}
};

// Function to serialize the tree using pre-order traversal.
string serialByPre(Node* root) {
    if (root == nullptr) {
        return "#_";  // Using "#_" to represent null nodes
    }
    stringstream ss;
    ss << root->value << "_";
    ss << serialByPre(root->left);
    ss << serialByPre(root->right);
    return ss.str();
}

// Helper function to deserialize the tree from the string
Node* reconPreOrder(queue<string>& q) {
    string value = q.front();
    q.pop();
    
    if (value == "#") {
        return nullptr;  // Null node
    }
    
    Node* node = new Node(stoi(value));  // Create the node from string value
    node->left = reconPreOrder(q);       // Recursively create the left child
    node->right = reconPreOrder(q);      // Recursively create the right child
    return node;
}

// Function to deserialize the tree from a string.
Node* reconPreString(string preStr) {
    stringstream ss(preStr);
    string value;
    queue<string> q;
    
    while (getline(ss, value, '_')) {
        q.push(value);
    }
    
    return reconPreOrder(q);
}

// Helper function to print the tree (in-order traversal)
void inorder(Node* root) {
    if (root == nullptr) {
        return;
    }
    inorder(root->left);
    cout << root->value << " ";
    inorder(root->right);
}

int main() {
    // Example usage
    Node* root = new Node(1);
    root->left = new Node(2);
    root->right = new Node(3);
    root->left->left = new Node(4);
    root->left->right = new Node(5);

    // Serialize the tree
    string serializedTree = serialByPre(root);
    cout << "Serialized tree: " << serializedTree << endl;

    // Deserialize the tree
    Node* deserializedTree = reconPreString(serializedTree);
    
    // Print the deserialized tree (in-order traversal)
    cout << "Deserialized tree (in-order traversal): ";
    inorder(deserializedTree);
    cout << endl;

    return 0;
}
```,
caption: [二叉树的序列化]
)

== 链表

=== 反转单链表

#figure(
```cpp
#include <iostream>
using namespace std;

// Node definition for singly linked list
struct Node {
    int value;
    Node* next;
    Node(int val) : value(val), next(nullptr) {}
};

Node* reverseLinkedList(Node* head) {
    if (head == nullptr) {
        return head;  // Return if the list is empty
    }
    Node* current = head;
    Node* pre = nullptr;
    Node* next = current->next;
    while (current != nullptr) {
        // Save the next node to avoid losing reference to the rest of the list
        next = current->next;
        // Reverse the current node's pointer
        current->next = pre;
        // Move the pointers forward
        pre = current;
        current = next;
    }

    // When the loop ends, pre points to the new head of the reversed list
    head = pre;
    return head;
}

Node* reverseListTail(Node* pre, Node* cur) {
    if (cur == nullptr) {
        return pre;
    }
    Node* next = cur->next;
    cur->next = pre;
    return reverseListTail(cur, next);
}

Node* reverseList(Node* head) {
    return reverseListTail(nullptr, head);
}

void printList(Node* head) {
    Node* current = head;
    while (current != nullptr) {
        cout << current->value << " -> ";
        current = current->next;
    }
    cout << "nullptr" << endl;
}

int main() {
    // Creating a linked list: 1 -> 2 -> 3 -> 4 -> nullptr
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(4);

    cout << "Original List: ";
    printList(head);

    // Reverse the linked list
    head = reverseList(head);

    cout << "Reversed List: ";
    printList(head);

    return 0;
}
```,
caption: [反转单链表]
)

=== 反转双链表

#figure(
```cpp
#include <iostream>

struct DoubleNode {
    int val;
    DoubleNode* pre;
    DoubleNode* next;

    DoubleNode(int value) : val(value), pre(nullptr), next(nullptr) {}
};

DoubleNode* reverseDoubleLinkedList(DoubleNode* head) {
    if (head == nullptr) {
        return nullptr;
    }

    DoubleNode* next = nullptr;
    DoubleNode* pre = nullptr;

    while (head != nullptr) {
        // Store the next node
        next = head->next;
        // Swap the next and previous pointers
        head->next = head->pre;
        head->pre = next;
        // Move pre to the current node
        pre = head;
        // Move head to the next node
        head = next;
    }
    head = pre;
    return head;
}

// Helper function to print the list (for testing)
void printList(DoubleNode* head) {
    while (head != nullptr) {
        std::cout << head->val << " ";
        head = head->next;
    }
    std::cout << std::endl;
}

int main() {
    // Create a sample doubly linked list: 1 <-> 2 <-> 3 <-> 4
    DoubleNode* head = new DoubleNode(1);
    head->next = new DoubleNode(2);
    head->next->pre = head;
    head->next->next = new DoubleNode(3);
    head->next->next->pre = head->next;
    head->next->next->next = new DoubleNode(4);
    head->next->next->next->pre = head->next->next;

    std::cout << "Original List: ";
    printList(head);

    head = reverseDoubleLinkedList(head);

    std::cout << "Reversed List: ";
    printList(head);

    return 0;
}
```,
caption: [反转双链表]
)

=== 打印公共部分

#figure(
```cpp
#include <iostream>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

void printCommonPart(Node* head1, Node* head2) {
    Node* p1 = head1;
    Node* p2 = head2;

    // Traverse the lists until the values are equal
    while (p1 != nullptr && p2 != nullptr && p1->value != p2->value) {
        if (p1->value < p2->value) {
            p1 = p1->next;
        } else {
            p2 = p2->next;
        }
    }

    // Print the common part while both nodes are not null and have equal values
    while (p1 != nullptr && p2 != nullptr && p1->value == p2->value) {
        std::cout << p1->value << std::endl;
        p1 = p1->next;
        p2 = p2->next;
    }
}

int main() {
    // Create two sample linked lists: 1->2->3->4 and 2->3->4->5
    Node* head1 = new Node(1);
    head1->next = new Node(2);
    head1->next->next = new Node(3);
    head1->next->next->next = new Node(4);

    Node* head2 = new Node(2);
    head2->next = new Node(3);
    head2->next->next = new Node(4);
    head2->next->next->next = new Node(5);

    std::cout << "Common part: " << std::endl;
    printCommonPart(head1, head2);

    return 0;
}
```,
caption: [打印公共部分]
)

=== 判断回文链表

#figure(
```cpp
#include <iostream>
#include <stack>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

// Method 1: Use stack to store all elements and compare them with the original list
// Time complexity: O(n), Space complexity: O(n)
bool isPalindrome1(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    std::stack<Node*> stack;
    Node* cur = head;

    // Push all elements into the stack
    while (cur != nullptr) {
        stack.push(cur);
        cur = cur->next;
    }

    // Compare elements from the stack with the list
    while (head != nullptr) {
        if (head->value != stack.top()->value) {
            return false;
        }
        stack.pop();
        head = head->next;
    }

    return true;
}

// Method 2: Use stack to store the second half of the list, and compare it with the first half
// Time complexity: O(n), Space complexity: O(n/2)
bool isPalindrome2(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    Node* slow = head;
    Node* fast = head;

    // Use slow and fast pointers to find the middle of the list
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // Push the second half of the list into the stack
    std::stack<Node*> stack;
    while (slow != nullptr) {
        stack.push(slow);
        slow = slow->next;
    }

    // Compare the first half with the second half from the stack
    while (!stack.empty()) {
        if (head->value != stack.top()->value) {
            return false;
        }
        stack.pop();
        head = head->next;
    }

    return true;
}

// Method 3: Reverse the second half of the list and compare it with the first half
// Time complexity: O(n), Space complexity: O(1)

Node* reverseList(Node* head) {
    Node* prev = nullptr;
    Node* curr = head;

    while (curr != nullptr) {
        Node* next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }

    return prev;
}

bool isPalindrome3(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return true;
    }

    Node* slow = head;
    Node* fast = head;

    // Use slow and fast pointers to find the middle of the list
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    // Reverse the second half of the list
    Node* secondHalf = reverseList(slow);
    Node* firstHalf = head;

    // Compare the first half with the reversed second half
    while (secondHalf != nullptr) {
        if (firstHalf->value != secondHalf->value) {
            return false;
        }
        firstHalf = firstHalf->next;
        secondHalf = secondHalf->next;
    }

    return true;
}

// Helper function to print the list (for testing)
void printList(Node* head) {
    while (head != nullptr) {
        std::cout << head->value << " ";
        head = head->next;
    }
    std::cout << std::endl;
}

int main() {
    // Create a sample linked list: 1 -> 2 -> 3 -> 2 -> 1
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);
    head->next->next->next = new Node(2);
    head->next->next->next->next = new Node(1);

    std::cout << "Is Palindrome (Method 1): " << isPalindrome1(head) << std::endl;
    std::cout << "Is Palindrome (Method 2): " << isPalindrome2(head) << std::endl;
    std::cout << "Is Palindrome (Method 3): " << isPalindrome3(head) << std::endl;

    return 0;
}
```,
caption: [判断回文链表]
)

方法 1: 笔试利用栈来做,遍历一遍链表,把链表元素入栈;
再遍历一遍链表,栈弹出元素并与原链表当前元素对比,不一样就返回 false

方法 2:
利用快慢指针,快指针一次走两步,慢指针一次走一步,当快指针到最后的时候,慢指针刚好到中间,这时候利用栈将链表后半部分的元素入栈,再弹出比较,从而节省了一半空间

方法 3:
利用快慢指针,快指针到最后的时候,慢指针刚好到中点,然后利用慢指针,将链表后半部分逆序,即 1->2 变成 2->1,再用两个指针,一个从头开始遍历,一个从尾开始遍历,有不同则返回 false,否则结束后返回 true,最后记得恢复原数组


=== 链表相交

题目: 给定两个可能有环也可能无环的单链表,头结点 head1 和 head2。请实现一个函数,如果两个链表相交,请返回相交的第一个节点。如果不相交,返回 null 要求:如果两个链表长度之和为 N,时间复杂度请达到 O(N),额外空间复杂度为 O(1)

#figure(
```cpp
#include <iostream>
#include <unordered_set>

struct Node {
    int value;
    Node* next;

    Node(int v) : value(v), next(nullptr) {}
};

// Helper function to detect if there is a loop in a linked list using a HashSet
Node* existLoop1(Node* head) {
    std::unordered_set<Node*> nodeSet;
    Node* temp = head;
    while (temp != nullptr) {
        if (nodeSet.find(temp) == nodeSet.end()) {
            nodeSet.insert(temp);
            temp = temp->next;
        } else {
            return temp;
        }
    }
    return nullptr;
}

// Helper function to detect loop using slow and fast pointers
Node* existLoop2(Node* head) {
    if (head == nullptr || head->next == nullptr) {
        return nullptr;
    }
    Node* slow = head;
    Node* fast = head;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next; // slow pointer moves 1 step
        fast = fast->next->next; // fast pointer moves 2 steps
        if (slow == fast) {
            fast = head; // Move fast pointer to the head to find the entrance to the loop
            while (slow != fast) {
                slow = slow->next;
                fast = fast->next;
            }
            return slow; // The node where they meet is the entrance to the loop
        }
    }
    return nullptr; // No loop
}

// Case 1: No loops in both lists
// Method 1: Use HashSet to find intersection
Node* noLoop1(Node* head1, Node* head2) {
    std::unordered_set<Node*> nodeSet;
    Node* p1 = head1;
    Node* p2 = head2;

    // Add nodes of first list to the HashSet
    while (p1 != nullptr) {
        nodeSet.insert(p1);
        p1 = p1->next;
    }

    // Check if any node of the second list is present in the HashSet
    while (p2 != nullptr) {
        if (nodeSet.find(p2) != nodeSet.end()) {
            return p2; // Intersection node found
        }
        p2 = p2->next;
    }

    return nullptr; // No intersection
}

// Method 2: Use two pointers, adjusting for the length difference
Node* noLoop2(Node* head1, Node* head2, Node* tail1, Node* tail2) {
    if (head1 == nullptr || head2 == nullptr) {
        return nullptr;
    }

    Node* p1 = head1;
    Node* p2 = head2;
    int d_value = 0;

    // Calculate length difference between the two lists
    while (p1->next != tail1) {
        ++d_value;
        p1 = p1->next;
    }

    while (p2->next != tail2) {
        --d_value;
        p2 = p2->next;
    }

    // If tail nodes are not the same, the lists do not intersect
    if (p1 != p2) {
        return nullptr;
    }

    p1 = head1;
    p2 = head2;

    // Adjust the longer list to have the same length as the shorter list
    if (d_value < 0) {
        while (d_value != 0) {
            ++d_value;
            p2 = p2->next;
        }
    } else {
        while (d_value != 0) {
            --d_value;
            p1 = p1->next;
        }
    }

    // Traverse both lists to find the intersection node
    while (p1 != p2) {
        p1 = p1->next;
        p2 = p2->next;
    }

    return p1; // Intersection node found
}

// Case 2: One list has a loop, the other does not
// Case 3: Both lists have a loop (with or without intersection)
Node* bothLoop(Node* head1, Node* head2) {
    Node* loop1 = existLoop2(head1);
    Node* loop2 = existLoop2(head2);

    if (loop1 == loop2) {
        return noLoop2(head1, head2, loop1, loop2);
    } else {
        // If both loops are different, no intersection
        Node* p1 = loop1->next;
        while (p1 != loop1) {
            if (p1 == loop2) {
                return loop2; // Intersection node within the loop
            }
            p1 = p1->next;
        }
        return nullptr; // No intersection in the loop
    }
}

// Main function to get the intersection node of two linked lists
Node* getIntersectNode(Node* head1, Node* head2) {
    if (head1 == nullptr || head2 == nullptr) {
        return nullptr;
    }

    // Check if both lists have loops
    Node* loop1 = existLoop2(head1);
    Node* loop2 = existLoop2(head2);

    // If both lists have no loops
    if (loop1 == nullptr && loop2 == nullptr) {
        return noLoop2(head1, head2, nullptr, nullptr);
    }

    // If both lists have loops
    if (loop1 != nullptr && loop2 != nullptr) {
        return bothLoop(head1, head2);
    }

    // If one list has a loop and the other does not, they cannot intersect
    return nullptr;
}

int main() {
    // Create sample linked lists
    Node* head1 = new Node(1);
    head1->next = new Node(2);
    head1->next->next = new Node(3);
    Node* head2 = new Node(4);
    head2->next = new Node(5);
    head2->next->next = head1->next; // Intersection at node with value 2

    Node* intersection = getIntersectNode(head1, head2);
    if (intersection != nullptr) {
        std::cout << "Intersection node: " << intersection->value << std::endl;
    } else {
        std::cout << "No intersection" << std::endl;
    }

    return 0;
}
```,
caption: [两链表相交]
)

==== 思路分析

- 步骤一: 先判断一个链表是否有环,如果有,返回头结点

  - 方法 1: 使用 hash 表遍历
  - 方法 2: 利用快慢指针

- 解释

  - 为何慢指针第一圈走不完一定会和快指针相遇？
    快指针先进入环---》当慢指针刚到达环的入口时,快指针此时在环中的某个位置(也可能此时相遇)
    ---》设此时快指针和慢指针距离为$x$,若在第二步相遇,则$x = 0$
    ---》设环的周长为$n$,那么看成快指针追赶慢指针,需要追赶$n-x$
    ---》快指针每次都追赶慢指针 1 个单位,设慢指针速度 1 节点/次,快指针 2
    节点/次,那么追赶需要$n-x$次 ---》在$n-x$次数内,慢指针走了$n-x$节点,因为$x\ge 0$,则慢指针走的路程小于等于
    n,即走不完一圈就和快指针相遇
  - 为什么必然会在入环点相遇？ 假设链表非环部分长度为$a$,慢指针入环后走了$b$距离与快指针相遇,设环中除$b$外剩余部分的长度为$c$,此时快指针已经走完了环的$n$圈。
    则快指针走的距离$s_1=a+n(b+c)+b$ 慢指针走的距离是$s_2=a+b$
    由题意可知$s_1=2s_2$,即$a+n(b+c)+b = 2(a+b)$,推出$a = c+(n-1)(b+c)$
    即从相遇点到入环点的距离加上 n-1 圈的环长恰好等于从链表头部到入环点的距离。

- 步骤二: 讨论 head1 和 head2 在不同情况下的处理方法
  - 情况 1: `loop1 == null && loop2 == null`
  - 情况 2: `loop1`,`loop2`中有`null`也有非`null`,则一定不相交
  - 情况 3: `loop1`,`loop2`都非空,则分三种情况

==== 复制含有随机指针节点的链表

random 指针是单链表节点结构中新增的指针,random 可能指向链表中的任意一个节点,也可能指向 null。给定一个由 node 节点类型组成的无环单链表的头结点 head,请实现一个函数完成这个链表的复制,并返回复制的新链表的头结点 

要求: 时间复杂度 O(N),额外空间复杂度 O(1)

#figure(
```cpp
#include <iostream>
#include <unordered_map>

using namespace std;

struct Node {
    int value;
    Node* next;
    Node* random;

    Node(int v) : value(v), next(nullptr), random(nullptr) {}
};

// Method 1: Using a HashMap to map old nodes to their copied nodes
Node* copyRandomList1(Node* head) {
    if (head == nullptr) return nullptr;

    unordered_map<Node*, Node*> map;

    // First pass: Create a copy of each node and store it in the map
    Node* temp = head;
    while (temp != nullptr) {
        map[temp] = new Node(temp->value);
        temp = temp->next;
    }

    // Second pass: Set the next and random pointers of the copied nodes
    temp = head;
    while (temp != nullptr) {
        map[temp]->next = map[temp->next];
        map[temp]->random = map[temp->random];
        temp = temp->next;
    }

    return map[head];
}

// Method 2: Without extra space, directly modify the list and split it at the end
Node* copyRandomList2(Node* head) {
    if (head == nullptr) return nullptr;

    // Step 1: Create the copy nodes and interlace them with the original list
    Node* temp = head;
    while (temp != nullptr) {
        Node* tempCopy = new Node(temp->value);
        Node* nextTemp = temp->next;
        temp->next = tempCopy;
        tempCopy->next = nextTemp;
        temp = nextTemp;
    }

    // Step 2: Copy the random pointers
    temp = head;
    while (temp != nullptr) {
        if (temp->random != nullptr) {
            temp->next->random = temp->random->next;
        }
        temp = temp->next->next;
    }

    // Step 3: Separate the copied list from the original list
    temp = head;
    Node* headCopy = head->next;
    while (temp != nullptr) {
        Node* tempCopy = temp->next;
        temp->next = temp->next->next;
        if (tempCopy->next != nullptr) {
            tempCopy->next = tempCopy->next->next;
        }
        temp = temp->next;
    }

    return headCopy;
}

int main() {
    Node* head = new Node(1);
    head->next = new Node(2);
    head->next->next = new Node(3);

    head->random = head->next->next; // 1's random points to 3
    head->next->random = head; // 2's random points to 1
    head->next->next->random = head->next; // 3's random points to 2

    Node* copiedList1 = copyRandomList1(head);
    Node* copiedList2 = copyRandomList2(head);

    // Output copied list from method 1
    cout << "Copied List 1 (Method 1):" << endl;
    Node* temp = copiedList1;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    // Output copied list from method 2
    cout << "Copied List 2 (Method 2):" << endl;
    temp = copiedList2;
    while (temp != nullptr) {
        cout << "Value: " << temp->value;
        if (temp->random != nullptr) {
            cout << ", Random Value: " << temp->random->value;
        } else {
            cout << ", Random Value: nullptr";
        }
        cout << endl;
        temp = temp->next;
    }

    return 0;
}
```,
caption: [复制含有随机指针节点的链表]
)

== 并查集

== 二分查找

