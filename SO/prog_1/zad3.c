/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Czemu nie musisz synchronizować dostępu do zmiennych współdzielonych?
 * A: ...
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <ucontext.h>

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

int main() {
  return EXIT_SUCCESS;
}
