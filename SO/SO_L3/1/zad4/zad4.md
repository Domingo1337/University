### Zadanie 4

> Zaprezentuj metody wysyłania sygnałów z użyciem poleceń kill, pkill i xkill
na programie xeyes.
> Który sygnał jest wysyłany domyślnie?
> Przy pomocy kombinacji klawiszy CTRL+Z wyślij xeyes sygnał SIGSTOP, po czym
wznów jego wykonanie.
> Przeprowadź inspekcję pliku `/proc/$PID/status` i wyświetl maskę sygnałów
zgłoszonych procesowi (ang. pending signals).
> Pokaż jak będzie się zmieniać, gdy będziemy wysyłać wstrzymanemu procesowi
kolejne sygnały, tj. SIGUSR1, SIGUSR2, SIGHUP, SIGINT. Co opisują pozostałe
pola pliku status dotyczące sygnałów?
> Który sygnał zostanie dostarczony jako pierwszy po wybudzeniu procesu?

##### Manuale i linki
* `man 7 signal`
* `man 2 sigaction`
* http://elixir.free-electrons.com/linux/latest/source/kernel/signal.c#L177

Domyślnie wysyłane sygnały:

* kill - SIGTERM
* pkill - SIGTERM
* xkill - Many  existing  applications  do  indeed abort  when  their  connection
to the X server is closed, but some can choose to continue.

xkill strace dump:

`poll([{fd=3, events=POLLIN}], 1, 399)   = 1 ([{fd=3, revents=POLLIN|POLLHUP}])
recvmsg(3, {msg_name(0)=NULL, msg_iov(1)=[{"", 4096}], msg_controllen=0, msg_flags=0}, 0) = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=2995, ...}) = 0
read(4, "# Locale name alias data base.\n#"..., 4096) = 2995
read(4, "", 4096)                       = 0
close(4)                                = 0
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "XIO:  fatal IO error 11 (Resourc"..., 77) = 77
write(2, "      after 415 requests (415 kn"..., 73) = 73
exit_group(1)                           = ?
+++ exited with 1 +++`


Resuming process after SIGSTOP:
`kill -s SIGCONT PID`

Showing process PID when got process name:
`pgrep name`

Maska sygnałów:
Each  thread in a process has an independent signal mask, which indicates
the set of signals that the thread is currently blocking.

Showing pending signals and queue count:
`cat /proc/$(pgrep xeyes)/status | grep Sig`

`SigQ:	0/31076
SigPnd:	0000000000000000
SigBlk:	0000000000000000
SigIgn:	0000000000000000
SigCgt:	0000000000000000`


Rzut okiem na man plik `proc/[pid]/status`

Provides much of the information in /proc/[pid]/stat and /proc/[pid]/statm
in a format that's easier for humans to parse.  Here's an example:
`man 5 proc` -> search status.


                  $ cat /proc/$$/status
                  Name:   bash
                  Umask:  0022
                  State:  S (sleeping)
                  Tgid:   17248
                  Ngid:   0
                  Pid:    17248
                  PPid:   17200
                  TracerPid:      0
                  Uid:    1000    1000    1000    1000
                  Gid:    100     100     100     100
                  FDSize: 256
                  Groups: 16 33 100
                  NStgid: 17248
                  NSpid:  17248
                  NSpgid: 17248
                  NSsid:  17200
                  VmPeak:     131168 kB
                  VmSize:     131168 kB
                  VmLck:           0 kB
                  VmPin:           0 kB
                  VmHWM:       13484 kB
                  VmRSS:       13484 kB
                  RssAnon:     10264 kB
                  RssFile:      3220 kB
                  RssShmem:        0 kB
                  VmData:      10332 kB
                  VmStk:         136 kB
                  VmExe:         992 kB
                  VmLib:        2104 kB
                  VmPTE:          76 kB
                  VmPMD:          12 kB
                  VmSwap:          0 kB
                  HugetlbPages:          0 kB        # 4.4
                  Threads:        1
                  SigQ:   0/3067
                  SigPnd: 0000000000000000
                  ShdPnd: 0000000000000000
                  SigBlk: 0000000000010000
                  SigIgn: 0000000000384004
                  SigCgt: 000000004b813efb
                  CapInh: 0000000000000000
                  CapPrm: 0000000000000000
                  CapEff: 0000000000000000
                  CapBnd: ffffffffffffffff
                  CapAmb:   0000000000000000
                  NoNewPrivs:     0
                  Seccomp:        0
                  Cpus_allowed:   00000001
                  Cpus_allowed_list:      0
                  Mems_allowed:   1
                  Mems_allowed_list:      0
                  voluntary_ctxt_switches:        150
                  nonvoluntary_ctxt_switches:     545

              The fields are as follows:

              * Name: Command run by this process.

              * Umask: Process umask, expressed in octal with a leading
                zero; see umask(2).  (Since Linux 4.7.)

              * State: Current state of the process.  One of "R (running)",
                "S (sleeping)", "D (disk sleep)", "T (stopped)", "T (tracing
                stop)", "Z (zombie)", or "X (dead)".

              * Tgid: Thread group ID (i.e., Process ID).

              * Ngid: NUMA group ID (0 if none; since Linux 3.13).

              * Pid: Thread ID (see gettid(2)).

              * PPid: PID of parent process.

              * TracerPid: PID of process tracing this process (0 if not
                being traced).

              * Uid, Gid: Real, effective, saved set, and filesystem UIDs
                (GIDs).

              * FDSize: Number of file descriptor slots currently allocated.

              * Groups: Supplementary group list.

              * NStgid : Thread group ID (i.e., PID) in each of the PID
                namespaces of which [pid] is a member.  The leftmost entry
                shows the value with respect to the PID namespace of the
                reading process, followed by the value in successively
                nested inner namespaces.  (Since Linux 4.1.)

              * NSpid: Thread ID in each of the PID namespaces of which
                [pid] is a member.  The fields are ordered as for NStgid.
                (Since Linux 4.1.)

              * NSpgid: Process group ID in each of the PID namespaces of
                which [pid] is a member.  The fields are ordered as for NSt‐
                gid.  (Since Linux 4.1.)

              * NSsid: descendant namespace session ID hierarchy Session ID
                in each of the PID namespaces of which [pid] is a member.
                The fields are ordered as for NStgid.  (Since Linux 4.1.)

              * VmPeak: Peak virtual memory size.

              * VmSize: Virtual memory size.

              * VmLck: Locked memory size (see mlock(3)).

              * VmPin: Pinned memory size (since Linux 3.2).  These are
                pages that can't be moved because something needs to
                directly access physical memory.

              * VmHWM: Peak resident set size ("high water mark").

              * VmRSS: Resident set size.  Note that the value here is the
                sum of RssAnon, RssFile, and RssShmem.

              * RssAnon: Size of resident anonymous memory.  (since Linux
                4.5).

              * RssFile: Size of resident file mappings.  (since Linux 4.5).

              * RssShmem: Size of resident shared memory (includes System V
                shared memory, mappings from tmpfs(5), and shared anonymous
                mappings).  (since Linux 4.5).

              * VmData, VmStk, VmExe: Size of data, stack, and text seg‐
                ments.

              * VmLib: Shared library code size.

              * VmPTE: Page table entries size (since Linux 2.6.10).

              * VmPMD: Size of second-level page tables (since Linux 4.0).

              * VmSwap: Swapped-out virtual memory size by anonymous private
                pages;

              * Threads: Number of threads in process containing this
                thread.

              * SigQ: This field contains two slash-separated numbers that
                relate to queued signals for the real user ID of this
                process.  The first of these is the number of currently
                queued signals for this real user ID, and the second is the
                resource limit on the number of queued signals for this
                process (see the description of RLIMIT_SIGPENDING in
                getrlimit(2)).

              * SigPnd, ShdPnd: Number of signals pending for thread and for
                process as a whole (see pthreads(7) and signal(7)).

              * SigBlk, SigIgn, SigCgt: Masks indicating signals being
                blocked, ignored, and caught (see signal(7)).



SIGHUP Term Hangup detected on controlling terminal or death of controlling process

SIGUSR1, SIGUSR2, SIGHUP, SIGINT

Sygnały czasu rzeczywistego są w takiej kolejności jak priorytety, chyba że
2 takie same wtedy w takiej kolejnośći w jakiej przyszły.

W linuxie sygnały standardowe_sync przed sygnałami standardowymi_async.
Sygnały standardowe_async mają priorytety (value).

Wśród standardowych_sync względem priorytetów (value).

#define SYNCHRONOUS_MASK \
  (sigmask(SIGSEGV) | sigmask(SIGBUS) | sigmask(SIGILL) | \
   sigmask(SIGTRAP) | sigmask(SIGFPE) | sigmask(SIGSYS))