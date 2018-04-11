package narzedzia;

import static java.lang.Math.*;

public class Min extends Fun2Arg {
    Min() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return min(arg1, arg2);
    }

    @Override
    public String toString() {
        return "min";
    }
}

