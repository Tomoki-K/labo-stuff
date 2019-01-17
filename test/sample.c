#include <klee/klee.h>

int main() {
   int i = 3 , N, sum = 0 ;

   klee_make_symbolic(&N, sizeof(N), "N");
   klee_assume(N > 1 & N < 10);

   for(i = 3 ; i< N; i++)  {
   }
   return sum;
}


// int main() {
//    int i , N = 10;

//    klee_make_symbolic(&i, sizeof(i), "i");
//    klee_assume(i > -1);

//    for( ; i< N; i++)  {
//    }
//    return i;
// }