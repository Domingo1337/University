#include <stdio.h>
#include <stdlib.h>

void insert_sort(long* first, long* last);

int main(int argc, char **argv) {
  if (argc < 2)
    return EXIT_FAILURE;

  long array[argc-1];

  for(int i = 0; i<argc-1; i++)
     array[i] = atol(argv[i+1] );

  insert_sort(array, array+(argc-2));

  for(int i = 0; i<argc-1; i++)
     printf ("%ld ", array[i]);
  printf("\n");

  return EXIT_SUCCESS;
}

