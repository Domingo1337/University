#ifndef MIPS_HPP
#define MIPS_HPP

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <map>
#include <string>
#include <vector>

class Instruction {
public:
    Instruction(std::string input, int p0, int l0, int p1, int l1, int p2, int l2);
    std::string fill(std::string arg0, std::string arg1, std::string arg2);
private:
    unsigned args[3];	// gdzie zaczynaja sie argumenty
    unsigned lens[3];	//jak dlugie sa argumenty;
    std::string output;
};

class InstructionParser {
public:
    InstructionParser(std::string filename);

    std::string parseArgument(std::string arg);

    void parseInstruction(std::string input);

    void parseFile(std::string filename);

private:
    std::map<std::string, Instruction*> imap;
    std::map<std::string, std::string> rmap;
    unsigned counter;
};

#endif //MIPS_HPP
