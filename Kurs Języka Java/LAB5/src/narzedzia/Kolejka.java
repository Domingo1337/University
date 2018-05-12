package narzedzia;

public class Kolejka<Symbol> extends Lista {
    public Symbol obsluz() throws WyjatekONP {
        if (poczatek == null)
            throw new ONP_PustaLista();
        Symbol s = (Symbol)poczatek.getWartosc();
        if (poczatek.getNastepny() != null) {
            poczatek.getNastepny().setPoprzedni(null);
            poczatek = poczatek.getNastepny();
        } else {
            poczatek = null;
            koniec = null;
        }
        return (Symbol) s;
    }
    public Symbol podejrzyj() throws WyjatekONP {
        if (poczatek == null)
            throw new ONP_PustaLista();
        Symbol s = (Symbol)poczatek.getWartosc();
        return (Symbol) s;
    }
}


