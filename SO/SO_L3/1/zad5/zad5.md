### Zadanie 5

> W systemach uniksowych istnieje pojęcie hierarchii procesów.
> Uruchom polecenie `ps -eo user,pid,pgid,ppid,tid,pri,stat,wchan,cmd`.
> Na wydruku zidentyfikuj identyfikator, grupę, rodzica oraz właściciela procesu.
> Kto jest rodzicem procesu init?
> Wskaż, które z wyświetlonych zadań są wątkami jądra.
> Jakie jest znaczenie poszczególnych znaków w kolumnie STAT?
> Wyświetl drzewiastą strukturę procesów poleceniem pstree – które zadań są
wątkami?

##### Manuele
* `man ps`

Mamy kolumny:
* USER - effective user name.
* PID  - process id.
* PGID  - process group id.
* PPID - parent process id.
* TID - the unique number representing a dispatchable entity (alias lwp, spid).
This value may also appear as: a process ID (pid); a process group ID (pgrp);
a session ID for the session leader (sid);
a thread group ID for the thread group leader (tgid);
and a tty process group ID for the process group leader (tpgid).
* PRI - priority of the process.  Higher number means lower priority.
* STAT - multi-character process state.  See section PROCESS STATE CODES for
the different values meaning.
* WCHAN - address of the kernel function where the process is sleeping.
* CMD - command with all its arguments as a string. Sometimes the process args
will be unavailable; when this happens, ps will insteadprint the executable
name in brackets.


##### Process State Codes

D - Uninterruptible sleep (usually IO)
R - Running or runnable (on run queue)
S - Interruptible sleep (waiting for an event to complete)
T - Stopped, either by a job control signal or because it is being traced.
t - Stopped by debugger during the tracing.
W - paging (not valid since the 2.6.xx kernel)
X - dead (should never be seen)
Z - Defunct (“zombie”) process, terminated but not reaped by its parent.

For BSD formats and when the stat keyword is used, additional characters may be displayed:
< - high-priority (not nice to other users)
N - low-priority (nice to other users)
L - has pages locked into memory (for real-time and custom IO)
s - is a session leader
l - is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
+ - is in the foreground process group


PID 0: proces w którego kontekście śię inicjalizuje jądro.
PCB: init_task. statycznie w obrazie jądra zaalokowany


Wątki jądra:
`ps -eo user,pid,pgid,ppid,tid,pri,stat,wchan,cmd  | grep "\[k"`


W `pstree` wątki w {} nawiasach.