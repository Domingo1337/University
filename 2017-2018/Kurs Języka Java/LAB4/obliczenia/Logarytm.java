package obliczenia;

import static java.lang.Math.*;

public class Logarytm extends Operator2Arg
{
    public Logarytm (Wyrazenie a1, Wyrazenie a2) {
        super(a1,a2);
    }

    public double oblicz () {
        return log(arg2.oblicz())/log(arg2.oblicz());
    }
    public String toString () {
        return "log("+arg1+" , "+arg2+")";
    }
}