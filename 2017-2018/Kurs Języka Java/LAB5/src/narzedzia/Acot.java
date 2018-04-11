package narzedzia;

import static java.lang.Math.*;

public class Acot extends Fun1Arg {
    Acot() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return 1/atan(arg1);
    }

    @Override
    public String toString() {
        return "acot";
    }
}

