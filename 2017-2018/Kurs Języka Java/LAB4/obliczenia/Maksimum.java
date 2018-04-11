package obliczenia;

import static java.lang.Math.*;

public class Maksimum extends Operator2Arg
{
    public Maksimum (Wyrazenie a1, Wyrazenie a2) {
        super(a1,a2);
    }

    public double oblicz () {
        return max(arg1.oblicz(),arg2.oblicz());
    }
    public String toString () {
        return "max("+arg1+" , "+arg2+")";
    }
}