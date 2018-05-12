package narzedzia;

import static java.lang.Math.*;

public class Exp extends Fun1Arg {
    Exp() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return exp(arg1);
    }

    @Override
    public String toString() {
        return "exp";
    }
}

