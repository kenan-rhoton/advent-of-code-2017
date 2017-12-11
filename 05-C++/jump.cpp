#include <vector>
#include <iostream>

int main() {
    std::vector<int> jumpcodes;
    int num;
    while (std::cin >> num) {
        jumpcodes.push_back(num);
    }
    int position = 0;
    int steps = 0;
    while (position >= 0 && position < jumpcodes.size()) {
        int val = jumpcodes[position];
        jumpcodes[position]++;
        steps++;
        position += val;
    }
    std::cout << steps << std::endl;
}
