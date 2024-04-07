#import "../template.typ": *
#pagebreak()
= 二叉树

二叉树结构：

```java
public static class Node{
    public int value;
    public Node left;
    public Node right;
    public Node(int data){
        this.value = data;
    }
}
```

== 二叉树的遍历

=== 递归序遍历：

```java
public static void f(Node head){
    if(head == null){
        return;
    }
    // 第一次进入
    f(head.left)
    // 左子树遍历结束第二次回到head
    f(head.right)
    // 右子树遍历结束第三次回到head
}
```

==== 举例

```mermaid
graph TD
1-->2
1-->3
2-->4
2-->5
3-->6
3-->7
```

节点遍历顺序：*1->2->4->4->4->2->5->5->5->2->1->3->6->6->6->3->7->7->7->3->1*

=== 先中后遍历

- 先序遍历：头节点->左子树->右子树
  节点遍历顺序：1->2->4->5->3->6->7(与递归序关系：第一次碰到即打印)
- 中序遍历：左子树->头节点->右子树
  节点遍历顺序：4->2->5->1->6->3->7(与递归序关系：第二次碰到即打印)
- 后序遍历：左子树->右子树->头节点
  节点遍历顺序：4->5->2->6->7->3->1(与递归序关系：第三次碰到即打印)

==== 递归方式

```java
//先序：头左右
public static void preOrderRecur(Node head){
    if(head == null){
        return;
    }
    System.out.print(head.value+" ");
    preOrderRecur(head.left);
    preOrderRecur(head.right);
}
//中序：左头右
public static void inOrderRecur(Node head){
    if(head == null){
        return;
    }
    inOrderRecur(head.left);
    System.out.print(head.value+" ");
    inOrderRecur(head.right);
}
//后序
public static void posOrderRecur(Node head){
    if(head == null){
        return;
    }
    posOrderRecur(head.left);
    posOrderRecur(head.right);
    System.out.print(head.value+" ");
}
```

==== 非递归方式

===== 先序遍历

```java
// 1.准备一个栈, 放进头节点, 从栈中弹出一个节点cur
// 2.打印cur
// 3.先右再左节点压入栈(如果有)
// 4.重复上述过程至栈为空
public static void preOrderUnRecur(Node head){
    System.out.print("pre-order:");
    if(head != null){
        Stack<Node> stack = new Stack<Node>();
        stack.add(head);
        while(!stack.isEmpty()){
            head = stack.pop();
            System.out.print(head.value+" ");
            if(head.right != null){
                stack.push(head.right);
            }
            if(head.left != null){
                stack.push(head.left);
            }
        }
    }
    System.out.println();
}
```

===== 中序遍历

```java
//1.先是每棵子树的的整个左边界进栈
//2.然后依次弹出, 弹出并打印(已包括根节点)
//3.每弹出一个节点时要检查是否有右子树, 如果有
//4.右子树重复上述过程, 重复完继续弹出
public static void inOrderunRecur(Node head){
    System.out.print("in-order");
    if(head != null){
        Stack<Node> stack = new Stack<Node>();
        while(!stack.isEmpty() || head !=null){
            //当head不为空时, 就将它的左子树放进栈中
            if(head != null){
                stack.push(head);
                head = head.left;
            //当head为空, stack不为空时, 弹出一个栈顶元素, 然后打印, 并看看他有没有右子树
            }else{
                head = stack.pop();
                System.out.print(head.value+" ");
                head = head.right;
            }
        }
    }
    System.out.println();
}
```

===== 后序遍历

```java
// 1.准备两个栈,先头节点压入第一个栈, 弹出到收集栈
// 2.然后先左后右节点压入栈
// 3.重复上述过程, 最后依次弹出收集栈的元素
public static void posOrderUnRecur(Node head){
    System.out.print("pos-order");
    if(head != null){
        Stack<Node> s1 = new Stack<Node>();//第一个栈
        Stack<Node> s2 = new Stack<Node>();//收集栈
        s1.push(head);//第一个头节点进栈
        while(!s1.isEmpty()){
            head = s1.pop();//第一个栈的栈顶弹出
            s2.push(head);//进入收集栈
            //先左节点进栈
            if(head.left != null){
                s1.push(head.left);
            }
            //后右节点进栈
            if(head.right != null){
                s1.push(head.right);
            }
        }
        //按顺序弹出收集栈栈顶节点
        while(!s2.isEmpty()){
            System.out.print(s2.pop().value+" ");
        }
    }
    System.out.println();
}
```

=== 层次遍历(宽度优先遍历)

```java
//宽度优先遍历
public static void bfs(Node head){
    if(head == null){
        return;
    }
    Queue<Node> queue = new LinkerList<>();
    queue.add(head);
    while(!queue.isEmpty()){
        Node cur = queue.poll();
        System.out.println(cur.value);
        if(cur.left != null){
            queue.add(cur.left);
        }
        if(cur.right != null){
            queue.add(cur.right);
        }
    }
}
```

== 二叉树经典题目

=== 求二叉树宽度

```java
public class GetMaxWidth {
    public static int getMaxWidth1(Node root) {
        if (root == null) {
            return 0;
        }
        Queue<Node> queue = new LinkedList<Node>();
        Node temp = root;
        int maxWidth = Integer.MIN_VALUE;
        queue.offer(temp);
        while (!queue.isEmpty()) {
            int levelSize = queue.size();
            if (levelSize > maxWidth) {
                maxWidth = levelSize;
            }
            for (int i = 0; i < levelSize; i++) {
                temp = queue.poll();
                if (temp.left != null) {
                    queue.offer(temp.left);
                }
                if (temp.right != null) {
                    queue.offer(temp.right);
                }
            }
        }
        return maxWidth;
    }

    // 左神的方法
    // 使用hash表
    public int maxWidth1(Node root) {
        if (root == null)
            return 0;
        Queue<Node> queue = new LinkedList<>();
        queue.add(root);
        HashMap<Node, Integer> levelMap = new HashMap<>();// 记录节点属于第几行
        levelMap.put(root, 1);
        int curLevel = 1;// 当前所在行数
        int curLevelNodes = 0;// 当前行数所有的节点个数
        int max = 0;// 目前为止一行中最多节点的个数
        while (!queue.isEmpty()) {
            Node cur = queue.poll();// 队列中的第一个
            int curNodeLevel = levelMap.get(cur);// 当前节点所在的行数
            if (cur.left != null)// 如果左孩子存在
            {
                levelMap.put(cur, curNodeLevel + 1);// 写入hash表
                queue.add(cur.left);// 入队
            }
            if (cur.right != null)// 同上
            {
                levelMap.put(cur, curNodeLevel + 1);
                queue.add(cur.right);
            }
            if (curNodeLevel == curLevel)// 如果这个节点所在的行数和目前行数相同
                curLevelNodes++;// 该行的节点数加一
            else {// 不同
                max = Math.max(max, curLevelNodes);// 比较这层的节点数是否是比之前最大的大
                curLevel++;// 进入下一行
                curLevelNodes = 1;// 下一行有一个节点
            }
        }
        // 指针为空时退出,所以其实最后一行还没比较
        max = Math.max(max, curLevelNodes);
        return max;
    }

    // 不使用hash表
    public int maxWidth2(Node root) {
        if (root == null)
            return 0;
        Queue<Node> queue = new LinkedList<>();
        queue.add(root);
        int curLevelNodes = 0;// 当前行数所有的节点个数
        int max = 0;// 目前为止一行中最多节点的个数
        Node levelEnd = root;
        Node nextEnd = null;
        while (!queue.isEmpty()) {
            Node cur = queue.poll();
            curLevelNodes++;
            if (cur.left != null)// 如果左孩子存在
            {
                queue.add(cur.left);// 入队
                nextEnd = cur.left;
            }
            if (cur.right != null)// 同上
            {
                queue.add(cur.right);
                nextEnd = cur.right;
            }
            if (cur == levelEnd) {
                levelEnd = nextEnd;
                max = Math.max(max, curLevelNodes);
                curLevelNodes = 0;
            }
        }
        return max;
    }
}
```

=== 判断一棵树是否是搜索二叉树

搜索二叉树：每棵子树的左树都比头节点小, 右树都比头节点大

```java
public static int minValue = Integer.MIN_VALUE;

// 用中序遍历判断, 如果是一直升序的则为搜索二叉树, 中间有一段不是升序的话, 则不是搜索二叉树
public static boolean isBST1(Node root) {
    if (root == null) {
        return true;
    }
    // 左树递归检查是否符合中序遍历从小到大排列
    boolean isLeftBst = isBST1(root.left);
    // 如果左树不符合返回false
    if (!isLeftBst) {
        return false;
    }
    // 如果不符合升序返回false
    if (root.value <= minValue) {
        return false;
    } else {
        // 更新minValue
        minValue = root.value;
    }
    // 检查右树是否符合升序中序遍历, 如果右树也符合, 则是搜索二叉树
    return isBST1(root.right);
}

// 迭代同理只需将打印部分换成判断部分即可
public static boolean isBST2(Node root) {
    Stack<Node> stack = new Stack<Node>();
    Node temp = root;
    while (temp != null || !stack.empty()) { // 加入temp!=null是为了让起初栈空时也进入循环
        while (temp != null) {
            stack.push(temp);
            temp = temp.left;
        }
        temp = stack.pop();
        // 如果不符合升序返回false
        if (root.value <= minValue) {
            return false;
        } else {// 更新minValue
            minValue = root.value;
        }
        temp = temp.right;
    }
    return true;
}
```

=== 判断一棵树是否是完全二叉树

完全二叉树：从左到右依次遍满, 可以只有左节点, 不能只有右节点而没有左节点

```java
public class IsCBT {
    //1.任意节点有右无左, 返回false
    //2.在1情况不违反的情况下, 如果遇到了第一个左右孩子不全的节点,
    public static boolean isCBT(Node head){
        if(head == null){
            return true;
        }
        LinkedList<Node> queue = new LinkedList<>();
        boolean leaf = false;//是否遇到左右孩子节点不双全的节点
        Node l = null;
        Node r = null;
        queue.add(head);
        while(!queue.isEmpty()) {
            head = queue.poll();
            l = head.left;
            r = head.right;
            //遇到左右孩子不全的节点后还遇到左右孩子不全的节点（不是叶子节点）, 或者遇到有右子树无左子树, 都返回false
            if ((leaf && (l != null || r != null)) ||
                    (l == null && r != null))
                return false;

            if (l != null) {
                queue.add(l);
            }
            if (r != null) {
                queue.add(r);
            }
            if (l == null || r == null) {
                leaf = true;
            }
        }
        return true;
    }
}
```

=== 判断一棵树是否是满二叉树

满二叉树：每层节点数达最大值

```java
public class IsFull {
    public static boolean isFull1(Node root) {
        int height = findHeight(root);
        int nodes = findNodes(root);

        return (1 << height - 1) == nodes;
    }

    public static int findHeight(Node root) {
        if (root == null) {
            return 0;
        }
        return Math.max(findHeight(root.left), findHeight(root.right)) + 1;
    }

    public static int findNodes(Node root) {
        if (root == null) {
            return 0;
        }
        return findNodes(root.left) + findNodes(root.right) + 1;
    }
}
```

=== 判断一棵树是否是平衡二叉树

平衡二叉树：对于任何一棵子树, 左树和右树高度差不超过 1

```java
public boolean isBalanced1(Node root) {
    if (root == null) {
        return true;
    }
    return isBalanced1(root.left) && isBalanced1(root.right) &&
            Math.abs(findHeight(root.left) - findHeight(root.right)) <= 1;
}

public static int findHeight(Node root) {
    if (root == null) {
        return 0;
    }
    return Math.max(findHeight(root.left), findHeight(root.right)) + 1;
}
```

=== 找两棵二叉树的最低公共祖先节点

最近公共祖先节点即两个节点向上走最先相遇的节点

```java
//给定两个二叉树的节点, 找他们最低的公共祖先节点
public class LowestCommonAncestor {
    //简单的方法：用哈希表来存父节点信息, 然后查重
    public static Node lowestCommonAncestor1(Node head, Node o1, Node o2){
        HashMap<Node,Node> fatherMap = new HashMap<>();
        fatherMap.put(head,head);
        //存储父亲节点信息
        fillMap(head,fatherMap);
        HashSet<Node> set1 = new HashSet<>();
        //先将o1节点的所有祖先节点信息存进set里
        Node cur = o1;
        //只有头节点会等于自己的父亲, 所有可以作为节点向上寻找祖先的条件
        while(cur != fatherMap.get(cur)){
            set1.add(cur);
            cur = fatherMap.get(cur);
        }
        //最后将头节点放进set
        set1.add(head);
        //然后开始检查o2节点的祖先中和o1相同的祖先节点
        cur = o2;
        while(cur != fatherMap.get(cur)){
            cur = fatherMap.get(cur);
            if(set1.contains(cur)){
                return cur;
            }
        }
        return null;
    }

    //存储每个节点的父亲信息
    public static void fillMap(Node head, HashMap<Node,Node> fatherMap){
        if(head == null){
            return;
        }
        fatherMap.put(head.left,head);
        fatherMap.put(head.right,head);
        fillMap(head.left,fatherMap);
        fillMap(head.right,fatherMap);
    }

    //精简高阶版：
    public static Node lowestCommonAncestor2(Node root, Node o1, Node o2) {
        if (root == null || root == o1 || root == o2) {
            return root;
        }
        Node retLeft = lowestCommonAncestor1(root.left, o1, o2);
        Node retRight = lowestCommonAncestor1(root.right, o1, o2);
        // 左右都不空, 则返回当前节点(即为最近公共祖先节点)
        // 左右有且仅有一个不空, 则返回不空的
        // 左右均空, 则返回空
        return retLeft == null ? retRight : (retRight == null ? retLeft : root);
    }
}
```

=== 找中序遍历中二叉树的某个节点的后继节点

在二叉树的中序遍历的序列中, node 的下一个节点叫做 node 的后继节点

```java
//只给一个在二叉树中的某个节点node, 请实现返回node的后继节点的函数
public class GetSuccessorNode {
    // 现在有一种新的二叉树节点类型
    public class NewNode {
        public int value;
        public NewNode left;
        public NewNode right;
        public NewNode parent;// 包含父亲节点

        public NewNode(int value) {
            this.value = value;
        }
    }
    // 中序遍历顺序的下一个节点

    //分两种情况来找x的后继节点
    //1.x有右树时, 后继节点为右树上最左的节点
    //2.x无右树时, 向上找, 找到一个父亲的左树是x时, 该父亲就是x的后继, 因为x是父亲左子树数中的最右节点
    public static NewNode getSuccessNode(NewNode cur){
        if (cur.right != null) {
            NewNode temp = cur.right;
            while (temp.left!=null) {
                temp = temp.left;
            }
            return temp;
        }else{// 没有右树向上找
            NewNode parent = cur.parent;
            //父亲不为空并且该节点不是父节点的左节点时, 一直向上找
            while(parent!=null&&parent.left != cur){
                cur = parent;
                parent = cur.parent;
            }
            //父亲不为空并且该节点不是父节点的左节点时, 一直向上找
            return parent;
        }
    }
}
```

=== 二叉树的序列化和反序列化

```java
//二叉树的序列化和反序列化
//序列化和反序列化：内存里的一棵树如何变成字符串形式, 又如何从字符串变成内存里的树的结构
public class SerialByPre {
    public static class Node {
        public int value;
        public Node left;
        public Node right;

        public Node(int data) {
            this.value = data;
        }
    }
    //序列化
    public static String serialByPre(Node head){
        if(head == null){
            return "#_";
        }
        String res = head.value + "_";
        res += serialByPre(head.left);
        res += serialByPre(head.right);
        return res;
    }
    //反序列化
    public static Node reconPreString(String preStr){
        //分割字符串
        String[] values = preStr.split("_");
        Queue<String> queue = new LinkedList<>();
        for(int i = 0; i != values.length; i++){
            queue.add(values[i]);
        }
        return reconPreOrder(queue);
    }
    public static Node reconPreOrder(Queue<String> queue){
        String value = queue.poll();
        if(value.equals("#")){
            return null;
        }
        Node head = new Node(Integer.valueOf(value));
        head.left = reconPreOrder(queue);
        head.right = reconPreOrder(queue);
        return head;
    }
}
```

=== 折纸问题

请把一段纸条竖着放在桌子上, 然后从纸条的下边向上方对折 1 次,
压出折痕后展开。此时 折痕是凹下去的,
即折痕突起的方向指向纸条的背面。如果从纸条的下边向上方连续对折 2 次,
压出折痕后展开, 此时有三条折痕, 从上到下依次是下折痕、下折痕和上折痕。
给定一个输入参数 N, 代表纸条都从下边向上方连续对折 N 次,
请从上到下打印所有折痕的方向 例如：N=1 时, 打印： down；N=2 时, 打印： down down
up

== 树形 DP 套路

=== 使用前提:

如果题目求解目标是 S 规则,则求解流程可以定成每一个节点尾头节点的子树在 S
规则下的每一个答案,并且最终答案一定在其中.

=== 套路

分析可能性->汇总需要左右孩子提供哪些信息, 构造 `ReturnType`->构造递归函数

1. 以某个节点 x 为头节点的字数中,分析答案的可能性,并且分析是以 x 的左子树,x
  的右子树和 x 整棵树的角度来考虑可能性(经验性,可以拿 x 是否参与来考虑可能性)
2. 根据第一步的可能性分析,列出所有需要的信息
3. 合并第二步的信息,对左树和右树提出同样的要求,并写出信息结构
4. 涉及递归函数,递归函数是处理以 x 为头节点的情况下的答案.(包括涉及递归的 base
  case,默认直接得到左树和右树的所有信息,以及把可能性做整合,并且要返回第三步的信息信息结构这四个小步骤)

==== 递归函数三步

1. base case 递归出口
2. 将左右孩子的返回方法当作黑盒直接使用
3. 实现信息具体实现逻辑

=== 判断搜索二叉树

```java
public static boolean isBST3(Node root) {
    return process(root).isBST;
}

static class ReturnType {
    int max;
    int min;
    boolean isBST;

    public ReturnType(int max, int min, boolean isBST) {
        this.max = max;
        this.min = min;
        this.isBST = isBST;
    }
}

public static ReturnType process(Node root) {
    // base case
    if (root == null) {
        return null;
    }
    ReturnType left = process(root.left);
    ReturnType right = process(root.right);

    int min = root.value;
    int max = root.value;
    if (left != null) {
        min = Math.min(min, left.min);
        max = Math.max(max, left.min);
    }
    if (right != null) {
        min = Math.min(min, right.min);
        max = Math.max(max, right.min);
    }

    boolean isBST = (left == null || (left.isBST && left.max < root.value))
            && (right == null || (right.isBST && right.min > root.value));
    return new ReturnType(max, min, isBST);
}
```

=== 判断平衡二叉树

```java
//1.先分析可能性
//左树平衡+右树平衡+|左子树高度-右子树高度|≤1时, 整棵树平衡

//2.提取条件
//每棵子树的返回类型需要包含的属性：
//①该子树是否平衡（boolean）
//②该子树的高度（int）

//3.coding
public static boolean isBalanced2(Node head){
    return process(head).isBalanced;
}

public static class ReturnType{
    public boolean isBalanced;
    public int height;
    public ReturnType(boolean isB, int hei){
        this.isBalanced = isB;
        this.height = hei;
    }
}

public static ReturnType process(Node x){
    if(x == null){
        return new ReturnType(true,0);
    }
    //左、右子树的数据
    ReturnType leftData = process(x.left);
    ReturnType rightData = process(x.right);

    //高度
    int height = Math.max(leftData.height, rightData.height)+1;
    //是否平衡
    boolean isBalanced = leftData.isBalanced && rightData.isBalanced
            && Math.abs(leftData.height - rightData.height) < 2;
    //返回数据
    return new ReturnType(isBalanced,height);
}
```

=== 判断满二叉树

```java
//1.先分析可能性
//左树满+右树满+（左树节点数 = 2^（左子树高度）-1）+（右树节点数 = 2^（右子树高度）-1）时, 整棵树满

//2.提取条件
//每棵子树的返回类型需要包含的属性：
//①该子树的节点数（int）
//②该子树的高度（int）

//3.coding
public static class Info{
    public int height;
    public int nodes;
    public Info(int height, int nodes){
        this.height = height;
        this.nodes = nodes;
    }
}

public static Info process(Node head){
    if(head == null){
        return new Info(0,0);
    }
    Info leftData = process(head.left);
    Info rightData = process(head.right);
    int height = Math.max(leftData.height, rightData.height) + 1;
    int nodes = leftData.nodes + rightData.nodes + 1;
    return new Info(height,nodes);
}

public static boolean isFull2(Node head){
    if(head == null){
        return true;
    }
    Info data = isF(head);
    return data.nodes == (1 << data.height - 1);
}
```

=== 二叉树节点间的最大距离

从二叉树的节点 a 出发,可以向上或者向下走,但沿途的节点只能经过一次,到达节点 b
时路径上的节点个数叫作 a 到 b
的距离,那么二叉树任何两个节点之间都有距离,求整棵树上的最大距离.

分析:

1. x 不参与
  1. 左最大距离
  2. 右最大距离
2. x 参与:左高+右高+1

=== 派对的最大快乐值

整个公司的人员结构可以看作是一棵标准的多叉树。树的头节点是公司唯一的老板,
除老板外, 每个员工都有唯一的直接上级, 叶节点是没有任何下属的基层员工,
除基层员工外, 每个员工都有一个或多个直接下级, 另外每个员工都有一个快乐值。
这个公司现在要办 party, 你可以决定哪些员工来,
哪些员工不来。但是要遵循如下的原则： 1.如果某个员工来了,
那么这个员工的所有直接下级都不能来。
2.派对的整体快乐值是所有到场员工快乐值的累加。
3.你的目标是让派对的整体快乐值尽量大。 给定一棵多叉树, 请输出派对的最大快乐值。
