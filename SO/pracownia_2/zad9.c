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

#define N 15
#define SIZE 5
#define MAX_SLEEP 3
#define MIN_SLEEP 2

pthread_mutex_t mutex_in;
pthread_mutex_t mutex_out;

int customers_in = 0;
int customers_out = 0;

pthread_cond_t queue_in;
pthread_cond_t queue_out;
pthread_cond_t all_in;
pthread_cond_t all_out;

void load() {
    pthread_mutex_lock(&mutex_in);
    customers_in = SIZE;
    pthread_cond_broadcast(&queue_in);

    pthread_cond_wait(&all_in, &mutex_in);
    pthread_mutex_unlock(&mutex_in);
}

void unload() {
    pthread_mutex_lock(&mutex_out);
    customers_out = SIZE;
    pthread_cond_broadcast(&queue_out);

    pthread_cond_wait(&all_out, &mutex_out);
    pthread_mutex_unlock(&mutex_out);
}

void *rollercoaster() {
    while (1) {
        printf("Roller Coaster: LOAD\n");
        load();

        sleep(1); /* run */

        printf("Roller Coaster: UNLOAD\n\n");
        unload();
    }
}

void board() {
    pthread_mutex_lock(&mutex_in);

    while (customers_in == 0) {
        pthread_cond_wait(&queue_in, &mutex_in);
    }

    customers_in--;
    if (customers_in == 0) {
        pthread_cond_signal(&all_in);
    }
    pthread_mutex_unlock(&mutex_in);
}

void unboard() {
    pthread_mutex_lock(&mutex_out);

    while (customers_out == 0) {
        pthread_cond_wait(&queue_out, &mutex_out);
    }

    customers_out--;
    if (customers_out == 0) {
        pthread_cond_signal(&all_out);
    }
    pthread_mutex_unlock(&mutex_out);
}

void *customer(void *num) {
    board();

    /* critsec */
    printf("Customer #%ld rides the roller coaster.\n", (long)num);

    unboard();
    return NULL;
}

int main() {
    srand(time(NULL));

    pthread_t rollercoaster_thread;
    pthread_t customers[N];

    if (pthread_create(&rollercoaster_thread, NULL, rollercoaster, NULL)) {
        fprintf(stderr, "Error creating rollercoaster thread.\n");
        return 1;
    }

    for (long i = 0; i < N; i++) {
        if (pthread_create(&customers[i], NULL, customer, (void *)i + 1)) {
            fprintf(stderr, "Error creating customer thread.\n");
            return 2;
        }
    }

    for (int i = 0; i < N; i++) {
        if (pthread_join(customers[i], NULL)) {
            fprintf(stderr, "Error joining thread.\n");
            return 3;
        }
    }

    pthread_cancel(rollercoaster_thread);

    return 0;
}