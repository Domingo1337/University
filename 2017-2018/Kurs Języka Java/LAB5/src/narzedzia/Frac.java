package narzedzia;

import static java.lang.Math.*;

public class Frac extends Fun1Arg {
    Frac() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return arg1-floor(arg1);
    }

    @Override
    public String toString() {
        return "frac";
    }
}