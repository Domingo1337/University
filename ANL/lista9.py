import matplotlib.pyplot as plt
import numpy as np
from scipy import special

binom = special.binom

def Bernstein(n, i):
    b = binom(n, i)

    def fun(t):
        if t == 0.:
            if i == 0.:
                return 1.
            return 0.
        if t == 1.:
            if i == n:
                return 1.
            return 0.
        return b * (t**i) * ((1-t)**(n-i))
    return fun


def Beizer(W, w):
    n = len(W)
    if n != len(w):
        raise AttributeError('W and w must be of equal length')
    B = []
    for i in range(n):
        B.append(Bernstein(n-1, i))

    def fun(t):
        den = 0.
        x = 0.
        y = 0.
        for i in range(n):
            multiplier = w[i] * B[i](t)
            den += multiplier
            x += multiplier * W[i][0]
            y += multiplier * W[i][1]
        return (x/den, y/den)
    return fun


W = [(0, 0), (3.5, 36), (25, 25), (25, 1.5), (-5, 3), (-5, 33),
     (15, 11), (-0.5, 35), (19.5, 15.5), (7, 0), (1.5, 10.5)]

w = [1, 6, 4, 2, 3, 4, 2, 1, 5, 4, 1]

beizer = Beizer(W, w)


n = 1000
x = []
y = []
for i in range(n+1):
    point = beizer(i/n)
    x.append(point[0])
    y.append(point[1])

plt.axis('equal')

while(True):
    plt.clf()
    plt.plot(x, y)
    for i in range(len(W)):
        plt.scatter(W[i][0], W[i][1], 10*w[i])
        plt.annotate('p '+str(i), (W[i][0], W[i][1]))

    plt.show(block=False)
    print('Points\t', W)
    print('Weights\t', w)
    s = input("Change weight of: ")
    i = int(s)
    s = input("to: ")
    w[i] = int(s)
    for i in range(n+1):
        point = beizer(i/n)
        x[i] = point[0]
        y[i] = point[1]
    plt.plot(x,y)
    plt.show(block=False)
    input('')
