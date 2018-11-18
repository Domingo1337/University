/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Zdefiniuj proces "zombie".
 * A: ...
 */

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  // args for calling ps
  char *args[] = {"/bin/ps", "-o", "pid,ppid,stat,cmd", NULL};

  // set SIGCHILD handler to ignore
  if (argc > 1 && strcmp(argv[1], "--bury") == 0) {
    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sigaction(SIGCHLD, &sa, NULL);
  }

  // create child and kill it
  if (fork() == 0) {
    exit(0);
  }

  if (fork() == 0) {
    execve(args[0], args, __environ);
  }

  sleep(1);

  return EXIT_SUCCESS;
}
