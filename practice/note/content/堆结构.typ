#import "../template.typ": *

#pagebreak()
= 堆结构

堆的节点关系:

```
left = 2*parent + 1
right = 2*parent + 2
parent = (child-1)/2
```

== 堆排序

#code(caption: [堆排序])[
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
// 用处: 把大根堆的最大值去掉之后再调整成大根堆(先把堆的最后一个和根交换, 然后对根heapify)
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
]

- 降序可以使用小根堆。
- 若是已知某个大根堆中 `i` 位置的数改成了`x`, 继续调整为大根堆要么 `heapInsert` 要么 `heapify`

== 经典题目

=== #link("https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37")[最多线段重合问题]

每一个线段都有 `start` 和 `end` 两个数据项，表示这条线段在 X 轴上从 `start` 位置开始到 `end` 位置结束。给定一批线段，求所有重合区域中最多重合了几个线段，首尾相接的线段不算重合。
例如：线段`[1,2]`和线段`[2.3]`不重合。 线段`[1,3]`和线段`[2,3]`重合

- 输入描述：
  - 第一行一个数`N`，表示有`N`条线段
  - 接下来`N`行每行`2`个数，表示线段起始和终止位置
- 输出描述：
  - 输出一个数，表示同一个位置最多重合多少条线段

===== 解法

先按照开始为止从小到大排序. 接着把结束位置放到小根堆里.
来到`[x,y]`, 把小根堆里面小于等于`x`的弹出, 把`y`放到小根堆, 看小根堆里有几个, 即当前`[x,y]`线段的答案.

所有线段中最大的值.

