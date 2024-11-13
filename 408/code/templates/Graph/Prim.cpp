#include <iostream>
#include <vector>
#include <queue>
#include <cstring>

using namespace std;

// 定义最大节点数
const int MAXN = 10001;

// 使用邻接表存储图
vector<pair<int, int>> graph[MAXN]; // graph[u] 存储节点u的所有邻接边 (v, weight)

// 函数声明
int prim(int n);

// 主函数
int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    while (cin >> n >> m) {
        // 清空图结构
        for (int i = 0; i <= n; ++i) {
            graph[i].clear();
        }

        // 读取边信息
        for (int i = 0; i < m; ++i) {
            int from, to, weight;
            cin >> from >> to >> weight;
            // 无向图，双向添加边
            graph[from].emplace_back(to, weight);
            graph[to].emplace_back(from, weight);
        }

        // 调用Prim算法，计算最小生成树的权值
        int ans = prim(n);
        if (ans == -1) {
            cout << "orz" << endl; // 输出 "orz" 表示无法构成最小生成树
        } else {
            cout << ans << endl;   // 输出最小生成树的权值
        }
    }

    return 0;
}

// Prim算法计算最小生成树的权值
// 参数: n为节点数
int prim(int n) {
    int nodeCnt = 0; // 记录已加入最小生成树的节点数
    int ans = 0;     // 记录最小生成树的总权值

    bool visited[MAXN]; // 记录节点是否已加入最小生成树
    memset(visited, false, sizeof(visited)); // 初始化为未访问

    // 使用优先队列 (小根堆) 存储边 (weight, to)
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> minHeap;

    // 将从节点1出发的所有边加入小根堆
    visited[1] = true; // 标记节点1为已访问
    nodeCnt++;

    for (auto& edge : graph[1]) {
        minHeap.emplace(edge.second, edge.first); // (weight, to)
    }

    // Prim算法主循环
    while (!minHeap.empty()) {
        auto [weight, to] = minHeap.top();
        minHeap.pop();

        // 如果目标节点已经在最小生成树中，跳过
        if (visited[to]) continue;

        // 否则，将该边加入最小生成树
        ans += weight;
        visited[to] = true;
        nodeCnt++;

        // 将目标节点的所有邻接边加入小根堆
        for (auto& edge : graph[to]) {
            if (!visited[edge.first]) {
                minHeap.emplace(edge.second, edge.first); // (weight, to)
            }
        }
    }

    // 判断是否构成了包含所有节点的最小生成树
    return nodeCnt == n ? ans : -1;
}
