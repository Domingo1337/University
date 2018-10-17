package obliczenia;

public class Liczba extends Wyrazenie{

	public Liczba(double w){
		wartosc  = w;
	}
	protected final double wartosc;
	
	public double oblicz(){
		return wartosc;
	}
	public String toString(){
		return String.valueOf(wartosc);
	}
}