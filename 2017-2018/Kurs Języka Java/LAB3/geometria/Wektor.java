package geometria;

public class Wektor{
		
		public Wektor(double x, double y){
			dx=x; dy=y;			
		}
		
		public final double dx;
		public final double dy;
		
		public String toString(){
		return "[ "+dx+" , "+dy+" ]";
		}
		
		public static Wektor zloz(Wektor v, Wektor w){
			return new Wektor(w.dx+v.dx, w.dy+v.dy);
		}
		
	}