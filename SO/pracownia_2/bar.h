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
    sem_t fst_door;
    sem_t snd_door;
    sem_t mutex;
    int n;
    int count;
} bar_t;

bar_t *barrier_init(const char *barrier_name, int n);
bar_t *barrier_open(const char *barrier_name);
void barrier_wait(bar_t *barrier);
void barrier_destroy(bar_t *barrier);
void barrier_detach(bar_t *barrier);
