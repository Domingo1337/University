public class Samochod extends Pojazd {
    String rejestracja;

    public Samochod(int moc, int rocznik, String model, String kolor, String rejestracja) {
        super(moc, rocznik, model, kolor);
        this.rejestracja = rejestracja;
    }

    @Override
    public String toString() {
        return rejestracja+": "+super.toString();
    }
}
