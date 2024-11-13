#include <iostream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <climits>

using namespace std;

const int MAXN = 1000; // 最大节点数量

// 邻接表：graph2[i] 存储与节点 i 相连的所有节点和对应的权重
vector<vector<pair<int, int>>> graph2(MAXN);

// Dijkstra算法：从起始节点start开始，返回到各节点的最短距离映射
unordered_map<int, int> dijkstra(int start);

// 辅助函数：从距离记录表中找到一个未被锁定且最短距离的节点
int getMinDistanceAndUnselectedNode(const unordered_map<int, int>& distanceMap, const unordered_set<int>& selectedNodes);

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int n, m;
    cout << "请输入节点数量和边数量 (n, m): ";
    cin >> n >> m;

    // 构建邻接表
    cout << "请输入每条边的起点、终点和权重 (from, to, weight):" << endl;
    for (int i = 0; i < m; i++) {
        int from, to, weight;
        cin >> from >> to >> weight;
        graph2[from].push_back({to, weight});
        graph2[to].push_back({from, weight}); // 如果是无向图
    }

    int start;
    cout << "请输入起始节点: ";
    cin >> start;

    // 执行 Dijkstra 算法
    unordered_map<int, int> distanceMap = dijkstra(start);

    // 输出从起始节点到各节点的最短距离
    cout << "从起始节点 " << start << " 到各节点的最短距离为：" << endl;
    for (const auto& pair : distanceMap) {
        cout << "节点 " << pair.first << ": " << pair.second << endl;
    }

    return 0;
}

/**
 * Dijkstra算法
 * 使用优先队列和映射来找到从起始节点 start 到各节点的最短路径。
 * @param start 起始节点
 * @return 返回从起始节点到每个节点的最短距离映射表
 */
unordered_map<int, int> dijkstra(int start) {
    // 存储从start到达每个节点的最小距离
    unordered_map<int, int> distanceMap;
    distanceMap[start] = 0;

    // 存储已锁定节点的集合
    unordered_set<int> selectedNodes;

    // 获取第一个最小距离且未锁定的节点
    int minNode = getMinDistanceAndUnselectedNode(distanceMap, selectedNodes);

    // 当存在未锁定的节点时，继续遍历
    while (minNode != -1) {
        // 获取从start到minNode的当前最小距离
        int distance = distanceMap[minNode];

        // 遍历minNode的所有邻接节点
        for (const auto& edge : graph2[minNode]) {
            int toNode = edge.first;
            int weight = edge.second;

            // 如果没有记录toNode的距离，初始化为当前计算的距离
            if (distanceMap.find(toNode) == distanceMap.end()) {
                distanceMap[toNode] = distance + weight;
            } else {
                // 否则，更新为较小的距离
                distanceMap[toNode] = min(distanceMap[toNode], distance + weight);
            }
        }

        // 将当前节点minNode加入锁定集合
        selectedNodes.insert(minNode);

        // 查找下一个最短距离且未锁定的节点
        minNode = getMinDistanceAndUnselectedNode(distanceMap, selectedNodes);
    }

    return distanceMap;
}

/**
 * 辅助函数
 * 从距离记录表中寻找一条从start到某节点的最短距离，且节点未被锁定，返回节点编号。
 * @param distanceMap 记录各节点最短距离的映射表
 * @param selectedNodes 已锁定的节点集合
 * @return 返回距离最短且未被锁定的节点编号，如果没有则返回 -1
 */
int getMinDistanceAndUnselectedNode(const unordered_map<int, int>& distanceMap,
                                    const unordered_set<int>& selectedNodes) {
    int minNode = -1;
    int minDistance = INT_MAX;

    // 遍历距离记录表，找到未锁定的最短距离节点
    for (const auto& pair : distanceMap) {
        int node = pair.first;
        int distance = pair.second;
        if (selectedNodes.find(node) == selectedNodes.end() && distance < minDistance) {
            minNode = node;
            minDistance = distance;
        }
    }

    return minNode;
}
