#import "../template.typ": *
#pagebreak()
= 杂题(1)

== 一个数据流中，最快可以取得中位数

```java
import java.util.Comparator;
import java.util.PriorityQueue;

public class MadianQuick {
    public static class MedianQuick{
        private PriorityQueue<Integer> maxHeap = new PriorityQueue<>(new MaxHeapComparator());
        private PriorityQueue<Integer> minHeap = new PriorityQueue<>(new MinHeapComparator());

        private void modifyTwoHeapsSize(){
            if (this.maxHeap.size() == this.minHeap.size() +2){
                this.maxHeap.add(this.minHeap.poll());
            }
            if (this.minHeap.size() == this.maxHeap.size() + 2) {
                this.maxHeap.add(this.minHeap.poll());
            }
        }

        public void addNumber(int num) {
            if (this.maxHeap.isEmpty()) {
                this.maxHeap.add(num);
                return;
            }
            if (this.maxHeap.peek() >= num) {
                this.maxHeap.add(num);
            } else {
                if (this.minHeap.isEmpty()) {
                    this.minHeap.add(num);
                    return;
                }
                if (this.minHeap.peek() > num) {
                    this.maxHeap.add(num);
                } else {
                    this.minHeap.add(num);
                }
            }
            modifyTwoHeapsSize();
        }

        public Integer getMedian() {
            int maxHeapSize = this.maxHeap.size();
            int minHeapSize = this.minHeap.size();
            if (maxHeapSize + minHeapSize == 0) {
                return null;
            }
            Integer maxHeapHead = this.maxHeap.peek();
            Integer minHeapHead = this.minHeap.peek();
            if (((maxHeapSize + minHeapSize) & 1) == 0) { //偶数
                return (maxHeapHead + minHeapHead) / 2;
            }
            return maxHeapSize > minHeapSize ? maxHeapHead : minHeapHead;
        }

    }
    public static class MaxHeapComparator implements Comparator<Integer> {
        @Override
        public int compare(Integer o1, Integer o2) {
            if (o2 > o1) {
                return 1;
            } else {
                return -1;
            }
        }
    }

    public static class MinHeapComparator implements Comparator<Integer> {
        @Override
        public int compare(Integer o1, Integer o2) {
            if (o2 < o1) {
                return 1;
            } else {
                return -1;
            }
        }
    }

}
```

== N 皇后问题

N 皇后问题是指在 N\*N 的棋盘上要摆 N
个皇后，要求任何两个皇后不同行、不同列，也不在同一条斜线上。 给定一个整数
n，返回 n 皇后的摆法有多少种 n = 1，返回 1 n = 2 或 3，2 皇后和 3
皇后问题怎么摆都不行，返回 0 n = 8，返回 92

```java
public static int num1(int n){
  if(n < 0){
    return 0;
  }
  //record[0]代表第0行的皇后放在哪一列
  int[] record = new int[n];
  return process1(0,record,n);
}
//record[0..i-1]的皇后，任意两个皇后一定不共行，不共列，不共斜线
//当前来到第i行，
//record[0...i-1]表示之前的行，放了的皇后位置
//n代表整体一共有多少行
//返回值是，摆完所有的皇后，合理的摆法有多少种
public static int process1(int i,int[] record,int n){
  //终止行
  if(i == n){
    return 1;
  }
  int res = 0;
  //当前行在i行，尝试所有的列j
  for(int j = 0;j < n;j++){
    //当前i行的皇后，放在j列，会不会和之前的(0...i-1)的皇后，共行共列或者共斜线
    //如果是，认为无效
    //如果不是，认为有效
    if(isValid(record,i,j){
      record[i] = j;
      res += process1(i+1,record,n);
    }
  }
  return res;
}
//record[0...i-1]需要看，后续的不需要
//返回i行皇后，放在j列，是否有效
public static boolean isValid(int[] record,int i,int j){
  for(int k = 0; k < i; k++){
    //共列和共斜线返回false
    if(j == record[k] || Math.abs(record[k] - j) == Math.abs(i-k)){
      return false;
    }
  }
  return true;
}
```
