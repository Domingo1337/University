package narzedzia;

import static java.lang.Math.*;

public class Atan extends Fun1Arg {
    Atan() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return atan(arg1);
    }

    @Override
    public String toString() {
        return "atan";
    }
}

