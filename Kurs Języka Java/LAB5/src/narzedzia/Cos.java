package narzedzia;

import static java.lang.Math.*;

public class Cos extends Fun1Arg {
    Cos() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return cos(arg1);
    }

    @Override
    public String toString() {
        return "cos";
    }
}

