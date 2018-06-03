#include<cstdio>
#include<cstdlib>
#include<vector>
#include<string>
#include<map>
#include<fstream>

class Instruction {
public:
    Instruction(std::string input, int p0, int l0, int p1, int l1, int p2, int l2) {
        output = input;
        args[0] = p0;
        args[1] = p1;
        args[2] = p2;
        lens[0] = l0;
        lens[1] = l1;
        lens[2] = l2;
    }

    std::string fill(std::string arg0, std::string arg1, std::string arg2) {
        while (arg0.size() < lens[0]) arg0 = "0" + arg0;
        while (arg1.size() < lens[1]) arg1 = "0" + arg1;
        while (arg2.size() < lens[2]) arg2 = "0" + arg2;
        for (unsigned i = 0; i < lens[0]; i++)
            output[i + args[0]] = arg0[i];
        for (unsigned i = 0; i < lens[1]; i++)
            output[i + args[1]] = arg1[i];
        for (unsigned i = 0; i < lens[2]; i++)
            output[i + args[2]] = arg2[i];
        return output;
    }

private:
    unsigned args[3] = {0,0,0}; // gdzie zaczynaja sie argumenty
    unsigned lens[3] = {0,0,0}; //jak dlugie sa argumenty;
    std::string output;
};
class InstructionParser {
public:
    InstructionParser(std::string filename) {
        std::ifstream file;
        file.open(filename);
        std::string name;
        while(file >> name) {
            int p0, p1, p2, l0, l1, l2;
            std::string binary;
            file >> p0 >> l0 >> p1 >> l1 >> p2 >> l2 >> binary;
            imap[name] = new Instruction(binary, p0, l0, p1, l1, p2, l2);

        }
        file.close();
        /// mapa reg->binary
        std::string reg[32]= {"$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                              "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                              "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                              "$t8", "$t9", "$k0", "$k0", "$gp", "$sp", "$fp", "$ra"
                             };
        std::string bin[32]= {"00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111",
                              "01000", "01001", "01010", "01011", "01100", "01101", "01110", "01111",
                              "10000", "10001", "10010", "10011", "10100", "10101", "10110", "10111",
                              "11000", "11001", "11010", "11011", "11100", "11101", "11110", "11111"
                             };
        for(int i = 0; i<32; i++)
            rmap[reg[i]]=bin[i];
    }

    void parseInstruction(std::string input) {
        size_t isize = input.size();
        std::vector <std::string> vec;
        unsigned i = 0;
        //szukanie nazwy
        while(i<isize && !isspace(input[i])) i++;
        vec.push_back(input.substr(0,i++));
        while(i<isize && isspace(input[i])) i++;
        //szukanie argumentów
        while(i<isize && vec.size()<4) {
            int j = i;
            while(j<isize && !isspace(input[j]) && input[j]!=',') j++;
            vec.push_back(input.substr(i,j-i));
            i = j+1;
            while(i<isize && isspace(input[i]) || input[i]==',') i++;
        }
        if (imap.find(vec[0])==imap.end()) {
            fprintf( stderr, "Invalid instruction\t%s\n", input.c_str());
        } else {
            Instruction * I = imap[vec[0]];
            std::string instr;
            if (vec.size() >= 4)
                instr = I->fill(parseArgument(vec[1]), parseArgument(vec[2]), parseArgument(vec[3]));
            else if (vec.size() == 3)
                instr = I->fill(parseArgument(vec[1]), parseArgument(vec[2]), "");
            else if (vec.size() == 2)
                instr = I->fill(parseArgument(vec[1]), "", "");
            else
                instr = I->fill("","","");
            printf("%08x\t%08x\t%s\n", (counter++)<<2, (unsigned)strtol(instr.c_str(),0,2), input.c_str());
        }
    }

    std::string parseArgument(std::string arg) {
        if(arg[0]=='$') {
            if(rmap.find(arg) == rmap.end())
                return parseArgument(arg.substr(1));
            return rmap[arg];
        }
        std::string ret = "";
        unsigned short s = 0;
        if(arg.size() > 1 && arg[0]=='0' && arg[1] == 'x')
            s = strtol(arg.c_str(), 0, 16);
        else
            s = strtol(arg.c_str(),0,10);

        while(s>0) {
            if((s&1)==1) ret = '1'+ret;
            else ret = '0'+ret;
            s/=2;
        }
        return ret;
    }

    void parseFile(std::string filename) {
        std::ifstream file;
        file.open(filename);
        std::string line;
        counter = 0;
        printf(".text\n");
        while(getline(file, line))
            if(line.size()>1)
                parseInstruction(line);
        file.close();
    }

private:
    std::map<std::string, Instruction*> imap;
    std::map<std::string, std::string> rmap;
    unsigned counter;
};
