#include <klee/klee.h>

int isPrime(int a) {
  for ( int i = 2; i < a; i++ ) {
    if ( a % i == 0 ) {
      return 0;
    }
  }
  if ( a > 1 ) {
    return 1;
  }
  return 0;
}

int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_assume(-10 < a & a < 20);
  return isPrime(a);
}
