#include <stdlib.h>
#include <stdio.h>
#include "matmul.h"
#include <time.h>

int main(int argc, char *argv[]) {
  if (argc != 2) { // Checks the amount of arguments passed.

    printf("Need one argument to play.\n");

    exit(1);
}
    size_t n = atoi(argv[1]);  // Converts char n to an integer
  double *A = (double *)malloc(n*n * sizeof(double)); // allocating memory to A
  double *B = (double *)malloc(n*n * sizeof(double)); // allocating memory to B


  for(size_t i = 0; i < n; i++){
    for(size_t j = 0; j < n; j++){
      A[i * n + j] = (double)rand()/RAND_MAX*2.0-1.0; //filling A with double values ranging from -1,1
      B[i * n + j] = (double)rand()/RAND_MAX*2.0-1.0; //filling B with double values ranging from -1,1

    }
  }

  printf("\n");

  double *Function1; //The value of psum returned in sumArray.c will be placed in this pointer to double
  clock_t t1; //Getting the timing for Function1
  t1 = clock();
  Function1 = mmul1(A,B,n); //Calling mmul1 function
  t1 = clock() - t1;
  double timetaken_Function1 =((double)t1)/CLOCKS_PER_SEC; // Time it took for mmul1 to execute
  printf("%f ms\n",(timetaken_Function1*1000));// printing time for mmul1 in ms
  printf("%f\n", Function1[n-1]); //printing the value of C in mmul1

  free(A);
  free(B);
  free(Function1);
  return 0;
}
