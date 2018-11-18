#include <stdio.h>
#include <stdlib.h>

int main() {
  printf("Hello World");
  int *ptr = malloc(sizeof(int));
  free(ptr);
  return 0;
}
