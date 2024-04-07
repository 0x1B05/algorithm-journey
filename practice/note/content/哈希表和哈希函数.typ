#import "../template.typ": *
#pagebreak()
= 哈希表和哈希函数

== 哈希函数

1. 输入域无穷
2. 输出域 S 有限,比如 MD5 的返回值是 0~2 的 64 次方-1
3. 相同的输入,一定返回相同的输出（不随机）
4. 不同的输入,可能有相同的输出（哈希碰撞）,但是概率非常低
5. 每一个输出都均匀离散（最重要的性质）
6. 若输入域通过哈希函数得到的输出是均匀离散的,那再 mod 一个 M,得到的输出在 0~M-1
  上野是均匀离散的

=== 经典题目 1

假设有一个文件,有 40 亿无符号整数(0-2^32-1),只给 1G 内存,找出出现次数最多的数.
分析:使用 Hash 表超内存,key->4byte,value->4byte,至少 8byte.若 40
亿数字均不同,会需要 320 亿字节,大约 32G.不怕相同数出现多次,怕不同数多.

=== 经典题目 2

哈希表的实现

=== 经典题目 3

利用哈希表设计 RandomPoll 实现增删查. 设计一种结构,在该结构中有三个功能：

- insert（key）：将某个 key 加入到该结构,做到不重复加入.
- delete（key）：将原本在结构中的某个 key 移除.
- getRandom（）：等概率随机返回结构中的任何一个 key. >
  要求：这三个功能的时间复杂度都为 O（1）

分析:

#tablem[
  | \ | map1 | map2 | | ----- | ------- | ------- | | key | String | Integer | |
  value | Integer | String |
]

1. 对于 insert 函数,只需要先判断哈希表中是否含有该 key,若无,调用 HashMap 的 put
  方法即可.
2. 对于 delete
  函数,删除了哈希表中的某一键值对后,只需要将最后一组键值对补充到删除的缺口上即可.
  > HashMap 的 put 方法,若以前已包含了键值对,则替换圆键值对.
3. getRandom 函数,`(int)Math.random()*mapSize` 可以在 0~size-1 中随机生成一个数.

```java
public static class RandomPool{
    HashMap<String,Integer> map1;
    HashMap<Integer,String> map2;
    int mapSize;
    public RandomPool(){
        map1 = new HashMap<String,Integer>();
        map2 = new HashMap<Integer,String>();
        mapSize = 0;
    }
    public  boolean insert(String str){
        if(!map1.containsKey(str)){
            map1.put(str,++mapSize);
            map2.put(mapSize,str);
            return true;
        }
        return false;
    }

    public void delete(String str){
        if(map1.containsKey(str)){
            int deleteIndex = map1.get(str);
            int lastIndex = --mapSize;
            map1.put(map2.get(lastIndex),deleteIndex);  //map1中用最后一组键值对填充被删掉键值对的位置
            map2.put(deleteIndex,map2.get(lastIndex));  map1中用最后一组键值对填充被删掉键值对的位置

            map1.remove(str);
            map2.remove(lastIndex);   //把最后一组键值对删除,因为该键值对已经拿去填充了

        }
    }

    public String getRandom(){
        return map2.get((int)Math.random()*mapSize);
    }
}
```

=== 经典题目 3:布隆过滤器

解决类似于黑名单,爬虫等问题

特点：

1. 没有删除行为,只有加入和查询行为
2. 做到使用空间很少,允许一定程度的失误率
3. 布隆过滤器可能将白名单的用户当成了黑名单,但不会将黑名单的用户当成白名单
4. 可以通过人为设计,例如将失误率降为万分之一,但不可避免.

==== 位图

```java
public static void main(String[] args){
    //a实际上占32bit
    int a = 0;
    //32bit * 10 -> 320bits
    //arr[0] 可以表示0~31位bit
    //arr[1] 可以表示32~63位bit
    int[] arr = new int[10];
    //想取得第178个bit的状态
    int i = 178;
    //定位出第178位所对应的数组元素是哪个
    int numIndex = i / 32;
    //定位出相应数组元素后,需要知道是数组元素的哪一位
    int bitIndex = i % 32;
    //拿到第178位的状态
    int s = ( (arr[numIndex] >> (bitIndex))  & 1);
    //把第i位的状态改成1
    arr[numIndex] = arr[numIndex] | (1<<(bitIndex));
    //把第i位的状态改成0
    arr[numIndex] = arr[numIndex] & (~ (1 << bitIndex));
    //把第i位拿出来
    int bit = (arr[i/32] >> (i%32)) & 1;
}
```

https://blog.csdn.net/dreamispossible/article/details/89972545

=== 一致性哈希原理

https://blog.csdn.net/kefengwang/article/details/81628977
