### Zadanie 6

> Do czego służy system plików proc w systemie Linux?
> Zaprezentuj zawartość przestrzeni adresowej X-serwera wyświetlając plik
`/proc/$PID/maps`, po czym zidentyfikuj w niej poszczególne zasoby pamięciowe
tj. stos, stertę, segmenty programu, pamięć anonimową, pliki odwzorowane
w pamięci, itp.
> Nie zapomnij wyjaśnić znaczenia kolumn wydruku!

##### Manuale i linki
* `man proc`
* http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html

The proc filesystem is a pseudo-filesystem which provides an interface to
kernel data structures.  It is commonly mounted at /proc.  Most of  it  is
read-only,  but  some files allow kernel variables to be changed.


`/proc/PID/cmdline` Command line arguments.
`/proc/PID/cpu` Current and last cpu in which it was executed.
`/proc/PID/cwd` Link to the current working directory.
`/proc/PID/environ` Values of environment variables.
`/proc/PID/exe` Link to the executable of this process.
`/proc/PID/fd` Directory, which contains all file descriptors.
`/proc/PID/maps` Memory maps to executables and library files.
`/proc/PID/mem` Memory held by this process.
`/proc/PID/root` Link to the root directory of this process.
`/proc/PID/stat` Process status.
`/proc/PID/statm` Process memory status information.
`/proc/PID/status` Process status in human readable form.


`df -T /proc`
Filesystem     Type 1K-blocks  Used Available Use% Mounted on
proc           proc         0     0         0    - /proc


##### Columns of /proc/pid/maps

* address - This is the starting and ending address of the region in the
process's address space.
* permissions - This describes how pages in the region can be accessed.
There are four different permissions: read, write, execute,
private (copy on write), and shared. If read/write/execute are disabled,
a '-' will appear instead of the 'r'/'w'/'x'. If a region is not shared, it
is private, so a 'p' will appear instead of an 's'. If the process attempts to
access memory in a way that is not permitted, a segmentation fault is generated.
Permissions can be changed using the mprotect system call.
* offset - If the region was mapped from a file (using mmap), this is
the offset in the file where the mapping begins. If the memory was not mapped
from a file, it's just 0.
* device - If the region was mapped from a file, this is the major and minor
device number (in hex) where the file lives.
* inode - If the region was mapped from a file, this is the file number.
* pathname - If the region was mapped from a file, this is the name of the file.
This field is blank for anonymous mapped regions. There are also special regions with names like [heap], [stack], or [vdso]. [vdso] stands for virtual dynamic shared object. It's used by system calls to switch to kernel mode. Here's a good article about it.



###### Pathname field

The pathname field will usually be the file that is backing the mapping.
For ELF files, you can easily coordinate with the offset field by looking at
the Offset field  in the ELF program headers (readelf -l).

There are additional helpful pseudo-paths:

* [stack] The initial process's (also known as the main thread's) stack.
* [stack:<tid>] A thread's stack (where the <tid> is a thread ID).
	It corresponds to the /proc/[pid]/task/[tid]/ path.
* [vdso] The virtual dynamically linked shared object.
* [heap] The process's heap.

If the pathname field is blank, this is an anonymous mapping as
obtained via mmap(2).


CODE SEGMENT
DATA SEGMENT
