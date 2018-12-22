/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include "bar.h"

bar_t *barrier_init(const char *barrier_name, int n) {

    bar_t *barrier = NULL;
    int fd = shm_open(barrier_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if (!fd || ftruncate(fd, sizeof(bar_t)) ||
        !(barrier = (bar_t *)mmap(NULL, sizeof(bar_t), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)) ||
        close(fd)) {
        perror("Barrier failed on shared memory allocation.\n");
    }

    if (sem_init(&barrier->mutex, 1, 1) || sem_init(&barrier->fst_door, 1, 1) ||
        sem_init(&barrier->snd_door, 1, 0)) {
        perror("Barrier failed to init semaphores.\n");
    }

    barrier->n = n;
    barrier->count = 0;

    return barrier;
}

bar_t *barrier_open(const char *barrier_name) {
    bar_t *barrier = NULL;
    int fd = shm_open(barrier_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if (!fd || ftruncate(fd, sizeof(bar_t)) ||
        !(barrier = (bar_t *)mmap(NULL, sizeof(bar_t), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)) ||
        close(fd)) {
        perror("Barrier failed on shared memory allocation\n");
    }

    return barrier;
}

void barrier_destroy(bar_t *barrier) {
    sem_destroy(&barrier->fst_door);
    sem_destroy(&barrier->snd_door);
    sem_destroy(&barrier->mutex);
}

void barrier_wait(bar_t *barrier) {
    assert(sem_wait(&barrier->fst_door) == 0);

    assert(sem_wait(&barrier->mutex) == 0);
    barrier->count++;
    if (barrier->count >= barrier->n) {
        assert(sem_post(&barrier->snd_door) == 0);
    } else {
        assert(sem_post(&barrier->fst_door) == 0);
    }
    assert(sem_post(&barrier->mutex) == 0);

    assert(sem_wait(&barrier->snd_door) == 0);

    assert(sem_wait(&barrier->mutex) == 0);
    barrier->count--;
    if (barrier->count > 0) {
        assert(sem_post(&barrier->snd_door) == 0);
    } else {
        assert(sem_post(&barrier->fst_door) == 0);
    }
    assert(sem_post(&barrier->mutex) == 0);
}