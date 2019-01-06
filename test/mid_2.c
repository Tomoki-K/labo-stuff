#include <klee/klee.h>

int mid(int a, int b, int c) {
  int lo = a;
  int hi = b;
  if ( a > b ) {
    lo = b;
    hi = a;
  }
  if ( c <= lo ) {
    return lo;
  }
  if ( c >= hi ) {
    return hi;
  }
  return c;
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
