#include <iostream>
#include <cstdio>
#include <cmath>
#include <math.h>

#define PI 3.14159265358979323846
#define PI_2 1.57079632679489661923

double my_sin(double x) {
    double sign = x<0. ? -1. : 1.;
    x = std::abs(x);

    while(x > 2*PI) {
        x = x - 2*PI;
    }
    if(x > PI) {
        x = x - PI;
        sign = -sign;
    }
    if(x > PI_2) {
        x = PI - x;
    }

    double x2 = x * x;
    double x3 = x * x2;
    double x5 = x3 * x2;
    double x7 = x5 * x2;
    double x9 = x7 * x2;

    return sign * (x - x3/6. + x5/120. - x7/5040. + x9/362880.);
}

double check_sin(double x, bool printResult = false) {
    double sinx = sin(x);
    double my_sinx = my_sin(x);
    double difference = std::abs(sinx - my_sinx);
    if(printResult)
        std::cout <<  x << "\t" <<  sinx << "\t" <<  my_sinx << "\t" <<  difference << std::endl;
    return difference;
}

void task_5() {
    std::cout << "Zadanie 5" << std::endl;

    double max_r = 0.0;
    double max_x = 0.0;
    for(double x = -3 * PI; x< 3*PI; x+=0.001) {
        double temp = check_sin(x);
        if (temp > max_r) {
            max_r = temp;
            max_x = x;
        }
    }

    std::cout << "Najwieksza roznica = " << max_r << " (x = " << max_x << ")" << std::endl;

}

void task_7() {
    std::cout << "Zadanie 7" << std::endl;
    size_t len = 20;
    float I[len];

    I[0] = 0.18232155679f;

    for(size_t n = 1; n < len; n++) {
        I[n] = 1.f/(float)n - 5.f*I[n-1];
        std::cout << "I[" << n << "] = " << I[n] << std::endl;
    }
}



int main(void) {
    task_5();
}
