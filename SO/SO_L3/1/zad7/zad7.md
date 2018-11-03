### Zadanie 7

> Uruchom aplikację firefox i przy pomocy programu lsof wyświetl zasoby
plikowe należące do procesu przeglądarki.
> Podaj znaczenie poszczególnych kolumn wykazu i zidentyfikuj,
które z wymienionych zasobów są zwykłymi plikami, katalogami, urządzeniami,
gniazdami (sieciowymi lub domeny uniksowej), potokami.
> Przechwyć wyjście z programu lsof przed i po otwarciu
wybranej strony w nowej zakładce, po czym wyświetl różnice poleceniem diff -u.


##### Manuale
* `man lsof`

`sudo lsof -p PID`
`sudo lsof -c firefox`

Columns:

* COMMAND - contains the first nine characters of the name of the UNIX command associated with the process.
* PID
* USER - is the user ID number or login name of the user to whom the process belongs, usually the same as reported by ps
* FD - is the File Descriptor number of the file or:

                       cwd  current working directory;
                       Lnn  library references (AIX);
                       err  FD information error (see NAME column);
                       jld  jail directory (FreeBSD);
                       ltx  shared library text (code and data);
                       Mxx  hex memory-mapped type number xx.
                       m86  DOS Merge mapped file;
                       mem  memory-mapped file;
                       mmap memory-mapped device;
                       pd   parent directory;
                       rtd  root directory;
                       tr   kernel trace file (OpenBSD);
                       txt  program text (code and data);
                       v86  VP/ix mapped file;

* TYPE - is the type of the node associated with the file
* DEVICE - contains the device numbers, separated by commas, for a character special, block special, regular, directory or NFS file;

                  or ``memory'' for a memory file system node under Tru64 UNIX;

                  or the address of the private data area of a Solaris socket stream;

                  or a kernel reference address that identifies the file (The kernel reference address may be used for FIFO's, for example.);

                  or the base address or device name of a Linux AX.25 socket device.

* SIZE/OFF - is the size of the file or the file offset in bytes.
* NODE - is the node number of a local file;

                  or the inode number of an NFS file in the server host;

                  or the Internet protocol type - e.g, ``TCP'';

                  or ``STR'' for a stream;

                  or ``CCITT'' for an HP-UX x.25 socket;

                  or the IRQ or inode number of a Linux AX.25 socket device.

* NAME - is the name of the mount point and file system on which the file resides;

                  or the name of a file specified in the names option (after any symbolic links have been resolved);

                  or the name of a character special or block special device;


An open file may be a regular file, a directory, a block special file,
a character special file, an executing text reference, a library,
a stream or a network file (Internet socket, NFS file or UNIX domain socket.)

