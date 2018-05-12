package geometria;

public class Punkt{
		public Punkt(){}
		public Punkt(double X, double Y){
			x = X; y = Y;
		}
		
		protected double x;
		protected double y;
		
		public String toString(){
			return x+" , "+y;
			//return "["+x+" , "+y+"]";
		}
		
		public void przesun(Wektor v){
			x = x+v.dx;
			y = y+v.dy;
		}
		
		/*public void odbij2(Prosta p){
			if(p.a==0){
			y=y-2*(y-p.c);
			}else if(p.b==0){
			x=-x;	
			}else{	
			//Prosta k = new Prosta(-p.b/p.a, 1.0, y-(p.b/p.a*x));
			Punkt q = Prosta.przeciecie(p,new Prosta(p.b/p.a, 1, y-((p.b/p.a)*x)));
			System.out.println(q);
			x=2*q.x-x;
			y=2*q.y-y;	
		}*/
		
		public void odbij(Prosta p){
			if(p.a==0){
			y=y-2*(y+p.c/p.b);
			}else if(p.b==0){
			x=x-2*(x+p.c/p.a);	
			}else{
			 x = 2*(x+(y+p.c/p.b)*(-p.a/p.b))/(1+(p.a*p.a)/(p.b*p.b)) - x;
			 y = 2*(x+(y+p.c/p.b)*(-p.a/p.b))/(1+(p.a*p.a)/(p.b*p.b))*(-p.a/p.b) - y -2*p.c/p.b;
			}
		}
			
		public void obroc(Punkt O, double alfa){
			double xp = (x-O.x) * Math.cos(alfa) - (y-O.y) * Math.sin(alfa) + O.x;
			double yp = (x-O.x) * Math.sin(alfa) + (y-O.y) * Math.cos(alfa) + O.y;
			x = xp;
			y = yp;
		}
				
		public static double odleglosc(Punkt p, Punkt q){
			return Math.sqrt((p.x-q.x)*(p.x-q.x)+(p.y-q.y)*(p.y-q.y));
		}
	}