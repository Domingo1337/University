package obliczenia;

import static java.lang.Math.*;

public class Podnies extends Operator2Arg
{
    public Podnies (Wyrazenie a1, Wyrazenie a2) {
        super(a1,a2);
    }

    public double oblicz () {
        return pow(arg1.oblicz(),arg2.oblicz());
    }
    public String toString () {
        return "("+arg1+" ^ "+arg2+")";
    }
}