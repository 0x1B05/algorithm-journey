#include <iostream>
#include <vector>
#include <queue>
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


vector<int> dijkstra(const MGraph& graph, int start) {
    vector<int> dist(graph.numVertices, INT_MAX); // 初始化所有顶点的距离为无穷大
    vector<bool> visited(graph.numVertices, false); // 初始化所有顶点为未访问
    dist[start] = 0; // 起点到自己的距离为 0

    // 使用优先队列来实现 Dijkstra 算法
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
    pq.push({0, start}); // 将起点加入队列，初始距离为 0

    while (!pq.empty()) {
        int u = pq.top().second; // 取出当前距离最小的节点
        pq.pop();

        // 如果该节点已经被访问过，跳过
        if (visited[u]) continue;

        visited[u] = true; // 标记该节点为已访问

        // 更新所有邻接节点的最短路径
        for (int v = 0; v < graph.numVertices; ++v) {
            if (graph.Edge[u][v] != INT_MAX && !visited[v]) {
                int newDist = dist[u] + graph.Edge[u][v];
                if (newDist < dist[v]) {
                    dist[v] = newDist;
                    pq.push({dist[v], v}); // 更新队列中的距离
                }
            }
        }
    }

    return dist; // 返回最短路径数组
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
