#import "../template.typ": *
#pagebreak()

== 简单排序算法

=== 选择排序

```java
public static void selectSort(int[] arr) {
    int len = arr.length;
    if (arr == null || len < 2) {
        return;
    }
    for (int i = 0; i < len - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j < len; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        swap(arr, i, minIndex);
    }
}
```

=== 冒泡排序

```java
public static void bubleSort(int[] arr) {
    int len = arr.length;
    if (arr == null || len < 2) {
        return;
    }
    for (int i = len - 1; i > 0; i--) {
        for (int j = 0; j < i; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr, j, j + 1);
            }
        }
    }
}
```

=== 插入排序

```java
public static void insertSort(int[] arr) {
        int len = arr.length;
        if (arr == null || len < 2) {
            return;
        }
        for (int i = 0; i < len - 1; i++) {//假设前i已经有序
            for (int j = i + 1; j > 0 && arr[j - 1] > arr[j]; j--) {//对i+1向前插入
                swap(arr, j, j - 1);
            }
        }
    }
```

== nlogn 排序

=== 归并排序

```java
public static void mergeSort(int[] arr) {
    int len = arr.length;
    if (arr == null || len < 2) {
        return;
    }
    process(arr, 0, len-1);
}

public static void process(int[] arr, int L, int R) {
    if (L == R) {
        return;
    }
    int mid = L + ((R - L) >> 1);
    process(arr, L, mid);
    process(arr, mid + 1, R);
    merge(arr, L, mid, R);
}

public static void merge(int[] arr, int L, int M, int R) {
    int[] container = new int[R - L + 1];
    int i = 0;
    int p1 = L, p2 = M + 1;
    while (p1 <= M && p2 <= R) {
        container[i++] = arr[p1] <= arr[p2] ? arr[p1++] : arr[p2++];
    }
    while (p1 <= M) {
        container[i++] = arr[p1++];
    }
    while (p2 <= R) {
        container[i++] = arr[p2++];
    }

    for(i = 0;i<container.length;i++)
    {
        arr[L+i] = container[i];
    }
}
```

==== 小和问题

数组小和定义如下:
$sum_(i=1)^(n)f_(i)$(其中$f_(i)$的定义是第$i$个数的左侧小于等于$s_(i)$的个数)
例如,数组 `s = [1, 3, 5, 2, 4, 6]` ,在 `s[0]` 的左边小于或等于 `s[0]` 的数的和为
0 ; 在 `s[1]` 的左边小于或等于 `s[1]` 的数的和为 1 ;在 `s[2]` 的左边小于或等于 `s[2]` 的数的和为
1+3=4 ;在 `s[3]` 的左边小于或等于 `s[3]` 的数的和为 1 ;在 `s[4]` 的左边小于或等于 `s[4]` 的数的和为
1+3+2=6 ;在 `s[5]` 的左边小于或等于 `s[5]` 的数的和为 1+3+5+2+4=15 .所以 s
的小和为 0+1+4+1+6+15=27 给定一个数组 s ,实现函数返回 s 的小和.

#tip("Tip")[
    变换参考系,从每个数右侧有几个数比自己大的角度入手.
] 

```java
public static long smallSum(int[] nums) {
    int len = nums.length;
    if (len < 2) {
        return 0;
    }
    return process(nums, 0, len - 1);
}

public static long process(int[] nums, int left, int right) {
    if (left == right) {
        return 0;
    }
    int mid = left + ((right - left) >> 1);
    return process(nums, left, mid) + process(nums, mid + 1, right) 
            + merge(nums, left, right);
}

public static long merge(int[] nums, int left, int right) {
    int mid = left + ((right - left) >> 1);
    int p1 = left;
    int p2 = mid + 1;
    int[] container = new int[right - left + 1];
    int i = 0;
    long sum = 0;

    while (p1 <= mid && p2 <= right) {
        sum += nums[p1] <= nums[p2] ? (nums[p1] * (right - p2 + 1)) : 0;
        container[i++] = nums[p1] <= nums[p2] ? nums[p1++] : nums[p2++]; // ++为各自运算
    }
    while (p1 <= mid) {
        container[i++] = nums[p1++];
    }
    while (p2 <= right) {
        container[i++] = nums[p2++];
    }
    for (i = 0; i < (right - left + 1); i++) {
        nums[left + i] = container[i];
    }
    return sum;
}
```

#tip("Tip")[
为什么想到用归并排序:归并排序的子序列有序,根据有序的子序列可以将时间复杂度降低.
]

==== 逆序对问题

在一个数组中,左边的数如果比右边的数大,则这两个数构成一个逆序对,找到逆序对的数量.

```java
public static int reversePairs(int[] arr) {
    int len = arr.length;
    if (arr == null || len < 2) {
        return 0;
    }
    return process(arr, 0, len-1);
}

public static int process(int[] arr, int L, int R) {
    if (L == R) {
        return 0;
    }
    int mid = L + ((R - L) >> 1);
    return process(arr, L, mid)+process(arr, mid + 1, R)+mergeAndCount(arr, L, mid, R);
}

public static int mergeAndCount(int[] arr, int L, int M, int R) {
    int[] container = new int[R - L + 1];
    int i = 0;
    int p1 = L, p2 = M + 1;
    int res = 0;
    while (p1 <= M && p2 <= R) {
        res += arr[p1] > arr[p2] ? (M-p1+1) : 0;//降低时间复杂度所在
        container[i++] = arr[p1] > arr[p2] ? arr[p2++] : arr[p1++];
    }
    while (p1 <= M) {
        container[i++] = arr[p1++];
    }
    while (p2 <= R) {
        container[i++] = arr[p2++];
    }

    for(i = 0;i<container.length;i++)
    {
        arr[L+i] = container[i];
    }

    return res;
}
```

=== 快速排序

==== 快速排序 1.0

===== 问题引入

给定一个数组`arr`和一个数 `num`,请把小于等于 `num`的数放在数组的左边,大于 `num`的数放在数组的右边.要求额外空间复杂度 `O(1)`,时间复杂度 `O(N)`.

```java
public static void swap(int[]arr,int i,int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

public static void qs1(int[]arr,int num) {
    int i = -1; //小于等于区域
    for(int j = 0;j<arr.length;j++)
    {
        if(arr[j]<=num)
        {
            swap(arr, ++i, j);
        }
    }
}
```

===== 快排 1.0

以最右边的数为基准分开数组,分开后将最右边的数与比起刚大一点的数交换,再将左右两侧递归使用上述方法（取最右侧为基准）

```java
public static void process(int[] arr, int l, int r) {
    if (l >= r) {   //仅仅是=是不够的,举例l=0,r=-1(即上一轮less=0)
        return;
    }
    int num = arr[r];
    int less = l - 1; // 小于等于区域
    for (int p = l; p <= r; p++) {
        if (arr[p] <= num) {
            swap(arr, ++less, p);
        }
    }
    process(arr, l, less-1);//注意r=less-1,而不是less,若为less,当less为子序列最大值时会造成死循环
    process(arr, less + 1, r);
}

public static void swap(int[] arr,int i,int j) {
    if(arr[i]==arr[j])
    {
        return;
    }
    arr[i] = arr[i]^arr[j];
    arr[j] = arr[i]^arr[j];
    arr[i] = arr[i]^arr[j];
}

public static void quickSort(int[] arr) {
    process(arr, 0, arr.length - 1);
}
```

==== 快速排序 2.0

===== 荷兰国旗问题

给定一个数组`arr`和一个数 `num`,请把小于`num`的数放在数组的左边,等于`num`的数放在数组的中间,大于 `num`的数放在数组的右边.要求额外空间复杂度 `O(1)`,时间复杂度 `O(N)`.

```java
public static void netherlandsFlag(int[] arr,int num) {
    int less = -1,more = arr.length;
    int p= 0;
    for(p = 0;p < more;p++)
    {
        if(arr[p]<num)
        {
            swap(arr, ++less, p);
        }else if(arr[p]>num){
            swap(arr, --more, p--);
        }
    }
}

public static void swap(int[] arr,int i,int j) {
    if(arr[i]==arr[j])
    {
        return;
    }
    arr[i] = arr[i]^arr[j];
    arr[j] = arr[i]^arr[j];
    arr[i] = arr[i]^arr[j];
}
```

===== 快排 2.0

在 1.0 的基础上将最右侧数的一组放在中间,左侧都比其小,右侧都比其大.

```java
public static void quickSort(int[] arr) {
    process(arr, 0, arr.length - 1);
}

public static void process(int[] arr, int l, int r) {
    if (l >= r) {
        return;
    }
    int less = l-1,more = r+1;
    int num = arr[r];
    int p= l;
    for(p = l;p<more;p++)
    {
        if(arr[p]<num)
        {
            swap(arr, ++less, p);
        }else if(arr[p]>num){
            swap(arr, --more, p--); // 大于区的交换之后未比较过，所以下标不能跳到下一位
        }
    }
    process(arr, l, less);
    process(arr, more, r);
}

public static void swap(int[] arr,int i,int j) {
    if(arr[i]==arr[j])
    {
        return;
    }
    arr[i] = arr[i]^arr[j];
    arr[j] = arr[i]^arr[j];
    arr[i] = arr[i]^arr[j];
}
```

数组有序的时候时间复杂度最高为 O(n^2)

==== 快速排序 3.0

```java
public static void quickSort(int[] arr) {
    process(arr, 0, arr.length - 1);
}

public static void process(int[] arr, int l, int r) {
    if (l >= r) {
        return;
    }
    swap(arr, l + (int) (Math.random() * (r - l + 1)), r);//利用随机数避免了人为构造复杂度高的数组
    int less = l-1,more = r+1;
    int num = arr[r];
    int p= l;
    for(p = l;p<more;p++)
    {
        if(arr[p]<num)
        {
            swap(arr, ++less, p);
        }else if(arr[p]>num){
            swap(arr, --more, p--);
        }
    }
    process(arr, l, less);
    process(arr, more, r);
}

public static void swap(int[] arr,int i,int j) {
    if(arr[i]==arr[j])
    {
        return;
    }
    arr[i] = arr[i]^arr[j];
    arr[j] = arr[i]^arr[j];
    arr[i] = arr[i]^arr[j];
}
```

== 堆排序
=== 完全二叉树子树和父树节点之间关系

==== 前提条件

二叉树一个节点有 2 个子节点,左节点和右节点。

==== 推导过程

假设根节点下标从 0 开始,则第 k 层的最后一个节点下标为：$2^{k}-1-1$,第一个节点为$2^{k-1}-1$。
假设父节点为第 k 层第 m 个节点,则其下标为:$F=2^{k-1}+m-1-1=2^{k-1}+m-2 $
其左子节点的下标
$C = F+(2^{k-1}-m)+(m-1) dot.op 2+1 $
$ = 2^{k-1}-m-2+(2^{k-1}-m)+(m-1) dot.op 2+1$
$ =2^{k}+2 m-4+1 =2F+1 $
即 *左子节点=2\*父节点+1* 同理 *右子节点=2\*父节点+2* 同样可知
*父节点=(子节点-1)/2*(这里计算机中的除以 2,省略掉小数)

=== 大根堆实现堆排序

大根堆就是根节点是整棵树的最大值(根节点大于等于左右子树的最大值),对于他的任意子树,根节点也是最大值。

```java
public static void heapSort(int[] nums) {
    if (nums == null || nums.length < 2) {
        return;
    }
    // // 首先对整体进行堆化
    // int heapSize = 0;
    // for (heapSize = 0; heapSize < nums.length; heapSize++) {
    // heapInsert(nums, heapSize); // o(logn)
    // }

    // 一种更快的堆化方式：利用heapify,所有数字是一次性给出,而不是一个个
    int heapSize = nums.length;
    for (int i = heapSize - 1; i >= 0; i--) { // 注意取等0
        heapify(nums, i, heapSize);
    }
    heapSize = nums.length;
    // 假设是完全二叉树,则复杂度：T(n) = n/2+(n/4)*2+(n/8)*3.... 为o(n)

    // heapSize表示长度而不是下标
    for (int i = 0; i < nums.length; i++) {
        swap(nums, 0, --heapSize); // o(1)
        heapify(nums, 0, heapSize); // o(logn) 事实上heapInsert也能完成堆化操作,但是复杂度高
    }
}

// 当前处于index位置,继续向上移动
public static void heapInsert(int[] nums, int index) {
    int parent = (index - 1) / 2;
    while (nums[index] > nums[parent]) {// 循环停止条件：1.已经是根节点的时候 2.父节点更大时
        swap(nums, index, parent);
        index = (index - 1) / 2;
        parent = (index - 1) / 2;
    }
}

// 某个数在index位置,能否往下移动(子树都是大根堆)
public static void heapify(int[] nums, int index, int heapSize) {
    int parent = index;
    int left = 2 * parent + 1;
    int right = 2 * parent + 2;
    while (left < heapSize) { // left是下标,heapSize是具体长度,故用<;这句话里表示如果还有孩子的话
        int largerChild = right < heapSize && nums[right] > nums[left] ? right : left;// 找到孩子中较大的一个
        int max = nums[largerChild] > nums[parent] ? largerChild : parent; // 找出父亲和较大的孩子里较大的那一个
        if (max != parent) { // 最大值不是父节点,交换父节点和最大值（即较大孩子）
            swap(nums, parent, max);
            parent = max;
            left = 2 * parent + 1;
            right = 2 * parent + 2;
        } else { // 最大值就是父节点,堆化完成
            break;
        }
    }
}
```

#tip("Tip")[
- 降序可以使用小根堆。 
- 若是已知某个大根堆中 `i` 位置的数改成了`x` ,继续调整为大根堆要么 `heapInsert` 要么 `heapify`
]

==== 堆排序扩展题目

已知一个几乎有序的数组, 几乎有序是指, 如果把数组排好顺序的话,
每个元素移动的距离可以不超过 k, 并且 k
相对于数组来说比较小。请选择一个合适的排序算法针对这个数据进行排序。

```java
// 复杂度o(nlogk)
public static void sortedArrDistanceLessK(int[] arr, int k) {
    PriorityQueue<Integer> heap = new PriorityQueue<>();
    // p1是入堆的指针,p2是排序数组的指针
    int p1 = 0;
    int p2 = 0;
    // 首先前 k+1 入堆
    for (; p1 <= Math.min(arr.length-1, k); p1++) {
        heap.add(arr[p1]);
    }
    // 接着往后依次维护 k+1 大小的范围 依次弹出最小值
    for (; p1 < arr.length; p1++, p2++) {
        arr[p2] = heap.poll();
        heap.add(arr[p1]);
    }
    while (!heap.isEmpty()) {
        arr[p2++] = heap.poll();
    }
}
```

> 这里使用了系统提供的优先队列结构（即小根堆）
> 扩容：每次成倍扩容,每扩容一次拷贝一下 o(n),扩容次数为
o(logn),但是平均每个数字只有 o(logn)

== 基数排序(不基于比较的排序)

不基于比较的排序一定要根据具体数据状况来做出一些操作

```java
public static void radixSort(int[] nums) {
    if (nums == null || nums.length < 2) {
        return;
    }
    radixSort(nums, 0, nums.length-1, getDigit(nums));
}

// 获得num倒数第digit位的数字
public static int getNum(int num, int digit) {
    // 先求10的d-1次方
    // x除以10的d-1次方后
    // 得到的数再与10求余
    return (num / (int) Math.pow(10, digit - 1)) % 10;
}

// 获得nums数组中的最大数的最大进制位
public static int getDigit(int[] nums) {
    int max = Integer.MIN_VALUE;
    int digit = 0;

    // 遍历得到数组最大值
    for (int i = 0; i < nums.length; i++) {
        max = Math.max(max, nums[i]);
    }
    // 获取最大值的位数
    while (max > 0) {
        max /= 10;
        digit++;
    }
    return digit;
}

// digit代表nums数组中最大数的最大进制位
public static void radixSort(int[] nums, int left, int right, int digit) {
    // radix表示10进制
    // container为辅助数组,临时存储nums
    final int radix = 10;
    int[] container = new int[right-left+1];
    // 依次对最低位到最高位进行排序
    for (int d = 1; d <= digit; d++) {
        // 申请0-9的基数数组
        int[] cnt = new int[radix];
        // 进行nums数组倒数第d位的词频统计
        for (int i = left; i <= right; i++) {
            int num = getNum(nums[i], d);
            cnt[num]++;
        }
        // 将基数数组改为前缀和数组
        // cnt[i]代表当前位上≤i的数字有几个
        for (int i = 1; i < cnt.length; i++) {
            cnt[i] = cnt[i] + cnt[i-1];
        }
        // 把nums[i]按cnt数组的顺序放在辅助数组中
        // 从右向左进行遍历,保证后进桶的后出桶,因为后进桶的倒数d-1位更大,排在更后面
        for (int i = container.length-1; i >= 0; i--) {
            // num表示当前数倒数第d位的数
            int num = getNum(nums[left+i], d);
            // --cnt[num]当前数应该放的顺序,--是因为cnt数组代表的是个数而不是下标,且放置后需要-1操作
            container[--cnt[num]] = nums[left+i];
        }
        // 将排好序的辅助数组copy回原数组
        for (int i = 0; i < container.length; i++) {
            nums[left+i] = container[i];
        }
    }
}
```

== 总结

#image("./images/2022-03-16-11-12-44.png")

=== 排序稳定性：

同样值的个体之间。如果不因为排序而改变相对次序，这个排序就是具有稳定性的，否则就是没有。

==== 不具备稳定性的排序：

选择排序、快速排序、堆排序

==== 可具备稳定性的排序：

冒泡排序、插入排序、归并排序、一切桶排序思想下的排序

=== 基于比较的排序：

1. 一般都是用快排，因为快排的常数项指标最低
1. O(NlogN)是最快的了
1. 当时间复杂度 O(NlogN),空间复杂度
  O(N)的条件下，还可以保持稳定，目前没有这样的算法

=== 一些坑：

1. 归并排序的额外空间复杂度可以变成
  O(1)，但实现很难（实现可用归并内部缓存法），还会丧失稳定性，不如直接用堆排序。
2. 原地归并排序没有意义，空间复杂度变成 O(1)，但时间复杂度
  O(N²)，不如直接用插入排序。
3. 快排可以做到稳定性，但会使快排的空间复杂度变成 O(N)，不如直接用归并排序。
4. 所以没必要改进，要得到一些性质就必要损失一些性质。
5. 如果面试官问你：奇数放数组左边，偶数放在数组右边，还要求原始的相对次序不变，时间复杂度
  O(N)，空间复杂度 O(1)。你可以回答这类似于经典快排的 0 1
  问题，但没办法做到上面的要求，所以我不会，希望面试官可以教教我。

=== 工程上对排序的改进

1. 充分利用 O（nlogn）和 O（n^2）排序各自的优势 > 例如小样本插入排序（此时
  O（n^2）较快,常数项小），样本大的时候快排
2. 稳定性的考虑

