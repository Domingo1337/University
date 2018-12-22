/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>

#include "bar.h"

#define K 3
#define N 10
#define HORSES 15

#define MIN_T 1
#define MAX_T 10

#define GATE "Gate"

void horse_around(int num) {
    bar_t *barrier = barrier_open(GATE);
    srand(time(NULL) + getpid()); /* Different for seed for every process every run */

    for (int i = 1; i <= K; i++) {
        printf("[%d] Horse #%d in gates for lap #%d...\n", getpid(), num, i);
        barrier_wait(barrier);

        printf("\t[%d] Horse #%d starts lap #%d!\n", getpid(), num, i);
        sleep(MIN_T + rand() % (MAX_T - MIN_T));
    }
    printf("[%d] Horse #%d finished\n", getpid(), num);
    exit(0);
}

int main() {
    srand(time(NULL));

    bar_t *barrier = barrier_init(GATE, N);

    for (int i = 1; i <= HORSES; i++) {
        switch (fork()) {
        case 0:
            horse_around(i);
            return 1;
        case -1:
            fprintf(stderr, "Horse %d failed to fork()\n", i);
        }
    }

    int left = HORSES;
    while (wait(NULL) != -1) { /* Wait for all the children */
        fprintf(stderr, "%d horses remain.\n", --left);
        if (left < N) {
            /* now the barrier may not work properly as there are less processes than the barrier's size */
        }
    }
    barrier_destroy(barrier);
}