#include <iostream>
#include <cmath>
#include <functional>
#include <limits>
#include <iomanip>
#include <assert.h>

#define PI   3.14159265358979323846
#define PI_2 1.57079632679489661923
#define E    2.71828182845904523536

double calc_e_minus_one(double exp, unsigned k = 200){
    double result = 0.;
    double num = 1.;
    double den = 1.;
    for(double i = 1; i<=k; i+=1.){
        num *= exp;
        den *= i;
        result += num/den;
    }

    return result;
}

void task_1a(double x){
    //calculate e^x2 - e^3x5
    double x2 = x*x;
    double three_x5 = 3*x*x*x*x*x;
    double first = std::pow(E, x2) - std::pow(E, three_x5);
    double second = -std::pow(E, x2)*calc_e_minus_one(three_x5-x2);
    std::cout << "e^" << x2 << "-e^"<<three_x5<<" = \t" << first <<"   <<>>  " << second << std::endl;
}

void task_1(){
    double x = 0.6933612;
    while(x < 0.69336153){
        task_1a(x);
        x+=0.000000005;
    }
}

int main(void)
{
    std::cout << std::fixed;
    std::cout << std::setprecision(15);
    task_1();
    task_1a(0.0000001);
}
