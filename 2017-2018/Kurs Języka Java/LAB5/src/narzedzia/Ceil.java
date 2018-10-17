package narzedzia;

import static java.lang.Math.*;

public class Ceil extends Fun1Arg {
    Ceil() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return ceil(arg1);
    }

    @Override
    public String toString() {
        return "ceil";
    }
}

