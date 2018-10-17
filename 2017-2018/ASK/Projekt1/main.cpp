#include "mips.hpp"

int main(int argc, char **argv){
    if(argc!=2){
        printf("Invalid arguments.\nUse: <./main <filename>> instead.\n");
        return EXIT_FAILURE;
    }
    InstructionParser IP("instructions.dat");
    IP.parseFile(argv[1]);
}
