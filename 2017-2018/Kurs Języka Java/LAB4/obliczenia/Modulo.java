package obliczenia;

import static java.lang.Math.*;

public class Modulo extends Operator2Arg
{
    public Modulo (Wyrazenie a1, Wyrazenie a2) {
        super(a1,a2);
    }

    public double oblicz () {
        return arg1.oblicz()%arg2.oblicz();
    }
    public String toString () {
        return "("+arg1+" mod "+arg2+")";
    }
}