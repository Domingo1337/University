package narzedzia;

public class Zmienna extends Operand {
    public Zmienna (String klucz, double wartosc) {
        this.klucz = klucz;
        this.wartosc = wartosc;
    }

    private String klucz;

    public String getKlucz() {
        return klucz;
    }

    public void setKlucz(String klucz) {
        this.klucz = klucz;
    }

    public void setWartosc(double wartosc) {
        this.wartosc = wartosc;
    }

    @Override
    public String toString() {
        return klucz;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Zmienna zmienna = (Zmienna) o;

        return klucz != null ? klucz.equals(zmienna.klucz) : zmienna.klucz == null;
    }

    @Override
    public double obliczWartosc() {
        return wartosc;
    }
}
