package narzedzia;

import static java.lang.Math.*;

public class Log extends Fun2Arg {
    Log() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        return log(arg1)/log(arg2);
    }

    @Override
    public String toString() {
        return "log";
    }
}
