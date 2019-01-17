#include <klee/klee.h>

int max(int a, int b, int c) {
  if ( a <= b && c <= b ) {
    return b;
  }
  if ( a <= c && b <= c) {
    return c;
  }
  return a;
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
