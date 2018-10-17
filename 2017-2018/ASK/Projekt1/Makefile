CC = g++
FLAGS = -Og -Wall -Wextra

all: mips
	$(CC) mips.o main.cpp $(FLAGS) -o main 
mips:
	$(CC) mips.cpp $(FLAGS) -c -o mips.o 
clean:
	rm -f *.o main
