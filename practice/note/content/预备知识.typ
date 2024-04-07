#import "../template.typ": *

= 算法预备知识

== acm风格算法笔试中处理输入和输出

=== 读写 api

1. 规定数据量(`BufferedReader`、`StreamTokenizer`、`PrintWriter`)，其他语言有对等的写法
2. 按行读(`BufferedReader`、`PrintWriter`)，其他语言有对等的写法
3. 不要用 `Scanner`、`System.out`，`IO` 效率慢

#code(
  caption: [acm风格测试方式],
)[
```java
// 子矩阵的最大累加和问题，不要求会解题思路，后面的课会讲
// 每一组测试都给定数据规模
// 需要任何空间都动态生成，在大厂笔试或者比赛中，这种方式并不推荐
// 测试链接 : https://www.nowcoder.com/practice/cb82a97dcd0d48a7b1f4ee917e2c0409?
// 请同学们务必参考如下代码中关于输入、输出的处理
// 这是输入输出处理效率很高的写法
// 提交以下的code，提交时请把类名改成"Main"，可以直接通过

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

public class Code02_SpecifyAmount{

    public static void main(String[] args) throws IOException {
        // 把文件里的内容，load进来，保存在内存里，很高效，很经济，托管的很好
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        // 一个一个读数字
        StreamTokenizer in = new StreamTokenizer(br);
        // 提交答案的时候用的，也是一个内存托管区
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) { // 文件没有结束就继续
            // n，二维数组的行
            int n = (int) in.nval;
            in.nextToken();
            // m，二维数组的列
            int m = (int) in.nval;
            // 装数字的矩阵，临时动态生成
            int[][] mat = new int[n][m];
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    in.nextToken();
                    mat[i][j] = (int) in.nval;
                }
            }
            out.println(maxSumSubmatrix(mat, n, m));
        }
        out.flush();
        br.close();
        out.close();
    }

    // 求子矩阵的最大累加和，后面的课会讲
    public static int maxSumSubmatrix(int[][] mat, int n, int m) {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < n; i++) {
            // 需要的辅助数组，临时动态生成
            int[] arr = new int[m];
            for (int j = i; j < n; j++) {
                for (int k = 0; k < m; k++) {
                    arr[k] += mat[j][k];
                }
                max = Math.max(max, maxSumSubarray(arr, m));
            }
        }
        return max;
    }

    // 求子数组的最大累加和，后面的课会讲
    public static int maxSumSubarray(int[] arr, int m) {
        int max = Integer.MIN_VALUE;
        int cur = 0;
        for (int i = 0; i < m; i++) {
            cur += arr[i];
            max = Math.max(max, cur);
            cur = cur < 0 ? 0 : cur;
        }
        return max;
    }

}
```
]

=== 动态空间 vs 静态空间

- 不推荐：临时动态空间
- 推荐：全局静态空间

#code(
  caption: [静态空间],
)[
```java
// 展示acm风格的测试方式
// 子矩阵的最大累加和问题，不要求会解题思路，后面的课会讲
// 每一组测试都给定数据规模
// 任何空间都提前生成好，一律都是静态空间，然后自己去复用，推荐这种方式
// 测试链接 : https://www.nowcoder.com/practice/cb82a97dcd0d48a7b1f4ee917e2c0409?
// 请同学们务必参考如下代码中关于输入、输出的处理
// 这是输入输出处理效率很高的写法
// 提交以下的code，提交时请把类名改成"Main"，可以直接通过

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

public class Code03_StaticSpace {

    // 题目给定的行的最大数据量
    public static int MAXN = 201;

    // 题目给定的列的最大数据量
    public static int MAXM = 201;

    // 申请这么大的矩阵空间，一定够用了
    // 静态的空间，不停复用
    public static int[][] mat = new int[MAXN][MAXM];

    // 需要的所有辅助空间也提前生成
    // 静态的空间，不停复用
    public static int[] arr = new int[MAXM];

    // 当前测试数据行的数量是n
    // 当前测试数据列的数量是m
    // 这两个变量可以把代码运行的边界规定下来
    public static int n, m;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    in.nextToken();
                    mat[i][j] = (int) in.nval;
                }
            }
            out.println(maxSumSubmatrix());
        }
        out.flush();
        br.close();
        out.close();
    }

    // 求子矩阵的最大累加和，后面的课会讲
    public static int maxSumSubmatrix() {
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < n; i++) {
            // 因为之前的过程可能用过辅助数组
            // 为了让之前结果不干扰到这次运行，需要自己清空辅助数组需要用到的部分
            Arrays.fill(arr, 0, m, 0);
            for (int j = i; j < n; j++) {
                for (int k = 0; k < m; k++) {
                    arr[k] += mat[j][k];
                }
                max = Math.max(max, maxSumSubarray());
            }
        }
        return max;
    }

    // 求子数组的最大累加和，后面的课会讲
    public static int maxSumSubarray() {
        int max = Integer.MIN_VALUE;
        int cur = 0;
        for (int i = 0; i < m; i++) {
            cur += arr[i];
            max = Math.max(max, cur);
            cur = cur < 0 ? 0 : cur;
        }
        return max;
    }

}
```
]

=== 按行读取

#code(
  caption: [按行读取],
)[
```java
// 展示acm风格的测试方式
// 测试链接 : https://www.nowcoder.com/exam/test/70070648/detail?pid=27976983
// 其中，7.A+B(7)，就是一个没有给定数据规模，只能按行读数据的例子
// 此时需要自己切分出数据来计算
// 请同学们务必参考如下代码中关于输入、输出的处理
// 这是输入输出处理效率很高的写法
// 提交以下的code，提交时请把类名改成"Main"，可以直接通过

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class Code04_ReadByLine {

    public static String line;

    public static String[] parts;

    public static int sum;

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while ((line = in.readLine()) != null) {
            parts = line.split(" ");
            sum = 0;
            for (String num : parts) {
                sum += Integer.valueOf(num);
            }
            out.println(sum);
        }
        out.flush();
        in.close();
        out.close();
    }
}
```
]

== 对数器

- 有一个想要测的方法 a, 一个暴力尝试的方法 b(不追求时间复杂度,好想好写的).
- 生成一个随机样本发生器, 可以产生随机样本.
  - 在方法 a 跑一遍,得到结果 a; 在方法 b 跑一遍,得到结果 b.
  - 把两个结果进行比较, 如果发现两个结果不一样,要么方法 a 错了;要么方法 b
    错了;要么两个方法都错.
    - 给一个小样本, 通过瞪眼法看看 a 结果和 b 的结果, 就可以知道方法 a 和 方法 b
      正确性.
    - 把方法 a 和方法 b 都改对, 然后把随机样本产生数的长度设置大些, 值也更随机些.
      跑个几千万次, 如果没有错误出现, 就可以确定方法 a 对了, 这个比 oj 更加可靠.

=== 举例
例如把冒泡排序和插入排序 2 个作对数器,方法 b 是系统自带的排序方法

#code(caption: [系统自带的排序方法])[
```java
public static void comparator(int[]arr){
    Arrays.sort(arr);
}
```
]

`generateRandomArray` 方法如下:

#code(
  caption: [generateRandomArray],
)[
```java
public static int[] generateRandomArray(int maxSize, int maxValue) {
    // Math.random()->[0,1)所有的小数,等概率返回一个
    // Math.random()*N->[0,N)所有小数,等概率返回一个
    // (int)(Math.random()*N)->[0,N-1]所有的整数,等概率返回一个
    int[] arr = new int[(int) ((maxSize + 1) * Math.random())];// 长度随机
    for (int i = 0; i < arr.length; i++) {
        arr[i] = (int) ((maxValue + 1) * Math.random()) - (int) (maxValue * Math.random());
    }
    return arr;
}
```
]

主函数如下:

#code(caption: [主函数])[
```java
public static void main(String[] args) {
    int testTime = 500000;
    int maxSize = 100;
    int maxValue = 100;
    boolean succeed = true;
    for (int i = 0; i < testTime; i++) {
        int[] arr1 = generateRandomArray(maxSize, maxValue);
        int[] arr2 = copyArray(arr1);
        insertionSort(arr1);
        comparator(arr2);
        if (!isEqual(arr1, arr2)) {// 打印arr1打印arr2
            succeed = false;
            break;
        }
    }
    System.out.println(succeed ? "Nice!" : "Fucking fucked!");
    if(!succeed){
        int[] arr = generateRandomArray(maxSize, maxValue);
        printArray(arr);
        insertionSort(arr);
        printArray(arr);
    }
}
```
]

=== 对数器模板

#code(caption: [对数器模板])[
```java
public static OutputType destMethod(InputType input) {
    .....
}
public static OutputType comparator(InputType input) {
    .....
}
public static InputType randGen(int maxSize, int maxValue) {
    .....
}
public static void main(String[] args){
    int testTime = 500000;
    int maxSize = 100;
    int maxValue = 100;
    boolean succeed = true;
    for(int i = 0; i <testTime; i++){
        InputType input = randGen(maxSize, maxValue);
        OutputType res1 = destMethod(input);
        OutputType res2 = comparator(input);
        if(!isEqual(res1,res2)){
            succeed = false;
            break;
        }
        if (i % 1000 == 0) {
                System.out.println(i + "round pass!!");
        }
    }
    System.out.println(succeed ? "Nice!" : "Oops!");
    if(!succeed){
        InputType input = randGen(maxSize, maxValue);
        print("input:"+input);
        OutputType res1 = destMethod(input);
        print("dest method output:"+output);
        OutputType res2 = comparator(input);
        print("comparator output:"+output);
    }
}
```
]

== 比较器

1. 比较器的实质就是重载比较运算符
2. 比较器可以很好地应用在特殊标准地排序上
3. 比较器可以很好地应用在根据特殊标准排序的结构上

#code(
  caption: [比较器],
)[
```java
// 以学生类为例子
public static class Student {
    public String name;
    public int id;
    public int age;

    public Student(String name, int id, int age) {
        this.name = name;
        this.id = id;
        this.age = age;
    }
}

public static void main(String[] args) {
    Student student1 = new Student("A", 2, 20);
    Student student2 = new Student("B", 3, 22);
    Student student3 = new Student("C", 1, 21);
    Student[] students = new Student[] { student1, student2, student3 };
    // 这个排序方法默认为升序,传入比较器,根据id的降序来排序
    Arrays.sort(students, new IdDescendingComparator());
}

// 编写比较器,实现Comparator接口
public static class IdDescendingComparator implements Comparator<Student> {
    // 返回负数的时候,第一个参数排在前面
    // 返回正数的时候,第二个参数排在前面
    // 返回0的时候,谁在前面都无所谓

    @Override
    public int compare(Student o1, Student o2) {
        // 后减前是降序
        // 前减后是升序
        return o2.id - o1.id;
    }
}
```
]

== master 公式

master 公式:也叫主定理.它提供了一种通过渐近符号表示递推关系式的方法. 应用 Master
定理可以很简便的求解递归方程.(递归就是系统帮做压栈和出栈的过程)

$T [n] = a*T[n/b] + O (n^d)$

#tip("Tip")[
    - $T[n]$->母问题的规模 
    - $T[n/b]$代表递归的子问题的规模 
    - $a$是调用次数 
    - $O(n^d)$除去递归之外的额外操作的复杂度
]

+ 当`d<log(b,a)`时,时间复杂度为`O(n^(logb a))`
+ 当`d=log(b,a)`时,时间复杂度为`O((n^d)*logn)`
+ 当`d>log(b,a)`时,时间复杂度为`O(n^d)`


=== 递归求数组的最大值

```java
public static int getMax(int[] arr) {
    return process(arr, 0, arr.length-1);
}

// 在[L,R]上求最大值
public static int process(int[] arr, int L, int R) {
    if (L == R) {
        return arr[L];
    }
    int mid = L + ((R - L) >> 1);//中点
    int leftMax = process(arr, L, mid);
    int rightMax = process(arr, mid+1, R);
    return Math.max(leftMax, rightMax);
}
```

=== master 公式说明

将整个数组分为两部分,则左部分为`n/2`,右部分也为`n/2`,两者相加,返回操作为`O(1)`

则得到的式子如下:
`a=2,b=2,d=0`、`T [n] = 2*T[n/2] + O (1)` 、`d<log(b,a)`则时间复杂度为`O(n)`

