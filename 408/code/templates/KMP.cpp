#include <vector>
#include <string>

using namespace std;

// Get the next array
vector<int> nextArray(const string &s, int m) {
    if (m == 1) {
        return {-1};
    }
    vector<int> next(m);
    next[0] = -1;
    next[1] = 0;
    // i indicates the current position to get the next value
    // cn is the index to compare with the previous character
    int i = 2, cn = 0;
    while (i < m) {
        if (s[i - 1] == s[cn]) {
            next[i++] = ++cn;
        } else if (cn > 0) {
            cn = next[cn];
        } else {
            next[i++] = 0;
        }
    }
    return next;
}

// KMP algorithm
int kmp(const string &s1, const string &s2) {
    // s1: the main string
    // s2: the pattern string
    int n = s1.length(), m = s2.length(), x = 0, y = 0;
    // O(m)
    vector<int> next = nextArray(s2, m);
    // O(n)
    while (x < n && y < m) {
        if (s1[x] == s2[y]) {
            x++;
            y++;
        } else if (y == 0) {
            x++;
        } else {
            y = next[y];
        }
    }
    return y == m ? x - y : -1;
}
