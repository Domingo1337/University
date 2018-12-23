/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

typedef struct {
    int seats;
    int customers;
    sem_t mutex;
    sem_t barber;
    sem_t barber_done;
    sem_t customer;
    sem_t customer_done;
} barbershop_t;

void barbershop_init(barbershop_t *, int);
void barbershop_destroy(barbershop_t *);

int walk_in(barbershop_t *);   /* return 0 on haircut done and 1 on full barbershop */
void cut_hair(barbershop_t *); /* barber's loop */