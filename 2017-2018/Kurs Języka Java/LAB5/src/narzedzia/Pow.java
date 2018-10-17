package narzedzia;

import static java.lang.Math.*;

public class Pow extends Fun2Arg {
    Pow() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return pow(arg2, arg1);
    }

    @Override
    public String toString() {
        return "pow";
    }
}
