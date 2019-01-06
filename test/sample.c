#include <klee/klee.h>

int mid(int a, int b, int c) {
  int x = a - b;
  int y = b - c;
  int z = a - c;
  if ( x * y > 0 ) return b;
  if ( x * z > 0 ) return c;
  return a;
}

int main() {
  int a;
  int b;
  int c;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  klee_make_symbolic(&c, sizeof(c), "c");
  return mid(a, b, c);
}
