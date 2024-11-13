#include <iostream>
#include <vector>
#include <queue>
#include <stack>
#include <unordered_set>

using namespace std;

// 常量定义
const int MAXN = 1000; // 最大节点数量

// 邻接表：graph2[i] 存储与节点 i 连接的所有节点和对应的权重
vector<vector<pair<int, int>>> graph2(MAXN);

// BFS 广度优先遍历函数声明
void bfs(int startIndex);

// DFS 深度优先遍历函数声明
void dfs(int startIndex);

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

    cout << "BFS traversal:" << endl;
    bfs(0); // 从节点 0 开始 BFS 遍历
    cout << "\nDFS traversal:" << endl;
    dfs(0); // 从节点 0 开始 DFS 遍历

    return 0;
}

/**
 * 广度优先遍历 (BFS)
 * 使用队列和集合来进行遍历，并打印每个节点的值。
 * @param startIndex 起始节点的索引
 */
void bfs(int startIndex) {
    if (graph2[startIndex].empty()) {
        return;
    }

    // 队列用于BFS遍历，集合用于记录已访问的节点
    queue<int> queue;
    unordered_set<int> visited;

    // 初始化，将起始节点加入队列和集合
    queue.push(startIndex);
    visited.insert(startIndex);

    // 当队列不为空时继续遍历
    while (!queue.empty()) {
        int cur = queue.front();
        queue.pop();

        // 打印当前节点的值
        cout << cur << " ";

        // 遍历当前节点的所有邻接节点
        for (auto& next : graph2[cur]) {
            int nextNode = next.first;
            if (visited.find(nextNode) == visited.end()) {
                queue.push(nextNode);
                visited.insert(nextNode);
            }
        }
    }
}

/**
 * 深度优先遍历 (DFS)
 * 使用栈和集合来进行遍历，并打印每个节点的值。
 * @param startIndex 起始节点的索引
 */
void dfs(int startIndex) {
    if (graph2[startIndex].empty()) {
        return;
    }

    // 栈用于DFS遍历，集合用于记录已访问的节点
    stack<int> stack;
    unordered_set<int> visited;

    // 初始化，将起始节点加入栈和集合，并打印其值
    stack.push(startIndex);
    visited.insert(startIndex);
    cout << startIndex << " ";

    // 当栈不为空时继续遍历
    while (!stack.empty()) {
        int cur = stack.top();
        stack.pop();

        // 遍历栈顶节点的邻接节点
        for (auto& next : graph2[cur]) {
            int nextNode = next.first;
            if (visited.find(nextNode) == visited.end()) {
                // 将当前节点压回栈中，再将未访问的邻接节点压入栈
                stack.push(cur);
                stack.push(nextNode);
                visited.insert(nextNode);
                cout << nextNode << " ";
                break; // 只处理一个未访问的邻接节点
            }
        }
    }
}
