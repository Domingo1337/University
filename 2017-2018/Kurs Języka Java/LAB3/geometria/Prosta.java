package geometria;

public class Prosta{
	public Prosta(double A, double B, double C){
		a=A; b=B; c=C;
	}
	public final double a,b,c;
	
	public String toString(){
		//String s = Double.toString(a);
		String s = new String();
		s+=a+"X";
		if(b>=0) s+="+";
		s+=b+"Y";
		if(c>=0) s+="+";
		return s+c+"=0";
		//return a+"x "+b+"y "+c+"=0";
	}
	
	public static Prosta translacja(Prosta p, Wektor v){
		return new Prosta(p.a, p.b, p.c-p.a*v.dx+v.dy);
	}
	
	public static Punkt przeciecie(Prosta k, Prosta l){
		if(czyRownolegle(k,l)) throw new IllegalArgumentException("Podano proste rownolegle"+k+" "+l);
		double x = (k.b*l.c-l.b*k.c)/(k.a*l.b-l.a*k.b);
		double y = (l.a*k.c-k.a*l.c)/(k.a*l.b-l.a*k.b);
		return new Punkt(x,y);
	}
	
	public static boolean czyProstopadle(Prosta k, Prosta l){
		double w = k.a*l.a + l.b*k.b;
		System.out.println("\n"+w+"\n");
		if(k.a*l.a + l.b*k.b == 0.0)
			return true;
		else return false;
	}
	
	public static boolean czyRownolegle(Prosta k, Prosta l){
		if(k.a*l.b - l.a*k.b == 0.0)
			return true;
		else return false;
	}
	

}