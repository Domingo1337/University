CC = gcc -ggdb
CFLAGS = -Og -std=gnu11 -Wall -Wextra -Wno-unused-parameter -Wno-unused-function

all: zad1 zad2 zad3 zad4 zad5 zad6

zad1: zad1.o
zad2: zad2.o
zad3: zad3.o
zad4: zad4.o
zad5: zad5.o
zad6: zad6.o | libmystr.so
	$(CC) $(CFLAGS) -o $@ $^ -ldl -Wl,-rpath,`pwd`

libmystr.so: strdrop.lo strcnt.lo
	$(CC) -shared -o $@ $^


clean:
	rm -f zad1 zad2 zad3 zad4 zad5 zad6
	rm -f *.o *.so *.lo
	rm -f *~

%.lo: %.c
	$(CC) $(CFLAGS) -fPIC -c -o $@ $^

# vim: ts=8 sw=8 noet
