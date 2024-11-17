#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>  // 包含INT_MAX

using namespace std;

const int MAXV = 100; // 最大顶点数
const int INF = INT_MAX;  // 无穷大，表示无法到达的距离

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

    // 初始化图的边（无向图）
    G->edge[0][1] = G->edge[1][0] = 10;
    G->edge[0][2] = G->edge[2][0] = 6;
    G->edge[0][3] = G->edge[3][0] = 5;
    G->edge[1][3] = G->edge[3][1] = 15;
    G->edge[2][3] = G->edge[3][2] = 4;
    G->edge[1][2] = G->edge[2][1] = 25;
    G->edge[3][4] = G->edge[4][3] = 2;

    // 运行Kruskal算法
    int result = kruskal(G);
    if (result == -1) {
        cout << "无法生成最小生成树，图不连通。" << endl;
    } else {
        cout << "Kruskal算法得到的最小生成树的权值为: " << result << endl;
    }

    return 0;
}
