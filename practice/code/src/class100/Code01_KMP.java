package class100;

/**
 * KMP
 */
public class KMP {
    public static int strStr(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        return kmp(s1, s2);
    }

    public static int kmp(char[] s1, char[] s2){
        int len1 = s1.length;
        int len2 = s2.length;
        int[] next = getNext(s2);
        int p1 = 0, p2 = 0;
        while(p1 < len1 && p2 < len2){
            if(s1[p1]==s2[p2]){
                p1++;
                p2++;
            }else if(p2==0){
                p1++;
            }else{
                p2 = next[p2];
            }
        }
        return p2==len2 ? p1-p2 : -1;
    }
    public static int[] getNext(char[] s){
        int len = s.length;
        if(len==1){
            return new int[] { -1 };
        }
        int[] next = new int[len];
        next[0] = -1;
        next[1] = 0;

        // cur => 当前要求next值的位置
        // cn => 当前字符要对比的字符的下标
        int cur = 2;
        int cn = 0;
        while (cur < len){
            if(s[cur-1]==s[cn]){
                next[cur++] = ++cn;
            }else if(cn > 0){
                cn = next[cn];
            }else{
                next[cur++] = 0;
            }
        }
        return next;
    }
}
