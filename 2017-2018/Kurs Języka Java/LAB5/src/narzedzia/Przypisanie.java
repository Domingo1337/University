package narzedzia;

public class Przypisanie extends Fun1Arg {
    public Przypisanie() {
        super();
        klucz = null;
        zmienne = null;
    }

    private String klucz;
    private Lista zmienne;

    public void set(String klucz, Lista zmienne) {
        this.klucz = klucz;
        this.zmienne = zmienne;
    }

    @Override
    public double obliczWartosc() throws WyjatekONP {
        if (brakujaceArgumenty() != 0)
            throw new WyjatekONP();
        if ((klucz != null) && (zmienne != null)) {
            try {
                zmienne.zmienWartosc(klucz, new Zmienna(klucz, arg1));
            } catch (ONP_BrakElementu w) {
                zmienne.dodaj(new Zmienna(klucz, arg1));
            }
            return arg1;
        } else
            throw new WyjatekONP();
    }

    @Override
    public String toString() {
        return "=";
    }
}