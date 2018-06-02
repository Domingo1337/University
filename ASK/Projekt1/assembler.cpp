#include<iostream>
#include<stdio.h>
#include<vector>
#include<string>
#include<map>
#include<fstream>
#include<algorithm>

using namespace std;

class Instruction {
public:
    int argc = 0; //ile jest argumentow
    Instruction(string input) {
        this->output = input;
        char last;
        int len = 1;
        int current = 0;
        while (current < output.size() && (output[current] == '0' || output[current] == '1' || isspace(output[current])))
            current++;
        if (current < output.size()) {
            last = output[current];
            args[0] = current;
            current = 0;
            for (int i = args[0] + 1; i < output.size(); i++) {
                char c = output[i];
                if (!(c == '0' || c == '1' || isspace(c)))
                    if (c == last)
                        len++;
                    else if (current <= 2) {
                        lens[current++] = len;
                        args[current] = i;
                        last = c;
                        len = 1;
                    }
            }
            if (current <= 2) {
                argc = current + 1;
                lens[current] = len;
            }
        }
    }

    string fill(string arg0, string arg1, string arg2) {
        while (arg0.size() < lens[0]) arg0 = "0" + arg0;
        while (arg1.size() < lens[1]) arg1 = "0" + arg1;
        while (arg2.size() < lens[2]) arg2 = "0" + arg2;
        for (int i = 0; i < lens[0]; i++)
            output[i + args[0]] = arg0[i];
        for (int i = 0; i < lens[1]; i++)
            output[i + args[1]] = arg1[i];
        for (int i = 0; i < lens[2]; i++)
            output[i + args[2]] = arg2[i];
        return output;
    }

private:
    int args[3] = {0,0,0}; // gdzie zaczynaja sie argumenty
    int lens[3] = {0,0,0}; //jak dlugie sa argumenty;
    string output;
};
class InstructionParser {
public:
    InstructionParser(string filename) {
        /// czyta linie pliku w formacie nazwa - spacja - nastepna linia: bajtowy szablon instrukcji
        ifstream file;
        file.open(filename);
        string s;
        while (getline(file, s)) {
            string name;
            int i = 0;
            while (!(isspace(s[i]) || s[i] == '\n'))
                name += s[i++];
            getline(file, s);
            s.erase(remove(s.begin(), s.end(), ' '), s.end());
            /// mapa rozkaz->binary
            imap[name] = new Instruction(s);
        }
        file.close();
        /// mapa reg->binary
        string reg[32]= {"$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                         "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                         "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                         "$t8", "$t9", "$k0", "$k0", "$gp", "$sp", "$fp", "$ra"
                        };
        string bin[32]= {"00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111",
                         "01000", "01001", "01010", "01011", "01100", "01101", "01110", "01111",
                         "10000", "10001", "10010", "10011", "10100", "10101", "10110", "10111",
                         "11000", "11001", "11010", "11011", "11100", "11101", "11110", "11111"
                        };
        for(int i = 0; i<32; i++)
            rmap[reg[i]]=bin[i];
    }

    void parseInstruction(string input) {
        vector < string > vec;
        for (int i = 0; i < input.size(); i++) {
            if (vec.size() >= 4) {
                vec.push_back(input.substr(i - 1));
                break;
            }
            int j = i;
            while (!(j >= input.size() || isspace(input[j++])));
            if(input[j-2]==',')
                vec.push_back(input.substr(i, j - i - 2));
            else
                vec.push_back(input.substr(i, j - i - 1));
            i = j - 1;
        }
        //   cout << "instrukcja:";
        //   for(int i =0 ; i<vec.size(); i++)
        //      cout <<"["<< vec[i] << "]";
        //     cout << endl;
        Instruction * I = imap[vec[0]];
        if (I == 0) {
            cerr << "Invalid instruction\n";
        } else {
            //cout << I->output << endl;
            if (vec.size() >= 4) {
                cout << I->fill(parseArgument(vec[1]), parseArgument(vec[2]), parseArgument(vec[3]));
            } else if (vec.size() == 3) {
                cout << I->fill(parseArgument(vec[1]), parseArgument(vec[2]), "");
            } else if (vec.size() == 2) {
                cout << I->fill(parseArgument(vec[1]), "", "");
            } else {
                cout << I->fill("","","");
                return;
            }
            cout << "\n";
            //   for (int i = I->argc + 1; i < vec.size(); i++)
            //      cout << vec[i];
            //   cout << endl;

        }
    }

    Instruction * get(string name) {
        return imap[name];
    }

    string parseArgument(string arg) {
        if(arg[0]=='$')
            return rmap[arg];
        return arg;
    }

private:
    map<string, Instruction*> imap;
    map<string, string> rmap;
};

int main() {
    InstructionParser IP("instructions.txt");
    Instruction * I = IP.get("add");
    IP.parseInstruction("add $zero, $s1, $t1 #test komentarza");
    IP.parseInstruction("sub 1 10 101\tkomentarz");
    //  cout << IP.parseArgument("$zero") << endl;
    //  cout << IP.parseArgument("$s1") << endl;
    //  cout << IP.parseArgument("$t1") << endl;
    //  cout << IP.parseArgument("$t2,") << endl;
    //  cout << IP.parseArgument("$t3") << endl;
}
