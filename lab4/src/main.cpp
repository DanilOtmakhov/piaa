#include <iostream>
#include <vector>
#include <string>

class KMPMatcher {
private:
    std::string pattern;
    std::vector<int> prefix;

    static std::vector<int> computePrefix(const std::string& pattern) {
        std::vector<int> prefix(pattern.size(), 0);
        int k = 0;

        std::cout << "Computing prefix array for pattern: " << pattern << std::endl;
        std::cout << "Prefix[0] = 0" << std::endl;

        for (size_t i = 1; i < pattern.size(); ++i) {
            while (k > 0 && pattern[k] != pattern[i]) {
                std::cout << "Mismatch at position " << i << " (k = " << k << "). Backtracking to " << prefix[k - 1] << std::endl;
                k = prefix[k - 1];
            }
            if (pattern[k] == pattern[i]) {
                k++;
                std::cout << "Match found at position " << i << " (k = " << k << ")." << std::endl;
            }
            prefix[i] = k;
            std::cout << "Prefix[" << i << "] = " << prefix[i] << std::endl;
        }

        return prefix;
    }

public:
    KMPMatcher(const std::string& pattern) : pattern(pattern), prefix(computePrefix(pattern)) {}

    std::vector<int> searchAll(const std::string& text) {
        std::vector<int> result;
        int k = 0;

        std::cout << "\nSearching all occurrences of pattern in text: " << text << std::endl;

        for (size_t i = 0; i < text.size(); ++i) {
            std::cout << "Checking text[" << i << "] = " << text[i] << " against pattern[" << k << "] = " << pattern[k] << std::endl;

            while (k > 0 && pattern[k] != text[i]) {
                std::cout << "Mismatch at text[" << i << "], backtracking to prefix[" << (k - 1) << "] = " << prefix[k - 1] << std::endl;
                k = prefix[k - 1];
            }
            if (pattern[k] == text[i]) {
                k++;
                std::cout << "Match at text[" << i << "], k = " << k << std::endl;
            }
            if (k == (int)pattern.size()) {
                result.push_back(i - k + 1);
                std::cout << "Pattern found at index " << (i - k + 1) << std::endl;
                k = prefix[k - 1];
            }
        }

        return result;
    }

    int searchFirst(const std::string& text) {
        int k = 0;

        std::cout << "\nSearching for the first occurrence of pattern in text: " << text << std::endl;

        for (size_t i = 0; i < text.size(); ++i) {
            std::cout << "Checking text[" << i << "] = " << text[i] << " against pattern[" << k << "] = " << pattern[k] << std::endl;

            while (k > 0 && pattern[k] != text[i]) {
                std::cout << "Mismatch at text[" << i << "], backtracking to prefix[" << (k - 1) << "] = " << prefix[k - 1] << std::endl;
                k = prefix[k - 1];
            }
            if (pattern[k] == text[i]) {
                k++;
                std::cout << "Match at text[" << i << "], k = " << k << std::endl;
            }
            if (k == (int)pattern.size()) {
                std::cout << "Pattern found at index " << (i - k + 1) << std::endl;
                return i - k + 1;
            }
        }

        return -1;
    }

    static int cyclicShiftIndex(const std::string& pattern, const std::string& text) {
        if (pattern.size() != text.size()) {
            return -1;
        }

        KMPMatcher matcher(text);
        std::string doubled = pattern + pattern;

        std::cout << "\nSearching for cyclic shift index of pattern in doubled text: " << doubled << std::endl;

        int index = matcher.searchFirst(doubled);

        if (index != -1 && index < (int)(pattern.size())) {
            return index;
        }

        return -1;
    }
};

int main() {
    std::cout << "Choose mode:\n";
    std::cout << "1 - Find all occurrences of the pattern\n";
    std::cout << "2 - Check if the pattern is a cyclic shift of the text\n";
    std::cout << "Enter 1 or 2: ";

    int mode;
    std::cin >> mode;
    std::cin.ignore();

    std::string pattern, text;
    std::cout << "Enter the pattern: ";
    std::getline(std::cin, pattern);
    std::cout << "Enter the text: ";
    std::getline(std::cin, text);

    if (pattern.empty() || text.empty()) {
        std::cout << "-1" << std::endl;
        return 0;
    }

    if (mode == 1) {
        std::cout << "\n--- Searching for all occurrences ---\n";
        if (pattern.size() > text.size()) {
            std::cout << "-1" << std::endl;
        } else {
            KMPMatcher matcher(pattern);
            std::vector<int> occurrences = matcher.searchAll(text);

            if (occurrences.empty()) {
                std::cout << "-1" << std::endl;
            } else {
                std::cout << "All occurrences: ";
                for (size_t i = 0; i < occurrences.size(); ++i) {
                    if (i != 0) std::cout << ",";
                    std::cout << occurrences[i];
                }
                std::cout << std::endl;
            }
        }
    } else if (mode == 2) {
        std::cout << "\n--- Searching for cyclic shift index ---\n";
        int shift = KMPMatcher::cyclicShiftIndex(pattern, text);
        std::cout << "Cyclic shift index: " << shift << std::endl;
    } else {
        std::cout << "Invalid mode selected." << std::endl;
    }

    return 0;
}
