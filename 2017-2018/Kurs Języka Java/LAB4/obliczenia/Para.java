package obliczenia;

public class Para{

	public final String klucz;
	private double wartosc;
	
	public Para(String k, double w){
		klucz = k;
		wartosc = w;
	}
	
	public String toString(){
		return klucz;
	}
	
	public void setWartosc(double w){
		this.wartosc = w;
	}
	
	public double getWartosc(){
		return wartosc;
	}
	
	public boolean equals(Para p){
		if(klucz == p.klucz)
			return true;
		else return false;
	}
		
}