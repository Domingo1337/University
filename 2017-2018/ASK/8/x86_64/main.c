#include <stdio.h>
#include <stdlib.h>

long sum(long x, long y);

int main(int argc, char **argv) {
  if (argc < 3)
    return EXIT_FAILURE;

  long x = strtol(argv[1], NULL, 10);
  long y = strtol(argv[2], NULL, 10);

  printf("%ld + %ld = %ld\n", x, y, sum(x, y));

  return EXIT_SUCCESS;
}
