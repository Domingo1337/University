package obliczenia;

import static java.lang.Math.*;

public class Atan extends Operator1Arg
{
    public Atan (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return atan(arg1.oblicz());
    }
    public String toString () {
        return "atan("+arg1+")";
    }
}
