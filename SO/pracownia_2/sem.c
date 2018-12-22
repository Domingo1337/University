/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include "sem.h"

void sem_init(sem_t *sem, unsigned value) {
    sem->value = value;
    sem->wakeups = 0;
    pthread_mutexattr_init(&sem->mutexattr);
    pthread_mutexattr_settype(&sem->mutexattr, PTHREAD_MUTEX_ERRORCHECK_NP);
    pthread_mutex_init(&sem->mutex, &sem->mutexattr);
    pthread_cond_init(&sem->cond, NULL);
}

void sem_wait(sem_t *sem) {
    assert(pthread_mutex_lock(&sem->mutex) == 0);
    sem->value--;
    if (sem->value < 0) {
        while (sem->wakeups <= 0) {
            assert(pthread_cond_wait(&sem->cond, &sem->mutex) == 0);
        }
        sem->wakeups--;
    }
    assert(pthread_mutex_unlock(&sem->mutex) == 0);
}

void sem_post(sem_t *sem) {
    assert(pthread_mutex_lock(&sem->mutex) == 0);
    sem->value++;
    if (sem->value <= 0) {
        sem->wakeups++;
        assert(pthread_cond_signal(&sem->cond) == 0);
    }
    assert(pthread_mutex_unlock(&sem->mutex) == 0);
}

void sem_getvalue(sem_t *sem, int *sval) { *sval = sem->value; }

void sem_destroy(sem_t *sem) {
    pthread_mutex_destroy(&sem->mutex);
    pthread_mutexattr_destroy(&sem->mutexattr);
    pthread_cond_destroy(&sem->cond);
}
