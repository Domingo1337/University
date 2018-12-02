#include <iostream>
#include <cmath>
#include <functional>
#include <limits>
#include <iomanip>

double* moments_of(int n, double x[], double y[]) {
    double *M = new double[n];
    double q[n];
    double u[n];

    q[0] = 0.;
    u[0] = 0.;

    for(int k = 1; k<n; k++) {
        double lk = (x[k] - x[k-1])/(x[k+1] - x[k-1]);
        double pk = lk * q[k-1] + 2.;
        double dk = 6. * (((y[k+1]-y[k]) / (x[k+1]-x[k])) - ((y[k]-y[k-1]) / (x[k]-x[k-1]))) / (x[k+1] - x[k-1]);
        q[k] = (lk - 1) / pk;
        u[k] = (dk - lk * u[k-1])/pk;
    }

    M[n-1] = u[n-1];
    for(int k = n-2; k >= 0; k--) {
        M[k] = u[k] + q[k] * M[k+1];
    }
    M[0] = 0.;

    return M;
}


void NFS(int times, int n, double t[], double x[], double y[]) {
    double* Mx = moments_of(n, t, x);
    double* My = moments_of(n, t, y);
    double delta = 1./ ((double) times);
    double T = 0.;

    for(int k = 1; T <= 1.; k++){
        double hk = t[k] - t[k-1];
        while(T <= t[k]){
            // std::cout << T << "\t";
            std::cout << (Mx[k-1]*(t[k]-T)*(t[k]-T)*(t[k]-T)/6. + Mx[k]*(T-t[k-1])*(T-t[k-1])*(T-t[k-1])/6. + (x[k-1] - Mx[k-1]*hk*hk/6.)*(t[k]-T) + (x[k] - Mx[k]*hk*hk/6.)*(T - t[k-1]))/hk << "\t";
            std::cout << (My[k-1]*(t[k]-T)*(t[k]-T)*(t[k]-T)/6. + My[k]*(T-t[k-1])*(T-t[k-1])*(T-t[k-1])/6. + (y[k-1] - My[k-1]*hk*hk/6.)*(t[k]-T) + (y[k] - My[k]*hk*hk/6.)*(T - t[k-1]))/hk << "\n";
            T+=delta;
        }
    }

    delete[] Mx;
    delete[] My;
}

int main() {
    double x[] = {15.5, 12.5, 8.0,  10.0, 7.0,   4.0,  8.0, 10.0, 9.5,  14.0, 18.0, 17.0, 22.0, 25.0, 19.0, 24.5, 23.0, 17.0, 16.0, 12.5, 16.5, 21.0, 17.0, 11.0, 5.5, 7.5, 10.0, 12.0};
    double y[] = {32.5, 28.5, 29.0, 33.0, 33.0, 37.0, 39.5, 38.5, 42.0, 43.5, 42.0, 40.0, 41.5, 37.0, 35.0, 33.5, 29.5, 30.5, 32.0, 19.5, 24.5, 22.0, 15.0, 10.5, 2.5, 8.0, 14.5, 20.0};

    double t[28];
    for(int i = 0; i <= 27; i++){
        t[i] = ((double) i)/ 27.;
    }

    NFS(10000, 28, t, x, y);
}
