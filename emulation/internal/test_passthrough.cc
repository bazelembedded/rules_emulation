#include <iostream>

int main(int argc, char *argv[]) {
  // Test that more than one argument is passed through. This should be done
  // with the args attribute in cc_test.
  if (argc < 2) {
    std::cerr << "No arguments passed through, there should be at least one "
                 "argument specified in the cc_test args parameter present "
                 "when running the test."
              << std::endl;
    return 1;
  }
  return 0;
}