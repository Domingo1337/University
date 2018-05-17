#include <stdio.h>
#include <stdlib.h>

unsigned mulf(unsigned a, unsigned b);



int main(int argc, char **argv) {
  if (argc != 3)
    return EXIT_FAILURE;
	
  float fa = strtof(argv[1], NULL);
  float fb = strtof(argv[2], NULL);

  printf("%f\t%f\n", fa, fb);

  unsigned a = *((unsigned*) &fa);
  unsigned b = *((unsigned*) &fb);
  printf("%d\t%d\n", a, b);


  unsigned ret = mulf(a,b);
  float fret = *((float*) &ret);

  printf("%f\t%u\n",fret, ret);

  return EXIT_SUCCESS;
}

