#include <iostream>
#include <cmath>
#include <functional>
#include <limits>
#include <iomanip>

#define PI 3.14159265358979323846
#define PI_2 1.57079632679489661923
#define E 2.71828182845904523536

void task_1a()
{
    double y = 1. / std::cbrt(3.);
    for (double x = y - 0.001; x < y + 0.001; x += 0.0001)
    {
        double x2 = x * x;
        double x5 = x2 * x2 * x;

        std::cout << "x = " << x << "\t";
        std::cout << std::pow(E, x2) - std::pow(E, 3. * x5) << "  <<>>  ";
        std::cout << 1. - x2 + 3. * x5 + 0.5 * x2 * x2 - 3. * x2 * x5 + x5 * x5 * 9. / 2. << "\n";
    }
}

double arcctg(double x)
{
    return PI_2 - atan(x);
}

void task_1b()
{
    // loop for x about 0 and about pi/2
    for (double x = -0.00001; x < 0.00001; x+=0.000001)
    {
        double x2 = x * x;
        double x3 = x * x2;
        double x5 = x * x2 * x2;
        double x7 = x5 * x2;
        double x9 = x7 * x2;
        double x11 = x9 * x2;
        double x_3 = std::pow(x, -3.);

        std::cout << "x = " << x << "\t";
        std::cout << std::pow(x, -3.) * (atan(x) - x) << "  <<>>  ";
        std::cout << x_3 * (-x3/3 + x5/5. - x7/7. + x9/9. - x11/11.) << "\n";
    }
    std::cout << std::endl;
    for (double x = PI_2-0.00001; x < PI_2 + 0.00001; x+=0.000001)
    {
        double x2 = x * x;
        double x3 = x * x2;
        double x5 = x * x2 * x2;
        double x7 = x5 * x2;
        double x9 = x7 * x2;
        double x11 = x9 * x2;
        double x_3 = std::pow(x, -3.);

        std::cout << "x = " << x << "\t";
        std::cout << std::pow(x, -3.) * (atan(x) - x) << "  <<>>  ";
        std::cout << x_3 * (-x3/3 + x5/5. - x7/7. + x9/9. - x11/11.) << "\n";
    }
}

void find_zero(double a, double b, double c)
{
    std::cout << a << "x2 + " << b << "x + " << c << " = 0\n";
    double delta = sqrt(b * b - (4. * a * c));
    double x1 = (-b - delta) / (2. * a);
    double x2 = (-b + delta) / (2. * a);

    double fx1 = a * x1 * x1 + b * x1 + c;
    double fx2 = a * x2 * x2 + b * x2 + c;

    int better = std::abs(fx1) <= std::abs(fx2) ? 1 : 2;
    double x3 = c / (a * (better == 1 ? x1 : x2));

    if (!std::isfinite(x3))
    {
        double ba = -b / a;
        better = std::abs(x1 - ba) > std::abs(x2 - ba) ? 1 : 2;
        x3 = ba - (better == 1 ? x1 : x2);
    }

    std::cout << "x1 = " << x1 << "\tx2 = " << x2 << '\n';
    std::cout << "x3 = " << x3 << " (using x" << better << ")\n";
    std::cout << "f(x1) = " << fx1 << "\nf(x2) = " << fx2 << '\n';
    std::cout << "f(x3) = " << a * x3 * x3 + b * x3 + c << '\n';
}

void task_2()
{
    std::cout << "Zadanie 2\n";

    find_zero(0.00000000001, 9876, -100000000000.0);
    std::cout << std::endl;

    find_zero(-0.000000000000123, 100 * PI, 0.0000000000000013);
    std::cout << std::endl;

    find_zero(-0.0001, -1000, 123456789101234567.);
    std::cout << std::endl;

    find_zero(1.0, 10000000000.0, 1.0);
    std::cout << std::endl;
}

// zeros of x^3 + 3qx -2r = 0
// Cardano-Tartaglii
void find_zero_CT(double q, double r)
{
    std::cout << "f(x) = x^3 + " << 3. * q << "x + " << 2. * r << '\n';
    double c = sqrt(q * q * q + r * r);
    double x_CT = std::cbrt(r + c) + std::cbrt(r + c);

    double d = std::pow(r + c, 2. / 3.);
    double x = 2. * r * d / (d * d + q * d + q * q);

    std::cout << "f(" << x_CT << ") = " << x_CT * x_CT * x_CT + 3. * q * x_CT - 2. * r << '\n';
    std::cout << "f(" << x << ") = " << x * x * x + 3. * q * x - 2. * r << "\n\n";
}

void task_3()
{
    std::cout << "Zadanie 3\n";
    find_zero_CT(0.0000001, 123.);
    find_zero_CT(1., 1.);
    find_zero_CT(123456789., 0.0001);
}

int main(void)
{

    std::cout << std::fixed;
    std::cout << std::setprecision(10);

    task_1b();
}
