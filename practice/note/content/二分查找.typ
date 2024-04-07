#import "../template.typ": *

#pagebreak()
= 二分查找

== 二分查找的本质

=== 问题引入

`1 2 3 5 5 5 8 9`

1. 找到第一个'>=5'的元素 (第一个 5)
2. 找到最后一个'\<5'的元素 (3)
3. 找到第一个'>5'的元素 (8)
4. 找到最后一个'<=5'的元素 (最后一个 5)

=== 新的角度

==== 情景概述

数组下标为`1 2 ... k-1 k ... n-2 n-1`,共 N 个元素 设前 k 个元素为蓝色区域,后 n-k
个为红色区域 假设一开始数组均为灰色,那么问题的目标即为找出蓝红边界,即求出未知数
k

==== 朴素算法

在最左侧设置一个蓝色指针,从最左边开始挨个遍历,直到找到蓝红边界 或
在最右侧设置一个红色指针,从最右边开始挨个遍历,直到找到蓝红边界

==== 二分查找

将蓝色指针右移的过程看作是扩展灰色区域为蓝色区域
将红色指针左移的过程看作是扩展灰色区域为红色区域

===== 例子

数组下标:`(0 1 2 3 4) [5 6 7 8]`
蓝色指针位于-1 位置,红色指针位于 9 位置

> ()内为蓝色边界,[]为红色边界

1. 蓝色指针移动到灰色区域的中间位置 (0+9)/2 即 4 位置,4 为蓝色说明 4 以及 4
  前的位置均为蓝色
2. 红色指针移动到灰色区域中间的位置 (4+8)/2 即 6 位置,6 为红色,说明 6 以及 6
  后的位置均为红色
3. 蓝色指针移动到灰色区域中间的位置 (4+6)/2 即 5 位置,5 为红色,说明 5 以及 5
  前的位置均为蓝色
4. 找到蓝红边界!

===== 伪代码

```
l = -1,r = n
while l+1 != r
    m = (l+r)/2 // 向下取整
    if IsBLUE(m)
        l = m
    else
        r = m
return l or r
```

初始:l 指向蓝色区域,r 指向红色区域 循环:l,r 快速向蓝红边界逼近,*保持 l,r
颜色不变* 结束:l,r 刚好指向蓝红边界

===== 细节问题

1. 为什么 l 的初始值为-1,r 的初始值为 n? 假设 l 初始化为 0
  则如果整个数组均为红色,则 l 一开始即会处于红色区域内 假设 r 初始化为 n-1
  则如果整个数组均为蓝色,则 r 一开始即会处于蓝色区域内
2. m 是否始终处于[0,n)以内?
  $l_{min} = -1$ $r_{min} = 1("Why?") arrow.r m_{min} = 0$
  $l_{max} = n-2$ $r_{max} = n arrow.r m_{min} = n-1$
  故 m 不会溢出
3. 更新指针时能不能写成 l=m+1 或 r=m-1? 可以,但是从正确性和易懂性来看,不好.
4. 会不会死循环?
  1. l+1=r(立刻推出)
  2. l+2=r(回归第一种情况)
  3. l+3=r(回归第二种或者第一种情况)
  4. ...

===== 问题解答

#tablem[
  | 问题 | 蓝红划分 | IsBLUE 条件 | 返回 | | ----------------------- |
  ------------------- | ----------- | ---- | | 找到第一个'>=5'的元素 | (1 2 3) [5
  5 5 8 9] | \<5 | r | | 找到最后一个'\<5'的元素 | (1 2 3) [5 5 5 8 9] | \<5 | l |
  | 找到第一个'>5'的元素 | (1 2 3 5 5 5) [8 9] | <=5 | r | |
  找到最后一个'<=5'的元素 | (1 2 3 5 5 5) [8 9] | <=5 | l |
]

===== 模型

1. 建模:划分蓝红边界,确定 IsBLUE()
2. 确定返回 l 还是 r
3. 套用模板
4. 后处理

后处理:[没有蓝色区域]和[没有红色区域]的细节如何处理?比如例子中查找第一个大于等于
5 的元素,如果数组中所有元素都小于 5 那么,返回的 r
直接访问会越界,需要特殊处理一下, 同理 返回 L 的时候如果是-1,也需要特殊处理才行
就需要在取值的时候先判断该索引是否在[0,N)的区间,然后再取值.

===== 思考题

二分查找的下标是否是适用于浮点数? 题:通过二分查找的方法计算$sqrt{2}$,要求误差精确到$10^{-6}$

== 练习

参考了 作者: 房顶上的铝皮水塔 https://www.bilibili.com/read/cv14984337 出处:
bilibili

=== 搜索插入

给定一个排序数组和一个目标值,在数组中找到目标值,并返回其索引.如果目标值不存在于数组中,返回它将会被按顺序插入的位置.

==== 题解

```java
class Solution {
    public int searchInsert(int[] nums, int target) {
        int index = bin(nums, -1, nums.length, target);
        return index;
    }
    private int bin(int[]nums, int left, int right, int target) {
        while(left + 1 != right) {
            int mid = left + ((right - left) >> 1);
            if (nums[mid] < target) left = mid;
            else right = mid;
        }
        // left 包括自身及其左边的值都比它小
        // right 及其右边的值都大于等于自身
        return right;
    }
}
```

=== 寻找峰值

峰值元素是指其值严格大于左右相邻值的元素.

给你一个整数数组  `nums`,找到峰值元素并返回其索引.数组可能包含多个峰值,在这种情况下,返回
任何一个峰值 所在位置即可.

你可以假设 `nums[-1] = nums[n] = -∞` .

==== 分析

===== 关于这道题,首先需要考虑是否能使用二分查找? 

首先我们假设数组中存在峰值,如果一个下标 i 对应的元素及其左右元素满足如下关系: 
`num[i] < nums[i+1] && nums[i] > nums[i-1]`说明峰值在其右边:
`num[i] > nums[i+1] && nums[i] < nums[i-1]` 说明峰值在其左边:
`num[i] < nums[i+1] && nums[i] < nums[i-1]` 说明在谷底,下一步往左边和右边都可以
所以可以认为使用二分查找,一次可以忽略左边或者右边的数字,加快搜索

===== 为什么存在峰值?

首先,示例以及题目中没有说明不存在峰值应该返回什么元素,所以一定存在.其实也可推导:
假设数组中存在一个元素,这个元素就是峰值:
假设数组中存在两个元素,若左边的元素大于右边的元素,左边的元素就是峰值:反之则右边的元素是峰值.存在更多元素的情况就是两个元素的情况的展开

既然如此,我们需要考虑 isBlue 的实现:
对于一个元素,如果这个元素小于右边大于左边,则可以放到蓝色区域,那么,最后一个放入蓝色区域的元素的下一个元素就是峰值.

==== 题解

```java
class Solution {
    public int findPeakElement(int[] nums) {
        if (nums.length == 1) return 0;
        return bin(nums, -1, nums.length);
    }
    // 数组中一定存在峰值吗?
    private int bin(int[]nums, int left, int right) {
        while(left + 1 != right) {
            int mid = left + ((right - left) >> 1);
            int lvalue = mid - 1 < 0 ? Integer.MIN_VALUE : nums[mid - 1];
            int rvalue = mid + 1 >= nums.length ? Integer.MIN_VALUE : nums[mid + 1];
            if (lvalue <= nums[mid] && nums[mid] <= rvalue)
                left = mid;
            else
                right = mid;
        }
        return right;
    }
}
```

> 另外题目中还说明了,不存在重复元素的情况,上述代码中等号可以去掉.

=== 在排序数组中查找元素的第一个位置和最后一个位置

给你一个按照非递减顺序排列的整数数组 `nums`,和一个目标值 `target`.请你找出给定目标值在数组中的开始位置和结束位置.如果数组中不存在目标值 `target`,返回
[-1, -1].

==== 分析

这题思路没有特别之处,将小于 target 的值归到蓝色区间,返回最后的 right
就可以.二分查找的模板存在一个问题,如果数组元素值都小于 target,那么 right 的值为
N:如果数组元素的值都大于 target,返回值为 0.

在上面的例子中,因为要找到具体的元素的下标,所以需要检查最后返回 right
对应的元素是不是 Target,并且还需要先考虑返回的 right 有没有数组越界.

==== 题解

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int left = -1 , right = nums.length;
        while(left + 1 != right) {
            int mid = left + ((right - left) >> 1);
            // 小于target都归到蓝色区间
            if (nums[mid] < target)
                left = mid;
            else
                right = mid;
        }
        // right的值就是target
        // CASE#1 有可能当前的值并不是target的值
        if (right == nums.length || nums[right] != target)
            return new int[]{-1,-1};
        int end = right;
        while (end + 1 < nums.length && nums[end + 1] == target) end ++;
        return new int[]{right, end};
    }
}
```

=== 搜索二维矩阵

编写一个高效的算法来判断  `m x n`  矩阵中,是否存在一个目标值.该矩阵具有如下特性: 

每行中的整数从左到右按升序排列. 每行的第一个整数大于前一行的最后一个整数.

==== 题解

```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        if (matrix[m-1][n-1] < target) return false;
        int left = -1, right = m*n;
        while(left + 1 != right) {
            int mid = (left + right) >> 1;
            int i = mid / n;
            int j = mid % n;
            if (matrix[i][j] < target) left = mid;
            else right = mid;
        }
        // 最后的结果是right
        return matrix[right/n][right%n] == target;
    }
}
```

=== 搜索二维矩阵 II

编写一个高效的算法来搜索  `m x n`  矩阵 `matrix` 中的一个目标值 `target` .该矩阵具有以下特性: 

每行的元素从左到右升序排列. 每列的元素从上到下升序排列.

==== 题解

```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        int i = 0, j = n - 1;
        while(i < m && j >= 0 ) {
            if (matrix[i][j] > target) j --;
            else if (matrix[i][j] < target) i ++;
            else // 相等情况
                return true;
        }
        return false;
    }
}
```

=== 较小三数之和

要求找到三个数,并且让这三个数之和小于 target.

==== 题解

```java
class Solution {
    public int threeSumSmaller(int[] nums, int target) {
        Arrays.sort(nums); // 排序
        int n = nums.length, cnt = 0;
        for(int i = 0; i + 2 < n; i ++) {
            for (int j = i + 1; j + 1 < n ; j++) {
                // 二分查找具体的值
                int real = target - nums[i] - nums[j];
                int index = bin(nums, j, n, real);
                cnt += index - j;
            }
        }
        return cnt;
    }
    // 找到一个值小于2
    private int bin(int[]nums, int left, int right, int target) {
        while(left + 1 != right) {
            int mid = left + ((right - left)>>1);
            if (nums[mid] < target) left = mid;
            else right = mid;
        }
        return left;
    }
}
```

=== 寻找右区间

给你一个区间数组 `intervals` ,其中 `intervals[i] = [starti, endi]` ,且每个 `starti` 都
不同 .区间 i 的 右侧区间 可以记作区间 j ,并满足 `startj >= endi` ,且 `startj` 最小化
. 返回一个由每个区间 i 的 右侧区间 在 `intervals` 中对应下标组成的数组.如果某个区间
i 不存在对应的 右侧区间 ,则下标 i 处的值设为 -1 .

==== 分析

这道题要求找当前的区间的右区间,如果找不到就-1,找得到就下标.其实做了这么多关于区间的题,不论是使用贪心的原则,合并区间也好,还是其他的方法也罢,一上来的第一个思路就是将区间元素按照区间中的
start 大小进行排序.我们想想这个排序的思路是否可以运用到这道题.

===== 举例

[ [1,4], [2,3], [3,4], [1,2], [2,5], [4,7] ] 排序:[ [1,4], [1,2], [2,3], [2,5],
[3,4], [4,7] ] 对于[1,4]而言:后面[1,2], [2,3], [2,5], [3,4]为蓝区,[4,7]为红区

这个例子而言,因为 end 一定大于 start,通过 start
进行排序之后的元组可以通过检查当前 mid
指向的元素是否为[1,4]的右区间.我们通过设计不是右区间的在蓝色区域,第一个是右区间的在红色区域就满足了题目的最小化
start 的要求.

同时这道题其实有个 case 很智障,[1,1]也是自己的右区间,所以需要额外判断当
start=end 的情况.

==== 题解

```java
class Solution {
    public int[] findRightInterval(int[][] intervals) {
        // 在排序之前使用Hash表记录int[] 的下标
        int n = intervals.length;
        HashMap<int[], Integer> map = new HashMap<>();
        for (int i = 0; i < n; i++)
            map.put(intervals[i], i);
        // 将数组进行排序
        Arrays.sort(intervals, Comparator.comparingInt(o -> o[0]));
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            // right 包括 （right）以后的数组的第一个元素都是大于等于 target
            int[] cur = intervals[i];
            int oriIndex = map.get(intervals[i]); // before sorting
            if (cur[0] == cur[1]) {
                ans[oriIndex] = oriIndex;
                continue;
            }
            int index = bin(i, n, intervals, cur[1]);
                // 在数组中可能二分查找找到不到这个元素
            if (index >= n || intervals[index][0] < cur[1])
                ans[oriIndex] = -1;
            else
                ans[oriIndex] = map.get(intervals[index]);
        }
        return ans;
    }
    // 搜索使用[left, right]下标框定起来的闭区间
    private int bin(int left, int right, int[][] nums, int target) {
        while (left + 1 != right) {
            // 相等的并入右区间
            int mid = left + ((right - left) >> 1);
            if (nums[mid][0] < target) left = mid;
            else right = mid;
        }
        return right;
    }
}
```

---

=== 寻找重复数

给定一个包含 n + 1 个整数的数组 nums ,其数字都在 [1, n] 范围内（包括 1 和
n）,可知至少存在一个重复的整数.

> 假设 nums 只有 一个重复的整数 ,返回 这个重复的数 . > 你设计的解决方案必须
不修改 数组 nums 且只用常量级 O(1) 的额外空间.

==== 分析

这道题中,给出长度为 n+1 的数组,但是数组中有一个存在元素 i,i
属于[1,n]存在一个重复值.我们可以有这样的一个思路,我们设计 left,right 和 mid
指针,我们在题目给定 nums 数组中,猜[left,mid]框定的区间内,nums
中的元素出现的次数.如果在 nums 中出现的次数大于
mid-left+1,即区间长度,说明存在重复元素.如果没有出现重复元素说明当前[left,mid]区间不对,我们转到[mid+1,right]子区间中尝试.

==== 题解

```java
class Solution {
    public int findDuplicate(int[] nums) {
        // 遍历 left 和 right区间内的所有数字
        // 只存在一个重复数字
        int left = 1 , right = nums.length - 1;
        while(left < right) {
            int mid = left + ((right - left) >> 1);
            // 统[left: mid]区间的数字的数量
            int cnt = 0;
            for (int num : nums) {
                if (num <= mid && num >= left)
                    cnt++;
            }
            // 如果当前区间的数字的数量超出
            // 区间确定的数字和统计的数量的关系只有两种,要么是小于cnt要么是等于cnt
            // 而且最后left == right时退出,所以返回left是可以的
            if (mid - left + 1 < cnt)
                right = mid;
            else
                left = mid + 1;
        }
        return left;
    }
}
```

此外,如果要验证自己的代码是否正确可以使用最基本的一些 Case 进行尝试: 

1. 数组长度为 2 时数组为{1,1},返回 left 会返回 1
2. 数组长度为 3 时,排序后的数组可能为{1,1,2}或者是{1,2,2},left=1,right=2,第一次的
  mid 等于 1.对于{1,1,2},[1,1]区间内的 cnt 是 2,right =
  mid,退出循环,left=1,并且作为返回值:对于{1,2,2},[1,1]区间的 cnt 为 1,cnt
  等于区间长度,left = mid + 1,退出循环,返回 left=2. 这个例子也说明当 cnt
  等于区间长度的时候 left=mid+1.

=== 最接近的二叉搜索树值

给定一个不为空的二叉搜索树和一个目标值`target`,请在改二叉搜索树中找到最接近目标`target`的数值.

> 给定的目标值`target`是一个浮点数 >
题目报郑在改二叉搜索树中只会存在一个最接近目标值的数

==== 分析

二叉搜索树可以通过成中序遍历形成一个有序数组,然后二分查找是可以的,这样时间空间复杂度都很高,没必要.

如果 target
小于当前的节点,那么接近这个数的节点肯定在左子树（往右边走越来越大,而且有右子树的最小值肯定大于当前节点）:反之如果大于,找右子树.终止的节点肯定在叶子节点上,同时在遍历的过程记录一个最小的距离的值.

==== 题解

```java
class Solution {
    public int closestValue(TreeNode root, double target) {
        int val, closest = root.val;
        while (root != null) {
            val = root.val;
            closest = Math.abs(val - target) < Math.abs(closest - target) ? val : closest;
            root = target < root.val ? root.left : root.right;
        }
        return closest;
    }
}
```

=== 旋转数组的最小数字

把一个数组最开始的若干个元素搬到数组的末尾,我们称之为数组的旋转.

给你一个可能存在重复元素值的数组 numbers
,它原来是一个升序排列的数组,并按上述情形进行了一次旋转.请返回旋转数组的最小元素.例如,数组
[3,4,5,1,2] 为 [1,2,3,4,5] 的一次旋转,该数组的最小值为 1.

注意,数组 [a[0], a[1], a[2], ..., a[n-1]] 旋转一次 的结果为数组 [a[n-1], a[0],
a[1], a[2], ..., a[n-2]] .

==== 分析

==== 题解

```java
class Solution {
    public int findMin(int【】 nums) {
        int len = nums.length;
        while(len > 0 && nums【0】 == nums【len - 1】) len--;
        if(len == 0) return nums【0】;
        int val = nums【len - 1】;
        int L = -1;
        int R = len;
        while(L + 1 != R) {
            int mid = L + ((R - L) >> 1);
            if(nums【mid】 <= val) {
                R = mid;
            }else {
                L = mid;
            }
        }
        return nums【R】;
    }
}
```

> 二分查找的本质依照https://www.bilibili.com/video/BV1d54y1q7k7 视频所写 >
笔记部分习题来源与 leetcode,选取来源于作者: 房顶上的铝皮水塔
https://www.bilibili.com/read/cv14984337 出处: bilibili
