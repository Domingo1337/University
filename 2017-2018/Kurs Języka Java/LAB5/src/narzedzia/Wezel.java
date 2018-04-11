package narzedzia;

public class Wezel {
    private Object wartosc;
    private  Wezel poprzedni;
    private  Wezel nastepny;

    public Wezel(Object w, Wezel p, Wezel n){
        wartosc = w;
        poprzedni = p;
        nastepny = n;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (getClass() == o.getClass()) {
            Wezel wezel = (Wezel) o;
            return wartosc.equals(wezel.getWartosc());
        }
        else return wartosc.equals(o);
    }

    @Override
    public String toString() {
        return wartosc.toString();
    }

    public Object getWartosc() {
        return wartosc;
    }
    public void setWartosc(Object w){this.wartosc=w;}

    public Wezel getNastepny() {
        return nastepny;
    }

    public void setNastepny(Wezel nastepny) {
        this.nastepny = nastepny;
    }

    public Wezel getPoprzedni() {
        return poprzedni;
    }

    public void setPoprzedni(Wezel poprzedni) {
        this.poprzedni = poprzedni;
    }
}

