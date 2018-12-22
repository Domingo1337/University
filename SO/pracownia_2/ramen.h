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
    int eating;
    int waiting;
    int must_wait;
    int seats;
    sem_t queue;
    sem_t mutex;
} ramen_t;

ramen_t *ramen_init(const char *, int);
ramen_t *ramen_open(const char *);
void ramen_wait(ramen_t *);
void ramen_finish(ramen_t *);
void ramen_destroy(ramen_t *);