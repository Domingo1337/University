package narzedzia;

public class Pi extends Funkcja {
    public Pi(){
        super();
    }
    @Override
    public double obliczWartosc() throws WyjatekONP {
        return 3.141592653589793d;
    }

    @Override
    public String toString() {
        return "pi";
    }
}
