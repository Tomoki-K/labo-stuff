#include <klee/klee.h>

int triangle(int a, int b, int c) {
  if ( a <= 0 || b <= 0 || c <= 0 )
    return 0; // invalid
  int type = 1; // Scalene
  if (a == b && b == c) {
    type = 2; // Equilateral
  } else if ( a == b || b == c || c == a ) {
    type = 3; // Isosceles
  }
  return type;
}

int main() {
  int a;
  int b;
  int c;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  klee_make_symbolic(&c, sizeof(c), "c");
  return triangle(a, b, c);
}
