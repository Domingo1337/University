package obliczenia;

import static java.lang.Math.*;

public class Cos extends Operator1Arg
{
    public Cos (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return cos(arg1.oblicz());
    }
    public String toString () {
        return "cos("+arg1+")";
    }
}
