package narzedzia;

public class Roznica extends Fun2Arg {
    public Roznica() {
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if(brakujaceArgumenty()!=0)
            throw new WyjatekONP();
        return arg2-arg1;
    }
    @Override
    public String toString() {
        return "-";
    }
}