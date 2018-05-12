package narzedzia;

public abstract class Fun1Arg extends Funkcja{
    public Fun1Arg() {
        super();
    }
    protected double arg1;
    @Override
    public void dodajArgument(double Argument) throws WyjatekONP {
        if(brakujaceArgumenty()==1) {
            argumenty++;
            arg1 = Argument;
        }
        else throw new WyjatekONP();
    }

    @Override
    public int arnosc() {
        return 1;
    }
}
