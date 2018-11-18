/* Imię nazwisko: Maksymilian Debeściak
 * Numer indeksu: 999999
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Dlaczego w pliku Makefile przekazujemy opcję '-Wl,-rpath,ścieżka'
 *    do sterownika kompilatora?
 * A: ...
 */

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
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

  char str[] = "hahaha!!!";

  printf("%d", strcnt(str, "a!"));
  printf("%d", strdrop(str, "a!"));

  return EXIT_SUCCESS;
}
