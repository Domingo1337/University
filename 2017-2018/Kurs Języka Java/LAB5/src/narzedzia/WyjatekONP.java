package narzedzia;

public class WyjatekONP extends Exception {
    public WyjatekONP(){
        super("Wyjatek ONP");
    }
    public WyjatekONP(String komunikat){
        super(komunikat);
    }
}