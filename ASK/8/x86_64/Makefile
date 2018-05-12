# variables for make's implicit rules described at:
# https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html

CC = gcc -g
CFLAGS = -Og -Wall
LDFLAGS = 
ASFLAGS = -g

all: hello main

main: main.o sum.o

%.stripped: %
	objcopy --strip-all --remove-section .note.gnu.build-id $< $@

hello: LDFLAGS += -nostdlib -static
hello: hello.o

clean:
	rm -f hello main *.stripped *.o *~

# vim: ts=8 sw=8 noet
