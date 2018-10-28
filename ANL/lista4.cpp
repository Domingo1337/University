#include <iostream>
#include <cmath>
#include <functional>
#include <limits>
#include <iomanip>

#define PI 3.14159265358979323846
#define PI_2 1.57079632679489661923
#define E 2.71828182845904523536

void task_3()
{
    double a = 0.;
    double b = 1.;

    for (unsigned i = 1; i <= 15; i++)
    {
        double x = (a + b) / 2.;
        double fx = x / pow(E, x) - 0.06064;
        double fa = a / pow(E, a) - 0.06064;

        std::cout << "[" << i << "] f(" << x << ") = " << fx;
        std::cout << "  \t(e: " << x - 0.0646926359947960 << " | " << pow(2., -(double)i - 1.) << ")\n";

        if (fx * fa < 0.)
        {
            b = x;
        }
        else
        {
            a = x;
        }
    }
}

double bisect(std::function<double(double)> f, double a, double b, double e = pow(10., -10.))
{
    double x = (a + b) / 2.;
    double fx = f(x);
    double fa = f(a);
    while (std::abs(fx) > e)
    {
        if (fx * fa < 0.)
        {
            b = x;
        }
        else
        {
            a = x;
        }
        x = (a + b) / 2;
        fx = f(x);
        fa = f(a);
    }
    std::cout << "f(" << x << ") = " << fx << '\n';
    return x;
}

void task_4()
{
    auto f = [](double x) { return x * x - log(x + 2.); };
    std::cout << "Pierwiastki f(x) = x^2 - ln(x+2):\n";

    //f zeruje sie na tych przedzialach:
    bisect(f, -1., 0.);
    bisect(f, 0.5, 1.5);
}

double inverse(double R, double e = 0.0000001)
{
    double x = R <= 1. ? 1. : 0.00001;
    double prev;
    std::cout << x;
    do
    {
        prev = x;
        x = x * (2 - R * x);
        std::cout << " -> " << x;
    } while (std::abs(prev - x) >= e);
    std::cout << "\n"
              << 1. / R << std::endl;
    return x;
}

double newtons(std::function<double(double)> f, std::function<double(double)> deriv, double a, double b, double e = 0.0000000001)
{
    double x = a;
    double fx = f(x);
    while (std::abs(fx) > e)
    {
        x = x - fx / deriv(x);
        fx = f(x);
    }
    return x;
}

double inv_sqrt(double R, double e = 0.0000001)
{
    double x = 0.00001;
    double prev;
    std::cout << x;
    do
    {
        prev = x;
        x = 0.5 * x * (3 - R);
        std::cout << " -> " << x;
    } while (std::abs(prev - x) >= e);
    std::cout << "\n"
              << 1. / R << std::endl;
    return x;
}

void task_5()
{
}

int main()
{
    std::cout << std::setprecision(10);
    std::cout << std::fixed;
    inv_sqrt(0.1);
}