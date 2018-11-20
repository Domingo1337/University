/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Zdefiniuj proces "zombie".
 * A: Niefukncjonujący proces, który nie został zakończony przez rodzica,
 *    więc jego struktury są dalej przechowywanie w tablicy procesów.
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

  // call ps
  if (fork() == 0) {
    execve(args[0], args, __environ);
  }

  sleep(1);

  return EXIT_SUCCESS;
}
