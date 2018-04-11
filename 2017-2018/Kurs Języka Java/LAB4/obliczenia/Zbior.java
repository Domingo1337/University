package obliczenia;

public class Zbior {
	
	Zbior(){
		wartosci = new Para[100];
	}
	Zbior(int n){
		wartosci = new Para[n];
	}
	
	Para wartosci[];
	private int licznik = 0;
	
	/** metoda szuka pary z określonym kluczem */
	public Para szukaj (String kl) {
		for(Para x: wartosci)
			if(x.klucz == kl)
				return x;
		throw new IllegalArgumentException("Nie znaleziono pary o kluczu "+kl);
	}
	/** metoda wstawia do zbioru nową parę */
	public void wstaw (Para p) throws IllegalArgumentException {
		for(int i =0; i<licznik; i++)
			if(wartosci[i].klucz == p.klucz)
				throw new IllegalArgumentException("W zbiorze znajduje sie juz para o kluczu ");
		wartosci[licznik] = p;
		licznik++;
	}
	/** metoda odszukuje parę i zwraca wartość związaną z kluczem */
	public double czytaj (String kl) throws IllegalArgumentException {
		for(Para x: wartosci)
			if(x.klucz == kl)
				return x.getWartosc();
		throw new IllegalArgumentException("W zbiorze nie ma pary o kluczu "+kl);
	}
	
	/** metoda wstawia do zbioru nową albo aktualizuje istniejącą parę */
	public void ustal (Para p) throws IllegalArgumentException {
		for(int i =0; i<=licznik; i++)
			if(wartosci[i]==p){
				wartosci[i]=p;
				break;
			}else if(i==licznik)
				wstaw(p);
	}
	/** metoda podaje ile par jest przechowywanych w zbiorze */
	public int ile () {
		return licznik;
	}
	/** metoda usuwa wszystkie pary ze zbioru */
	public void czysc () {
		wartosci = new Para[wartosci.length];
		licznik = 0;
	}
}