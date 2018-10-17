package narzedzia;

public class Iloraz extends Fun2Arg {
   Iloraz(){
        super();
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if(brakujaceArgumenty()!=0)
            throw new WyjatekONP();
        if(arg1==0)
            throw new ONP_DzielPrzez0();
        return arg2/arg1;
    }

    @Override
    public String toString() {
        return "/";
    }
}