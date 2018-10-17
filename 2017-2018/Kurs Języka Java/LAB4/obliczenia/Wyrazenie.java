package obliczenia;

public abstract class Wyrazenie {
	/** dziedziczona metoda zwracająca wartość wyrażenia jako double */
	public abstract double oblicz();
	
	//** dziedziczona metoda zwracająca wyrażenie w postaci tekstowej */
	public abstract String toString();
	
	/** metoda sumująca wyrażenia */
	public static double sumuj (Wyrazenie... wyr) {
		double wynik = 0;
		for(int i =0; i<wyr.length; i++)
			wynik+=wyr[i].oblicz();
		return wynik;
	}
	
	/** metoda mnożąca wyrażenia */
	public static double pomnoz (Wyrazenie... wyr) {
		double wynik = 1;
		for(int i =0; i<wyr.length; i++)
			wynik*=wyr[i].oblicz();
		return wynik;	
	}
}