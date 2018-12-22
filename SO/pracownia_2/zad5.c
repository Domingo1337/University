/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>

#include "ramen.h"

#define RAMEN "Tsuta Ramen"
#define SEATS 5

#define CUSTOMERS 23
#define EATING_TIME 15
#define MAX_DELAY 60

void eat_ramen_and_die(int num) {
    ramen_t *ramen = ramen_open(RAMEN);

    srand(time(NULL) + getpid()); /* Different for seed for every process every run */
    sleep(rand() % MAX_DELAY);    /* So they all don't go rushing to the door */

    printf("[%d]Customer #%d enters %s restaurant.\n", getpid(), num, RAMEN);
    ramen_wait(ramen);

    printf("[%d]Customer #%d eats delicous ramen.\n", getpid(), num);
    sleep(rand() % EATING_TIME);

    printf("[%d]Customer #%d leaves.\n", getpid(), num);
    ramen_finish(ramen);

    exit(0);
}

int main() {
    ramen_t *ramen = ramen_init(RAMEN, SEATS);

    for (int i = 1; i <= CUSTOMERS; i++) {
        switch (fork()) {
        case 0:
            eat_ramen_and_die(i);
            return 1;
        case -1:
            fprintf(stderr, "Customer %d failed to fork()\n", i);
        }
    }

    while (wait(NULL) != -1)
        ; /* Wait for all the children */

    ramen_destroy(ramen);
}