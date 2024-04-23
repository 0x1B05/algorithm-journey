#import "../template.typ": *

#pagebreak()
= 堆结构
堆的节点关系:

```
left = 2*parent + 1
right = 2*parent + 2
parent = (child-1)/2
```

完全二叉树和数组前缀范围来对应，大小，单独的变量size来控制

堆的调整：`heapInsert`（向上调整）、`heapify`（向下调整）

#tip(
  "Tip",
)[
`heapInsert`、`heapify`方法的单次调用，时间复杂度`O(log n)`，完全二叉树的结构决定的
]

== 堆排序

=== 复杂度分析

==== 建堆复杂度

- 从顶到底建堆，时间复杂度`O(n * log n)`，`log1 + log2 + log3 + … + logn -> O(n*logn)`
  #tip("Tip")[
  或者用增倍分析法：
  - 建堆的复杂度分析
    - 当元素为N时复杂度的上限是`O(n * log n)`
    - 当元素为2N时复杂度的下限是`O(n * log n)`
    - 故而复杂度就是`O(n * log n)`
  - 子矩阵数量的复杂度分析
    - `n*m`矩阵, 任选两点后去重$(n^2 m^2)/4$, 复杂度上限$O(n^2 m^2)$
    - `2n*2m`矩阵, 2 4象限任选两点不需要去重, 复杂度下限$O(n^2 m^2)$
    - 故而复杂度就是$O(n^2 m^2)$
  ]

- 从底到顶建堆，时间复杂度`O(n)`，总代价就是简单的等比数列关系，为啥会有差异？
  - 顶到底，第一层`heapInsert`一层，第二层`heapInsert`二层...
  - 底到顶，最后一层`heapify`一层，倒二层`heapify`二层...
  - 而底的元素多，因此底到顶`heapify`更好

==== 调整阶段
从最大值到最小值依次归位，时间复杂度`O(n * log n)`, 时间复杂度`O(n * log n)`，不管以什么方式建堆，调整阶段的时间复杂度都是这个，所以整体复杂度也是这个.

==== 空间复杂度
额外空间复杂度是`O(1)`，因为堆直接建立在了要排序的数组上，所以没有什么额外空间

=== #link("https://www.luogu.com.cn/problem/P1177")[ acm风格 ]
#code(
  caption: [堆排序-acm风格],
)[
```java
public class Code01_HeapSort {
    public static int MAXN = 100001;
    public static int[] nums = new int[MAXN];
    public static int n;

    // i位置的数，变大了，又想维持大根堆结构
    // 向上调整大根堆
    public static void heapInsert(int cur) {
        int parent = (cur - 1) / 2;
        while (nums[cur] > nums[parent]) {
            swap(cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    // i位置的数，变小了，又想维持大根堆结构
    // 向下调整大根堆
    // 当前堆的大小为size
    public static void heapify(int cur, int size) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int maxChild = right < size && nums[right] > nums[left] ? right : left;
            int max = nums[maxChild] > nums[cur] ? maxChild : cur;
            if (max == cur) {
                break;
            } else {
                swap(max, cur);
                cur = max;
                left = 2 * cur + 1;
            }
        }
    }

    // 从顶到底建立大根堆，O(n * logn)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort1() {
        // 每个节点向上移动形成大根堆
        for (int cur = 1; cur < n; cur++) {
            heapInsert(cur);
        }
        int size = n;
        while (size > 0) {
            swap(0, --size);
            heapify(0, size);
        }
    }

    // 从底到顶建立大根堆，O(n)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort2() {
        for (int cur = n - 1; cur >= 0; cur--) {
            heapify(cur, n);
        }
        int size = n;
        while (size > 1) {
            swap(0, --size);
            heapify(0, size);
        }
    }

    public static void swap(int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        n = (int) in.nval;
        for (int i = 0; i < n; i++) {
            in.nextToken();
            nums[i] = (int) in.nval;
        }
        // heapSort1();
        heapSort2();
        for (int i = 0; i < n - 1; i++) {
            out.print(nums[i] + " ");
        }
        out.println(nums[n - 1]);
        out.flush();
        out.close();
        br.close();
    }
}
```
]

#tip(
  "Tip",
)[
- 降序可以使用小根堆。
- 若是已知某个大根堆中 `i` 位置的数改成了`x`, 继续调整为大根堆要么 `heapInsert` 要么 `heapify`
]

=== #link("https://www.luogu.com.cn/problem/P1177")[ acm风格 ]

#code(
  caption: [堆排序-leetcode风格],
)[
```java
public class Code02_HeapSort {
    // i位置的数，变小了，又想维持大根堆结构
    // 向下调整大根堆
    // 当前堆的大小为size
    public static void heapify(int[] nums, int cur, int size) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int maxChild = right < size && nums[right] > nums[left] ? right : left;
            int max = nums[maxChild] > nums[cur] ? maxChild : cur;
            if (max == cur) {
                break;
            } else {
                swap(nums, max, cur);
                cur = max;
                left = 2 * cur + 1;
            }
        }
    }

    // i位置的数，变大了，又想维持大根堆结构
    // 向上调整大根堆
    public static void heapInsert(int[] nums, int cur) {
        int parent = (cur - 1) / 2;

        while (nums[cur] > nums[parent]) {
            swap(nums, cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    // 从顶到底建立大根堆，O(n * logn)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort1(int[] nums) {
        int n = nums.length;
        // 每个节点向上移动形成大根堆
        for (int i = 0; i < n; i++) {
            heapInsert(nums, i);
        }

        int size = n;
        while (size > 1) {
            swap(nums, 0, --size);
            heapify(nums, 0, size);
        }
    }

    // 从底到顶建立大根堆，O(n)
    // 依次弹出堆内最大值并排好序，O(n * logn)
    // 整体时间复杂度O(n * logn)
    public static void heapSort2(int[] nums) {
        int n = nums.length;
        for (int cur = n - 1; cur >= 0; cur--) {
            heapify(nums, cur, n);
        }
        int size = n;
        while (size > 1) {
            swap(nums, 0, --size);
            heapify(nums, 0, size);
        }
    }
    public static void swap(int[] nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }

    public static int[] sortArray(int[] nums) {
        if (nums.length > 1) {
            // heapSort1为从顶到底建堆然后排序
            // heapSort2为从底到顶建堆然后排序
            // 用哪个都可以
            // heapSort1(nums);
            heapSort2(nums);
        }
        return nums;
    }
}
```
]

== 经典题目

=== #link(
  "https://www.nowcoder.com/practice/65cfde9e5b9b4cf2b6bafa5f3ef33fa6",
)[题目1: 合并K个有序链表]

合并 `k` 个升序的链表并将结果作为一个升序的链表返回其头节点。


#example("Example")[
- 输入： `[L{1,2,3},{4,5,6,7}]`
- 返回值：`{1,2,3,4,5,6,7}`
]
#tip("Tip")[
- 节点总数 `0≤n≤5000`
- 每个节点的`val`满足 `∣val∣<=1000`
- 要求：时间复杂度 `O(nlogn)`
]

==== 解答

k个链表；n个节点。

暴力解法复杂度分析： 把所有节点加入一个大容器，然后再排序。
- 空间O(n)
- 时间O(n)+O(nlogn)

堆结构复杂度分析：
- 空间O(k)
- 时间O(nlogk)

#code(
  caption: [题目1: 合并K个有序链表],
)[
```java
public class Code01_MergeKSortedLists {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    public ListNode mergeKLists(ArrayList<ListNode> lists) {
        PriorityQueue<ListNode> heap = new PriorityQueue<>((a, b) -> (a.val - b.val));
        for (ListNode listNode : lists) {
            if (listNode != null) {
                heap.add(listNode);
            }
        }
        if (heap.isEmpty()) {
            return null;
        }
        ListNode head = heap.poll();
        ListNode tail = head;
        if (tail.next != null) {
            heap.add(tail.next);
        }
        while (!heap.isEmpty()) {
            ListNode cur = heap.poll();
            tail.next = cur;
            tail = cur;
            if (cur.next != null) {
                heap.add(cur.next);
            }
        }
        return head;
    }
}
```
]

=== #link(
  "https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37",
)[题目2: 最多线段重合问题]

每一个线段都有 `start` 和 `end` 两个数据项，表示这条线段在 X 轴上从 `start` 位置开始到 `end` 位置结束。给定一批线段，求所有重合区域中最多重合了几个线段，首尾相接的线段不算重合。
例如：线段`[1,2]`和线段`[2,3]`不重合。 线段`[1,3]`和线段`[2,3]`重合

- 输入描述：
  - 第一行一个数`N`，表示有`N`条线段
  - 接下来`N`行每行`2`个数，表示线段起始和终止位置
- 输出描述：
  - 输出一个数，表示同一个位置最多重合多少条线段

#example("Example")[
输入：
```
  3
  1 2
  2 3
  1 3
  ```
输出：`2`
]

#tip("Tip")[
  - $N≤10^4$
  - $1≤"start","end"≤10^5$
]

==== 解答

重合区域的左边界一定是某个线段的左边界。

先按照开始位置从小到大排序. 接着把结束位置放到小根堆里. 来到`[x,y]`,
把小根堆里面小于等于`x`的弹出, 把`y`放到小根堆, 看小根堆里有几个, 即当前`[x,y]`线段的答案.

解释： 以`x`为重合区域左边界，有多少线段(包括自身)能到达`x`的右边，因为左边的线段开始位置比`x`早，结束位置又在`x`之后，那就是算一次重合(结束位置在`x`之前的已经被弹出)。

#code(
  caption: [题目2: 最多线段重合问题],
)[
```java
public class Code02_MaxCover {
    public static int MAXN = 10001;
    public static int n;
    public static int[][] line = new int[MAXN][2];

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                line[i][0] = (int) in.nval;
                in.nextToken();
                line[i][1] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int[] heap = new int[MAXN];
    public static int size = 0;

    public static void heapInsert(int cur) {
        int parent = (cur - 1) / 2;
        while (heap[cur] < heap[parent]) {
            swap(cur, parent);
            cur = parent;
            parent = (cur - 1) / 2;
        }
    }

    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static void heapify(int cur) {
        int left = 2 * cur + 1;
        while (left < size) {
            int right = left + 1;
            int minChild = right < size && heap[right] < heap[left] ? right : left;
            int min = heap[minChild] < heap[cur] ? minChild : cur;
            if (min == cur) {
                break;
            } else {
                swap(cur, min);
                cur = min;
                left = 2 * cur + 1;
            }
        }
    }
    public static void add(int num) {
        int cur = size++;
        heap[cur] = num;
        heapInsert(cur);
    }

    public static void pop() {
        swap(0, --size);
        heapify(0);
    }

    public static int compute() {
        int max = 0;
        Arrays.sort(line, 0, n, (a, b) -> a[0] - b[0]);

        for (int i = 0; i < n; i++) {
            while (size > 0 && heap[0] <= line[i][0]) pop();
            add(line[i][1]);
            max = Math.max(max, size);
        }

        return max;
    }
}
```
]

- 时间复杂度：O(nlogn)
- 空间复杂度：O(n)

=== #link(
  "https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/",
)[题目3: 将数组和减半的最少操作次数]

给你一个正整数数组 `nums` 。每一次操作中，你可以从 `nums` 中选择 任意
一个数并将它减小到 *恰好*
一半。（注意，在后续操作中你可以对减半过的数继续执行操作）

请你返回将 `nums` 数组和 至少 减少一半的 最少 操作数。

#example(
  "Example",
)[
- 输入：`nums = [5,19,8,1]`
- 输出：`3`
- 解释：初始 nums 的和为 `5 + 19 + 8 + 1 = 33` 。
  以下是将数组和减少至少一半的一种方法：
  - 选择数字 `19` 并减小为 `9.5` 。
  - 选择数字 `9.5` 并减小为 `4.75` 。
  - 选择数字 `8` 并减小为 `4` 。
  - 最终数组为 `[5, 4.75, 4, 1]` ，和为 `5 + 4.75 + 4 + 1 = 14.75` 。
  - `nums` 的和减小了 `33 - 14.75 = 18.25` ，减小的部分超过了初始数组和的一半，`18.25 >= 33/2 = 16.5` 。
  - 我们需要 `3` 个操作实现题目要求，所以返回 `3` 。
  - 可以证明，无法通过少于 `3` 个操作使数组和减少至少一半。
]

#tip("Tip")[
`1 <= nums.length <= 10^5`
`1 <= nums[i] <= 10^7`
]

==== 解答

#code(caption: [题目3: 将数组和减半的最小操作数])[
```java
public class Code03_MinimumOperationsToHalveArraySum {
    public static int halveArray(int[] nums) {
        PriorityQueue<Double> heap = new PriorityQueue<>((a, b) -> b.compareTo(a));
        double sum = 0;
        for (int i = 0; i < nums.length; i++) {
            heap.add((double) nums[i]);
            sum += nums[i];
        }
        double target = sum / 2;

        int ans = 0;
        double cur = 0;
        for (double minus = 0; minus < target; minus += cur) {
            cur = heap.poll() / 2;
            heap.add(cur);
            ans++;
        }
        return ans;
    }

    public static int MAXN = 100001;

    public static long[] heap = new long[MAXN];

    public static int size;

    public static int halveArray2(int[] nums) {
        size = nums.length;
        long sum = 0;
        for (int i = size - 1; i >= 0; i--) {
            heap[i] = (long) nums[i] << 20;
            sum += heap[i];
            heapify(i);
        }
        sum /= 2;
        int ans = 0;
        for (long minus = 0; minus < sum; ans++) {
            heap[0] /= 2;
            minus += heap[0];
            heapify(0);
        }
        return ans;
    }

    public static void heapify(int i) {
        int l = i * 2 + 1;
        while (l < size) {
            int best = l + 1 < size && heap[l + 1] > heap[l] ? l + 1 : l;
            best = heap[best] > heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(best, i);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static void swap(int i, int j) {
        long tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }
}
```
]
