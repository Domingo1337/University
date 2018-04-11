package obliczenia;

public class Odwrotnosc extends Operator1Arg
{
    public Odwrotnosc (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return 1.0/(arg1.oblicz());
    }
    public String toString () {
        return "(1/"+arg1+")";
    }
}
