#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdlib.h>

int main() {
  pid_t pid;

  for (int i=0; i<5; i++) {
    pid = fork();
    if (pid < 0) {
      perror("Fork failed\n");
      exit(EXIT_FAILURE);
    } else if (pid == 0) {
      printf("Yay we are in different process\n");
      _exit(EXIT_SUCCESS);
    }
  }
  int status;
  waitpid(pid, &status, 0);
  return(EXIT_SUCCESS);
}
