#include <klee/klee.h>

int max(int a, int b, int c) {
  int max = a;
  if ( b > max ) {
    max = b;
  }
  if ( c > max ) {
    max = c;
  }
  return max;
}

int main() {
  int a;
  int b;
  int c;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  klee_make_symbolic(&c, sizeof(c), "c");
  return max(a, b, c);
}
