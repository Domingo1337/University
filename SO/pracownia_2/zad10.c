/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>

#include "barbershop.h"

#define SEATS 3
#define CUSTOMERS 10

barbershop_t *barbershop;
pthread_t barber_thread;
int customers_left;

void *customer(void *data) {
    int num = (long)data;

    if (walk_in(barbershop))
        fprintf(stdout, "Customer #%d walked away with his hair uncut.\n", num);
    else
        fprintf(stdout, "Customer #%d got a haircut.\n", num);

    customers_left--;
    if (customers_left == 0)
        pthread_cancel(barber_thread);
    return NULL;
}

void *barber() {
    fprintf(stdout, "Barber opens.\n");
    while (1)
        cut_hair(barbershop);
    return NULL;
}

int main() {
    barbershop_t b;
    barbershop = &b;
    barbershop_init(barbershop, SEATS);

    if (pthread_create(&barber_thread, NULL, barber, NULL)) {
        fprintf(stderr, "Error creating barber thread\n");
        return 1;
    }

    customers_left = CUSTOMERS;
    pthread_t customer_threads[CUSTOMERS];
    for (long i = 1; i <= CUSTOMERS; i++) {
        if (pthread_create(&customer_threads[i], NULL, customer, (void *)i)) {
            fprintf(stderr, "Error creating customer thread\n");
            return 2;
        }
    }

    pthread_join(barber_thread, NULL);
    barbershop_destroy(barbershop);
    return 0;
}