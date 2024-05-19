#import "../template.typ": *

= 动态规划

== 从递归入手一维动态规划

#tip("Tip")[
  题目 1 到题目 4，都从递归入手，逐渐改出动态规划的实现
]

=== #link(
  "https://leetcode.cn/problems/minimum-cost-for-tickets/",
)[题目 2: 最低票价 ]

在一个火车旅行很受欢迎的国度，你提前一年计划了一些火车旅行.
在接下来的一年里，你要旅行的日子将以一个名为 days 的数组给出, 每一项是一个从 1
到 365 的整数 火车票有三种不同的销售方式:

- 一张 为期 1 天 的通行证售价为 `costs[0]` 美元
- 一张 为期 7 天 的通行证售价为 `costs[1]` 美元
- 一张 为期 30 天 的通行证售价为 `costs[2]` 美元

通行证允许数天无限制的旅行, 例如，如果我们在第 2 天获得一张 为期 7 天 的通行证,
那么我们可以连着旅行 7 天(第 2~8 天)

返回你想要完成在给定的列表 `days` 中列出的每一天的旅行所需要的最低消费

#example(
  "Example",
)[
- 输入：`days = [1,4,6,7,8,20]`, `costs = [2,7,15]`
- 输出：`11`
- 解释：
  - 例如，这里有一种购买通行证的方法，可以让你完成你的旅行计划：
  - 在第 1 天，你花了 `costs[0] = $2` 买了一张为期 1 天的通行证，它将在第 1 天生效。
  - 在第 3 天，你花了 `costs[1] = $7` 买了一张为期 7 天的通行证，它将在第 3, 4, ...,
    9 天生效。
  - 在第 20 天，你花了 `costs[0] = $2` 买了一张为期 1 天的通行证，它将在第 20
    天生效。
  - 你总共花了 \$11，并完成了你计划的每一天旅行。
]

==== 解答

#code(
  caption: [解答],
)[
```java
// dp缓存
public static int mincostTickets(int[] days, int[] costs) {
    int[] dp = new int[days.length + 1];
    for (int i = 0; i < dp.length; i++) {
        dp[i] = Integer.MAX_VALUE;
    }
    int ans = f1(days, costs, 0, dp);

    return ans;
}

// 当前位于days[cur...], 要接着完成days的最低消费
public static int f1(int[] days, int[] costs, int cur, int[] dp) {
    // 后续已经没有旅行了
    if (cur >= days.length) {
        return 0;
    }
    if (dp[cur] < Integer.MAX_VALUE) {
        return dp[cur];
    }
    int ans = Integer.MAX_VALUE;
    for (int k = 0; k < costs.length; k++) {
        // 如果costs[0] 1天 -> f(days,costs,cur+1)
        // 如果costs[1] 7天 -> f(days,costs,cur+?);要看days[cur]+7 恰好<days[i] -> f(days, costs, i)
        // 如果costs[2] 30天 -> f(days,costs,cur+?);要看days[cur]+30 恰好<days[i] -> f(days, costs, i)
        if (k == 0) {
            // 1天
            ans = Math.min(ans, costs[0] + f1(days, costs, cur + 1, dp));
        } else if (k == 1) {
            // 7天
            int i = 0;
            for (i = cur + 1; i < days.length && days[i] < days[cur] + 7; i++)
                ;
            ans = Math.min(ans, costs[1] + f1(days, costs, i, dp));
        } else {
            // 30天票
            int i = 0;
            for (i = cur + 1; i < days.length && days[i] < days[cur] + 30; i++)
                ;
            ans = Math.min(ans, costs[2] + f1(days, costs, i, dp));
        }
    }
    dp[cur] = ans;
    return ans;
}

// 表依赖
public static int MAX_DAYS = 366;

public static int mincostTickets2(int[] days, int[] costs) {
    int n = days.length;
    int[] dp = new int[n + 1];
    Arrays.fill(dp, 0, n + 1, Integer.MAX_VALUE);
    dp[n] = 0;

    for (int cur = n - 1; cur >= 0; cur--) {
        for (int k = 0; k < costs.length; k++) {
            if (k == 0) {
                // 1天
                dp[cur] = Math.min(dp[cur], costs[0] + dp[cur + 1]);
            } else if (k == 1) {
                // 7天
                int i = 0;
                for (i = cur + 1; i < days.length && days[i] < days[cur] + 7; i++)
                    ;
                dp[cur] = Math.min(dp[cur], costs[1] + dp[i]);
            } else {
                // 30天票
                int i = 0;
                for (i = cur + 1; i < days.length && days[i] < days[cur] + 30; i++)
                    ;
                dp[cur] = Math.min(dp[cur], costs[2] + dp[i]);
            }
        }
    }
    return dp[0];
}
```
]


这里面左的处理更简洁值得学习一下:

#code(caption: [左神的处理])[
```java
// 无论提交什么方法都带着这个数组      0  1  2
public static int[] durations = { 1, 7, 30 };

...
for (int k = 0, j = i; k < 3; k++) {
    // k是方案编号 : 0 1 2
    while (j < days.length && days[i] + durations[k] > days[j]) {
        // 因为方案2持续的天数最多，30天
        // 所以while循环最多执行30次
        // 枚举行为可以认为是O(1)
        j++;
    }
    ans = Math.min(ans, costs[k] + f1(days, costs, j));
}
...
```
]

=== #link(
  "https://leetcode.cn/problems/decode-ways/description/",
)[题目 3: 解码方法]

一条包含字母 A-Z 的消息通过以下映射进行了 编码 ：

```
'A' -> "1"
'B' -> "2"
...
'Z' -> "26"
```

要解码已编码的消息，所有数字必须基于上述映射的方法，反向映射回字母（可能有多种方法）。例如，"11106"
可以映射为：

- `"AAJF"` ，将消息分组为 `(1 1 10 6)`
- `"KJF"` ，将消息分组为 `(11 10 6)`

注意，消息不能分组为 `(1 11 06)` ，因为 `"06" `不能映射为 `"F" `，这是由于 `"6" `和 `"06" `在映射中并不等价。

给你一个只含数字的非空字符串 `s` ，请计算并返回解码方法的总数 。

#tip("Tip")[
  题目数据保证答案肯定是一个 32 位 的整数。
]

==== 解答

#code(
  caption: [解答],
)[
```java
public static int numDecodings(String s) {
    int[] dp = new int[s.length() + 1];
    Arrays.fill(dp, -1);
    int ans = f(s, 0, dp);
    return ans;
}

// s[cur...有多少种编码方法.
public static int f(String s, int cur, int[] dp) {
    if (cur == s.length()) {
        return 1;
    }
    if (dp[cur] != -1) {
        return dp[cur];
    }

    int ans = 0;
    // 选当前的
    if (s.charAt(cur) == '0') {
        return 0;
    } else {
        ans += f(s, cur + 1, dp);
        // 选当前的以及下一个(要求要小于26)
        if (cur + 1 < s.length() && ((s.charAt(cur) - '0') * 10 + (s.charAt(cur + 1) - '0')) <= 26) {
            ans += f(s, cur + 1, dp);
        }
    }

    dp[cur] = ans;
    return ans;
}

public static int numDecodings2(String s) {
    int n = s.length();
    int[] dp = new int[n + 1];
    Arrays.fill(dp, 0);

    dp[n] = 1;
    for (int cur = n - 1; cur >= 0; cur--) {
        if (s.charAt(cur) == '0') {
            dp[cur] = 0;
        } else {
            dp[cur] += dp[cur + 1];
            // 选当前的以及下一个(要求要小于26)
            if (cur + 1 < n && ((s.charAt(cur) - '0') * 10 + (s.charAt(cur + 1) - '0')) <= 26) {
                dp[cur] += dp[cur + 2];
            }
        }

    }

    return dp[0];
}
```
]

给出了一种空间压缩的方法, 利用变量的滚动更新就算出来了结果, 非常 amazing.

#code(
  caption: [空间压缩],
)[
```java
// 严格位置依赖的动态规划 + 空间压缩
public static int numDecodings3(String s) {
    // dp[i+1]
    int next = 1;
    // dp[i+2]
    int nextNext = 0;
    for (int i = s.length() - 1, cur; i >= 0; i--) {
        if (s.charAt(i) == '0') {
            cur = 0;
        } else {
            cur = next;
            if (i + 1 < s.length() && ((s.charAt(i) - '0') * 10 + s.charAt(i + 1) - '0') <= 26) {
                cur += nextNext;
            }
        }
        nextNext = next;
        next = cur;
    }
    return next;
}
```
]

=== #link("https://leetcode.cn/problems/decode-ways-ii/")[题目 4: 解码方法 II]

一条包含字母 A-Z 的消息通过以下映射进行了 编码 ：

```
'A' -> "1"
'B' -> "2"
...
'Z' -> "26"
```

要解码已编码的消息，所有数字必须基于上述映射的方法，反向映射回字母（可能有多种方法）。例如，"11106"
可以映射为：

- `"AAJF"` ，将消息分组为 `(1 1 10 6)`
- `"KJF"` ，将消息分组为 `(11 10 6)`

注意，消息不能分组为 `(1 11 06)` ，因为 `"06" `不能映射为 `"F" `，这是由于 `"6" `和 `"06" `在映射中并不等价。

除了 上面描述的数字字母映射方案，编码消息中可能包含 `'*'` 字符，可以表示从 `'1'` 到 `'9' `的任一数字（不包括` '0'`）。例如，编码字符串 `"1*"` 可以表示` "11"`、`"12"`、`"13"`、`"14"`、`"15"`、`"16"`、`"17"`、`"18" `或 `"19" `中的任意一条消息。对 `"1*" `进行解码，相当于解码该字符串可以表示的任何编码消息。

给你一个字符串 s ，由数字和 `'*'` 字符组成，返回 解码 该字符串的方法 数目 。

由于答案数目可能非常大，返回 10^9 + 7 的 模 。

==== 解答

#code(
  caption: [解答],
)[
```java
public static int numDecodings(String s) {
    long[] dp = new long[s.length() + 1];
    Arrays.fill(dp, -1);
    long ans = f(s, 0, dp);
    return (int) ans;
}

public static long MOD = 1000000007;

// s[cur...]有多少种编码方法.
public static long f(String s, int cur, long[] dp) {
    if (cur == s.length()) {
        return 1;
    }
    if (dp[cur] != -1) {
        return dp[cur];
    }

    long ans = 0;
    // 选当前的
    if (s.charAt(cur) == '0') {
        return 0;
    } else {
        // 当前不是0, 有几种情况.
        // 仅选当前位(可能是数字或者*).
        // 选当前位以及下一位, 第一位是1/2 或者 *, 第二位是0-6或者, 第二位是*

        // 仅选当前位, 区分普通和*
        int cur_char = s.charAt(cur) - '0';
        if (cur_char > 0 && cur_char < 10) {
            // 是普通数字
            ans += f(s, cur + 1, dp);
        } else {
            // 是*
            ans += 9 * f(s, cur + 1, dp);
        }

        // 选当前以及下一位
        boolean oneOr2 = cur_char == 1 || cur_char == 2;
        boolean curStar = cur_char == ('*' - '0');
        if (cur + 1 < s.length()) {
            // 第一位是1/2, 第二个是 0-6 / *
            int next_char = s.charAt(cur + 1) - '0';
            boolean isNum = next_char >= 0 && next_char <= 9;
            boolean lessThan6 = isNum && next_char <= 6;
            boolean nextStar = next_char == ('*' - '0');
            if (oneOr2) {
                if ((cur_char == 2 && lessThan6)
                        || (cur_char == 1 && isNum)) {
                    ans += f(s, cur + 2, dp);
                } else if (nextStar) {
                    if (cur_char == 1) {
                        ans += 9 * f(s, cur + 2, dp);
                    } else if (cur_char == 2) {
                        ans += 6 * f(s, cur + 2, dp);
                    }
                }
                // 第一位是*(代表1/2), 第二位可能是数字或者*
            } else if (curStar) {
                if (isNum) {
                    if (lessThan6) {
                        ans += 2 * f(s, cur + 2, dp);
                    } else {
                        ans += f(s, cur + 2, dp);
                    }
                } else if (nextStar) {
                    ans += 15 * f(s, cur + 2, dp);
                }
            }
        }
    }

    ans = (ans + MOD) % MOD;
    dp[cur] = ans;
    return ans;
}

public static int numDecodings2(String s) {
    int n = s.length();
    long[] dp = new long[n + 1];
    Arrays.fill(dp, 0);

    dp[n] = 1;
    for (int cur = n - 1; cur >= 0; cur--) {
        if (s.charAt(cur) == '0') {
            dp[cur] = 0;
        } else {
            // 当前不是0, 有几种情况.
            // 仅选当前位(可能是数字或者*).
            // 选当前位以及下一位, 第一位是1/2 或者 *, 第二位是0-6或者, 第二位是*

            // 仅选当前位, 区分数字和*
            int cur_char = s.charAt(cur) - '0';
            if (cur_char > 0 && cur_char < 10) {
                // 是普通数字
                dp[cur] += dp[cur + 1];
            } else {
                // 是*
                dp[cur] += 9 * dp[cur + 1];
            }

            // 选当前以及下一位
            boolean oneOr2 = cur_char == 1 || cur_char == 2;
            boolean curStar = cur_char == ('*' - '0');
            if (cur + 1 < s.length()) {
                // 第一位是1/2, 第二个是 0-6 / *
                int next_char = s.charAt(cur + 1) - '0';
                boolean isNum = next_char >= 0 && next_char <= 9;
                boolean lessThan6 = isNum && next_char <= 6;
                boolean nextStar = next_char == ('*' - '0');
                if (oneOr2) {
                    if ((cur_char == 2 && lessThan6)
                            || (cur_char == 1 && isNum)) {
                        dp[cur] += dp[cur + 2];
                    } else if (nextStar) {
                        if (cur_char == 1) {
                            dp[cur] += 9 * dp[cur + 2];
                        } else if (cur_char == 2) {
                            dp[cur] += 6 * dp[cur + 2];
                        }
                    }
                    // 第一位是*(代表1/2), 第二位可能是数字或者*
                } else if (curStar) {
                    if (isNum) {
                        if (lessThan6) {
                            dp[cur] += 2 * dp[cur + 2];
                        } else {
                            dp[cur] += dp[cur + 2];
                        }
                    } else if (nextStar) {
                        dp[cur] += 15 * dp[cur + 2];
                    }
                }
            }
        }

        dp[cur] = (dp[cur] + MOD) % MOD;
        dp[cur] = dp[cur];
    }

    return (int) dp[0];
}
```
]

这里依然可以使用滚动更新.

=== #link(
  "https://leetcode.cn/problems/ugly-number-ii/description/",
)[题目 5: 丑数 II]

#tip(
  "Tip",
)[
  当熟悉了从递归到动态规划的转化过程, 那么就可以纯粹用动态规划的视角来分析问题了,
  题目 5 到题目 8，都是纯粹用动态规划的视角来分析、优化的
]

#definition(
  "Definition",
)[
*丑数* 就是质因子只包含 `2`、`3` 和 `5` 的正整数。给你一个整数 `n` ，请你找出并返回第 `n` 个
丑数 。
]


#example("Example")[
- 输入：`n = 10`
- 输出：`12`
- 解释：`[1, 2, 3, 4, 5, 6, 8, 9, 10, 12]` 是由前 10 个丑数组成的序列。
]

#example("Example")[
- 输入：`n = 1`
- 输出：`1`
- 解释：`1` 通常被视为丑数。
]

==== 解答

方法 1(最暴力): 自然数枚举, 一个个试(?)

方法 2(次暴力): 每个丑数都是前面的某个丑数\*2,\*3,\*5 得到的, 从 1 开始,
每个丑数数分别\*2,\*3,\*5, 找到最小的, 排序 1 -> 2 3 5 找到最小的 2 2 -> 4 6 10
找到除去 2, 最小的那个即 3 3 -> 6 9 15 找到除去 2 3 最小的那个即 4 ....

方法 2 的决策策略就是比前面一个丑数大的里面最小的那个

方法 3(最优解): 从 1 开始, 三个指针\*2,\*3,\*5, 找到最小的,
然后相应的倍数移到下一个丑数上面去.

一开始三个指针都指向 1. p1(2), p2(3), p3(5) 找到指针指着的较小的那个 即 2. 接着
p1 指针没必要留在 1 位置了, 移到 2 位置. p1(4), p2(3), p3(5)
找到指针指着的较小的那个 即 3. 接着 p2 指针没必要留在 1 位置了, 移到 2 位置.

到期问题, 什么样的可能性再也不会成为下一个丑数的解了.

#code(caption: [解答])[
```java
public static int nthUglyNumber(int n) {
    int[] uglyNums = new int[n + 1];
    uglyNums[1] = 1;
    // p2 p3 p5分别对应*2 *3 *5的指针分别停在什么下标
    int p2 = 1, p3 = 1, p5 = 1;
    for (int i = 2; i <= n; i++) {
        int a = uglyNums[p2] * 2;
        int b = uglyNums[p3] * 3;
        int c = uglyNums[p5] * 5;
        // 当前的丑数
        int cur = Math.min(Math.min(a, b), c);
        if (cur == a) {
            ++p2;
        }
        if (cur == b) {
            ++p3;
        }
        if (cur == c) {
            ++p5;
        }
        uglyNums[i] = cur;
    }
    return uglyNums[n];
}
```
]

=== #link(
  "https://leetcode.cn/problems/longest-valid-parentheses/description/",
)[题目 6: 最长有效括号]

给你一个只包含 `'('` 和 `')' `的字符串，找出最长有效（格式正确且连续）括号 子串
的长度。

#example("Example")[
- 输入：`s = "(()"`
- 输出：`2`
- 解释：最长有效括号子串是 `"()"`
]


==== 解答

#code(caption: [解答])[
```java
public static int longestValidParentheses(String str) {
    char[] s = str.toCharArray();
    // dp[0...n-1]
    // dp[i]: 子串必须以i结尾, 往左最多推多远能有效?
    int[] dp = new int[s.length];
    if (s.length > 0) {
        dp[0] = 0;
    }
    int ans = 0;

    for (int cur = 1; cur < dp.length; cur++) {
        if (s[cur] == ')') {
            int tmp = cur - dp[cur - 1] - 1;
            if (tmp >= 0 && s[tmp] == '(') {
                // 只要往前推一次就可以了, 如果tmp正好推到底了也不用管
                dp[cur] = dp[cur - 1] + 2 + (tmp > 0 ? dp[tmp - 1] : 0);
            } else {
                dp[cur] = 0;
            }
        } else {
            dp[cur] = 0;
        }
        ans = Math.max(dp[cur], ans);
    }
    return ans;
}
```
]

=== #link(
  "https://leetcode.cn/problems/unique-substrings-in-wraparound-string/description/",
)[题目 7: 环绕字符串中唯一的子字符串]

定义字符串 `base` 为一个 `"abcdefghijklmnopqrstuvwxyz" `无限环绕的字符串，所以 `base` 看起来是这样的： `"...zabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcd...."`.

给你一个字符串 `s` ，请你统计并返回 `s` 中有多少 不同非空子串 也在 `base` 中出现。

#example(
  "Example",
)[
- 输入：`s = "zab"`
- 输出：`6`
- 解释：字符串 `s` 有六个子字符串 `("z", "a", "b", "za", "ab", and "zab")` 在 `base` 中出现。
]


==== 解答



=== 总结

知道怎么算的算法 vs 知道怎么试的算法

有些递归在展开计算时，总是重复调用同一个子问题的解，这种重复调用的递归变成动态规划很有收益
如果每次展开都是不同的解，或者重复调用的现象很少，那么没有改动态规划的必要

任何动态规划问题都一定对应着一个有重复调用行为的递归
所以任何动态规划的题目都一定可以从递归入手，逐渐实现动态规划的方法

*尝试策略* 就是
*转移方程*，完全一回事！推荐从*尝试*入手，因为代码好写，并且一旦发现尝试错误，重新想别的递归代价轻！

动态规划的大致过程：
想出设计优良的递归尝试(方法、经验、固定套路很多)，有关尝试展开顺序的说明 ->
记忆化搜索(从顶到底的动态规划)
，如果每个状态的计算枚举代价很低，往往到这里就可以了 ->
严格位置依赖的动态规划(从底到顶的动态规划) ，更多是为了下面说的
进一步优化枚举做的准备 ->
进一步优化空间（空间压缩），一维、二维、多维动态规划都存在这种优化 ->
进一步优化枚举也就是优化时间（本节没有涉及，但是后续巨多内容和这有关）

解决一个问题，可能有很多尝试方法;
众多的尝试方法中，可能若干的尝试方法有重复调用的情况，可以转化成动态规划;
若干个可以转化成动态规划的方法中，又可能有优劣之分.
判定哪个是最优的动态规划方法，依据来自题目具体参数的数据量,
最优的动态规划方法实现后，后续又有一整套的优化技巧

== 从递归入手二维动态规划

- 尝试函数有 1 个可变参数可以完全决定返回值，进而可以改出 1 维动态规划表的实现
- 尝试函数有 2 个可变参数可以完全决定返回值，那么就可以改出 2 维动态规划的实现

一维、二维、三维甚至多维动态规划问题，大体过程都是：

1. 写出尝试递归
2. 记忆化搜索(从顶到底的动态规划)
3. 严格位置依赖的动态规划(从底到顶的动态规划)
4. 空间、时间的更多优化

动态规划表的大小：每个可变参数的可能性数量相乘
动态规划方法的时间复杂度：动态规划表的大小 \* 每个格子的枚举代价

二维动态规划依然需要去整理 动态规划表的格子之间的依赖关系 找寻依赖关系，往往
通过画图来建立空间感，使其更显而易见 然后依然是 从简单格子填写到复杂格子
的过程，即严格位置依赖的动态规划(从底到顶)

二维动态规划的压缩空间技巧原理不难，会了之后千篇一律
但是不同题目依赖关系不一样，需要很细心的画图来整理具体题目的依赖关系
最后进行空间压缩的实现

一定要 *写出可变参数类型简单（不比 int 类型更复杂）*，并且
*可以完全决定返回值的递归，* 保证做到
这些可变参数可以完全代表之前决策过程对后续过程的影响！再去改动态规划！

不管几维动态规划, 经常从递归的定义出发，避免后续进行很多边界讨论,
这需要一定的经验来预知

=== #link(
  "https://leetcode.cn/problems/minimum-path-sum/description/",
)[ 题目 1 : 最小路径和 ]

给定一个包含非负整数的 m x n 网格 `grid` ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

说明：每次只能向下或者向右移动一步。

==== 解答


#code(caption: [ 题目 1 : 最小路径和 ])[
```java
public int minPathSum(int[][] grid) {
  // 暴力递归
  public static int minPathSum1(int[][] grid) {
    return f1(grid, grid.length - 1, grid[0].length - 1);
  }

  // 从(0,0)到(i,j)最小路径和
  // 一定每次只能向右或者向下
  public static int f1(int[][] grid, int i, int j) {
    if (i == 0 && j == 0) {
      return grid[0][0];
    }
    int up = Integer.MAX_VALUE;
    int left = Integer.MAX_VALUE;
    if (i - 1 >= 0) {
      up = f1(grid, i - 1, j);
    }
    if (j - 1 >= 0) {
      left = f1(grid, i, j - 1);
    }
    return grid[i][j] + Math.min(up, left);
  }

  // 记忆化搜索
  public static int minPathSum2(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    int[][] dp = new int[n][m];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        dp[i][j] = -1;
      }
    }
    return f2(grid, grid.length - 1, grid[0].length - 1, dp);
  }

  public static int f2(int[][] grid, int i, int j, int[][] dp) {
    if (dp[i][j] != -1) {
      return dp[i][j];
    }
    int ans;
    if (i == 0 && j == 0) {
      ans = grid[0][0];
    } else {
      int up = Integer.MAX_VALUE;
      int left = Integer.MAX_VALUE;
      if (i - 1 >= 0) {
        up = f2(grid, i - 1, j, dp);
      }
      if (j - 1 >= 0) {
        left = f2(grid, i, j - 1, dp);
      }
      ans = grid[i][j] + Math.min(up, left);
    }
    dp[i][j] = ans;
    return ans;
  }

  // 严格位置依赖的动态规划
  public static int minPathSum3(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    int[][] dp = new int[n][m];
    dp[0][0] = grid[0][0];
    for (int i = 1; i < n; i++) {
      dp[i][0] = dp[i - 1][0] + grid[i][0];
    }
    for (int j = 1; j < m; j++) {
      dp[0][j] = dp[0][j - 1] + grid[0][j];
    }
    for (int i = 1; i < n; i++) {
      for (int j = 1; j < m; j++) {
        dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j];
      }
    }
    return dp[n - 1][m - 1];
  }

  // 严格位置依赖的动态规划 + 空间压缩技巧
  public static int minPathSum4(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    // 先让dp表，变成想象中的表的第0行的数据
    int[] dp = new int[m];
    dp[0] = grid[0][0];
    for (int j = 1; j < m; j++) {
      dp[j] = dp[j - 1] + grid[0][j];
    }
    for (int i = 1; i < n; i++) {
      // i = 1，dp表变成想象中二维表的第1行的数据
      // i = 2，dp表变成想象中二维表的第2行的数据
      // i = 3，dp表变成想象中二维表的第3行的数据
      // ...
      // i = n-1，dp表变成想象中二维表的第n-1行的数据
      dp[0] += grid[i][0];
      for (int j = 1; j < m; j++) {
        dp[j] = Math.min(dp[j - 1], dp[j]) + grid[i][j];
      }
    }
    return dp[m - 1];
  }
}
```
]


#tip("Tip")[
改成动态规划的时候, 并不能把`dp`都初始化为-1
]


#tip(
  "Tip",
)[
  能改成动态规划的递归，统一特征：
  - *决定返回值的可变参数类型往往都比较简单，一般不会比 int 类型更复杂。为什么？*
    - 从这个角度，可以解释
      *带路径的递归（可变参数类型复杂），不适合或者说没有必要改成动态规划* 题目 2
      就是说明这一点的
] 

=== #link(
  "https://leetcode.cn/problems/word-search/description/",
)[题目 2: 单词搜索]

给定一个 m x n 二维字符网格 `board` 和一个字符串单词 `word` 。如果 `word` 存在于网格中，返回 `true` ；否则，返回 `false` 。

单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。

#tip("Tip")[
  往往题目的数据量都比较小
]

#code(
  caption: [题目 2: 单词搜索],
)[
```java
public static boolean exist(char[][] board, String word) {
    boolean succeed = false;

    char[] w = word.toCharArray();

    int m = board.length;
    int n = board[0].length;

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            succeed = f(board, w, i, j, 0);
            if (succeed)
                break;
        }
    }

    return succeed;
}

// 从i,j出发,到了w[k], 接下来能不能匹配到w[k+1...]
public static boolean f(char[][] board, char[] w, int i, int j, int k) {
    // 匹配到最后一个了
    if (k == w.length) {
        return true;
    }

    // 越界
    if (i < 0 || i == board.length || j < 0 || j == board[0].length || board[i][j] != w[k]) {
        return false;
    }

    // 不越界 board[i][j] = w[k]
    char tmp = board[i][j];
    board[i][j] = 0;
    boolean ans = f(board, w, i + 1, j, k + 1)
            || f(board, w, i - 1, j, k + 1)
            || f(board, w, i, j + 1, k + 1)
            || f(board, w, i, j - 1, k + 1);
    board[i][j] = tmp;
    return ans;
}
```
]

=== #link(
  "https://leetcode.cn/problems/longest-common-subsequence/description/",
)[题目 3: 最长公共子序列]

给定两个字符串 `text1` 和 `text2`，返回这两个字符串的最长 公共子序列
的长度。如果不存在 公共子序列 ，返回 `0` 。

一个字符串的 子序列
是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。

例如，`"ace" `是 `"abcde" `的子序列，但 `"aec" `不是 `"abcde" `的子序列。
两个字符串的 公共子序列 是这两个字符串所共同拥有的子序列。

#tip("Tip")[
- 输入：`text1 = "abcde"`, `text2 = "ace"`
- 输出：`3`
- 解释：最长公共子序列是 `"ace" `，它的长度为 `3` 。
]


==== 解答

可能性, 动态规划的关键 一种常见的就是长度定好之后, 按照结尾来讨论可能性.(为啥,
一种常见的模型)

#code(
  caption: [题目 3: 最长公共子序列],
)[
```java
public class Code03_LongestCommonSubsequence {
    public static int longestCommonSubsequence(String text1, String text2) {
        char[] t1 = text1.toCharArray();
        char[] t2 = text2.toCharArray();
        return f(t1, t2, t1.length - 1, t2.length - 1);
    }

    // t1[0..p1] 与 t2[0...p2] 公共子序列的长度
    public static int f(char[] t1, char[] t2, int i1, int i2) {
        if (i1 < 0 || i2 < 0) {
            return 0;
        }
        // 公共子串不包含结尾
        int p1 = f(t1, t2, i1 - 1, i2 - 1);
        // 要一个结尾,不要另一个
        int p2 = f(t1, t2, i1, i2 - 1);
        int p3 = f(t1, t2, i1 - 1, i2);
        // 两个结尾都要
        int p4 = t1[i1] == t2[i2] ? (p1 + 1) : 0;
        return Math.max(Math.max(p1, p2), Math.max(p3, p4));
    }
    // 为了避免很多边界讨论
    // 很多时候往往不用下标来定义尝试，而是用长度来定义尝试
    // 因为长度最短是0，而下标越界的话讨论起来就比较麻烦
    public static int longestCommonSubsequence2(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        return f2(s1, s2, n, m);
    }

    // s1[前缀长度为len1]对应s2[前缀长度为len2]
    // 最长公共子序列长度
    public static int f2(char[] s1, char[] s2, int len1, int len2) {
        if (len1 == 0 || len2 == 0) {
            return 0;
        }
        int ans;
        if (s1[len1 - 1] == s2[len2 - 1]) {
            ans = f2(s1, s2, len1 - 1, len2 - 1) + 1;
        } else {
            ans = Math.max(f2(s1, s2, len1 - 1, len2), f2(s1, s2, len1, len2 - 1));
        }
        return ans;
    }

    // 记忆化搜索
    public static int longestCommonSubsequence3(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                dp[i][j] = -1;
            }
        }
        return f3(s1, s2, n, m, dp);
    }

    public static int f3(char[] s1, char[] s2, int len1, int len2, int[][] dp) {
        if (len1 == 0 || len2 == 0) {
            return 0;
        }
        if (dp[len1][len2] != -1) {
            return dp[len1][len2];
        }
        int ans;
        if (s1[len1 - 1] == s2[len2 - 1]) {
            ans = f3(s1, s2, len1 - 1, len2 - 1, dp) + 1;
        } else {
            ans = Math.max(f3(s1, s2, len1 - 1, len2, dp), f3(s1, s2, len1, len2 - 1, dp));
        }
        dp[len1][len2] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    public static int longestCommonSubsequence4(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int len1 = 1; len1 <= n; len1++) {
            for (int len2 = 1; len2 <= m; len2++) {
                if (s1[len1 - 1] == s2[len2 - 1]) {
                    dp[len1][len2] = 1 + dp[len1 - 1][len2 - 1];
                } else {
                    dp[len1][len2] = Math.max(dp[len1 - 1][len2], dp[len1][len2 - 1]);
                }
            }
        }
        return dp[n][m];
    }

    // 严格位置依赖的动态规划 + 空间压缩
    public static int longestCommonSubsequence5(String str1, String str2) {
        char[] s1, s2;
        if (str1.length() >= str2.length()) {
            s1 = str1.toCharArray();
            s2 = str2.toCharArray();
        } else {
            s1 = str2.toCharArray();
            s2 = str1.toCharArray();
        }
        int n = s1.length;
        int m = s2.length;
        int[] dp = new int[m + 1];
        for (int len1 = 1; len1 <= n; len1++) {
            int leftUp = 0, backup;
            for (int len2 = 1; len2 <= m; len2++) {
                backup = dp[len2];
                if (s1[len1 - 1] == s2[len2 - 1]) {
                    dp[len2] = 1 + leftUp;
                } else {
                    dp[len2] = Math.max(dp[len2], dp[len2 - 1]);
                }
                leftUp = backup;
            }
        }
        return dp[m];
    }
}
```
]

=== #link(
  "https://leetcode.cn/problems/longest-palindromic-subsequence/description/",
)[最长回文子序列]

#definition(
  "Definition",
)[
  子序列定义为：不改变剩余字符顺序的情况下，删除某些字符或者不删除任何字符形成的一个序列。
]

给你一个字符串 `s` ，找出其中最长的回文子序列，并返回该序列的长度。

#example("Example")[
- 输入：`s = "bbbab"`
- 输出：`4`
- 解释：一个可能的最长回文子序列为 `"bbbb" `。
]


#example("Example")[
- 输入：`s = "cbbd"`
- 输出：`2`
- 解释：一个可能的最长回文子序列为 `"bb"` 。
]

#tip("Tip")[
- 1 <= `s.length` <= 1000
- s 仅由小写英文字母组成
]

==== 解答

#code(caption: [题目4: 最长回文子序列])[
```java
public class Code04_LongestPalindromicSubsequence {
    public static int longestPalindromeSubseq1(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        int ans = f1(s, 0, n - 1, dp);
        return ans;
    }
    // l...r 最长回文子序列
    public static int f1(char[] s, int l, int r, int[][] dp) {
        if (l == r) {
            return 1;
        }
        if (l + 1 == r) {
            return s[l] == s[r] ? 2 : 1;
        }
        if (dp[l][r] != 0) {
            return dp[l][r];
        }
        int ans;
        if (s[l] == s[r]) {
            ans = 2 + f(s, l + 1, r - 1, dp);
        } else {
            ans = Math.max(f(s, l + 1, r, dp), f(s, l, r - 1, dp));
        }
        dp[l][r] = ans;
        return ans;
    }
    // 严格表结构
    public static int longestPalindromeSubseq3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];


        // l为行，r为列 -> r >= l
        for (int l = n - 1; l >= 0; l--) {
            // l=r 对角线是1
            dp[l][l] = 1;

            // l+1 = r
            if (l + 1 < n) {
                dp[l][l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }

            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = 2 + dp[l - 1][r - 1];
                } else {
                    dp[l][r] = Math.max(dp[l - 1][r], dp[l][r - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```
]


=== #link(
  "https://www.nowcoder.com/practice/aaefe5896cce4204b276e213e725f3ea",
)[题目5: 二叉树的结构数]

#definition("Definition")[
  树的高度: 定义为所有叶子到根路径上节点个数的最大值.
]

小强现在有`n`个节点,他想请你帮他计算出有多少种不同的二叉树满足节点个数为`n`且树的高度不超过`m`的方案.因为答案很大,所以答案需要模上`1e9+7`后输出.

- 输入描述： 第一行输入两个正整数`n`和`m`. `1≤m≤n≤50`
- 输出描述： 输出一个答案表示方案数.

#example("Example")[
- 输入： `3 3`
- 输出： `5`
]

==== 解答

#code(
  caption: [题目5: 二叉树的结构数],
)[
```java
public class Code05_NodenHeightNotLargerThanm {
    public static int MAXN = 51;
    public static int MAXM = 51;
    public static int MOD = 1000000007;
    public static long[][] dp = new long[MAXN][MAXM];
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int n = (int) in.nval;
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0; i < n+1; i++) {
                for (int j = 0; j < m+1; j++) {
                    dp[i][j] = -1;
                }
            }

            out.println(compute(n, m));
        }
        out.flush();
        out.close();
        br.close();
    }
    // n个节点，高度不超过m
    // 记忆化搜索
    public static int compute(int n, int m) {
        if (n == 0) {
            return 1;
        }
        // n>0
        if (m == 0) {
            return 0;
        }
        if (dp[n][m] != -1) {
            return (int) dp[n][m];
        }
        long ans = 0;
        // left 几个 right 几个 头占掉一个
        for (int i = 0; i < n; i++) {
            int left = compute(i, m - 1) % MOD;
            int right = compute(n - i - 1, m - 1) % MOD;
            ans = (ans + ((long) left * right) % MOD) % MOD;
        }
        dp[n][m] = ans;
        return (int) ans;
    }
}
```
]

=== #link(
  "https://leetcode.cn/problems/longest-increasing-path-in-a-matrix/",
)[矩阵中的最长递增路径]

给定一个 `m x n` 整数矩阵 `matrix` ，找出其中 最长递增路径 的长度。

对于每个单元格，你可以往上，下，左，右四个方向移动。 你 不能 在 对角线
方向上移动或移动到 边界外（即不允许环绕）。

#example("Example")[
- 输入：

  ```
        matrix =
        [[9,9,4],
        [6,6,8],
        [2,1,1]]
        ```

- 输出：`4` 
- 解释：最长递增路径为 `[1, 2, 6, 9]`。
]

#tip("Tip")[
  - m == matrix.length
  - n == matrix[i].length
  - 1 <= m, n <= 200
  - 0 <= matrix[i][j] <= 2^31 - 1
]

==== 解答

#code(caption: [题目6: 矩阵中最长递增路径])[
```java
public class Code06_LongestIncreasingPath {
    public static int longestIncreasingPath(int[][] matrix) {
        int n = matrix.length;
        int m = matrix[0].length;
        int max = Integer.MIN_VALUE;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                max = Math.max(max, f(matrix, i, j));
            }
        }
        return max;
    }
    // 从 i,j 出发 最长的递增路径
    public static int f(int[][] matrix, int i, int j) {
        int next = 0;

    if (i > 0 && grid[i][j] < grid[i - 1][j]) {
      next = Math.max(next, f1(grid, i - 1, j));
    }
    if (i + 1 < grid.length && grid[i][j] < grid[i + 1][j]) {
      next = Math.max(next, f1(grid, i + 1, j));
    }
    if (j > 0 && grid[i][j] < grid[i][j - 1]) {
      next = Math.max(next, f1(grid, i, j - 1));
    }
    if (j + 1 < grid[0].length && grid[i][j] < grid[i][j + 1]) {
      next = Math.max(next, f1(grid, i, j + 1));
    }
    return next + 1;
    }

      public static int longestIncreasingPath2(int[][] grid) {
    int n = grid.length;
    int m = grid[0].length;
    int[][] dp = new int[n][m];
    int ans = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        ans = Math.max(ans, f2(grid, i, j, dp));
      }
    }
    return ans;
  }

  public static int f2(int[][] grid, int i, int j, int[][] dp) {
    if (dp[i][j] != 0) {
      return dp[i][j];
    }
    int next = 0;
    if (i > 0 && grid[i][j] < grid[i - 1][j]) {
      next = Math.max(next, f2(grid, i - 1, j, dp));
    }
    if (i + 1 < grid.length && grid[i][j] < grid[i + 1][j]) {
      next = Math.max(next, f2(grid, i + 1, j, dp));
    }
    if (j > 0 && grid[i][j] < grid[i][j - 1]) {
      next = Math.max(next, f2(grid, i, j - 1, dp));
    }
    if (j + 1 < grid[0].length && grid[i][j] < grid[i][j + 1]) {
      next = Math.max(next, f2(grid, i, j + 1, dp));
    }
    dp[i][j] = next + 1;
    return next + 1;
  }
}
```
]
=== #link(
  "https://leetcode.cn/problems/distinct-subsequences/description/",
)[题目7: 不同的子序列]

给你两个字符串 `s` 和 `t` ，统计并返回在 `s` 的 子序列 中 `t` 出现的个数，结果需要对 `10^9 + 7` 取模。

#example("Example")[
- 输入：`s = "rabbbit", t = "rabbit"`
- 输出：`3`
- 解释：
  - 如下所示, 有 3 种可以从 `s` 中得到 `"rabbit"` 的方案。
    - *rabb* b *it*
    - *rab* b *bit*
    - *rabb* b *it*
]

==== 解答
#code(
  caption: [题目7: 不同的子序列],
)[
```java
public class Code01_DistinctSubsequences {
    // 直接动态规划
    public static int numDistinct(String s, String t) {
        int MOD = 1000000007;
        char[] s1 = s.toCharArray();
        char[] s2 = t.toCharArray();
        int len1 = s1.length;
        int len2 = s2.length;
        // 表示前缀长度(使用下标会有很多边界情况的讨论)
        int[][] dp = new int[len1 + 1][len2 + 1];
        // 尝试: s1[...p1] 已经匹配了x个 s2[...p2]

        // s1[0] -> s2[0] = 1 s2[1....] 0
        // s2[0] -> s1[0] = 1 s1[1....] 1 (子序列生成的空集)
        for (int i = 0; i < dp.length; i++) {
            dp[i][0] = 1;
        }

        // 按照末尾讨论可能性,s1[...p1] s2[...p2]
        // 不要s1的最后一个, 就要s1[...p1-1] s2[...p2]
        // 对应 dp[p1-1][p2](上)
        // 要s1的最后一个，就要要求s1[p1] == s2[p2], 接下来s1[...p1-1] s2[...p2-1]
        // 对应dp[p1-1][p2-1](左上)
        // 以上两种可能性相加

        // -------->填表
        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                int p1 = dp[i-1][j]%MOD;
                // 因为代表长度所以在下标的时候要-1，不然会越界
                int p2 = s1[i-1]==s2[j-1]?( dp[i-1][j-1]%MOD ):0;
                dp[i][j] = (p1+p2)%MOD;
            }
        }

        return dp[len1][len2];
    }

    // 空间压缩
    public static int numDistinct2(String str, String target){
        int MOD = 1000000007;
        char[] s1 = s.toCharArray();
        char[] s2 = t.toCharArray();
        int len1 = s1.length;
        int len2 = s2.length;
        // 表示前缀长度(使用下标会有很多边界情况的讨论)
        int[] dp = new int[len2 + 1];
        dp[0] = 1;

        // -------->填表
        for (int i = 1; i <= len1; i++) {
            int leftUp = 1, backup;
            for (int j = 1; j <= len2; j++) {
                backup = dp[j];
                // 上
                int p1 = dp[j]%MOD;
                // 左上
                int p2 = s1[i-1]==s2[j-1]?( leftUp%MOD ):0;
                // 当前
                dp[j] = (p1+p2)%MOD;
                leftUp = backup;
            }
        }

        return dp[len2];
    }
}
```
]

=== #link(
  "https://leetcode.cn/problems/edit-distance/description/",
)[题目8: 编辑距离]
给你两个单词 `word1` 和 `word2`， 请返回将 `word1` 转换成 `word2` 所使用的最少操作数。
你可以对一个单词进行如下三种操作：
- 插入一个字符(代价为`a`)
- 删除一个字符(代价为`b`)
- 替换一个字符(代价为`c`)

#example("Example")[
- 输入：`word1 = "horse", word2 = "ros", a=b=c=1`
- 输出：`3`
- 解释：
  - horse -> rorse (将 'h' 替换为 'r')
  - rorse -> rose (删除 'r')
  - rose -> ros (删除 'e')
]

==== 解答

1. `s1[i-1]`参与
    - `s1[i-1]`->`s2[j-1]`
        1. `s1[i-1]==s2[j-1]` `s1[0...i-2]`搞定`s2[0...j-2]`即`dp[i-1][j-1]`
        2. `s1[i-1]!=s2[j-1]` `s1[i-1]`直接替换成`s2[j-1]`即`dp[i-1][j-1]+替换代价`
    - `s1[i-1]!->s2[j-1]`
        - `s1[...i-1]`搞定`s2[...j-2]`，最后通过插入搞定`s2[j-1]` 即`dp[i][j-1]+插入`
2. `s1[i-1]`不参与, 删掉`s1[i-1]` 即`dp[i-1][j]+删除代价`

#code(caption: [题目8: 编辑距离])[
```java
public class Code02_EditDistance {
	public int minDistance(String word1, String word2) {
		return editDistance2(word1, word2, 1, 1, 1);
	}

	// 原初尝试版
	// a : str1中插入1个字符的代价
	// b : str1中删除1个字符的代价
	// c : str1中改变1个字符的代价
	// 返回从str1转化成str2的最低代价
	public static int editDistance1(String str1, String str2, int a, int b, int c) {
		char[] s1 = str1.toCharArray();
		char[] s2 = str2.toCharArray();
		int n = s1.length;
		int m = s2.length;
		// dp[i][j] :
		// s1[前缀长度为i]想变成s2[前缀长度为j]，至少付出多少代价
		int[][] dp = new int[n + 1][m + 1];
		for (int i = 1; i <= n; i++) {
			dp[i][0] = i * b;
		}
		for (int j = 1; j <= m; j++) {
			dp[0][j] = j * a;
		}
		for (int i = 1; i <= n; i++) {
			for (int j = 1; j <= m; j++) {
				int p1 = Integer.MAX_VALUE;
				if (s1[i - 1] == s2[j - 1]) {
					p1 = dp[i - 1][j - 1];
				}
				int p2 = Integer.MAX_VALUE;
				if (s1[i - 1] != s2[j - 1]) {
					p2 = dp[i - 1][j - 1] + c;
				}
				int p3 = dp[i][j - 1] + a;
				int p4 = dp[i - 1][j] + b;
				dp[i][j] = Math.min(Math.min(p1, p2), Math.min(p3, p4));
			}
		}
		return dp[n][m];
	}

	// 枚举小优化版
	public static int editDistance2(String str1, String str2, int a, int b, int c) {
		char[] s1 = str1.toCharArray();
		char[] s2 = str2.toCharArray();
		int n = s1.length;
		int m = s2.length;
		// dp[i][j] :
		// s1[前缀长度为i]想变成s2[前缀长度为j]，至少付出多少代价
		int[][] dp = new int[n + 1][m + 1];
		for (int i = 1; i <= n; i++) {
			dp[i][0] = i * b;
		}
		for (int j = 1; j <= m; j++) {
			dp[0][j] = j * a;
		}
		for (int i = 1; i <= n; i++) {
			for (int j = 1; j <= m; j++) {
				if (s1[i - 1] == s2[j - 1]) {
					dp[i][j] = dp[i - 1][j - 1];
				} else {
					dp[i][j] = Math.min(Math.min(dp[i - 1][j] + b, dp[i][j - 1] + a), dp[i - 1][j - 1] + c);
				}
			}
		}
		return dp[n][m];
	}

	// 空间压缩
	public static int editDistance3(String str1, String str2, int a, int b, int c) {
		char[] s1 = str1.toCharArray();
		char[] s2 = str2.toCharArray();
		int n = s1.length;
		int m = s2.length;
		int[] dp = new int[m + 1];
		for (int j = 1; j <= m; j++) {
			dp[j] = j * a;
		}
		for (int i = 1, leftUp, backUp; i <= n; i++) {
			leftUp = (i - 1) * b;
			dp[0] = i * b;
			for (int j = 1; j <= m; j++) {
				backUp = dp[j];
				if (s1[i - 1] == s2[j - 1]) {
					dp[j] = leftUp;
				} else {
					dp[j] = Math.min(Math.min(dp[j] + b, dp[j - 1] + a), leftUp + c);
				}
				leftUp = backUp;
			}
		}
		return dp[m];
	}

}
```
]

== 从递归入手三位动态规划

