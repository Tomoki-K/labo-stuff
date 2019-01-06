#include <klee/klee.h>

int triangle(int a, int b, int c) {
  int type = 0; // Scalene
  if (a == b && b == c) {
    type = 1; // Equilateral
  } else if ( a == b || b == c || c == a ) {
    type = 2; // Isosceles
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
