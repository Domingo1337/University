import java.io.Serializable;

public class Tramwaj extends Pojazd implements Serializable{
    String numer_boczny;

    public Tramwaj(String model, String kolor, int rocznik, String numer_boczny) {
        super(model, kolor, rocznik);
        this.numer_boczny = numer_boczny;
    }

    @Override
    public String toString() {
        return "Tramwaj{" +
                "numer_boczny='" + numer_boczny + '\'' +
                ", model='" + model + '\'' +
                ", kolor='" + kolor + '\'' +
                ", rocznik=" + rocznik +
                '}';
    }
}
