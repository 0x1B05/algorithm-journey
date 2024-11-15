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
