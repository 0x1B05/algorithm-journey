#include <iostream>
#include <vector>
#include <queue>
#include <climits>  // 包含INT_MAX

using namespace std;

const int MAXV = 100;  // 最大顶点数
const int INF = INT_MAX;  // 无穷大

// 图的结构定义
typedef struct {
    int numberVertices, numberEdges;   // 顶点数和边数
    char VerticesList[MAXV];           // 顶点列表（用字符表示）
    int edge[MAXV][MAXV];              // 邻接矩阵
} MGraph;

// Prim算法，返回最小生成树的权值
int prim(MGraph *G) {
    int n = G->numberVertices;
    int nodeCnt = 0;
    int ans = 0;

    vector<bool> set(n, false);  // 用于跟踪某个顶点是否已经包含在MST中
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> heap;

    // 从顶点0开始，将其所有相连的边加入优先队列
    for (int i = 0; i < n; i++) {
        if (G->edge[0][i] != 0) {
            heap.push({G->edge[0][i], i});  // 插入边的权重和目标顶点
        }
    }
    set[0] = true;  // 将起始顶点标记为已包含
    nodeCnt++;

    while (!heap.empty()) {
        pair<int, int> top = heap.top();
        heap.pop();
        int weight = top.first;
        int to = top.second;

        if (!set[to]) {  // 如果该顶点还没有被包含在MST中
            ans += weight;  // 加入到MST，累加权值
            nodeCnt++;
            set[to] = true;

            // 将包含顶点的所有边加入到优先队列中
            for (int i = 0; i < n; i++) {
                if (G->edge[to][i] != 0 && !set[i]) {
                    heap.push({G->edge[to][i], i});  // 将边的权重和目标顶点加入队列
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

    // 初始化图的边（无向图）
    G->edge[0][1] = G->edge[1][0] = 10;
    G->edge[0][2] = G->edge[2][0] = 6;
    G->edge[0][3] = G->edge[3][0] = 5;
    G->edge[1][3] = G->edge[3][1] = 15;
    G->edge[2][3] = G->edge[3][2] = 4;
    G->edge[1][2] = G->edge[2][1] = 25;
    G->edge[3][4] = G->edge[4][3] = 2;

    // 运行Prim算法
    int result = prim(G);
    if (result == -1) {
        cout << "无法生成最小生成树，图不连通。" << endl;
    } else {
        cout << "Prim算法得到的最小生成树的权值为: " << result << endl;
    }

    return 0;
}
