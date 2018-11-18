### Zadanie 3

> Jaką rolę pełnią sygnały w systemach uniksowych?
> W jakich sytuacjach jądro wysyła sygnał procesowi?
> Kiedy jądro dostarcza sygnały do procesu?
> Co musi zrobić proces by wysłać sygnał albo obsłużyć sygnał?
> Których sygnałów nie można zignorować i dlaczego?
> Podaj przykład, w którym obsłużenie sygnału SIGSEGV lub SIGILL może być
świadomym zabiegiem programisty.

##### Manuale
* `man 7 signal`
* `man 2 sigaction`
* `man 2 sigprocmask`

Sygnały są przede wszystkim po to żeby dostarczać informacje asynchronicznie do procesów z kernela.
Signals are used to notify a process or thread of a particular event.

Sygnały są również używane do innych celów: system operacyjny zamienia na
przykład niektóre wyjątki procesora na sygnały. (np. sygnał SIGFPE – dzielnie przez 0).

Kiedy jądro wysyła sygnał użytkownikowi:
czasem jako reakcję na przerwanie typu dzielenie przez zero SIGFPE, SIGILL, SIGSEGV, SIGBUS.
SIGCHLD - umarło dziecko
SIGPIPE - próbujesz pisać do pipe, którego koniec nie jest otwarty/czytany
SIGALRM - jak sobie ustawimy alarm

The userret() function is executed after processing a trap (e.g., a
system call or interrupt) before returning to user-mode execution.

Żeby obsłużyć sygnał process musi użyć funkcji która powiąże procedurę
odpowiadającą danemu sygnałowi z tym sygnałem.
`sigaction(2)`


Waiting for a signal to be caught
       The following system calls suspend execution of the calling process or thread until a signal is caught (or an unhandled signal terminates the process):

       pause(2)        Suspends execution until any signal is caught.

       sigsuspend(2)   Temporarily changes the signal mask (see below) and suspends execution until one of the unmasked signals is caught.

   Synchronously accepting a signal
       Rather  than  asynchronously catching a signal via a signal handler, it is possible to synchronously accept the signal, that is, to block execution until the signal is delivered,
       at which point the kernel returns information about the signal to the caller.  There are two general ways to do this:

       * sigwaitinfo(2), sigtimedwait(2), and sigwait(3) suspend execution until one of the signals in a specified set is delivered.  Each of these calls returns information  about  the
         delivered signal.

       * signalfd(2)  returns a file descriptor that can be used to read information about signals that are delivered to the caller.  Each read(2) from this file descriptor blocks until
         one of the signals in the set specified in the signalfd(2) call is delivered to the caller.  The buffer returned by read(2) contains a structure describing the signal.



#### Wysyłanie sygnałów

Musi zrobić TRAP do kernela.

The following system calls and library functions allow the caller to send a signal:
* raise(3)        - Sends a signal to the calling thread.
* kill(2)         - Sends a signal to a specified process, to all members of a specified process group, or to all processes on the system.
* killpg(3)       - Sends a signal to all of the members of a specified process group.
* pthread_kill(3) - Sends a signal to a specified POSIX thread in the same process as the caller.
* tgkill(2)       - Sends a signal to a specified thread within a specific process.  (This is the system call used to implement pthread_kill(3).)
* sigqueue(3)     - Sends a real-time signal with accompanying data to a specified process.


Nie można nadpisać, ani zignorować sygnału SIGTERM(źle chyba). (SIGSTOP, SIGKILL)
Powoduje on natychmiastowe zamknięcie procesu. Nie można go zignorować pewnie
dlatego, że jeśli program byłby złośliwy to mógłby próbować uniemożliwić
zamknięcie siebie.
Trzeba mieć jakąś pewność że da się te akcje przeprowadzić.
Nie docierają one także do procesu tylko ich efekty są wykonywane przez jądro.


SIGSEGV SIGSEGKILL
Możę jak program jest debugerem to może to obsłużyć.
Można stos wydłużać za pomocą SIGSEGV.
Emulatory, maszyny wirtualne.

Albo do konwertowania tego na exceptiony C++
https://code.google.com/archive/p/segvcatch/