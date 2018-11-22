/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 *
 * Oświadczam, że:
 *  - rozwiązanie zadania jest mojego autorstwa,
 *  - jego kodu źródłowego dnie będę udostępniać innym studentom,
 *  - a w szczególności nie będę go publikować w sieci Internet.
 *
 * Q: Jak proces wykrywa, że drugi koniec potoku został zamknięty?
 * A: Wywołanie read na zamkniętym potoku zwraca 0, a próba pisania
 *    do zamkniętego potoku powoduje przyjście sygnału SIGTERM,
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static int fd_read, fd_write;

static void func_1() {
  static int words = 0;
  static int r = 1, w = 1;
  static char current;

  while (w && r && (r = read(fd_read, &current, 1))) {
    while (isspace(current) && (r = read(fd_read, &current, 1)))
      ; /* ignore all the whitespaces */

    if (r) {
      while ((w = write(fd_write, &current, 1)) &&
             (r = read(fd_read, &current, 1)) && !isspace(current))
        ; /* write as long as you are able to read and havent encountered ad
             whitespace */

      if (w) {
        words++;
        current = ' ';
        w = write(fd_write, &current, 1);
      }
    }
  }

  close(fd_read);
  close(fd_write);
  fprintf(stderr, "words = %d\n", words);
  exit(w ? EXIT_SUCCESS : EXIT_FAILURE);
}

static void func_2() {
  static int removed = 0;
  static int w = 1;
  static char current;

  while (w && read(fd_read, &current, 1)) {
    if (current == ' ' || isalnum(current)) {
      w = write(fd_write, &current, 1);
    } else {
      removed++;
    }
  }

  close(fd_read);
  close(fd_write);
  fprintf(stderr, "removed = %d\n", removed);
  exit(w ? EXIT_SUCCESS : EXIT_FAILURE);
}

static void func_3() {
  static int chars = 0;
  static char buffer[255];
  static int size, w = 1;
  while (w && (size = read(fd_read, buffer, 255)) > 0) {
    chars += (w = write(fd_write, buffer, size));
  }

  close(fd_read);
  close(fd_write);
  fprintf(stderr, "chars = %d\n", chars);
  exit(w ? EXIT_SUCCESS : EXIT_FAILURE);
}

int main(void) {
  int pipes[4];
  if (pipe(pipes) || pipe(pipes + 2)) {
    fprintf(stderr, "could not open pipes\n");
    return EXIT_FAILURE;
  }

  pid_t proc[3];

  if ((proc[0] = fork()) == 0) {
    fd_read = STDIN_FILENO;
    fd_write = pipes[1];
    close(pipes[0]);
    close(pipes[2]);
    close(pipes[3]);
    func_1();
  } else if ((proc[1] = fork()) == 0) {
    fd_read = pipes[0];
    fd_write = pipes[3];
    close(pipes[1]);
    close(pipes[2]);
    func_2();
  } else if ((proc[2] = fork()) == 0) {
    fd_read = pipes[2];
    fd_write = STDOUT_FILENO;
    close(pipes[0]);
    close(pipes[1]);
    close(pipes[3]);
    func_3();
  } else {
    close(pipes[0]);
    close(pipes[1]);
    close(pipes[2]);
    close(pipes[3]);

    for (unsigned short i = 0; i < 3; i++) {
      int status;
      if (waitpid(proc[i], &status, 0) == -1) {
        fprintf(stderr, "waitpid failed for proc %d\n", i);
        return EXIT_FAILURE;
      }

      if (WIFEXITED(status)) {
        const int es = WEXITSTATUS(status);
        if (es == EXIT_SUCCESS) {
          fprintf(stderr, "process %d exited succesfully\n", i);
        } else {
          fprintf(stderr, "exit status of proc %d was %d\n", i, es);
        }
      }
    }
  }
  return EXIT_SUCCESS;
}
