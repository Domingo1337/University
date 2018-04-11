package narzedzia;

public class Suma extends Fun2Arg {
    Suma(){
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if(brakujaceArgumenty()!=0)
            throw new WyjatekONP();
        return arg1+arg2;
    }

    @Override
    public String toString() {
        return "+";
    }
}
