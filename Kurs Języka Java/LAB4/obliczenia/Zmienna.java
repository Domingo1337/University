package obliczenia;

public class Zmienna extends Wyrazenie{

	public Zmienna(Para p){
		klucz = p.klucz;
		wartosci.wstaw(p);
	}
	
	public final String klucz;
	
	public double oblicz(){
		return wartosci.czytaj(klucz);
	}
	
	public String toString(){
		return klucz;
	}
	
	public static final Zbior wartosci = new Zbior();
	
}