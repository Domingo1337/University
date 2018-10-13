#include <iostream>
#include <cmath>
#include <functional>
#include <limits>
#include <iomanip>
#include <assert.h>

#define PI   3.14159265358979323846
#define PI_2 1.57079632679489661923
#define E    2.71828182845904523536

void find_zero(double a, double b, double c)
{
    std::cout << "f(x) = " << a << "x^2 + " << b << "x + " << c << std::endl;

    double delta = b * b - 4. * a * c;
    if (delta < 0)
    {
        std::cerr << "delta < 0!!!";
        return;
    }
    delta = sqrt(delta);
    std::cout << "sqrt(delta): " << delta << "\n";
    double x1 = (-b + delta) / (2. * a);
    double x2 = (-b - delta) / (2. * a);
    std::cout << "f(" << x1 << ") = " << a * x1 * x1 + b * x1 + c << std::endl;
    std::cout << "f(" << x2 << ") = " << a * x2 * x2 + b * x2 + c << std::endl;
}

double my_sin(double x)
{
    double sign = x < 0. ? -1. : 1.;
    x = std::abs(x);

    while (x > 2 * PI)
    {
        x = x - 2 * PI;
    }
    if (x > PI)
    {
        x = x - PI;
        sign = -sign;
    }
    if (x > PI_2)
    {
        x = PI - x;
    }

    double x2 = x * x;
    double x3 = x * x2;
    double x5 = x3 * x2;
    double x7 = x5 * x2;
    double x9 = x7 * x2;

    return sign * (x - x3 / 6. + x5 / 120. - x7 / 5040. + x9 / 362880.);
}

double check_sin(double x, bool printResult = false)
{
    double sinx = sin(x);
    double my_sinx = my_sin(x);
    double difference = std::abs(sinx - my_sinx);
    if (printResult)
        std::cout << x << "\t" << sinx << "\t" << my_sinx << "\t" << difference << std::endl;
    return difference;
}

double ACTG(double x)
{
    assert(x >= -1. && x <= 1.);
    return PI_2 - atan(x);
}

double arcctg(double x)
{
    if(x>= -1. && x <= 1.)
        return ACTG(x);
    else if(x > 1.)
        return PI_2 - ACTG(1./x);
    else
        return PI + PI_2 - ACTG(1./x);
}

void derivative_check(std::function<double(double)> f, std::function<double (double)> derivative, double x, unsigned n = 30)
{
    double fx = f(x);
    double actual = derivative(x);
    std::cout << "f(" << x << ") = " << fx << std::endl;
    std::cout << "f'(" << x << ") = " << actual << std::endl;
    std::cout << "h    \t: standard error \t: symmetrical error" << std::endl;
    double h = 1.;
    for(unsigned i = 0; i<n; i++, h/=2.)
    {
        double standard = (f(x + h) - fx) / h;
        double symmetrical = (f(x + h) - f(x - h)) / (2. * h);
        std::cout << h  << " \t: " << std::abs(actual - standard) << " \t: " << std::abs(actual - symmetrical) << std::endl;
    }
}

void task_1()
{
    std::cout << "Zadanie 1" << std::endl;

    find_zero(0.00000000001, 9876, -100000000000.0);
    std::cout << std::endl;

    find_zero(-0.000000000000123, 100*PI, 0.0000000000000013);
    std::cout << std::endl;

    find_zero(-0.0001, -1000, 123456789101234567.);
    std::cout << std::endl;

    std::cout << "przyklady z wykladu" << std::endl;
    find_zero(1.0, 1000000000.0, 1.0);
    find_zero(1.0, 10000000000.0, 1.0);
}

void task_2()
{
    std::cout << "Zadanie 2" << std::endl;

    size_t len = 20;
    double x[len];
    double seventh = -1 / 7.;
    double acc = 1;
    x[0] = 1.;
    x[1] = seventh;
    std::cout << x[0] << "\t" << acc << std::endl;
    acc *= seventh;
    std::cout << x[1] << "\t" << acc << std::endl;
    acc *= seventh;
    for (size_t i = 2; i < len; i++, acc *= seventh)
    {
        x[i] = 2. * x[i - 2] / 7. + 13 * x[i - 1] / 7.;
        std::cout << x[i] << "  \t(-1/7)^" << i+1 << " = " << acc << std::endl;
    }
}

void task_3()
{
    std::cout << "Zadanie 3" << std::endl;

    double pi = 0;
    double sign = 1;
    unsigned k;
    for (k = 0; std::abs(PI - pi) >= 0.00001; k++, sign = -sign)
        pi += 4. * sign / (2. * k + 1.);
    std::cout << "Przyblizone pi = " << pi << " po " << k << " iteracjach. Roznica: " << std::abs(PI - pi) << std::endl;
}

void task_5()
{
    std::cout << "Zadanie 5" << std::endl;

    double max_r = 0.0;
    double max_x = 0.0;
    for (double x = -3 * PI; x < 3 * PI; x += 0.001)
    {
        double temp = check_sin(x);
        if (temp > max_r)
        {
            max_r = temp;
            max_x = x;
        }
    }

    std::cout << "Najwieksza roznica = " << max_r << " (x = " << max_x << ")" << std::endl;
}

void task_6()
{
    std::cout << "Zadanie 6" << std::endl;
    double max_r = 0.;
    double max_x = 0.;
    for(double x = -3.*PI; x<3.*PI; x+=0.001)
    {
        double y1 = PI_2 - atan(x);
        double y2 = arcctg(x);
        if(std::abs(y1-y2)>max_r)
        {
            max_r = std::abs(y1-y2);
            max_x = x;
        }
    }
    std::cout << "Najwieksza roznica = " << max_r << " (x = " << max_x << ")" << std::endl;
}

void task_7()
{
    std::cout << "Zadanie 7" << std::endl;
    size_t len = 20;
    float I[len+1];

    I[0] = 0.18232155679f;

    for (size_t n = 1; n < len+1; n++)
    {
        I[n] = 1.f / (float)n - 5.f * I[n - 1];
        std::cout << "I[" << n << "] = " << I[n] << std::endl;
    }
}

void task_8()
{
    std::cout << "Zadanie 8" << std::endl;
    std::cout << "sin" << std::endl;
    derivative_check([](double x){return sin(x);},
                     [](double x){return cos(x);},
                     PI_2);

    std::cout << "\nx^3 - x^2 + x" << std::endl;
    derivative_check([](double x){return x*x*x - x*x + x;},
                     [](double x){return 3.*x*x - 2.*x + 1.;},
                     0.000123);

    std::cout << "\natan" << std::endl;
    derivative_check([](double x){return atan(x);},
                     [](double x){return 1./(x*x+1);},
                     0.);
}

int main(void)
{
    //std::cout << std::fixed;
    //std::cout << std::setprecision (std::numeric_limits<double>::digits10 + 1);
    //task_1();
    //task_2();
    //task_3();
    //task_5();
    //task_6();
    task_7();
    //task_8();
    //task_8();
}
