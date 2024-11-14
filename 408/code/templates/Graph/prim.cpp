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
