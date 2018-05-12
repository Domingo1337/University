package narzedzia;

import static java.lang.Math.*;

public class Sgn extends Fun1Arg {
    Sgn() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        if(arg1>0) return 1;
        if(arg1<0) return -1;
        return 0;
    }

    @Override
    public String toString() {
        return "sgn";
    }
}

