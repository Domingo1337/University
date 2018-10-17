package narzedzia;

public class E extends Funkcja {
    public E(){
        super();
    }
    @Override
    public double obliczWartosc() throws WyjatekONP {
        return 2.7182818284590452d;
    }

    @Override
    public String toString() {
        return "e";
    }
}
