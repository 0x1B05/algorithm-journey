#include <iostream>
#include <algorithm>

using namespace std;

// 定义最大节点数和最大边数
const int MAXN = 5001;
const int MAXM = 200001;

// 全局变量声明
int n, m;                   // n为节点数, m为边数
int edges[MAXM][3];         // edges存储所有边的信息, 每条边为 [u, v, w]
int father[MAXN];           // 并查集的父节点数组
int ans;                    // 最小生成树的权值总和

// 函数声明
void init();                // 初始化并查集
bool unionSet(int x, int y); // 合并两个节点所在的集合
int find(int x);            // 查找节点x的代表元（路径压缩）
bool compute();             // 计算最小生成树的权值

// 主函数
int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    while (cin >> n >> m) {
        init(); // 初始化并查集
        // 读取所有边的信息
        for (int i = 0; i < m; i++) {
            cin >> edges[i][0] >> edges[i][1] >> edges[i][2]; // 读取边u, v和权值w
        }

        // 计算最小生成树的权值并输出结果
        if (compute()) {
            cout << ans << endl; // 输出最小生成树的总权值
        } else {
            cout << "orz" << endl; // 如果无法构成最小生成树，输出"orz"
        }
    }
    return 0;
}

// 初始化并查集，每个节点的父节点指向自己
void init() {
    ans = 0; // 重置答案
    for (int i = 1; i <= n; i++) {
        father[i] = i; // 父节点初始化为自己
    }
}

// 查找节点x的代表元，并进行路径压缩
int find(int x) {
    if (father[x] != x) {
        father[x] = find(father[x]); // 路径压缩
    }
    return father[x];
}

// 合并两个节点x和y所在的集合，返回是否合并成功
bool unionSet(int x, int y) {
    int fx = find(x); // 查找x的代表元
    int fy = find(y); // 查找y的代表元
    if (fx != fy) {   // 如果两个节点不在同一个集合，则合并
        father[fx] = fy; // 合并集合
        return true;
    } else {
        return false; // 如果已经在同一集合，则不合并
    }
}

// 计算最小生成树的总权值，返回是否构成最小生成树
bool compute() {
    // 使用C++标准库中的sort函数对边按权值从小到大排序
    sort(edges, edges + m, [](const int* a, const int* b) {
        return a[2] < b[2]; // 按照边的权值升序排序
    });

    int edgeCnt = 0; // 记录加入最小生成树的边数
    ans = 0; // 初始化最小生成树的权值

    // 遍历所有边，使用Kruskal算法构建最小生成树
    for (int i = 0; i < m; ++i) {
        int u = edges[i][0];
        int v = edges[i][1];
        int w = edges[i][2];

        // 如果u和v不在同一个集合，合并它们，并将该边加入最小生成树
        if (unionSet(u, v)) {
            ans += w; // 累加权值
            edgeCnt++; // 计数已加入最小生成树的边
        }
    }

    // 判断最小生成树是否包含所有的n-1条边
    return edgeCnt == n - 1;
}
