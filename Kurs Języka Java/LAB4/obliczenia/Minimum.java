package obliczenia;

import static java.lang.Math.*;

public class Minimum extends Operator2Arg
{
    public Minimum (Wyrazenie a1, Wyrazenie a2) {
        super(a1,a2);
    }

    public double oblicz () {
        return min(arg1.oblicz(),arg2.oblicz());
    }
    public String toString () {
        return "min("+arg1+" , "+arg2+")";
    }
}