#include <iostream>
#include <vector>
#include <cstring> // 用于 `memset` 初始化数组
using namespace std;

// 点的最大数量
const int MAXN = 11;
// 边的最大数量
const int MAXM = 21;

// 邻接矩阵
int graph1[MAXN][MAXN];

// 邻接表
vector<vector<pair<int, int>>> graph2(MAXN);

// 链式前向星
int head[MAXN], nextEdge[MAXM], to[MAXM], weight[MAXM];
int cnt = 1;

// n->节点数量
void build(int n) {
    // 邻接矩阵清空
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            graph1[i][j] = 0;
        }
    }

    // 邻接表清空
    graph2.clear();
    graph2.resize(n + 1);

    // 链式前向星清空
    cnt = 1;
    memset(head, 0, sizeof(head));
}

// 链式前向星加边
void addEdge(int u, int v, int w) {
    to[cnt] = v;
    weight[cnt] = w;
    nextEdge[cnt] = head[u];
    head[u] = cnt++;
}

// 建立有向图带权图
void directGraph(vector<vector<int>>& edges) {
    for (auto& edge : edges) {
        graph1[edge[0]][edge[1]] = edge[2];
    }
    for (auto& edge : edges) {
        graph2[edge[0]].emplace_back(edge[1], edge[2]);
    }
    for (auto& edge : edges) {
        addEdge(edge[0], edge[1], edge[2]);
    }
}

// 建立无向图带权图
void undirectGraph(vector<vector<int>>& edges) {
    for (auto& edge : edges) {
        graph1[edge[0]][edge[1]] = edge[2];
        graph1[edge[1]][edge[0]] = edge[2];
    }
    for (auto& edge : edges) {
        graph2[edge[0]].emplace_back(edge[1], edge[2]);
        graph2[edge[1]].emplace_back(edge[0], edge[2]);
    }
    for (auto& edge : edges) {
        addEdge(edge[0], edge[1], edge[2]);
        addEdge(edge[1], edge[0], edge[2]);
    }
}

// 遍历图结构
void traversal(int n) {
    cout << "邻接矩阵遍历: " << endl;
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            if (graph1[i][j] != 0) {
                cout << i << "->" << j << " weight: " << graph1[i][j] << endl;
            }
        }
    }

    cout << "邻接表遍历: " << endl;
    for (int i = 1; i <= n; i++) {
        for (auto& edge : graph2[i]) {
            cout << i << "->" << edge.first << " weight: " << edge.second << endl;
        }
    }

    cout << "链式前向星遍历: " << endl;
    for (int i = 1; i <= n; i++) {
        for (int ei = head[i]; ei > 0; ei = nextEdge[ei]) {
            cout << i << "->" << to[ei] << " weight: " << weight[ei] << endl;
        }
    }
}

// 主函数
int main() {
    int n1 = 4;
    vector<vector<int>> edges1 = {{1, 3, 6}, {4, 3, 4}, {2, 4, 2}, {1, 2, 7}, {2, 3, 5}, {3, 1, 1}};
    build(n1);
    directGraph(edges1);
    traversal(n1);
    cout << "==============================" << endl;

    int n2 = 5;
    vector<vector<int>> edges2 = {
        {3, 5, 4}, {4, 1, 1}, {3, 4, 2}, {5, 2, 4}, {2, 3, 7}, {1, 5, 5}, {4, 2, 6}};
    build(n2);
    undirectGraph(edges2);
    traversal(n2);

    return 0;
}
