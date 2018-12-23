CC = gcc -ggdb -pthread
CFLAGS = -Og -std=gnu11 -Wall -Wextra -Wno-unused-parameter -Wno-unused-function

all: zad1 zad2 zad3 zad4 zad5 zad9 zad10

zad1: zad1.o sem.o
zad2: zad2.o sem.o
zad3: zad3.o
zad4: zad4.o bar.o -lrt
zad5: zad5.o ramen.o -lrt
zad9: zad9.o
zad10: zad10.o barbershop.o

clean:
	rm -f zad1 zad2 zad3 zad4 zad5 zad6 zad9 zad10
	rm -f *.o
	rm -f *~

# vim: ts=8 sw=8 noet
