/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Zdefiniuj proces "sierotę".
 * A: Proces w chwilowym stanie pomiędzy śmiercią rodzica a przygarnięciem
 *    procesu przez inny.
 *
 * Q: Co się stanie, jeśli główny proces nie podejmie się roli żniwiarza?
 * A: Żniwiarzem osieroconego procesu zostaje init(1).
 */

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
  prctl(PR_SET_CHILD_SUBREAPER); /* set this process as subreaper */

  if (fork() == 0) {
    if (fork() == 0) {
      printf("grandchild pid is %d\n", getpid());

      if (fork() == 0) {
        char *args[] = {"/bin/ps", "-o", "pid,ppid,cmd", NULL};
        execve(args[0], args, __environ);
      }
      while (wait(NULL) > 0)
        ; /* wait for all grandchildren */

    } else {
      printf("child pid is %d\n", getpid());
    }
  } else {
    printf("parent pid is %d\n", getpid());
    while (wait(NULL) > 0)
      ; /* wait for all children */
  }
}
