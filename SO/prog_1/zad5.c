/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Czemu procedura printf nie jest wielobieżna, a snprintf jest?
 * A: Procedura printf ma statyczne struktury, m.in. bufor do ktorego zapisuje napis do wypisania,
 *    zawołanie printf z innego wątku zanim bufor zostanie wypisany nadpisze go.
 *    Snprintf nie posiada bufora, pisze od razu pod zadany adres.
 */

#define _GNU_SOURCE
#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>
#include <unistd.h>

void handler(int sig, siginfo_t *si, void *context) {
  static char buffer[64];
  int size;

  size = snprintf(buffer, 64, "Faulty address: 0x%lx\n", (long)si->si_addr);
  write(STDOUT_FILENO, buffer, size);

  switch (si->si_code) {
  case SEGV_MAPERR:
    write(STDOUT_FILENO, "Error code: MAPERR\n", 20);
    break;

  case SEGV_ACCERR:
    write(STDOUT_FILENO, "Error code: ACCERR\n", 20);
    break;

  default:
    size = snprintf(buffer, 64, "Error code: %d\n", si->si_code);
    write(STDOUT_FILENO, buffer, size);
  }

  ucontext_t *ucontext = (ucontext_t *)context;
  size = snprintf(buffer, 64, "Stack pointer: 0x%lx\n",
                  (long)ucontext->uc_mcontext.gregs[REG_RSP]);
  write(STDOUT_FILENO, buffer, size);

  size = snprintf(buffer, 64, "Instruction pointer: 0x%lx\n",
                  (long)ucontext->uc_mcontext.gregs[REG_RIP]);
  write(STDOUT_FILENO, buffer, size);

  write(STDOUT_FILENO, "Backtrace:\n", 12);
  void *bt[128];
  size = backtrace(bt, 128);
  backtrace_symbols_fd(bt, size, STDOUT_FILENO);

  exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = handler;
    sigaction(SIGSEGV, &sa, NULL);

    if (!strcmp(argv[1], "--maperr")) {
      int *p = NULL;
      *p = 2137;
    } else if (!strcmp(argv[1], "--accerr")) {
      int *p = (int *)main;
      *p = 2137;
    }
  } else {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
