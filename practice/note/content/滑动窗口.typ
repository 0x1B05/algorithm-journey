#import "../template.typ": *
#pagebreak()
= 滑动窗口

滑动窗口,即有一个大小可变的窗口,`L` `R` 两端方向一致的向前滑动（`R` 固定,`L` 滑动；`L` 固定, `R` 滑动）。

== 经典题目

有一个整型数组 `arr` 和一个大小为 `w` 的窗口从数组的最左边滑到最右边,窗口每次向右边滑一个位置。

#example("Example")[
数组为`[4,3,5,4,3,3,6,7]`,窗口大小为 `3` 时:

```
[4 3 5]4 3 3 6 7    |窗口中最大值为5
4[3 5 4]3 3 6 7     |窗口中最大值为5
4 3[5 4 3]3 6 7     |窗口中最大值为5
4 3 5[4 3 3]6 7     |窗口中最大值为4
4 3 5 4[3 3 6]7     |窗口中最大值为6
4 3 5 4 3[3 6 7]    |窗口中最大值为7
```
]

如果数组长度为 `n`, 窗口大小为 `w`, 则一共产生 `n-w+1` 个窗口的最大值。 请实现一个函数:
- 输入:整型数组 `arr`,窗口大小为 `w`。
- 输出:一个长度为 `n-w+1` 的数组 res,res[i]表示每一种窗口状态下的最大值. 以本题为例,结果应该 返回`{5,5,5,4,6,7}`。

== 单调队列

数组arr,在 L,R 两端滑动(只能向前滑动,L <= R)的时候,给出窗口内的最大值.(不用遍历)

采用双端队列(头进头出,尾进尾出):队列里放下标.(下标包含的信息更多,包含了位置和值的信息)

对于最大值结构: 头 大->小 尾

R 向前滑动的时候,数从尾进,小的直接入队,要是当前数比队尾更大,队尾弹出 L
向前滑动的时候,看看过期的点是不是队的头节点,要是弹出,不然不动


举例:

```
|0|1|2|3|4|5|6|7|
|-|-|-|-|-|-|-|-|
|3|2|4|6|3|5|4|5|
```


->R (0,3)入 |0 ->R (1,2)<(0,3) (1,2)入 |0 1 ->R (2,4)要进 (2,4)>(1,2)弹(1,2)
(2,4)>(0,3)弹(0,3) (2,4)入 |2 ->R (3,6)要进 弹(2,4) 入(3,6) |3 ->R (4,3)入 |3 4
->R (5,5)要入 弹(4,3) (5,5)入 |3 5 ->R (6,4)入 |3 5 6 ->R (7,5)要入 弹(6,4)
弹(5,5)(严格保证单调性) 入(7,5) |3 7


```
|0|1|2|3|4|
|-|-|-|-|-|
|6|4|2|5|3|
```

->R ->R ->R | 0 1 2 ->L 看看过期位置是不是双端队列头部节点的位置,若是,从头部弹出
|1 2 ->L |2 ->R (2,2)弹出 (3,5)入 ->R |3 4 ->L 2过期,看头部不是2,不需要任何操作.

双端队列里数的含义: 若 R 不再向前扩,让L向前扩,谁会依次成为最大值然后会被 L
会淘汰掉的数.
双端队列弹出的数不可能再成为最大值,因为入队的元素,下标更大,值也更大.

```java
public static int[] maxSlidingWindow(int[] nums, int k) {
    int[] res = new int[nums.length - k + 1];
    int index = 0;
    LinkedList<Integer> doubleEndQueue = new LinkedList<>();
    for(int i = 0;i<nums.length;i++){
        while(!doubleEndQueue.isEmpty()&&nums[doubleEndQueue.peekLast()]<nums[i]){  // 如果不空并且要加入的值大于双端队列的尾节点,一直弹
            doubleEndQueue.pollLast();
        }
        doubleEndQueue.add(i);
        if(i-k==doubleEndQueue.peekFirst()){    // 如果过期的节点是双端队列的头节点,那么弹出
            doubleEndQueue.pollFirst();
        }
        if(i>=k-1){ // 如果来到k-1之后的位置(窗口形成)
            res[index++]=nums[doubleEndQueue.peekFirst()];
        }
    }
    return res;
}
```

=== 复杂度分析

每个数,最多进一次队列,最多出一次队列.总代价 O(n),单词平均 O(1).
