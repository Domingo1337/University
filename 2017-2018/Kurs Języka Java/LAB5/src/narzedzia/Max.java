package narzedzia;

import static java.lang.Math.*;

public class Max extends Fun2Arg {
    Max() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return max(arg1, arg2);
    }

    @Override
    public String toString() {
        return "max";
    }
}

