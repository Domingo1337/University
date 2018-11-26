/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Czemu procedura printf nie jest wielobieżna, a snprintf jest?
 * A: Procedura printf buforuje napis w statycznej strukturze zanim go wypisze.
 *    Snprintf nie posiada bufora, pisze od razu pod zadany adres.
 */

#define _GNU_SOURCE
#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <ucontext.h>
#include <unistd.h>

void handler(int sig, siginfo_t *si, void *context) {
  static char buffer[64];
  int size;

  size = snprintf(buffer, 64, "Faulty address: 0x%lx\n", (long)si->si_addr);
  size = write(STDOUT_FILENO, buffer, size);

  switch (si->si_code) {
  case SEGV_MAPERR:
    size = write(STDOUT_FILENO, "Error code: MAPERR\n", 20);
    break;

  case SEGV_ACCERR:
    size = write(STDOUT_FILENO, "Error code: ACCERR\n", 20);
    break;

  default:
    size = snprintf(buffer, 64, "Error code: %d\n", si->si_code);
    size = write(STDOUT_FILENO, buffer, size);
  }

  ucontext_t *ucontext = (ucontext_t *)context;
  size = snprintf(buffer, 64, "Stack pointer: 0x%lx\n",
                  (long)ucontext->uc_mcontext.gregs[REG_RSP]);
  size = write(STDOUT_FILENO, buffer, size);

  size = snprintf(buffer, 64, "Instruction pointer: 0x%lx\n",
                  (long)ucontext->uc_mcontext.gregs[REG_RIP]);
  size = write(STDOUT_FILENO, buffer, size);

  size = write(STDOUT_FILENO, "Backtrace:\n", 12);
  void *bt[128];
  size = backtrace(bt, 128);
  backtrace_symbols_fd(bt, size, STDOUT_FILENO);

  exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    stack_t ss;

    ss.ss_sp = malloc(SIGSTKSZ);
    if (ss.ss_sp == NULL) {
      fprintf(stderr, "stack malloc failed\n");
      return EXIT_FAILURE;
    }
    ss.ss_size = SIGSTKSZ;
    ss.ss_flags = 0;
    if (sigaltstack(&ss, NULL) == -1) {
      fprintf(stderr, "sigalstack failed\n");
      return EXIT_FAILURE;
    }

    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sa.sa_sigaction = handler;
    sigaction(SIGSEGV, &sa, NULL);

    if (!strcmp(argv[1], "--maperr")) {
      int *ptr = mmap(NULL, 4, PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
      if (ptr == MAP_FAILED) {
        fprintf(stderr, "mmap failed\n");
        return EXIT_FAILURE;
      }
      munmap(ptr, 4);
      *ptr = 0xDEAD;
    } else if (!strcmp(argv[1], "--accerr")) {
      int *ptr = mmap(NULL, 4, PROT_READ, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
      if (ptr == MAP_FAILED) {
        fprintf(stderr, "mmap failed\n");
        return EXIT_FAILURE;
      }
      *ptr = 0xC0DE;
    }
  } else {
    fprintf(stderr, "no arguments provided\n");
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
