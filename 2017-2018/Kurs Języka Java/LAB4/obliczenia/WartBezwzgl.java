package obliczenia;

import static java.lang.Math.*;

public class WartBezwzgl extends Operator1Arg
{
    public WartBezwzgl (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return abs(arg1.oblicz());
    }
    public String toString () {
        return "|"+arg1+"|";
    }
}
