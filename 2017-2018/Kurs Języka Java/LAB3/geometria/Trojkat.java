package geometria;

public class Trojkat extends Punkt{

	public Trojkat(Punkt p, Punkt q, Punkt r){
		if(Math.abs(Punkt.odleglosc(p,q)-Punkt.odleglosc(p,r)) < Punkt.odleglosc(q,r) && Punkt.odleglosc(q,r) < (Punkt.odleglosc(p,q)+Punkt.odleglosc(p,r))){
			a = p;
			b = q;
			c = r;
		}else{
			throw new IllegalArgumentException("Punkty ("+p+" ),( "+q+") i ("+r+") nie tworza trojkata");		
		}
	}
	
	protected Punkt a;
	protected Punkt b;
	protected Punkt c;
	
	public String toString(){
		return "("+a+") , ("+b+") , ("+c+")";
	}
	
	public void obroc(Punkt p, double alfa){
		a.obroc(p, alfa);
		b.obroc(p, alfa);
		c.obroc(p, alfa);
	}
	
	public void odbij(Prosta p){
		a.odbij(p);
		b.odbij(p);
		c.odbij(p);
	}
	
	public void przesun(Wektor v){
		a.przesun(v);
		b.przesun(v);
		c.przesun(v);
	}

}