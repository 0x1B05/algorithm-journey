package class038;

import java.util.HashSet;

public class Code01_Subsequences {
    public static String[] generatePermutation(String str) {
        char[] s = str.toCharArray();
        HashSet<String> set = new HashSet<>();
        f1(s, 0, new StringBuilder(), set);
        int size = set.size();
        String[] res = new String[size];
        int i = 0;
        for (String ans : set) {
            res[i++] = ans;
        }
        return res;
    }

    public static void f1(char[] s, int cur, StringBuilder path, HashSet<String> set) {
        if (cur == s.length) {
            set.add(path.toString());
        } else {
            path.append(s[cur]);
            f1(s, cur + 1, path, set);
            path.deleteCharAt(path.length() - 1);
            f1(s, cur + 1, path, set);
        }
    }

    public static void main(String[] args) {
        String str = "ab";
        generatePermutation(str);
    }
}
