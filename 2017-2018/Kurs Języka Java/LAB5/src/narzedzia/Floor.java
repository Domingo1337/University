package narzedzia;

import static java.lang.Math.*;

public class Floor extends Fun1Arg {
    Floor() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return floor(arg1);
    }

    @Override
    public String toString() {
        return "floor";
    }
}

