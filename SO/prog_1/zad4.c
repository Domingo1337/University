/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Jak proces wykrywa, że drugi koniec potoku został zamknięty?
 * A: ...
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

static void func_1() {
  static int words = 0;

  while (1) {
  }

  fprintf(stderr, "words = %d\n", words);
}

static void func_2() {
  static int removed = 0;

  while (1) {
  }

  fprintf(stderr, "removed = %d\n", removed);
}

static void func_3() {
  static int chars = 0;

  while (1) {
  }

  fprintf(stderr, "chars = %d\n", chars);
}

int main(void) {
  return EXIT_SUCCESS;
}
