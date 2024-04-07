package class089;

import java.util.ArrayList;
import java.util.Arrays;

// 最大数
// 给定一组非负整数nums
// 重新排列每个数的顺序（每个数不可拆分）使之组成一个最大的整数
// 测试链接 : https://leetcode.cn/problems/largest-number/
public class Code01_LargestNumber {
    // 暴力枚举每一个字符串, 找到字典序最小的
    public static String way1(String[] str) {
        ArrayList<String> ans = new ArrayList<>();
        f(str, ans, 0);
        ans.sort((a, b) -> a.compareTo(b));
        return ans.get(0);
    }

    public static void f(String[] str, ArrayList<String> ans, int cur) {
        if (cur == str.length) {
            StringBuffer path = new StringBuffer();
            for (String s : str) {
                path.append(s);
            }
            ans.add(path.toString());
        } else {
            for (int i = cur; i < str.length; i++) {
                swap(str, i, cur);
                f(str, ans, cur + 1);
                swap(str, i, cur);
            }
        }
    }

    public static void swap(String[] str, int i, int j) {
        String tmp = str[i];
        str[i] = str[j];
        str[j] = tmp;
    }

    // 目标
    public static String way2(String[] str) {
        Arrays.sort(str, (a, b) -> (a + b).compareTo(b + a));
        StringBuilder path = new StringBuilder();
        for (String string : str) {
            path.append(string);
        }
        return path.toString();
    }

    // 生成随机输入
    public static String[] inputGen(int inputLen, int strLen, int strVar) {
        int len1 = (int) (Math.random() * inputLen + 1);
        String[] input = new String[len1];
        for (int i = 0; i < len1; i++) {
            int len2 = (int) (Math.random() * strLen + 1);
            // 生成一个随机长度为len2的字符串填入input[i]
            char[] randStr = new char[len2];
            for (int j = 0; j < randStr.length; j++) {
                randStr[j] = (char) ('a' + (Math.random() * strVar));
            }
            input[i] = String.valueOf(randStr);
        }

        return input;
    }

    public static void main(String[] args) {
        int inputLen = 8; // 数组中最多几个字符串
        int strLen = 5; // 字符串长度最大多长
        int strVar = 4; // 字符的种类有几种
        int testTime = 2000;
        boolean succeed = true;
        for (int i = 0; i < testTime; i++) {
            String[] input = inputGen(inputLen, strLen, strVar);
            String output1 = way1(input);
            String output2 = way2(input);
            if (!output1.equals(output2)) {
                succeed = false;
                break;
            }
            if (i % 100 == 0) {
                System.out.println(i + "round pass!!");
            }
        }
        if (!succeed) {
            System.out.println("Oops!!");
        } else {
            System.out.println("wuhu!!!");
        }

    }

    // largest number
    public static String largestNumber(int[] nums) {
        int len = nums.length;
        String[] strs = new String[len];
        int i = 0;
        for (int num : nums) {
            strs[i++] = String.valueOf(num);
        }
        Arrays.sort(strs, (a, b) -> (b + a).compareTo(a + b));
        if (strs[0].equals("0")) {
            return "0";
        }

        StringBuffer path = new StringBuffer();
        for (String string : strs) {
            path.append(string);
        }

        return path.toString();
    }
}
