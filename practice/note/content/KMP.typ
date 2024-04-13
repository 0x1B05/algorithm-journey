#import "../template.typ": *
#pagebreak()

= KMP

长为 n 的字符串`str1`和和长为 m 的字符串`str2`，`str1`是否包含`str2`，如果包含则返回`str2`在`str1`中起始位置。
如何做到时间复杂度为 O(n)?

分析:

1. 暴力枚举，遍历`str1`的每个字符的位置，依次比对两个字符相应位置的字符，如果`str2`字符串的指针走到了最后，则表示当前匹配成功，返回当前
  str1 的起始位置.
2. KMP 算法

== 暴力枚举

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

== KMP

=== 举例

`str1`:`abbsabbzabbsabbn`
`str2`:`abbsabbzabbsabbn`

=== 算法思路

kmp: p1->s1,p2->s2. 若 s1 中的 p->p+i 部分匹配 s2 中的 0->i 的部分,而 s1 中的
p2=p+i+1 却不匹配 s2 的 p1=i+1. 则取`p1=next[p1]`,那么判断s2[p1]与s1[p2],若等,则继续.
若不等,则取p1=next[p1],s2[p2]与s1[p2],若等,则继续. 若不等,则取p1=next[p1]...
直到next数组取到-1,若依然不等,那么p1++.

getNext: next[0]=-1 next[1]=0 cn代表:1. 和i-1位置比的位置. 2.
当前使用的next数组的信息

当前处于i位置,cn则是i-1位置的next值 的下一个

=== 代码实现:
```java
public static class KMP{
    public static kmp(String str1,String str2){
        
    }
}
```
=== 复杂度分析:

==== 的复杂度

设`str1`的长度为 n,`str2`的长度为 m |||

==== `getNextArr`的复杂度

=== 一些证明

==== kmp 算法的证明:

`str1`:|i|...|k|...|j|...|x|
`str2`:|0|...| |...|j-i|...|m|

m 的 next 是 j-i,为什么可以直接把 str2 的匹配头从 i 移到 j? 假设 str1 中有 i< k
< j,那 k 是完全匹配 str2 的头.

==== nextArr 的证明:

字符串:`abbstabbecabbstabb??`
next 数组+1 为什么最多就是 next[i]=next[i-1]+1,而不能更多?
