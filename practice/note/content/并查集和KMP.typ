#import "../template.typ": *
#pagebreak()
= 并查集和 KMP

== 并查集

=== 岛问题

一个矩阵中只有 0 和 1
两种值，每个位置都可以和自己的上下左右四个位置相连，如果有一片 1
连在一起，这个部分叫做一个岛，求一个矩阵上有多少个岛.

> 举例： > 001010 > 111010 > 100100 > 000000 > 这个矩阵有 3 个岛

```java
public static int countIslands(int[][] m) {
    if (m == null || m[0] == null) {
        return 0;
    }
    int N = m.length;
    int M = m[0].length;
    int res = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            if (m[i][j] == 1) {
                res++;
                infect(m, i, j, N, M);
            }
        }
    }
    return res;
}

// 递归进行感染
public static void infect(int[][] m, int i, int j, int N, int M) {
    if (i < 0 || i >= N || j < 0 || j >= M || m[i][j] != 1) {
        return;
    }
    //i,j没有越界，且当前位置值为1
    m[i][j] = 2;
    //修改当前值之后再递归，不会导致无限循环
    infect(m, i + 1, j, N, M);
    infect(m, i - 1, j, N, M);
    infect(m, i, j + 1, N, M);
    infect(m, i, j - 1, N, M);
}
```

> 时间复杂度 O(m \* n)

=== 并查集引入

岛问题进阶:如何设计一个并行算法解决这个问题? 并查集结构的两个函数:

1. `bool isSameSet(ele a,ele b)`判断两个函数是否同属于一个集合
2. `void union(set a,set b)`合并两个集合

分析:

1. 假设用链表实现,`union`需要 O(1)而`isSameSet`需要 O(n)
2. 假设用哈希表实现,`isSameSet`需要 O(1)而`union`需要 O(n)

问题:如何实现`isSameSet`和`union`都是 O(1)

```java
import java.util.HashMap;
import java.util.List;
import java.util.Stack;

public class UnionFind {
    //样本进来会包一层，叫做元素
    public static class Element<V>{
        public V value;
        public Element(V value){
            this.value = value;
        }
    }
    public static class UnionFindSet<V>{
        public HashMap<V,Element<V>> elementMap;

        //key 某个元素 value 该元素的父亲
        public HashMap<Element<V>,Element<V>> fatherMap;
        //key 某个集合的代表元素，value 该集合的大小
        public HashMap<Element<V>,Integer> sizeMap;
        public UnionFindSetInit(List<V> list){
            elementMap = new HashMap<>();
            fatherMap = new HashMap<>();
            sizeMap = new HashMap<>();
            for (V value : list) {
                Element<V> element = new Element<V>(value);
                elementMap.put(value,element);
                fatherMap.put(element,element);
                sizeMap.put(element,1);
            }
        }

        //给定一个ele，往上一直找，将代表元素返回
        private Element<V> findHead(Element<V> element){
            // path用来存放向上查找的路径
            Stack<Element<V>> path = new Stack<>();
            while (element != fatherMap.get(element)){  // 父是自己为止.
                path.push(element);
                element = fatherMap.get(element);
            }
            //将遍历的整条链的父都设置为找到的代表元素
            //即将其扁平化(向上找优化)
            while (!path.isEmpty()){
                fatherMap.put(path.pop(),element);  // 把途径的元素都直接放在根的下面
            }
            return element;
        }

        public boolean isSameSet(V a,V b){
            if(elementMap.containsKey(a) && elementMap.containsKey(b)){
                return findHead(elementMap.get(a)) == findHead(elementMap.get(b));
            }
            return false;
        }

        public void union(V a,V b){
            if(elementMap.containsKey(a) && elementMap.containsKey(b)){
                Element<V> aF = findHead(elementMap.get(a));
                Element<V> bF = findHead(elementMap.get(b));
                if(aF != bF){
                    Element<V> big = sizeMap.get(aF) >= sizeMap.get(bF) ? aF : bF;
                    Element<V> small = big == aF ? bF : aF;
                    fatherMap.put(small,big);
                    sizeMap.put(big,sizeMap.get(aF) + sizeMap.get(bF));
                    sizeMap.remove(small);
                }
            }
        }
    }
}
```

> `findHead()`用的次数越多则空间复杂度越低,当逼近 O(n)次或大于
O(n)次,可以认为并查集在 O(1)内实现了`isSameSet`,`union`

== KMP

长为 n 的字符串`str1`和和长为 m 的字符串`str2`，`str1`是否包含`str2`，如果包含则返回`str2`在`str1`中起始位置。
如何做到时间复杂度为 O(n)?

分析:

1. 暴力枚举，遍历`str1`的每个字符的位置，依次比对两个字符相应位置的字符，如果`str2`字符串的指针走到了最后，则表示当前匹配成功，返回当前
  str1 的起始位置.
2. KMP 算法

=== 暴力枚举

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

=== KMP

==== 举例

`str1`:`abbsabbzabbsabbn`
`str2`:`abbsabbzabbsabbn`

==== 算法思路

kmp: p1->s1,p2->s2. 若 s1 中的 p->p+i 部分匹配 s2 中的 0->i 的部分,而 s1 中的
p2=p+i+1 却不匹配 s2 的 p1=i+1. 则取`p1=next[p1]`,那么判断s2[p1]与s1[p2],若等,则继续.
若不等,则取p1=next[p1],s2[p2]与s1[p2],若等,则继续. 若不等,则取p1=next[p1]...
直到next数组取到-1,若依然不等,那么p1++.

getNext: next[0]=-1 next[1]=0 cn代表:1. 和i-1位置比的位置. 2.
当前使用的next数组的信息

当前处于i位置,cn则是i-1位置的next值 的下一个

==== 代码实现:
```java
public static class KMP{
    public static kmp(String str1,String str2){
        
    }
}
```
==== 复杂度分析:

===== 的复杂度

设`str1`的长度为 n,`str2`的长度为 m |||

===== `getNextArr`的复杂度

==== 一些证明

===== kmp 算法的证明:

`str1`:|i|...|k|...|j|...|x|
`str2`:|0|...| |...|j-i|...|m|

m 的 next 是 j-i,为什么可以直接把 str2 的匹配头从 i 移到 j? 假设 str1 中有 i< k
< j,那 k 是完全匹配 str2 的头.

===== nextArr 的证明:

字符串:`abbstabbecabbstabb??`
next 数组+1 为什么最多就是 next[i]=next[i-1]+1,而不能更多?
