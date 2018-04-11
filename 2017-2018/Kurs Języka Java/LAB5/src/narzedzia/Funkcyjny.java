package narzedzia;

public interface Funkcyjny extends Obliczalny
{
    int arnosc ();
    int brakujaceArgumenty ();
    void dodajArgument (double Argument) throws WyjatekONP;
}