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

    for (unsigned i = 0; i <= 15; i++)
    {
        double x = (a + b) / 2.;
        double fx = x / pow(E, x) - 0.06064;
        double fa = a / pow(E, a) - 0.06064;

        std::cout << "[" << i << "] f(" << x << ") = " << fx;
        std::cout << "  \t(e: " << std::abs(x - 0.0646926359947960) << "\t| " << pow(2., -(double)i - 1.) << ")\n";

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

double bisect(std::function<double(double)> f, double a, double b, double e = pow(0.1, 10.))
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
    auto f = [](double x) {
        return x * x - log(x + 2.);
    };
    std::cout << "Pierwiastki f(x) = x^2 - ln(x+2):\n";

    //f zeruje sie na tych przedzialach:
    bisect(f, -1., 0.);
    bisect(f, 0.5, 1.5);
}

double newtons(double x0, std::function<double(double)> next, bool print = true)
{
    double x = x0;
    double prev;
    int i = 0;
    int max_iters = 20;

    do
    {
        prev = x;
        x = next(x);
    } while (prev != x && ++i < max_iters);

    if (print)
    {
        std::cout << "x[" << i << "] = " << x;
    }
    return x;
}

void inverse(double R, double x0)
{
    auto f = [=](double x) {
        return x * (2. - R * x);
    };
    std::cout << "Inverse of " << R << " starting in " << x0 << ":\n";
    newtons(x0, f);
    std::cout << "\t(" << 1. / R << ")\n";
}
void task_5()
{
    double xs[] = {1000000.0};
    for (auto x : xs)
    {
        inverse(x, 1.);
        inverse(x, 0.00000001);
        std::cout << "\n";
    }
}

void inverse_sqrt(double a, double x0)
{
    auto f = [=](double x) {
        return x * (1.5 - 0.5 * a * x * x);
    };
    std::cout << "Inverse sqrt of " << a << " starting in " << x0 << ":\n";
    newtons(x0, f);
    std::cout << "\t(" << 1. / sqrt(a) << ")\n";
}
void task_6()
{
    double xs[] = {0.0001, 0.1, 0.3333333, 0.5, 1.0, 2.0, PI, 1000.0};
    for (auto x : xs)
    {
        inverse_sqrt(x, 1);
        inverse_sqrt(x, 0.00001);
        std::cout << "\n";
    }
}

// a = m * 2^c
double a_sqrt(double m, double c)
{
    auto f = [=](double x) {
        return 0.5 * (x + m / x);
    };
    m = newtons(1., f, false);
    c = 0.5 * c;
    return m * pow(2., c);
}
void task_7()
{
    double ms[] = {0.5, 0.6, 0.7, 0.8, 0.9, 0.99999};
    double cs[] = {1., -123., 120., -2., 20., 3.};
    for (unsigned i = 0; i < sizeof(ms) / sizeof(double); i++)
    {
        double x = ms[i] * pow(2., cs[i]);
        std::cout << "x = " << x << "\n";
        std::cout << "a_sqrt = " << a_sqrt(ms[i], cs[i]) << "\n  sqrt = " << sqrt(x) << "\n\n";
    }
}

int main()
{
    std::cout << std::setprecision(17);
    task_5();
}
