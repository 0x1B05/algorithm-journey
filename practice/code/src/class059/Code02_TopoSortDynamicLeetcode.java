package class059;

import java.util.ArrayList;

/**
 * Code02_TopoSortDynamicLeetcode
 */
public class Code02_TopoSortDynamicLeetcode {
    public static int[] findOrder(int n, int[][] pre) {
        // pre[i][1] -> pre[i][0]

        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        int[] indegree = new int[n];

        // 初始化
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }

        // 建图
        for (int[] edge : pre) {
            graph.get(edge[1]).add(edge[0]);
            indegree[edge[0]]++;
        }

        // 初始化queue
        int[] queue = new int[n];
        int l = 0, r = 0;

        for (int i = 0; i < n; i++) {
            if (indegree[i] == 0) {
                queue[r++] = i;
            }
        }

        // 逐渐干掉入度为0的节点
        int cnt = 0;
        while (l < r) {
            int cur = queue[l++];
            cnt++;
            for (int next : graph.get(cur)) {
                if (--indegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }

        return cnt==n?queue:new int[0];
    }
}
