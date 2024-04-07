package class067;

public class Code02_WordSearch {
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
        boolean ans = f2(board, w, i + 1, j, k + 1)
                || f2(board, w, i - 1, j, k + 1)
                || f2(board, w, i, j + 1, k + 1)
                || f2(board, w, i, j - 1, k + 1);
        board[i][j] = tmp;
        return ans;
    }

    public static boolean exist2(char[][] board, String word) {
        char[] w = word.toCharArray();
        int m = board.length;
        int n = board[0].length;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (board[i][j] == w[0] && f2(board, w, i, j, 0)) {
                    return true;
                }
            }
        }

        return false;
    }

    public static boolean f2(char[][] board, char[] w, int i, int j, int k) {
        if (k == w.length - 1) {
            return true;
        }

        if (i < 0 || i == board.length || j < 0 || j == board[0].length || board[i][j] != w[k]) {
            return false;
        }

        char tmp = board[i][j];
        board[i][j] = 0;

        boolean ans = false;
        if (i + 1 < board.length && board[i + 1][j] == w[k + 1]) {
            ans = ans || f2(board, w, i + 1, j, k + 1);
        }
        if (i - 1 >= 0 && board[i - 1][j] == w[k + 1]) {
            ans = ans || f2(board, w, i - 1, j, k + 1);
        }
        if (j + 1 < board[0].length && board[i][j + 1] == w[k + 1]) {
            ans = ans || f2(board, w, i, j + 1, k + 1);
        }
        if (j - 1 >= 0 && board[i][j - 1] == w[k + 1]) {
            ans = ans || f2(board, w, i, j - 1, k + 1);
        }

        board[i][j] = tmp;
        return ans;
    }
}
