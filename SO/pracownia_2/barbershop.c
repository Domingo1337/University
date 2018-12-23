/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include "barbershop.h"

void barbershop_init(barbershop_t *barbershop, int seats) {
    if (sem_init(&barbershop->barber, 0, 0) || sem_init(&barbershop->barber_done, 0, 0) ||
        sem_init(&barbershop->customer, 0, 0) || sem_init(&barbershop->customer_done, 0, 0) ||
        sem_init(&barbershop->mutex, 0, 1)) {
        perror("barbershop failed to init semaphores.\n");
    }

    barbershop->seats = seats;
    barbershop->customers = 0;
}

void barbershop_destroy(barbershop_t *barbershop) {
    sem_destroy(&barbershop->mutex);
    sem_destroy(&barbershop->barber);
    sem_destroy(&barbershop->barber_done);
    sem_destroy(&barbershop->customer);
    sem_destroy(&barbershop->customer_done);
}

int walk_in(barbershop_t *barbershop) {
    sem_wait(&barbershop->mutex);
    if (barbershop->customers == barbershop->seats) {
        sem_post(&barbershop->mutex);
        return 1;
    }
    barbershop->customers++;
    sem_post(&barbershop->mutex);

    sem_post(&barbershop->customer);
    sem_wait(&barbershop->barber);

    /* customer critsec */

    sem_post(&barbershop->customer_done);
    sem_wait(&barbershop->barber_done);

    sem_wait(&barbershop->mutex);
    barbershop->customers--;
    sem_post(&barbershop->mutex);
    return 0;
}

void cut_hair(barbershop_t *barbershop) {
    sem_wait(&barbershop->customer);
    sem_post(&barbershop->barber);

    /* barber critsec */
    fprintf(stdout, "\tBarber is now cutting hair\n");

    sem_wait(&barbershop->customer_done);
    sem_post(&barbershop->barber_done);
}