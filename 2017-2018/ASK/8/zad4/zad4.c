#include <stdio.h>
#include <stdlib.h>

unsigned long fibonacci(unsigned long n);

int main(int argc, char **argv) {
  if (argc != 2)
    return EXIT_FAILURE;

  unsigned long n = strtoul(argv[1], NULL, 10);

  printf("fibbonaci(%ld) = %ld\n", n, fibonacci(n));

  return EXIT_SUCCESS;
}

