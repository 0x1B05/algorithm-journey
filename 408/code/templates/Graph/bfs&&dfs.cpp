#include <iostream>
#include <queue>
#include <stack>
#include <vector>

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
            graph.Edge[i][j] = 0; // 初始化为无穷大
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
            if (graph.Edge[cur][i] != 0 && !visited[i]) {
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
            if (graph.Edge[cur][i] != 0 && !visited[i]) {
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
