import java.io.Serializable;

public class Pojazd implements Serializable{
    int moc;
    int rocznik;
    String model;
    String kolor;

    public Pojazd(int moc, int rocznik, String model, String kolor) {
        this.moc = moc;
        this.rocznik = rocznik;
        this.model = model;
        this.kolor = kolor;
    }

    @Override
    public String toString() {
       return kolor+" "+model+" "+String.valueOf(rocznik)+"r. "+String.valueOf(moc)+"KM";
    }
}
