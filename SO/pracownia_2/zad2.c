/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "sem.h"
#include <signal.h>

#define N 3
#define MAX_SLEEP 3
#define MIN_SLEEP 2

pthread_mutex_t forks[N];
pthread_t thread[N];

void think() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }
void eat() { sleep(rand() % MAX_SLEEP + MIN_SLEEP); }

void take_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    if (lft < rgt) {
        pthread_mutex_lock(&forks[lft]);
        pthread_mutex_lock(&forks[rgt]);
    } else {
        pthread_mutex_lock(&forks[rgt]);
        pthread_mutex_lock(&forks[lft]);
    }
}

void put_forks(int i) {
    int rgt = i;
    int lft = (i + 1) % N;
    pthread_mutex_unlock(&forks[lft]);
    pthread_mutex_unlock(&forks[rgt]);
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
            exit(3);
        }
    }
    exit(EXIT_SUCCESS);
}

int main() {
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = handler;
    sigaction(SIGINT, &sa, NULL);

    srand(time(NULL));
    for (long i = 0; i < N; i++) {
        if (pthread_create(&thread[i], NULL, philosopher, (void *)i)) {
            fprintf(stderr, "Error creating thread\n");
            return 1;
        }
    }

    for (int i = 0; i < N; i++) {
        if (pthread_join(thread[i], NULL)) {
            fprintf(stderr, "Error joining thread\n");
            return 2;
        }
    }
}