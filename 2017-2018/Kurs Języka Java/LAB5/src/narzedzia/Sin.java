package narzedzia;

import static java.lang.Math.*;

public class Sin extends Fun1Arg {
    Sin() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return sin(arg1);
    }

    @Override
    public String toString() {
        return "sin";
    }
}

