package narzedzia;

public abstract class Fun2Arg extends Fun1Arg{
    public Fun2Arg() {
        super();
    }
    protected double arg2;
    @Override
    public void dodajArgument(double Argument) throws WyjatekONP {
        if(brakujaceArgumenty()==2) {
            argumenty++;
            arg1 = Argument;
        }else if(brakujaceArgumenty()==1){
            argumenty++;
            arg2 = Argument;
        }
        else throw new WyjatekONP();
    }

    @Override
    public int arnosc() {
        return super.arnosc()+1;
    }
}
