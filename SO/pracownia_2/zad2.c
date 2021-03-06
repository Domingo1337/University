/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "sem.h"

#define N 6
#define MAX_SLEEP 5
#define MIN_SLEEP 1

sem_t forks[N];
pthread_t thread[N];

void think() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }
void eat() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }

void take_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    if (lft < rgt) {
        sem_wait(&forks[lft]);
        sem_wait(&forks[rgt]);
    } else {
        sem_wait(&forks[rgt]);
        sem_wait(&forks[lft]);
    }
}

void put_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    sem_post(&forks[lft]);
    sem_post(&forks[rgt]);
}

void *philosopher(void *arg) {
    int i = (long)arg;
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
    for (int i = 0; i < N; i++) {
        if (pthread_cancel(thread[i])) {
            fprintf(stderr, "Error canceling thread %d\n", i);
            exit(4);
        }
    }

    for (int i = 0; i < N; i++)
        sem_destroy(&forks[i]);

    exit(EXIT_SUCCESS);
}

int main() {
    struct sigaction sa;
    sa.sa_sigaction = handler;
    sigaction(SIGINT, &sa, NULL);

    srand(time(NULL));

    for (int i = 0; i < N; i++)
        sem_init(&forks[i], 1);

    for (long i = 0; i < N; i++) {
        if (pthread_create(&thread[i], NULL, philosopher, (void *)i)) {
            fprintf(stderr, "Error creating thread.\n");
            return 2;
        }
    }

    for (int i = 0; i < N; i++) {
        if (pthread_join(thread[i], NULL)) {
            fprintf(stderr, "Error joining thread.\n");
            return 3;
        }
    }
    for (int i = 0; i < N; i++)
        sem_destroy(&forks[i]);

    return 0;
}