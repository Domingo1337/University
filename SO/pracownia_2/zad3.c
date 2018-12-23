/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <semaphore.h>

#define N 6
#define MAX_SLEEP 5
#define MIN_SLEEP 1

pid_t philosophers[N];
sem_t *forks[N];
char names[N][16];

void think() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }
void eat() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }

void take_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    if (lft < rgt) {
        sem_wait(forks[lft]);
        sem_wait(forks[rgt]);
    } else {
        sem_wait(forks[rgt]);
        sem_wait(forks[lft]);
    }
}

void put_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    sem_post(forks[lft]);
    sem_post(forks[rgt]);
}

void philosopher(int i) {
    srand(time(NULL) + getpid()); /* Different for seed for every process every run */
    while (1) {
        printf("%d THINKS...\n", i);
        think();
        printf("%d WAITS\n", i);
        take_forks(i);
        printf("%d EATS...\n", i);
        eat();
        printf("%d STOPPED\n", i);
        put_forks(i);
    }
}

void handler(int sig, siginfo_t *si, void *context) {
    for (int i = 0; i < N; i++)
        kill(philosophers[i], SIGKILL);

    for (int i = 0; i < N; i++)
        sem_unlink(names[i]);

    exit(EXIT_SUCCESS);
}

int main() {
    struct sigaction sa;
    sa.sa_sigaction = handler;
    sigaction(SIGINT, &sa, NULL);

    for (int i = 0; i < N; i++) {
        snprintf(names[i], 16, "/sem%d", i);
        forks[i] = sem_open(names[i], O_CREAT, S_IRUSR | S_IWUSR, 10);
    }

    for (long i = 0; i < N; i++) {
        switch ((philosophers[i] = fork())) {
        case 0:
            philosopher(i);
            return 1;
        case -1:
            fprintf(stderr, "Error creating thread.\n");
            return 2;
        }
    }

    while (wait(NULL) != -1)
        ; /* Wait for all the children */

    for (int i = 0; i < N; i++)
        sem_unlink(names[i]);

    return 0;
}
