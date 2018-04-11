package narzedzia;

public abstract class Funkcja extends Symbol implements Funkcyjny {
    int argumenty;
    public Funkcja(){
        argumenty = 0;
    }

    public int brakujaceArgumenty() {
        return arnosc()-argumenty;
    }
    public int arnosc(){
        return 0;
    }
    public void dodajArgument(double Argument) throws WyjatekONP {
        throw new WyjatekONP();
    }
}