import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

/**
 * Code01_KillMonsterEverySkillUseOnce
 */
public class Code01_KillMonsterEverySkillUseOnce {
    public static int MAXN = 11;
    public static int[] kill = new int[MAXN];
    public static int[] blood = new int[MAXN];

    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int T = (int) in.nval;
            for (int i = 0; i < T; i++) {
                in.nextToken();
                int n = (int) in.nval;
                in.nextToken();
                int m = (int) in.nval;
                for (int j = 0; j < n; j++) {
                    in.nextToken();
                    kill[j] = (int)in.nval;
                    in.nextToken();
                    blood[j] = (int)in.nval;
                }
                int ans = compute(n, m, 0);
                out.println(ans==Integer.MAX_VALUE ? -1:ans);
            }
        }
        out.flush();
        out.close();
        br.close();
    }

    // n->技能数量，hp->怪物血量，cur->当前来到第几个技能
    public static int compute(int n, int hp, int cur) {
        if (hp <= 0) {
            return cur;
        }
        if (cur == n) {
            return Integer.MAX_VALUE;
        }

        int ans = Integer.MAX_VALUE;

        for (int j = cur; j < n; j++) {
            swap(cur, j);
            ans = Math.min(ans, compute(n, hp-(hp>blood[cur]?kill[cur]:kill[cur]*2), cur+1));
            swap(cur, j);
        }

        return ans;
    }

    public static void swap(int i, int j){
        int tmp = blood[i];
        blood[i] = blood[j];
        blood[j] = tmp;

        int tmp2 = kill[i];
        kill[i] = kill[j];
        kill[j] = tmp2;
    }
}
