#import "../template.typ": *
#pagebreak()
= 有序表、哈希表和链表

== 哈希表简单介绍

1. 哈希表在使用层面上可以理解为一种集合结构
2. 如果只有 key,没有伴随数据 value,可以使用 HashSet 结构(C++中叫 UnOrderedSet)
3. 如果既有 key,又有伴随数据 value,可以使用 HashMap 结构(C++中叫 UnOrderedMap)
4. 有无伴随数据,是 HashMap 和 HashSet 唯一的区别,底层的实际结构是一回事
5. 使用哈希表增(put)、删(remove)、改(put)和查(get)的操作,可以认为时间复杂度为
  0(1),但是常数时间比较大
6. 放入哈希表的东西,如果是基础类型,内部按值传递,内存占用就是这个东西的大小
7. 放入哈希表的东西,如果不是基础类型,内部按引用传递,内存占用是这个东西内存地址的大小

== 有序表

=== 有序表的简单介绍

1. 有序表在使用层面上可以理解为一种集合结构
2. 如果只有 key,没有伴随数据 value,可以使用 TreeSet 结构(C++中叫 OrderedSet)
3. 如果既有 key,又有伴随数据 value,可以使用 TreeMap 结构(C++中叫 OrderedMap)
4. 有无伴随数据,是 TreeSet 和 TreeMap 唯一的区别,底层的实际结构是一回事
5. 有序表和哈希表的区别是,有序表把 key 按照顺序组织起来,而哈希表完全不组织
6. 红黑树、AVL 树、size-balance-tree 和跳表等都属于有序表结构,只是底层具体实现不同
7. 放入有序表的东西,如果是基础类型,内部按值传递,内存占用就是这个东西的大小
8. 放入有序表的东西,如果不是基础类型,必须提供比较器,内部按引用传递,内存占用是这个东西内存地址的大小

=== 有序表的固定操作

1. `void put(key,value)`: 将一个`(key,value)`记录加入到表中,或者将 key 的记录更新成
  value。
2. `get(key)`: 根据给定的 key,查询 value 并返回。
3. `void remove(key)`: 移除 key 的记录。
4. `boolean containsKey(key)`: 询问是否有关于 key 的记录。
5. `firstKey()`: 返回所有键值的排序结果中,最左(最小)的那个。
6. `lastKey()`: 返回所有键值的排序结果中,最右(最大)的那个。
7. `floorKey(key)`: 如果表中存入过 key,返回 key; 否则返回所有键值的排序结果中,key
  的前一个。
8. `ceilingKey(key)`: 如果表中存入过 key,返回 key; 否则返回所有键值的排序结果中,key
  的后一个。 以上所有操作时间复杂度都是`0(logN)`,N 为有序表含有的记录数

== 链表

=== 节点结构

==== 单链表的节点结构

```java
class Node {
    public int value;
    public Node next;

    public Node(int v) {
        value = v;
    }
}
```

由以上结构的节点依次连接起来所形成的链叫单链表结构。

==== 双链表的节点结构

```java
class DoubleNode {
    int value;
    DoubleNode pre;
    DoubleNode next;

    public DoubleNode(int value) {
        this.value = value;
    }
}
```

由以上结构的节点依次连接起来所形成的链叫双链表结构。
单链表和双链表结构只需要给定一个头部节点 head,就可以找到剩下的所有的节点。

=== 题目

==== 反转单向和双向链表

题目: 分别实现反转单向链表和反转双向链表的函数 要求: 如果链表长度为
N,时间复杂度要求为 O(N),额外空间复杂度为 O(1)

===== 反转单链表

- 迭代实现

```java
class ReverseLinkedList {
    class Node {
        int value;
        Node next;

        public void setVal(int value) {
            this.value = value;
        }
    }

    public Node reverseLinkedList(Node head) {
        if (head == null)
            return head;
        //pre一直代表遍历到要反转节点的前驱节点
        //next一直代表遍历到要反转节点的后继节点
        Node current = head;
        Node pre = null;
        Node next = current.next;
        while (current != null) {
            //先用next保存head的下一个节点的信息
            //保证单链表不会因为反转head节点的原next节点而就此断裂
            next = current.next;
            //反转,head的后继变成向前指,指向head的next前驱
            current.next = pre;
            //节点的前驱和节点都后移,继续遍历
            pre = current;
            current = next;
        }
        //如果head为null的时候,pre就为最后一个节点了,就此链表已经反转完毕,pre就是反转后链表的第一个节点
        head = pre;
        return head;
    }
}
```

- 尾递归实现
  尾递归的含义是,一个方法或函数中所有递归形式的调用都出现在方法或函数的末尾,则这个递归方法或函数是尾递归的。当递归调用是整个方法或函数体中最后执行的语句,且返回值不属于表达式的一部分时,递归调用就是尾递归。尾递归的特点是在回归过程中不用做任何操作,当编译器检测到尾递归时,会覆盖当前的栈帧而不是新建一个栈帧,从而优化栈空间。

```java
public static Node reverseList(Node head) {
    return reverseListTail(null, head);
}

public static Node reverseListTail(Node pre, Node cur) {
    if (cur == null) {
        return pre;
    }
    Node next = cur.next;
    cur.next = pre;
    return reverseListTail(cur, next);
}
```

- 附普通递归(空间复杂度为 O(N)):

```java
public static Node recursionReverseLinkedList(Node head) {
    if (head.next == null){
        return head;
    }
    Node newHead = recursionReverseLinkedList(head.next);
    Node pre = head;
    head.next.next = pre;
    pre.next = null;
    return newHead;
}
```

===== 反转双链表

```java
public class ReverseDoubleLinkedList {
    public static class DoubleNode {
        int val;
        DoubleNode pre;
        DoubleNode next;

        public DoubleNode(int value) {
            this.val = value;
        }
    }

    public static DoubleNode reverseDoubleLinkedList(DoubleNode head) {
        if (head == null) {
            return null;
        }

        DoubleNode next = null;
        // pre的作用仅仅是记录head的上一个节点
        DoubleNode pre = null;

        while (head != null) {
            // 先用next保持后继节点,然后交换前后节点
            next = head.next;
            head.next = head.pre;
            head.pre = next;
            // 记录pre
            pre = head;
            // head指向next保存的原节点的后继节点,即向后推进一个节点
            head = next;
        }
        head = pre;
        return head;
    }
}
```

==== 打印两个有序链表的公共部分

题目: 给定两个有序链表的头指针 head1 和 head2,打印两个链表的公共部分 要求:
如果两个链表的长度之和为 N,时间复杂度要求为 O(N),额外空间复杂度为 O(1)

```java
public class PrintCommonPart {
    public static class Node {
        public int value;
        public Node next;

        public Node(int v) {
            value = v;
        }
    }

    public static void printCommonPart(Node head1, Node head2) {
        Node p1 = head1;
        Node p2 = head2;
        while (p1.value != p2.value) {
            if (p1.value < p2.value) {
                p1 = p1.next;
            } else {
                p2 = p2.next;
            }
        }
        while (p1.value == p2.value || (p1 == null && p2 == null)) {
            System.out.println(p1.value);
            p1 = p1.next;
            p2 = p2.next;
        }
    }
}
```

==== 判断一个链表是否是回文结构

题目: 给定一个单链表的头结点 head,请判断该链表是否为回文结构 例子: 1->2->1,返回
true; 1->2->2->1,返回 true; 15->6->15,返回 true; 1->2->3,返回 false; 要求:
如果链表长度为 N,时间复杂度要求为 O(N),额外空间复杂度为 O(1)

```java
public class IsPalindrome {
    // 单链表结构
    public static class Node {
        public int value;
        public Node next;

        public Node(int value) {
            this.value = value;
        }
    }

    // 方法1: 用栈结构存储整个链表元素,再依次弹出并与链表从头开始比较,空间复杂度: O（n)
    public static boolean isPalindrome1(Node head) {
        if (head == null || head.next == null) {
            return true;
        }
        // 申请一个栈
        Stack<Node> stack = new Stack<Node>();
        Node cur = head;
        // 将单链表元素按顺序入栈
        while (cur != null) {
            stack.push(cur);
            cur = cur.next;
        }
        // 不断弹出栈顶元素,并和单链表从头开始比较,不相等就返回false
        while (head != null) {
            if (head.value != stack.pop().value) {
                return false;
            }
            head = head.next;
        }
        return true;
    }

    // 方法2: 用栈只存储链表一半的元素（中间位置到最后）,最后依次弹出并与链表的前半部分比较
    // 空间复杂度: O（n/2）
    public static boolean isPalindrome2(Node head) {
        if (head == null || head.next == null) {
            return true;
        }
        // 用快慢指针来确定中间位置
        // 快指针一次走两步,慢指针一次走一步
        // 快指针走完时,慢指针刚好来到右部分第一个节点上
        Node slow = head.next;// 慢指针,若元素个数为偶数时,最后指向中间位置的后一个位置
        Node quick = head;// 快指针
        while (quick.next != null && quick.next.next != null) {
            slow = slow.next;
            quick = quick.next.next;
        }
        // 把从慢指针即中间位置开始的右部分元素放进栈中
        Stack<Node> stack = new Stack<Node>();
        while (slow != null) {
            stack.push(slow);
            slow = slow.next;
        }
        // 不断弹出栈顶元素,并从头和单链表元素比较,不相等就返回false
        while (!stack.isEmpty()) {
            if (head.value != stack.pop().value) {
                return false;
            }
            head = head.next;
        }
        return true;
    }

    // 方法3: 将链表对折,后半部分的链表反转与前半部分链表进行比较
    public boolean isPalindromList3(Node head) {
        if (head == null || head.next == null) {
            return true;
        }

        Node slow = head.next;
        Node quick = head;

        // 元素总个数为奇数时,慢指针最后指向中间位置,若为偶数,则走到中间位置的前一位
        // 注意: 在向后遍历的时候,需要判断快指针指向的节点是否为空,不然会出现异常
        // 若quick.next != null,那么说明这是偶数个,quick.next.next != null,说明是奇数个
        while (quick.next != null && quick.next.next != null) {
            quick = quick.next.next;
            slow = slow.next;
        }
        // slow来的中点位置,反转后半部分,反转后中点指向null
        Node head2 = reverseSingleList(slow);
        Node p1 = head;
        Node p2 = head2;
        // 将前半部分和后半部分进行对比
        // 前半部分从cur即head开始,后半部分从quick即end开始
        while (p1 != null && p2 != null) {
            if (p1.value != p2.value) {
                return false;
            }
            p1 = p1.next;
            p2 = p2.next;
        }
        // 不能改变原有的数据结构,所以还要把后半部分反转回去
        // 遍历完cur来到中间位置,接上反转回来的后半部分头节点
        slow = reverseSingleList(head2);
        return true;
    }

    private Node reverseSingleList(Node head) {
        Node pre = null;
        Node next = null;

        while (head != null) {
            // 存储原来next节点
            next = head.next;
            // next节点指向上一个节点
            head.next = pre;
            // 下一个节点的上一个节点就是当前节点
            pre = head;
            // 向后推进一个节点
            head = next;
        }
        // 返回反转后的头节点,即最后一个节点
        return pre;
    }
}
```

方法 1: 笔试利用栈来做,遍历一遍链表,把链表元素入栈;
再遍历一遍链表,栈弹出元素并与原链表当前元素对比,不一样就返回 false

方法 2:
利用快慢指针,快指针一次走两步,慢指针一次走一步,当快指针到最后的时候,慢指针刚好到中间,这时候利用栈将链表后半部分的元素入栈,再弹出比较,从而节省了一半空间

方法 3:
利用快慢指针,快指针到最后的时候,慢指针刚好到中点,然后利用慢指针,将链表后半部分逆序,即
1->2 变成 2->1,再用两个指针,一个从头开始遍历,一个从尾开始遍历,有不同则返回
false,否则结束后返回 true,最后记得恢复原数组

==== 将单向链表按某值划分成左边小,中间相等,右边大的形式

题目: 给定一个单链表的头结点 head,节点的值类型是整型,再给定一个整数
pivot,实现一个调整链表的函数,将链表调整为左部分都是值小于 pivot
的节点,中间部分都是值等于 pivot 的节点,右部分都是值大于 pivot 的节点

进阶: 在实现原问题功能的基础上,增加如下要求 要求: 调整后所有小于 pivot
的节点之间的相对顺序和调整前一样 要求: 调整后所有等于 pivot
的节点之间的相对顺序和调整前一样 要求: 调整后所有大于 pivot
的节点之间的相对顺序和调整前一样 要求: 时间复杂度达到 O(N),额外空间复杂度为 O(1)

```java
public class LinkedPartition {
    public static class Node{
        int value;
        Node next;
        public Node(int val){
            this.value = val;
        }
    }
    //方法一: 将链表元素放进数组partition,然后再连回成单链表
    public Node linkerPartition1(Node head, int num){
        if(head == null || head.next == null){
            return head;
        }
        //先计算有多少个节点
        int i = 0;
        Node cur = head;
        while(cur != null){
            i++;
            cur = cur.next;
        }
        //然后申请一个和节点数相同的数组
        int[] arr = new int[i];
        //再把节点的value放进数组
        cur = head;
        i = 0;
        while(cur != null){
            arr[i++] = cur.value;
            cur = cur.next;
        }
        //再对数组中的元素用荷兰国旗方法对值进行小于、等于、大于的区域划分
        arrPartition(arr, num);
        //最后把排好序的数组元素按顺序更新到原来链表的value上
        cur = head;
        i = 0;
        while(cur != null){
            cur.value = arr[i++];
            cur = cur.next;
        }
        return head;
    }
    //荷兰国旗划分法
    public void arrPartition(int[] arr, int num){
        int less = -1;
        int more = arr.length;
        int cur = 0;
        while(cur != more){
            if(arr[cur] < num){
                swap(arr,++less,cur++);
            }else if(arr[cur > num){
                swap(arr,--more,cur);
            }else{
                cur++;
            }
        }
    }
    public void swap(int[] arr, int i, int j){
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
    //方法二: 用六个变量将原链表拆分成三个小链表,表示大于、小于、等于区域的局部链表,划分完将这三个链表连起来
    public static Node listPartition2(Node head, int num) {
        Node less = null; // 存放小于num的节点,指向第一个出现在该区域的节点
        Node endless = null; // 指向小于num的节点链表的结尾
        Node equal = null; // 存放等于num的节点,指向第一个出现在该区域的节点
        Node endequal = null; // 指向等于num的节点链表的结尾
        Node more = null; // 存放大于num的节点,指向第一个出现在该区域的节点
        Node endmore = null; // 指向大于num的节点链表的结尾
        Node temp = head;

        // 分别对三个区进行填充
        while (temp != null) {
            //less区
            if (temp.value < num) {
                if (less == null) {//是空则头尾均为temp
                    less = temp;
                    endless = temp;
                } else {//非空则尾加temp
                    endless.next = temp;
                    endless = endless.next;
                }
            } else if (temp.value > num) {//more区
                if (more == null) {
                    more = temp;
                    endmore = temp;
                } else {
                    endmore.next = temp;
                    endmore = endmore.next;
                }
            } else {//equal区
                if (equal == null) {
                    equal = temp;
                    endequal = temp;
                } else {
                    endequal.next = temp;
                    endequal = endequal.next;
                }
            }
            temp = temp.next;
        }

        endless.next = null;
        endequal.next = null;
        endmore.next = null;
        if (less == null) {
            if (equal != null) {
                head = equal;
                endequal.next = more;
            } else {
                head = more;
            }
        } else {
            head = less;
            if (equal != null) {
                endless.next = equal;
                endequal.next = more;
            } else {
                endless.next = more;
            }
        }
        return head;
    }
    public Node listPartition2(Node head, int num){
        Node less = null;     // 存放小于num的节点,指向第一个出现在该区域的节点
        Node endless = null;    // 指向小于num的节点链表的结尾
        Node equal = null;      // 存放等于num的节点,指向第一个出现在该区域的节点
        Node endequal = null;   // 指向等于num的节点链表的结尾
        Node more = null;       // 存放大于num的节点,指向第一个出现在该区域的节点
        Node endmore = null;    // 指向大于num的节点链表的结尾
        Node next = null;

        while(head != null){
            next = head.next;
            head.next = null;

            //小于num放进less区域
            if(head.value < num){
                //当前区域为空时,头节点和尾节点都更新为head,代表第一个进入该区域的节点
                if(less == null){
                    less = head;
                    endless = head;
                }else{
                    //不为空时,上一次的尾节点的next节点指向当前的head
                    endless.next = head;
                    //再更新当前的尾节点变成head
                    endless = head;
                }
            //more区
            }else if(head.value > num){
                if(more == null){
                    more = head;
                    endmore = head;
                }else{
                    endmore.next = head;
                    endmore = head;
                }
            //euqal区
            }else{
                if(equal == null){
                    equal = head;
                    endequal = head;
                }else{
                    endequal.next = head;
                    endequal = head;
                }
            }
            //推进节点
            head = head.next;
        }
        //将划好的三个部分子链表串起来,返回
        //还需要考虑到可能会有某个部分子链表不存在的情况

        //less子链存在
        if(less != null){
            endless.next = equal;
            //less和equal子链都存在
            if(equal != null){
                endequal.next = more;
            //less存在,equal不存在,less直接和more相连
            }else{
                endless.next = more;
            }
            return less;
        //less不存在
        }else{
            //less不存在,equal存在,equal和more相连
            if(equal != null){
                endequal.next = more;
                return equal;
            }else{
                //less不存在,equal也不存在
                return more;
            }
        }
    }
}
```

方法 1: 利用 node 数组,将链表全部节点放入数组中,然后进行
partition,但是保持不了相对顺序

方法 2: 利用 6
个变量,分别指向小于区的头,小于区的尾,等于区的头,等于区的尾,大于区的头,大于区的尾;
通过遍历,可以将所有元素对应哪个区域找到,并更新各个变量的值,最后再将小于区的尾和等于区的头连接,等于区的尾和大于区的头连接,返回小于区的头（一定要讨论是否有小于区,等于区,大于区）

==== 复制含有随机指针节点的链表

题目: 一种特殊的单链表节点类描述如下:

```java
class Node{
    int value;
    Node next;
    Node random;
    Node(int val){
        value = val;
    }
}
```

random 指针是单链表节点结构中新增的指针,random
可能指向链表中的任意一个节点,也可能指向 null。给定一个由 node
节点类型组成的无环单链表的头结点
head,请实现一个函数完成这个链表的复制,并返回复制的新链表的头结点 要求:
时间复杂度 O(N),额外空间复杂度 O(1)

```java
public class CopyRandomList {
    public static class Node {
        int value;
        Node next;
        Node random;

        public Node(int value) {
            this.value = value;
        }
    }

    // 方法一: 直接用hashmap来进行元素列表节点和复制节点间的映射,key存原来的节点,value存新复制的节点
    public Node copyRandomList1(Node head) {
        // hashmap的key和value都是存Node类型,存入的是地址
        HashMap<Node, Node> map = new HashMap<Node, Node>();

        // 第一次遍历: 拷贝节点,形成key是旧结点,value是复制的新节点
        Node temp = head;
        while (temp != null) {
            map.put(temp, new Node(temp.value));
            temp = temp.next;
        }
        // 第二次遍历: 复制节点间的关系,即复制next和random指针
        // 原链表节点间的指针关系是知道的,比如想知道A'和B'之间的关系,可以通过:A'->A->B->B',这样就找到了B'
        while (temp != null) {
            // get(temp).next得到复制节点的next,get(temp.next)得到原来节点的next节点的复制节点
            map.get(temp).next = map.get(temp.next);
            // random同理
            map.get(temp).random = map.get(temp.random);
            temp = temp.next;
        }
        // 返回get(head)中存的复制链表的头节点
        return map.get(head);
    }

    // 方法二: 不用额外空间。首先,先将结点复制到链表中,形成: 1->1’->2->2’->3->3’->…->null形式;
    // 其次复制rand结构,如1‘的rand指针需指向3’,则又1指针指向3, 3的next为3‘,因此可得出1’的rand指向3‘。
    // 最后将链表拆分得到复制链表。
    public Node copyRandomList2(Node head) {
        if (head == null)
            return null;
        // 拷贝节点,重建链表结构: 1->1'->2->2'->3->3'->...->null形式
        // 就是将拷贝的节点直接关联到原节点的next指针上
        Node temp = head;
        while (temp != null) {
            Node tempCopy = new Node(temp.value);
            Node temp2 = temp.next;// 先将当前节点原来的next节点存起来
            temp.next = tempCopy;// 再把当前节点的next节点改成拷贝节点
            tempCopy.next = temp2;// 将拷贝节点next节点存回原来的next节点,变成1->1'->2结构
            temp = temp2;// 让temp来到下一个原节点位置
        }
        // 进行random 的拷贝
        temp = head;
        while (temp != null) {
            temp.next.random = temp.random == null ? null : temp.random.next;
            temp = temp.next.next;
        }
        // 拆分链表结构
        temp = head;
        Node headCopy = head.next;
        while (temp.next != null) {
            Node temp2 = temp.next;
            temp.next = temp.next.next;
            temp = temp2;
        }
        return headCopy;
    }
}
```

==== 两个单链表相交的一系列问题

题目: 给定两个可能有环也可能无环的单链表,头结点 head1 和
head2。请实现一个函数,如果两个链表相交,请返回相交的第一个节点。如果不相交,返回
null 要求:如果两个链表长度之和为 N,时间复杂度请达到 O(N),额外空间复杂度为 O(1)

```java
public class GetIntersectionNode {
    public static class Node {
        int value;
        Node next;

        public Node(int value) {
            this.value = value;
        }
    }

    // 利用HashSet来判断有没有环
    public static Node existLoop1(Node head) {
        HashSet<Node> set = new HashSet<Node>();
        Node temp = head;
        while (temp != null) {
            if (!set.contains(temp)) {
                set.add(temp);
                temp = temp.next;
            } else {
                return temp;
            }
        }
        return null;
    }

    // 利用快慢指针来判断有没有环
    public static Node existLoop2(Node head) {
        if (head == null || head.next == null) {
            return null;
        }
        Node p1 = head;
        Node p2 = head;

        while (p2 != null && p2.next != null) {
            p1 = p1.next; // 慢指针一次一步
            p2 = p2.next.next; // 快指针一次两步
            if (p1 == p2) {
                p2 = head; // p1和p2相遇证明有环,p2回到head位置
                while (p1 != p2) {
                    p1 = p1.next;
                    p2 = p2.next; // p2和p1都每次走一步
                }
                if (p1 == p2) {
                    return p1; // 再次相遇时就是入环节点
                }
            }
        }
        return null; // 没相遇过就是无环
    }

    // 情况一: 两个都没环
    // 方法一: 使用HashSet
    public static Node noLoop1(Node head1, Node head2) {
        Node p1 = head1;
        Node p2 = head2;
        HashSet<Node> set = new HashSet<Node>();
        // 遍历其中一个链表并将节点存入HashSet
        while (p1 != null) {
            set.add(p1);
            p1 = p1.next;
        }
        // 对另一个链表遍历,如果HashSet中存有相同节点则相交,且此节点就是交点
        while (p2 != null) {
            if (set.contains(p2)) {
                return p2;
            }
            p2 = p2.next;
        }
        return null;
    }

    // 方法二: 利用双指针走差值步
    // 使用tail是为了方便后面的情况调用,增加代码复用率
    public static Node noLoop2(Node head1, Node head2, Node tail1, Node tail2) {
        if (head1 == null || head2 == null) {
            return null;
        }
        Node p1 = head1;
        Node p2 = head2;
        // d_value是链表长度差值
        int d_value = 0;
        while (p1.next != tail1) {
            ++d_value;
            p1 = p1.next;
        }
        while (p2.next != tail2) {
            --d_value;
            p2 = p2.next;
        }
        if (p1 != p2) {// 如果最后一个节点不一样一定不相交
            return null;
        }
        p1 = head1;
        p2 = head2;
        // 让p1 p2有相同的起点
        if (d_value < 0) {
            // p2更长
            while (d_value != 0) {
                ++d_value;
                p2 = p2.next;
            }
        } else {
            // 相等或者p1更长
            while (d_value != 0) {
                --d_value;
                p1 = p1.next;
            }
        }
        // 遍历到相交点
        while (p1 != p2) {
            p1 = p1.next;
            p2 = p2.next;
        }
        return p1;
    }

    // 情况二: 一个有环一个无环,必然无法相交
    // 情况三: 两个都有环(无交点,入环前相交,入环后相交)
    public static Node bothLoop(Node head1, Node head2) {
        Node loop1 = existLoop2(head1);
        Node loop2 = existLoop2(head2);
        Node p1 = head1;
        // Node p2 = head2;
        if (loop1 == loop2) {
            return noLoop2(head1, head2, loop1, loop2);
            // int d_value = 0; // 两个链表长度的差值
            // // 遍历cur1和cur2链表得到他们的长度差值和最后一个节点
            // while (p1 != loop1) {
            //     d_value++;
            //     p1 = p1.next;
            // }
            // while (p2 != loop2) {
            //     d_value--;
            //     p2 = p2.next;
            // }
            // // 如果n>0,代表head1链表长,cur1等于长的链表的头节点
            // p1 = d_value > 0 ? head1 : head2;
            // // cur2代表短的链表的头节点
            // p2 = p1 == head1 ? head2 : head1;
            // // 长链表先走n步
            // while (d_value != 0) {
            //     d_value--;
            //     p1 = p1.next;
            // }
            // // 然后cur1和cur2都一次走一步
            // while (p1 != p2) {
            //     p1 = p1.next;
            //     p2 = p2.next;
            // }
            // // 最后相同时就是相交节点
            // return p1;
            // 环内相交:
        } else {
            // cur1从loop1.next开始不断走
            p1 = loop1.next;
            // 走回到自己之前,不断寻找loop1环内是否有和loop2相同的节点
            while (p1 != loop1) {
                // 遇到loop2,返回相交节点
                if (p1 == loop2) {
                    return loop2;
                }
                // 推进到下一个节点
                p1 = p1.next;
            }
            // 走完了也没有相同节点,两个链表不相交
            return null;
        }
    }

    public static Node getIntersectNode(Node head1, Node head2) {
        if (head1 == null || head2 == null) {
            return null;
        }
        // 先检查两个单链表是否有环
        Node loop1 = existLoop2(head1);
        Node loop2 = existLoop2(head2);
        // 如果都无环
        if (loop1 == null && loop2 == null) {
            return noLoop2(head1, head2,null,null);
        }
        // 如果都有环
        if (loop1 != null && loop2 != null) {
            return bothLoop(head1, head2);
        }
        // 一个有环一个无环,单链表结构下永不相交
        return null;
    }
}

```

===== 思路分析

- 步骤一: 先判断一个链表是否有环,如果有,返回头结点

  - 方法 1: 使用 hash 表遍历
  - 方法 2: 利用快慢指针

- 解释

  - 为何慢指针第一圈走不完一定会和快指针相遇？
    快指针先进入环---》当慢指针刚到达环的入口时,快指针此时在环中的某个位置(也可能此时相遇)
    ---》设此时快指针和慢指针距离为$x$,若在第二步相遇,则$x = 0$
    ---》设环的周长为$n$,那么看成快指针追赶慢指针,需要追赶$n-x$
    ---》快指针每次都追赶慢指针 1 个单位,设慢指针速度 1 节点/次,快指针 2
    节点/次,那么追赶需要$n-x$次 ---》在$n-x$次数内,慢指针走了$n-x$节点,因为$x\ge 0$,则慢指针走的路程小于等于
    n,即走不完一圈就和快指针相遇
  - 为什么必然会在入环点相遇？ 假设链表非环部分长度为$a$,慢指针入环后走了$b$距离与快指针相遇,设环中除$b$外剩余部分的长度为$c$,此时快指针已经走完了环的$n$圈。
    则快指针走的距离$s_1=a+n(b+c)+b$ 慢指针走的距离是$s_2=a+b$
    由题意可知$s_1=2s_2$,即$a+n(b+c)+b = 2(a+b)$,推出$a = c+(n-1)(b+c)$
    即从相遇点到入环点的距离加上 n-1 圈的环长恰好等于从链表头部到入环点的距离。

- 步骤二: 讨论 head1 和 head2 在不同情况下的处理方法
  - 情况 1: `loop1 == null && loop2 == null`
  - 情况 2: `loop1`,`loop2`中有`null`也有非`null`,则一定不相交
  - 情况 3: `loop1`,`loop2`都非空,则分三种情况
