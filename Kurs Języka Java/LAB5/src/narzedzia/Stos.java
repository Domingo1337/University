package narzedzia;

public class Stos<Double> extends Lista {
    public double sciagnij() throws WyjatekONP {
        if (koniec == null)
            throw new WyjatekONP();
        double element = (double) koniec.getWartosc();
        if (koniec.getPoprzedni() != null) {
            koniec.getPoprzedni().setNastepny(null);
            koniec = koniec.getPoprzedni();
        } else {
            poczatek = null;
            koniec = null;
        }
        return element;
    }
}
