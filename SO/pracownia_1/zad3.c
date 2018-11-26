/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Czemu nie musisz synchronizować dostępu do zmiennych współdzielonych?
 * A: Naraz działać może tylko jedno włókno. Poszczególne włókna nie są wywłaszczane.
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>
#include <unistd.h>

static ucontext_t uctx_func_1, uctx_func_2, uctx_func_3;

static char buffer[256];
static char word[256];
static unsigned short word_size;
static _Bool end = 0;

static void func_1() {
  static int words = 0;
  static int r = 1;
  static char current;
  while (r && (r = read(STDIN_FILENO, &current, 1))) {
    while (isspace(current) && (r = read(STDIN_FILENO, &current, 1)))
      ; /* ignore all the whitespaces */
    if (r) {
      words++;
      buffer[0] = current;

      unsigned short i = 1;
      while ((r = read(STDIN_FILENO, &current, 1))) {
        if (isspace(current)) {
          buffer[i] = '\0';
          setcontext(&uctx_func_2);
        } else {
          buffer[i++] = current;
        }
      }
    }
  }

  end = 1;
  buffer[0] = '\0';
  fprintf(stderr, "words = %d\n", words);
  setcontext(&uctx_func_2);
}

static void func_2() {
  static int removed = 0;
  while (1) {
    unsigned short i = 0, j = 0;
    while (buffer[i] != '\0') {
      if (isalnum(buffer[i])) {
        word[j++] = buffer[i];
      } else {
        removed++;
      }
      i++;
    }
    if (j != 0){
      word[j++] = ' ';
    }
    word_size = j;

    if (end) {
      fprintf(stderr, "removed = %d\n", removed);
    }
    setcontext(&uctx_func_3);
  }
}

static void func_3() {
  static int chars = 0;

  while (1) {
    chars += write(STDOUT_FILENO, word, word_size);

    if (end) {
      fprintf(stderr, "chars = %d\n", chars);
      exit(EXIT_SUCCESS);
    } else {
      setcontext(&uctx_func_1);
    }
  }
}

int main() {
  char stack1[1024];
  getcontext(&uctx_func_1);
  uctx_func_1.uc_stack.ss_sp = stack1;
  uctx_func_1.uc_stack.ss_size = sizeof stack1;
  makecontext(&uctx_func_1, func_1, 0);

  char stack2[1024];
  getcontext(&uctx_func_2);
  uctx_func_2.uc_stack.ss_sp = stack2;
  uctx_func_2.uc_stack.ss_size = sizeof stack2;
  makecontext(&uctx_func_2, func_2, 0);

  char stack3[1024];
  getcontext(&uctx_func_3);
  uctx_func_3.uc_stack.ss_sp = stack3;
  uctx_func_3.uc_stack.ss_size = sizeof stack3;
  makecontext(&uctx_func_3, func_3, 0);

  setcontext(&uctx_func_1);

  return EXIT_SUCCESS;
}
