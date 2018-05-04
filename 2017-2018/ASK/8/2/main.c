#include <stdio.h>
#include <stdlib.h>

typedef struct {
	unsigned long lcm, gcd;
	} result_t;

result_t lcm_gcd(unsigned long, unsigned long);

int main(int argc, char **argv) {
  if (argc < 3)
    return EXIT_FAILURE;

  long x = strtol(argv[1], NULL, 10);
  long y = strtol(argv[2], NULL, 10);

  while(x != 0)
{
	long temp = x;
	x = y;
	y = temp%y;
}
	
  result_t res = lcm_gcd(x, y);

  printf("(%ld, %ld): lcm = %ld gcd = %ld", x, y, res.lcm, res.gcd);

  return EXIT_SUCCESS;
}
