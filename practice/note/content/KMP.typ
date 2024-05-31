#import "../template.typ": *
#pagebreak()

= KMP

1. 理解`next`数组：不包含当前字符，前面字符串，前缀和后缀最大匹配长度（不包含整体，于是`next[0]=-1`,`next[1]=0`）
2. 假设已经有了`next`数组，匹配过程如何得到加速的(两个核心)
3. 理解匹配主流程之后，详解`next`数组如何快速生成(一个核心)
4. 复杂度证明

== #link("https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/")[KMP问题引入]

长为 n 的字符串`str1`和和长为 m 的字符串`str2`，`str1`是否包含`str2`，如果包含则返回`str2`在`str1`中起始位置。

分析:

1. 暴力枚举，遍历`str1`的每个字符的位置，依次比对两个字符相应位置的字符，如果`str2`字符串的指针走到了最后，则表示当前匹配成功，返回当前
  str1 的起始位置.O(n\*m)
2. KMP 算法.O(n+m)

=== 暴力枚举

#code(caption: [KMP - 暴力枚举])[
```java
class Solution {
    // 暴力解法
    public int strStr(String haystack, String needle) {
        // 首先进行边界条件判断
        if(haystack == null || needle == null || haystack.length() < needle.length()){
            return -1;
        }
        if("".equals(needle)) return 0;
        char[] charH = haystack.toCharArray();
        char[] charN = needle.toCharArray();
        for(int i = 0; i + charN.length - 1 < charH.length; i++){
            int ch = i;
            int cn = 0;
            while(cn < charN.length && charH[ch] == charN[cn]){
                ch++;
                cn++;
            }
            if(cn == charN.length){
                return i;
            }
        }
        return -1;
    }
}
```
]

=== `next`数组理解举例

#example("Example")[
`str`:`aabaabsaabaaa`

```
a  a  b  a  a  b  s  a  a  b  a  a  a
0  1  2  3  4  5  6  7  8  9  10 11 12
-1 0  1  0  1  2  3  0  1  2  3  4  5
```

- `next[2]`:
    - prefix: `aa` -> 1
- `next[3]`:
    - prefix: `aab` -> 0
- `next[4]`:
    - prefix: `a ab a` -> 1
- `next[5]`:
    - prefix: `aa b aa` -> 2
- `next[6]`:
    - prefix: `aab aab` -> 3
...
]

#example("Example")[
也可以错开`str`:`aaaaat`

- `next[5]`:
    - prefix: `aaaaa` -> 4
]

=== 匹配过程加速举例

```
      0  1  2  3  4  5  6  7  8  9  10 11 12 13
s1:   a  a  b  a  a  b  c  a  a  b  a  a  b  a
next: -1 0  1  0  1  2  3  0  1  2  3  4  5  6
s2:   a  a  b  a  a  b  c  a  a  b  a  a  b  t
next: -1 0  1  0  1  2  3  0  1  2  3  4  5  6
```

从0开头匹配到13发现不对, 接着s1匹配的位置不动，s2的位置来到6，6和13匹配。

```
      0  1  2  3  4  5  6  7  8  9  10 11 12 13
s1:   a  a  b  a  a  b  c  a  a  b  a  a  b  a
next: -1 0  1  0  1  2  3  0  1  2  3  4  5  6

                           0  1  2  3  4  5  6
s2:                        a  a  b  a  a  b  c
next:                      -1 0  1  0  1  2  3
```

疑问？
1. 那1, 2, 3...6开头匹配就放弃?
  - 由于`next`数组的存在必然无法匹配出`s2`
2. 7开头匹配为什么不是`s2[0]`和`s1[7]`开始匹配? 怎么直接跳到`s2[6]`和`s1[13]`？
  - `next`数组的含义来确定的

疑问2显然
```
    |i|      ....      |j|
s1: |            |..7..|a|
    |0|      ....      |k|
s2: |..7..|      |..7..|b|
```

疑问1
```
    |i|  |?| ... |p|   |j|
s1: |            |..7..|a|
    |0|      ....      |k|
s2: |..7..|      |..7..|b|
```

假设`?`(`i<?<p`)开头能配出`s2`, 那么`? -> j-1`就可以配出s2前面等长的一段。而`?- -> j-1`又和对应位置的s2里的字符相等，那么`next`就要增加了(最大匹配长度决定)，矛盾！

整体：

```
      0  1  2  3  4  5  6  7  8  9  10 11 12 13
s1:   a  a  b  a  a  b  c  a  a  b  a  a  b  ?
s2:   a  a  b  a  a  b  c  a  a  b  a  a  b  t
next: -1 0  1  0  1  2  3  0  1  2  3  4  5  6
```

从0开头匹配到13发现不对, 接着s1匹配的位置不动，s2的位置来到6，6和13匹配。

```
      0  1  2  3  4  5  6  7  8  9  10 11 12 13
s1:   a  a  b  a  a  b  c  a  a  b  a  a  b  ?

                           0  1  2  3  4  5  6
s2:                        a  a  b  a  a  b  c
next:                      -1 0  1  0  1  2  3
```

又不对

```
      0  1  2  3  4  5  6  7  8  9  10 11 12 13
s1:   a  a  b  a  a  b  c  a  a  b  a  a  b  ?

                                    0  1  2  3
s2:                                 a  a  b  a
next:                               -1 0  1  0
```

再不对就跳到`-1`了

```
s1: 14...
s2: 0...
```

=== `next`数组如何快速生成

`next[0]=-1`,`next[1]=0`

==== 不用跳

```
    0  1  2  3  4  5  6 | 7 | 8  9  10 11 12 13 14| 15| 16
s2: a  b  a  t  a  b  a | s | a  b  a  t  a  b  a | s | ?
next:...                                            7
```

`next[16]`?
`next[15] = 7`, `s2[7]==s2[15]`=>`next[16]=8`

为啥不能更大？
假设`next[16]=10` => `s2[0..9]`与`s2[6..15]`相等. 于是`next[15]=9`，矛盾！

==== 跳多次

===== 跳一次：


```
     0  1  2  3  4  5  6 | 7 | 8  9  10 11 12 13 14| 15| 16
s2:  a  b  a  t  a  b  a | s | a  b  a  t  a  b  a | s | ?
next:         ...          3         ...             7
```

- `s2[7]!=s2[15]` => `next[7] = 3`
- `s[3]==s[15]` => `next[16] = 4`

===== 跳两次：


```
     0  1  2  3  4  5  6 | 7 | 8  9  10 11 12 13 14| 15| 16
s2:  a  b  a  t  a  b  a | s | a  b  a  t  a  b  a | b | ?
next:         1    ...     3         ...             7
```

- `s2[7]!=s2[15]` => `next[7] = 3`
- `s[3]!=s[15]` => `next[3] = 1`
- `s[1]==s[15]` => `next[16] = 2`

===== 跳三次：

```
     0  1  2  3  4  5  6 | 7 | 8  9  10 11 12 13 14| 15| 16
s2:  a  b  a  t  a  b  a | s | a  b  a  t  a  b  a | a | ?
next:   0     1    ...     3         ...             7
```

- `s2[7]!=s2[15]` => `next[7] = 3`
- `s[3]!=s[15]` => `next[3] = 1`
- `s[1]!=s[15]` => `next[1] = 0`
- `s[0]==s[15]` => `next[16] = 1`

===== 跳到头：

```
     0  1  2  3  4  5  6 | 7 | 8  9  10 11 12 13 14| 15| 16
s2:  a  b  a  t  a  b  a | s | a  b  a  t  a  b  a | f | ?
next:   0     1    ...     3         ...             7
```

- `s2[7]!=s2[15]` => `next[7] = 3`
- `s[3]!=s[15]` => `next[3] = 1`
- `s[1]!=s[15]` => `next[1] = 0`
- `s[0]!=s[15]` => `next[0] = -1` => `next[16] = 0`

==== 凭啥？

```
      | 0 -- 9 | 10 | 11 -- 20 | 21 | 22 |
s2:   |   ..   | x  |    ..    |  y | ?  |
next: |   ..   |    |    ..    | 10 | ?  |
```

- 如果`x==y`那么就`next[22] = next[22-1]+1`
- 如果`x!=y`, 为啥要继续基于`x`的`next`数组的值往前跳呢？
  - `next[22]`已经无法到达`10`了，于是希望在`0-9`保留一个尽量长的前缀，`11-20`保留一个尽量长的后缀。
  - 而`s2[0...9]`与`s2[11...20]`是完全一样的，于是`11-20`尽量长的后缀与`0-9`尽量长的后缀是一样的，那就是基于`x`的`next`数组的值。

=== 代码实现:
#code(caption: [kmp])[
```java
// KMP算法
public static int kmp(char[] s1, char[] s2) {
    // s1中当前比对的位置是x
    // s2中当前比对的位置是y
    int n = s1.length, m = s2.length, x = 0, y = 0;
    // O(m)
    int[] next = nextArray(s2, m);
    // O(n)
    while (x < n && y < m) {
        if (s1[x] == s2[y]) {
            x++;
            y++;
        } else if (y == 0) {
            x++;
        } else {
            y = next[y];
        }
    }
    return y == m ? x - y : -1;
}

// 得到next数组
public static int[] nextArray(char[] s, int m) {
    if (m == 1) {
        return new int[] { -1 };
    }
    int[] next = new int[m];
    next[0] = -1;
    next[1] = 0;
    // i表示当前要求next值的位置
    // cn表示当前要和前一个字符比对的下标
    int i = 2, cn = 0;
    while (i < m) {
        if (s[i - 1] == s[cn]) {
            next[i++] = ++cn;
        } else if (cn > 0) {
            cn = next[cn];
        } else {
            next[i++] = 0;
        }
    }
    return next;
}
```
]

=== 时间复杂度

==== `nextArray`: O(m)

- i: 规模m => O(m)
- i-cn: 最大值max(i)-min(cn)=m => O(m)

#three-line-table[
  |branch                |i(m)   |i-cn(m)|
  | -                    | -     | -     |
  | `s[i - 1] == s[cn]`  |  ↑    | 不变  |
  | `cn>0`               |  不变 | ↑     |
  | else                 |  ↑    | ↑     |
]

复杂度: 分支1的次数+分支2的次数+分支3的次数.

`i + (i-cn)`也就O(2m),而这两个量在每个分支都只有变多的时候，没有不变/变少的时候，因此必然<=2m，因此复杂度O(m).

#tip("Tip")[
为什么这么捏造这两个量？
- 因为既有i增加，又有cn减少，在这情况下，两者相减(有时候也相除)有单调性。
]

#tip("Tip")[
可以均摊，得到一个位置的next值是O(1)
]

==== 主流程

- x: 最大规模n => O(n)
- x-y: 最大规模max(x)-min(y)=n-0 => O(n)

#three-line-table[
  |branch                |x(n)   |x-y(m)|
  | -                    | -     | -     |
  | `s1[x] == s2[y]`     |  ↑    | 不变  |
  | `y==0`               |  ↑    | ↑     |
  | else                 |  不变 | ↑     |
]

同理O(n)

== 题目

=== #link("https://leetcode.cn/problems/subtree-of-another-tree/")[题目1: 另一棵树的子树]

给你两棵二叉树 `root` 和 `subRoot` 。检验 `root` 中是否包含和 `subRoot` 具有相同结构和节点值的子树。如果存在，返回 `true` ；否则，返回 `false` 。

二叉树 `tree` 的一棵子树包括 `tree` 的某个节点和这个节点的所有后代节点。`tree` 也可以看做它自身的一棵子树。

#example("Example")[
- 输入：`root = [3,4,5,1,2]`, `subRoot = [4,1,2]`
- 输出：`true`
]

#tip("Tip")[
- `root` 树上的节点数量范围是 `[1, 2000]`
- `subRoot` 树上的节点数量范围是 `[1, 1000]`
- `-10^4 <= root.val <= 10^4`
- `-10^4 <= subRoot.val <= 10^4`
]
