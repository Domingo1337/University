#include <iostream>
#include <climits>
#include <cmath>
#include <iomanip>
#include <vector>
#include <algorithm>
#include <functional>

#define PI 3.14159265358979323846

void task_3()
{
    double x = 0.5;
    //print values as in in task 3 but in some order. 0s added for easy gnuplot drawing.
    for (int k = 0; k < 8; k++, x += 1 / 16.)
    {
        std::cout << x << "\t0\n"
                  << x / 2. << "\t0\n"
                  << x * 2. << "\t0\n";
        std::cout << -x << "\t0\n"
                  << x / -2. << "\t0\n"
                  << x * -2. << "\t0\n";
    }
}

void task_6()
{
    //some big numbers
    double x = __DBL_MAX__ / 3.f;
    double y = __DBL_MAX__ / 2.f;

    double u = x * x;
    u = u + y * y;
    double d = sqrt(u);
    std::cout << d << std::endl;
}

void task_6_better()
{
    //some big numbers
    double x = __DBL_MAX__ / 3.f;
    double y = __DBL_MAX__ / 2.f;

    double lesser{}, bigger{};
    if (x >= y)
    {
        bigger = std::abs(x);
        lesser = std::abs(y);
    }
    else
    {
        bigger = std::abs(y);
        lesser = std::abs(x);
    }

    double u = lesser / bigger;
    double d = bigger * sqrt(1. + u * u);
    std::cout << d << std::endl;
}

void task_6_even_better(std::vector<double> v)
{
    double v_max = *(std::max_element(v.begin(), v.end()));
    double t = v_max*v_max;
    double sum = 0.;
    for (auto &it : v)
    {
        sum += (it*it) / t;
    }
    std::cout << std::abs(v_max) * sqrt(sum) << std::endl;
}

void task_7(unsigned k = 30)
{
    double x = 2.;
    double pow2 = 1.;
    for (unsigned i = 1; std::cout << x << "\t[k = " << i << "]\n" && i < k; i++)
    {
        pow2 *= 2.;
        double t = x / pow2;
        x = pow2 * sqrt(2. * (1. - sqrt(1. - t * t)));
    }
}

void task_7_better(unsigned k = 30)
{
    double x = 2.;
    double pow2 = 1.;
    double sqr2 = sqrt(2.);
    for (unsigned i = 1; std::cout << x << "\t[k = " << i << "]\n" && i < k; i++)
    {
        pow2 *= 4.;
        x = sqr2 * x / sqrt(1 + sqrt(1 - x * x / pow2));
    }
}


int main(void)
{
    std::cout << std::setprecision(20);
    // std::cout << std::fixed;
    //task_6();
    //task_6_better();
    //task_6_even_better({100.0, 100.0, 100.0});
    //task_7();
    //task_7_better();
    //std::cout << PI << "  \t[PI]\n";
}
