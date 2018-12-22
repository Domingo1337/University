/* Imię nazwisko: Dominik Gulczyński
 * Numer indeksu: 299391
 */

#include <assert.h>
#include <pthread.h>
#include <stdio.h>

typedef struct {
  int value, wakeups;
  pthread_mutex_t mutex;
  pthread_mutexattr_t mutexattr;
  pthread_cond_t cond;
} sem_t;

void sem_init(sem_t *sem, unsigned value);
void sem_wait(sem_t *sem);
void sem_post(sem_t *sem);
void sem_getvalue(sem_t *sem, int *sval);
void sem_destroy(sem_t *sem);
