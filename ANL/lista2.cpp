#include <iostream>

#define PI   3.14159265358979323846
#define PI_2 1.57079632679489661923
#define E    2.71828182845904523536


void task_3(){
    double x = 0.5;
    //print values as in in task 3 in pretty much random order.
    for(int k = 0; k<8; k++, x+= 1/16.){
        std::cout << x << "\n" << x/2. << "\n" << x*2.<< "\n";
        std::cout << -x << "\n" << x/-2. << "\n" << x*-2.<< std::endl;
    }
}

int main(void){
   task_3();
}
