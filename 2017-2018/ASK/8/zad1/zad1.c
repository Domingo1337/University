#include <stdio.h>
#include <stdlib.h>

long clz(long); /* count leading zeros */

int main(int argc, char **argv) {
  if (argc < 2)
    return EXIT_FAILURE;

  long x = strtol(argv[1], NULL, 10);

  printf("leading zeros of %ld: %ld\n", x, clz(x));

  return EXIT_SUCCESS;
}

