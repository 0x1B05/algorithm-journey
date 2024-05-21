#import "../template.typ": *

#pagebreak()
= 数论

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

#code(caption: [模相同])[
```java
import java.math.BigInteger;

// 加法、减法、乘法的同余原理
// 不包括除法，因为除法必须求逆元，后续课讲述
public class Code03_SameMod {

	// 为了测试
	public static long random() {
		return (long) (Math.random() * Long.MAX_VALUE);
	}

	// 计算 ((a + b) * (c - d) + (a * c - b * d)) % mod 的非负结果
	public static int f1(long a, long b, long c, long d, int mod) {
		BigInteger o1 = new BigInteger(String.valueOf(a)); // a
		BigInteger o2 = new BigInteger(String.valueOf(b)); // b
		BigInteger o3 = new BigInteger(String.valueOf(c)); // c
		BigInteger o4 = new BigInteger(String.valueOf(d)); // d
		BigInteger o5 = o1.add(o2); // a + b
		BigInteger o6 = o3.subtract(o4); // c - d
		BigInteger o7 = o1.multiply(o3); // a * c
		BigInteger o8 = o2.multiply(o4); // b * d
		BigInteger o9 = o5.multiply(o6); // (a + b) * (c - d)
		BigInteger o10 = o7.subtract(o8); // (a * c - b * d)
		BigInteger o11 = o9.add(o10); // ((a + b) * (c - d) + (a * c - b * d))
		// ((a + b) * (c - d) + (a * c - b * d)) % mod
		BigInteger o12 = o11.mod(new BigInteger(String.valueOf(mod)));
		if (o12.signum() == -1) {
			// 如果是负数那么+mod返回
			return o12.add(new BigInteger(String.valueOf(mod))).intValue();
		} else {
			// 如果不是负数直接返回
			return o12.intValue();
		}
	}

	// 计算 ((a + b) * (c - d) + (a * c - b * d)) % mod 的非负结果
	public static int f2(long a, long b, long c, long d, int mod) {
		int o1 = (int) (a % mod); // a
		int o2 = (int) (b % mod); // b
		int o3 = (int) (c % mod); // c
		int o4 = (int) (d % mod); // d
		int o5 = (o1 + o2) % mod; // a + b
		int o6 = (o3 - o4 + mod) % mod; // c - d
		int o7 = (int) (((long) o1 * o3) % mod); // a * c
		int o8 = (int) (((long) o2 * o4) % mod); // b * d
		int o9 = (int) (((long) o5 * o6) % mod); // (a + b) * (c - d)
		int o10 = (o7 - o8 + mod) % mod; // (a * c - b * d)
		int ans = (o9 + o10) % mod; // ((a + b) * (c - d) + (a * c - b * d)) % mod
		return ans;
	}

	public static void main(String[] args) {
		System.out.println("测试开始");
		int testTime = 100000;
		int mod = 1000000007;
		for (int i = 0; i < testTime; i++) {
			long a = random();
			long b = random();
			long c = random();
			long d = random();
			if (f1(a, b, c, d, mod) != f2(a, b, c, d, mod)) {
				System.out.println("出错了!");
			}
		}
		System.out.println("测试结束");

		System.out.println("===");
		long a = random();
		long b = random();
		long c = random();
		long d = random();
		System.out.println("a : " + a);
		System.out.println("b : " + b);
		System.out.println("c : " + c);
		System.out.println("d : " + d);
		System.out.println("===");
		System.out.println("f1 : " + f1(a, b, c, d, mod));
		System.out.println("f2 : " + f2(a, b, c, d, mod));
	}

}
```
]

总结:
- 加法`a+b -> (a+b)%MOD`
- 减法`a-b -> (MOD+a-b)%MOD`
- 乘法`a*b-> int x = ((long)a*b)%MOD`
