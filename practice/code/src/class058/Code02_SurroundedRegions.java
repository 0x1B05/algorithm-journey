package class058;

class Code02_SurroundedRegions {
    public void solve(char[][] board) {
        int n = board.length;
        int m = board[0].length;

        for (int i = 0; i < n; i++) {
            if(board[i][0]=='O'){
                infect(board, i, 0, 'O', 'F');
            }
            if(board[i][m-1]=='O'){
                infect(board, i, m-1, 'O', 'F');
            }
        }

        for (int j = 1; j < m-1; j++) {
            if(board[0][j]=='O'){
                infect(board, 0, j, 'O', 'F');
            }
            if(board[n-1][j]=='O'){
                infect(board, n-1, j, 'O', 'F');
            }
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j]=='O') {
                    board[i][j] = 'X';
                }
                if (board[i][j]=='F') {
                    board[i][j] = 'O';
                }
            }
        }
    }

    public static void infect(char[][] board, int i, int j, char dest, char infected){
        if( i < 0 || i >= board.length || j < 0 || j >= board[0].length || board[i][j] != dest ){
            return;
        }

        board[i][j] = infected;
        infect(board, i-1, j, dest, infected);
        infect(board, i+1, j, dest, infected);
        infect(board, i, j+1, dest, infected);
        infect(board, i, j-1, dest, infected);
    }
}
