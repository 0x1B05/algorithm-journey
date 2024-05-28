package class061;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;
/**
 * Code02_PrimStatic
 */
public class Code02_PrimStatic {
    public static int MAXN = 5001;
    public static int MAXM = 400001;
    public static int n,m;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] to = new int[MAXM];
    public static int[] next = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // 反向索引堆
    public static int[][] heap = new int[MAXN][2];
    // where[v] = -1，表示v这个节点，从来没有进入过堆
    // where[v] = -2，表示v这个节点，已经弹出过了
    // where[v] = i(>=0)，表示v这个节点，在堆上的i位置
    public static int[] where = new int[MAXN];
    public static int heapSize;

    // 最小生成树已经找到的节点数
    public static int nodeCnt;
    // 最小生成树的权重和
    public static int ans;

    public static void build(){
        cnt = 1;
        heapSize = 0;
        nodeCnt = 0;
        Arrays.fill(head, 1, n+1, 0);
        Arrays.fill(where, 1, n+1, -1);
    }

    public static void addEdge(int f, int t, int w){
        to[cnt] = t;
        weight[cnt] = w;
        next[cnt] = head[f];
        head[f] = cnt++;
    }

    // 当前处于cur,向上调整成堆
    public static void heapInsert(int cur){
        int parent = (cur-1)/2;
        while(heap[parent][1]>heap[cur][1]){
            swap(parent, cur);
            cur = parent;
            parent = (cur-1)/2;
        }
    }

    // 当前处于cur,向下调整成堆
    public static void heapify(int cur){
        int left = 2*cur+1;
        while(left<heapSize){
            int right = left+1;
            int minChild = (right<heapSize && heap[right][1]<heap[left][1])?right:left;
            int min = heap[minChild][1]<heap[cur][1]?minChild:cur;
            if(min==cur){
                break;
            }else{
                swap(minChild, cur);
                cur = minChild;
                left = 2*cur+1;
            }
        }
    }

    // 堆上i位置与j位置交换
    public static void swap(int i, int j){
        // where的交换
        int a = heap[i][0];
        int b = heap[j][0];
        where[a] = j;
        where[b] = i;

        // 元素的交换
        int[] tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static boolean isEmpty(){
        return heapSize==0 ? true:false;
    }

    public static int popTo, popWeight;
    public static void pop(){
        popTo = heap[0][0];
        popWeight = heap[0][1];
        swap(0, --heapSize);
        heapify(0);
        where[popTo] = -2;
        nodeCnt++;
    }

    // 点在堆上的记录要么新增，要么更新，要么忽略
    // 当前处理编号为cur的边
    public static void addOrUpdateOrIgnore(int cur){
        int t = to[cur];
        int w = weight[cur];
        if(where[t]==-1){
            // 从来没进入过
            heap[heapSize][0] = t;
            heap[heapSize][1] = w;
            where[t] = heapSize++;
            heapInsert(where[t]);
        }else if(where[t]>=0){
            // 已经在堆里
            // 谁小留谁
            heap[where[t]][1] = Math.min(heap[where[t]][1], w);
            heapInsert(where[t]);
        }
    }

    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken()!=StreamTokenizer.TT_EOF){
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build();
            for (int i = 0, f, t, w; i < m; i++) {
                in.nextToken();
                f = (int) in.nval;
                in.nextToken();
                t = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                addEdge(f, t, w);
                addEdge(t, f, w);
            }
            int ans = prim();
            out.println(nodeCnt == n ? ans : "orz");
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int prim(){
        // 从1节点出发
        nodeCnt = 1;
        where[1] = -2;
        for (int ei = head[1]; ei > 0; ei=next[ei]) {
            addOrUpdateOrIgnore(ei);
        }

        while(!isEmpty()){
            pop();
            ans += popWeight;
            for (int ei = head[popTo]; ei > 0; ei=next[ei]) {
                addOrUpdateOrIgnore(ei);
            }
        }
        return ans;
    }
}
