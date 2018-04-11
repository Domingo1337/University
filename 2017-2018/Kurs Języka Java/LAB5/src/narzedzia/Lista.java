package narzedzia;

import java.util.Objects;

public class Lista<T> {
    public Lista() {
        poczatek = null;
        koniec = null;
    }

    protected Wezel poczatek;
    protected Wezel koniec;

    public T szukaj(String zapytanie) throws WyjatekONP {
        Wezel pomoc = poczatek;
        boolean czyZnaleziono = false;
        while (pomoc != null) {
            if (Objects.equals(pomoc.toString(), zapytanie)) {
                czyZnaleziono = true;
                return (T) pomoc.getWartosc();
            }
            pomoc = pomoc.getNastepny();
        }
        if (!czyZnaleziono)
            throw new ONP_BrakElementu(zapytanie);
        return null;
    }

    public void zmienWartosc(String zapytanie, T wartosc) throws WyjatekONP {
        Wezel pomoc = poczatek;
        boolean czyZnaleziono = false;
        while (pomoc != null) {
            if (Objects.equals(pomoc.toString(), zapytanie)) {
                pomoc.setWartosc(wartosc);
                czyZnaleziono = true;
                break;
            }
            pomoc = pomoc.getNastepny();
        }
        if (!czyZnaleziono)
            throw new ONP_BrakElementu(zapytanie);
    }

    public void dodaj(T wartosc) {
        Wezel nowy = new Wezel(wartosc, null, null);
        if (poczatek == null) {
            poczatek = nowy;
            koniec = nowy;
        } else {
            Wezel pomoc = poczatek;
            while (pomoc.getNastepny() != null) {
                pomoc = pomoc.getNastepny();
            }
            pomoc.setNastepny(nowy);
            nowy.setPoprzedni(pomoc);
            koniec = nowy;
        }
    }

    public void usun(T element) throws WyjatekONP {
        if (poczatek == null)
            throw new ONP_PustaLista();
        else {
            Wezel pomoc = poczatek;
            boolean czyZnaleziono = false;
            while (pomoc != null) {
                if (pomoc.equals(element)) {
                    if (getSize() == 1) {
                        poczatek = null;
                        koniec = null;
                    } else {
                        if (pomoc.getPoprzedni() != null)
                            pomoc.getPoprzedni().setNastepny(pomoc.getNastepny());
                        if (pomoc.getNastepny() != null)
                            pomoc.getNastepny().setPoprzedni(pomoc.getPoprzedni());
                    }
                    czyZnaleziono = true;
                }
                pomoc = pomoc.getNastepny();
            }
            if (czyZnaleziono == false)
                throw new ONP_BrakElementu();
        }
    }

    public T getElement(int indeks) throws WyjatekONP {
        if (poczatek == null)
            throw new ONP_PustaLista();
        Wezel W = poczatek;
        for (int i = 0; i < indeks; i++) {
            W = W.getNastepny();
            if (W == null)
                throw new WyjatekONP();
        }
        return (T) W.getWartosc();
    }

    public int getSize() {
        Wezel pomoc = poczatek;
        int licznik = 0;
        while (pomoc != null) {
            pomoc = pomoc.getNastepny();
            licznik++;
        }
        return licznik;
    }

    void wypisz() throws WyjatekONP {
        if (poczatek == null)
            throw new ONP_PustaLista();
        Wezel pomoc = poczatek;
        do {
            System.out.print(pomoc.getWartosc() + "\t");
            pomoc = pomoc.getNastepny();
        } while (pomoc != null);
        System.out.print("\n");
    }

    void wyczysc(){
        poczatek = null;
        koniec = null;
    }
}
