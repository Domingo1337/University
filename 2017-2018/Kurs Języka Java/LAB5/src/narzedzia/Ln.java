package narzedzia;

import static java.lang.Math.*;

public class Ln extends Fun1Arg {
    Ln() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return log(arg1);
    }

    @Override
    public String toString() {
        return "ln";
    }
}

