package narzedzia;

public class Liczba extends Operand {
    public Liczba(double w){
        wartosc = w;
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        return wartosc;
    }

    @Override
    public String toString() {
        return String.valueOf(wartosc);
    }

}
