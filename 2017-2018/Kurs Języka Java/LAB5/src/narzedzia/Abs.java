package narzedzia;

import static java.lang.Math.*;

public class Abs extends Fun1Arg {
    Abs() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return abs(arg1);
    }

    @Override
    public String toString() {
        return "abs";
    }
}