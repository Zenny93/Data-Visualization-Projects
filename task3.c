#include <stdlib.h>
#include <stdio.h>
#include <time.h>

//test1 function
void test1(double* data, int elems, int stride) /* The test function */
{
  int i;
  double result = 0.0;
  volatile double sink;

  for (i = 0; i < elems; i += stride) {
    result += data[i];
  }
  sink = result; /* So compiler doesn't optimize away the loop */
}
//test2 function
void test2(double* data, int elems, int stride) /* The test function */
{
  int i;
  volatile double result = 0.0;

  for (i = 0; i < elems; i += stride) {
    result += data[i];
  }
}
//main function
int main(int argc, char *argv[]) {
  int n_elems = 64000; // 512000Bytes * 1/8 bytes(which is the size of a double)
  double *data = (double *)malloc(n_elems * sizeof(double)); // allocating memory to array data

  for(size_t i = 0; i < n_elems; i++){
    data[i] = (double)rand()/RAND_MAX*2.0-1.0; //filling data with double values ranging from -1,1

  }

  int stride[7] = {1,2,4,8,11,15,17}; // Stride array with 7 elememts

  printf("// timing for test1\n");
  double timetaken_test1t1;
  for (int i = 0; i < 7; i++){
    test1(data, n_elems, stride[i]); //warming up the cache for test1
    double acc = 0.0;
    for (int j = 0; j < 100; j++){ // looping 100 times

      clock_t t1;
      t1 = clock(); // start timing collection
      test1(data, n_elems, stride[i]); // calling function test1 again to get time it takes for function to execute
      t1 = clock() - t1; // end timing collection
      acc += t1;
      timetaken_test1t1 =(double)acc/CLOCKS_PER_SEC; // Time it took for test to execute


    }

    printf("%f ",(((timetaken_test1t1)/100)*1000));// priting the average time which is why I divide by 100
  }

  printf("\n");
  printf("// timing for test2\n");
  double timetaken_test2t2;
  for (int i = 0; i < 7; i++){ // The for loop for looping through test2
    test2(data, n_elems, stride[i]); //warming up the cache for test2
    double sum = 0.0;
    for (int j = 0; j < 100; j++){ // lopping 100 times

      clock_t t2;
      t2 = clock(); // start of getting time
      test2(data, n_elems, stride[i]);  // calling function test2 again to get the time the function executes.
      t2 = clock() - t2; // end of getting time
      sum += t2;
      timetaken_test2t2 =(double)sum/CLOCKS_PER_SEC; // Time it took for test to execute


    }

    printf("%f ",(((timetaken_test2t2)/100)*1000));//
  }

  printf("\n");
  free(data);

  return 0;
}
