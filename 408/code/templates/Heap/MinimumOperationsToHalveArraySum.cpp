#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

// First approach using priority queue (max-heap)
int halveArray(vector<int>& nums) {
    priority_queue<double> heap;
    double sum = 0;
    for (int num : nums) {
        heap.push((double)num);
        sum += num;
    }
    double target = sum / 2;
    int ans = 0;
    double cur = 0;
    while (sum > target) {
        cur = heap.top() / 2;
        heap.pop();
        heap.push(cur);
        sum -= cur;  // Subtract the halved value from sum
        ans++;
    }
    return ans;
}

// Heapify function for custom heap implementation
void heapify(vector<long>& heap, int i, int size) {
    int left = 2 * i + 1;
    while (left < size) {
        int right = left + 1;
        int best = (right < size && heap[right] > heap[left]) ? right : left;
        best = heap[best] > heap[i] ? best : i;
        if (best == i) {
            break;
        }
        swap(heap[best], heap[i]);
        i = best;
        left = 2 * i + 1;
    }
}

// Second approach using custom heap
int halveArray2(vector<int>& nums) {
    int size = nums.size();
    vector<long> heap(size);
    long sum = 0;

    // Build the heap with scaled values (shifting to avoid float)
    for (int i = 0; i < size; i++) {
        heap[i] = (long)nums[i] << 20;  // Multiply by 2^20 to keep precision
        sum += heap[i];
    }

    sum /= 2;  // Target is half of the sum
    int ans = 0;
    while (sum > 0) {
        heapify(heap, 0, size);
        heap[0] /= 2;
        sum -= heap[0];  // Decrease sum by halved value
        ans++;
    }
    return ans;
}

int main() {
    // Example usage
    vector<int> nums = {5, 10, 7};
    cout << "Minimum operations (priority queue approach): " 
         << halveArray(nums) << endl;

    cout << "Minimum operations (custom heap approach): " 
         << halveArray2(nums) << endl;

    return 0;
}
