package geometria;

public class Odcinek extends Punkt{

	public Odcinek(Punkt p, Punkt q){
		if(p!=q){
			a = p;
			b = q;
		}else
			throw new IllegalArgumentException("Punkty "+p+" i "+q+" nie tworza odcinka");
	}
	
	protected Punkt a;
	protected Punkt b;
	
	public String toString(){
		return "("+a+") , ("+b+")";
	}
	
	public void obroc(Punkt p, double alfa){
		a.obroc(p, alfa);
		b.obroc(p, alfa);
	}
	
	public void odbij(Prosta p){
		a.odbij(p);
		b.odbij(p);
	}
	
	public void przesun(Wektor v){
		a.przesun(v);
		b.przesun(v);
	}

}