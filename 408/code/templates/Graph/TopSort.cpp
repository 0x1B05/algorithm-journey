#include <iostream>
#include <vector>
#include <cstring>

using namespace std;

// 定义最大节点数和最大边数
const int MAXN = 200001;
const int MAXM = 200001;

// 全局变量声明
int l, r; // 队列的左右指针
int n, m; // 图的节点数和边数
int indegree[MAXN]; // 存储每个节点的入度
int topo_queue[MAXN]; // 队列，用于存储拓扑排序的结果

// 函数声明
void readGraph(vector<vector<int>>& graph);
bool topSort(vector<vector<int>>& graph);
void printTopoSort();

// 主函数
int main() {
    // 使用C++的输入输出流
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    while (cin >> n >> m) {
        // 初始化图
        vector<vector<int>> graph(n + 1); // 使用vector创建一个邻接表，节点编号从1到n
        memset(indegree, 0, sizeof(indegree)); // 入度数组初始化为0

        // 读取图的信息
        readGraph(graph);

        // 进行拓扑排序，并判断是否存在拓扑序列
        if (!topSort(graph)) {
            cout << -1 << endl; // 存在环，无法进行拓扑排序
        } else {
            printTopoSort(); // 输出拓扑排序结果
        }
    }

    return 0;
}

// 读取有向图的结构信息
void readGraph(vector<vector<int>>& graph) {
    for (int i = 0; i < m; ++i) {
        int from, to;
        cin >> from >> to;
        graph[from].push_back(to); // 建立从from到to的有向边
        indegree[to]++; // 更新目标节点的入度
    }
}

// 拓扑排序函数，返回是否存在拓扑排序（true为存在，false为不存在）
bool topSort(vector<vector<int>>& graph) {
    l = 0, r = 0; // 初始化队列的左右指针

    // 将所有入度为0的节点加入队列
    for (int i = 1; i <= n; ++i) {
        if (indegree[i] == 0) {
            topo_queue[r++] = i;
        }
    }

    int cnt = 0; // 记录拓扑排序中节点的个数
    while (l < r) {
        int cur = topo_queue[l++]; // 出队当前节点
        cnt++; // 计数已排序的节点数量

        // 遍历当前节点的所有邻居节点
        for (int next : graph[cur]) {
            if (--indegree[next] == 0) { // 如果当前邻居节点入度变为0，加入队列
                topo_queue[r++] = next;
            }
        }
    }

    // 如果拓扑排序中的节点数等于图中所有节点数，则说明图中无环
    return cnt == n;
}

// 输出拓扑排序的结果
void printTopoSort() {
    // 输出拓扑排序的队列
    for (int i = 0; i < n - 1; ++i) {
        cout << topo_queue[i] << " ";
    }
    cout << topo_queue[n - 1] << endl;
}
