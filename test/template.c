#include <klee/klee.h>

int foo( int x ) {
}

int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  return foo(a);
}
