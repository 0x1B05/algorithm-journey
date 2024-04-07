#import "../template.typ": *

#pagebreak()
= 同余原理

== 最大公约数 and 最小公倍数

证明辗转相除法就是证明关系： `gcd(a, b) = gcd(b, a % b)`
假设`a % b = r`，即需要证明的关系为：`gcd(a, b) = gcd(b, r)`

证明过程：
因为`a % b = r`，所以如下两个等式必然成立

1. `a = b * n + r`，n 为 0、1、2、3....中的一个整数
2. `r = a − b * n`，n 为 0、1、2、3....中的一个整数

假设 u 是 b 和 r 的公因子，则有: `b = x * u, r = y * u`; 把 b 和 r 带入 1 得到，`a = x * u * n + y * u = (x * n + y) * u`

这说明 : u 如果是 b 和 r 的公因子，那么 u 也是 a 的因子

假设 v 是 a 和 b 的公因子，则有: `a = s * v`, `b = t * v`

把 a 和 b 带入 2 得到，`r = s * v - t * v * n = (s - t * n) * v`

这说明 : v 如果是 a 和 b 的公因子，那么 v 也是 r 的因子

综上，a 和 b 的每一个公因子 也是 b 和 r 的一个公因子，反之亦然
所以，a 和 b 的全体公因子集合 = b 和 r 的全体公因子集合, 即 `gcd(a, b) = gcd(b, r)`

#code(caption: [gcd && lcm])[
```java
public static long gcd(long a, long b) {
    return b == 0 ? a : gcd(b, a % b);
}

public static long lcm(long a, long b) {
    return (long) a / gcd(a, b) * b;
}
```
]

=== 题目

==== #link("https://leetcode.cn/problems/nth-magical-number/")[ 第 N 个神奇数字 ]

一个正整数如果能被 a 或 b 整除，那么它是神奇的。
给定三个整数 n , a , b ，返回第 n 个神奇的数字。

#tip("Tip")[
    因为答案可能很大，所以返回答案 对 10^9 + 7 取模后的值。
] 

===== 解答

先估计答案范围, 一定 `1~min(a, b)` 之间

#code(caption: [解答])[
```java
public class Code02_NthMagicalNumber {

	public static int nthMagicalNumber(int n, int a, int b) {
		long lcm = lcm(a, b);
		long ans = 0;
		// l = 0
		// r = (long) n * Math.min(a, b)
		// l......r
		for (long l = 0, r = (long) n * Math.min(a, b), m = 0; l <= r;) {
			m = (l + r) / 2;
			// 1....m
			if (m / a + m / b - m / lcm >= n) {
				ans = m;
				r = m - 1;
			} else {
				l = m + 1;
			}
		}
		return (int) (ans % 1000000007);
	}

	public static long gcd(long a, long b) {
		return b == 0 ? a : gcd(b, a % b);
	}

	public static long lcm(long a, long b) {
		return (long) a / gcd(a, b) * b;
	}

}
```
]

== 同余原理
