#include <stdio.h>
#include <stdlib.h>

typedef struct {
	unsigned long lcm, gcd;
	} result_t;

result_t lcm_gcd(unsigned long, unsigned long);

int main(int argc, char **argv) {
  if (argc < 3)
    return EXIT_FAILURE;

  unsigned long x = strtol(argv[1], NULL, 10);
  unsigned long y = strtol(argv[2], NULL, 10);
 // printf("x:%ld y: %ld\n", x, y);
	
  result_t res = lcm_gcd(x, y);

  printf("lcm: %lu\tgcd: %lu\n", res.lcm, res.gcd);

  return EXIT_SUCCESS;
}
