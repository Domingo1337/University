/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "sem.h"

#define N 7
#define K 3
#define S 3
#define MAX_SLEEP 3
#define MIN_SLEEP 1

sem_t *sem;

void *func(void *data) {
    int id = (long)data;
    for (int i = 0; i < K; i++) {
        printf("thread #%d, waiting\n", id);
        sem_wait(sem);

        int t = MIN_SLEEP + rand() % (MAX_SLEEP - MIN_SLEEP);
        printf("thread #%d doing work for %d seconds\n", id, t);
        sleep(t);

        printf("thread #%d, leaving critsec\n", id);
        sem_post(sem);
    }
    return NULL;
}

int main() {
    srand(time(NULL));

    pthread_t thread[N];
    sem_t _sem;
    sem = &_sem;
    sem_init(sem, S);

    for (long i = 0; i < N; i++) {
        if (pthread_create(&thread[i], NULL, func, (void *)i)) {
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

    return 0;
}
