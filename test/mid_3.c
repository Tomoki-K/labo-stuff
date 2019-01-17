#include <klee/klee.h>

int mid(int a, int b, int c) {
  if (( b <= a && a <= c ) || ( c <= a && a <= b ))
    return a;
  if (( a <= b && b <= c ) || ( c <= b && b <= a ))
    return b;
  if (( a <= c && c <= b ) || ( b <= c && c <= a ))
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
