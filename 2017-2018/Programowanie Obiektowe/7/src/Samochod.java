import java.io.Serializable;

public class Samochod extends Pojazd implements Serializable{
    String rejestracja;

    public Samochod(String model, String kolor, int rocznik, String rejestracja) {
        super(model, kolor, rocznik);
        this.rejestracja = rejestracja;
    }

    @Override
    public String toString() {
        return "Samochod{" +
                "rejestracja='" + rejestracja + '\'' +
                ", model='" + model + '\'' +
                ", kolor='" + kolor + '\'' +
                ", rocznik=" + rocznik +
                '}';
    }
}
