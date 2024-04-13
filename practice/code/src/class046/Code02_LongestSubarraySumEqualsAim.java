package class046;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.HashMap;

/**
 * Code02_LongestSubarraySumEqualsAim
 */
public class Code02_LongestSubarraySumEqualsAim {
    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int n;
    public static int k;

    // 先算出来前缀和，前缀和数组-aim -> p1 p2 p3(取最小的)
    // 遍历，每个都减一下aim 然后找最早出现的那个(hashmap记录一下)
    // key -> 前缀和，value -> 最早出现的index
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            k = (int) in.nval;
            arr = new int[n];
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static HashMap<Integer, Integer> map = new HashMap<>();
    public static int compute() {
        map.clear();
        map.put(0, -1);

        int ans = 0;
        for (int i = 0, sum = 0; i < n; i++) {
            sum += arr[i];
            if (!map.containsKey(sum)) {
                map.put(sum, i);
            }
            // i-map.get(sum-aim)
            if (map.containsKey(sum - k)) {
                ans = Math.max(ans, i - map.get(sum - k));
            }
        }
        return ans;
    }
}
