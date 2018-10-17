package obliczenia;

import static java.lang.Math.*;

public class Sin extends Operator1Arg
{
    public Sin (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return sin(arg1.oblicz());
    }
    public String toString () {
        return "sin("+arg1+")";
    }
}
