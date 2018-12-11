
RWLock = {
    owner: Thread,
    readers: int,
    critsec: Mutex,
    noreaders: CondVar,
    nowriter: CondVar,
    writer: Mutex,
}


init(RWLock l):
    readers = 0
    owner = null


rdlock(RWLock l):
    lock(critsec)
    while (owner != null)
        cv_wait (nowriter, critsec)
    readers += 1
    unlock(critsec)


wrlock(RWLock l):
    lock(writer)
    lock(critsec)

    while (owner != null)
        cv_wait (nowriter, critsec)

    while (readers > 0)
        cv_wait (noreaders, critsec)

    owner = current_thread()
    unlock (critsec)


unlock(RWLock l):
    lock(critsec)
    if (owner == current_thread())
        owner = null
        unlock(writer)
        nowriter = true
    else
        readers -= 1
        if (readers == 0)
            noreaders = true

    unlock (critsec)
