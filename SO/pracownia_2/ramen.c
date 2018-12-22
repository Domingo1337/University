/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include "ramen.h"

ramen_t *ramen_init(const char *restaurant_name, int seats) {

    ramen_t *ramen = NULL;
    int fd = shm_open(restaurant_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if (!fd || ftruncate(fd, sizeof(ramen_t)) ||
        !(ramen = (ramen_t *)mmap(NULL, sizeof(ramen_t), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)) ||
        close(fd)) {
        perror("ramen failed on shared memory allocation.\n");
    }

    if (sem_init(&ramen->queue, 1, 5) || sem_init(&ramen->mutex, 1, 1)) {
        perror("ramen failed to init semaphores.\n");
    }

    ramen->eating = 0;
    ramen->waiting = 0;
    ramen->must_wait = 0;
    ramen->seats = seats;

    return ramen;
}

ramen_t *ramen_open(const char *restaurant_name) {
    ramen_t *ramen = NULL;
    int fd = shm_open(restaurant_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if (!fd || ftruncate(fd, sizeof(ramen_t)) ||
        !(ramen = (ramen_t *)mmap(NULL, sizeof(ramen_t), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)) ||
        close(fd)) {
        perror("ramen failed on shared memory allocation.\n");
    }

    return ramen;
}
void ramen_wait(ramen_t *ramen) {
    sem_wait(&ramen->mutex);
    if (ramen->eating < ramen->seats) {
        ramen->eating++;
        if (ramen->eating == ramen->seats) {
            ramen->must_wait = 1;
        }
    } else {
        ramen->waiting++;
        while (ramen->must_wait) {
            sem_post(&ramen->mutex);
            sem_wait(&ramen->queue);
            sem_wait(&ramen->mutex);
        }
        ramen->eating++;
        ramen->waiting--;
        if (ramen->eating < ramen->seats && ramen->waiting > 0) {
            sem_post(&ramen->queue);
        }
    }
    sem_post(&ramen->mutex);
}
void ramen_finish(ramen_t *ramen) {
    sem_wait(&ramen->mutex);
    ramen->eating--;
    if (ramen->eating == 0 && ramen->waiting > 0) {
        ramen->must_wait = 0;
        sem_post(&ramen->queue);
    }
    sem_post(&ramen->mutex);
}

void ramen_destroy(ramen_t *ramen) {
    sem_destroy(&ramen->mutex);
    sem_destroy(&ramen->queue);
}