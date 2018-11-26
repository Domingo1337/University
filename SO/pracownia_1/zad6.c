/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Dlaczego w pliku Makefile przekazujemy opcję '-Wl,-rpath,ścieżka'
 *    do sterownika kompilatora?
 * A: -Wl sprawia, że następny argument przekazany będzie linkera.
 *    -rd dodaje ścieżkę do zbioru ścieżek w których szukane są biblioteki w czasie wykonywania.
 */

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void) {
  char s_pid[6]; /* max pid == 32767 */
  sprintf(s_pid, "%d", getpid());
  char *args[] = {"/usr/bin/pmap", s_pid, NULL};

  if (fork() == 0) {
    execve(args[0], args, __environ);
  } else {
    wait(NULL);
  }

  void *handle;
  int (*strdrop)(char *, const char *);
  int (*strcnt)(const char *, const char *);

  if (!(handle = dlopen("libmystr.so", RTLD_LAZY))) {
    return EXIT_FAILURE;
  }

  *(void **)(&strdrop) = dlsym(handle, "strdrop");
  *(void **)(&strcnt) = dlsym(handle, "strcnt");
  if (!(strdrop && strcnt)) {
    return EXIT_FAILURE;
  }

  char str[] = "hahaha, hohoho!!!";

  printf("%d\n", strdrop(str, "h"));
  printf("%d\n", strcnt(str, "ha!"));

  if (fork() == 0) {
    execve(args[0], args, __environ);
  } else {
    wait(NULL);
  }
  return EXIT_SUCCESS;
}
