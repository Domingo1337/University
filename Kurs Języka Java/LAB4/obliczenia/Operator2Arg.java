package obliczenia;

public abstract class Operator2Arg extends Operator1Arg
{
    protected final Wyrazenie arg2;

    public Operator2Arg (Wyrazenie a1, Wyrazenie a2) {
        super(a1);
        if (a2==null) throw new IllegalArgumentException();
        arg2 = a2;
    }
}
