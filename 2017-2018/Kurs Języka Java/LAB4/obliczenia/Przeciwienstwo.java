package obliczenia;

public class Przeciwienstwo extends Operator1Arg
{
    public Przeciwienstwo (Wyrazenie a1) {
        super(a1);
    }

    public double oblicz () {
        return -arg1.oblicz();
    }
    public String toString () {
        return "-("+arg1+")";
    }
}
