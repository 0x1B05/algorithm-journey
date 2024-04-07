package class038;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Code03_Permutations {
    public static List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        f(nums, 0, res);
        return res;
    }

    public static void f(int[] nums, int cur, List<List<Integer>> res) {
        if (cur == nums.length - 1) {
            List<Integer> ans = new ArrayList<>();
            for (int num : nums) {
                ans.add(num);
            }
            res.add(ans);
        } else {
            for (int i = cur; i < nums.length; i++) {
                swap(nums, cur, i);
                f(nums, cur + 1, res);
                swap(nums, cur, i);
            }
        }
    }

    public static void swap(int[] nums, int i, int j) {
        if (i == j) {
            return;
        }
        nums[i] = nums[i] ^ nums[j];
        nums[j] = nums[i] ^ nums[j];
        nums[i] = nums[i] ^ nums[j];
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int len = sc.nextInt();
        int[] nums = new int[len];
        for (int i = 0; i < len; i++) {
            nums[i] = sc.nextInt();
        }
        sc.close();

        List<List<Integer>> ans = permute(nums);
        for (List<Integer> list : ans) {
            for (int num : list) {
                System.out.print(num + " ");
            }
            System.out.println();
        }
    }
}
