import java.io.Serializable;

public class Pojazd implements Serializable{
    int rocznik;
    String model;
    String kolor;

    public Pojazd(String model, String kolor, int rocznik) {
        this.rocznik = rocznik;
        this.model = model;
        this.kolor = kolor;
    }

}
