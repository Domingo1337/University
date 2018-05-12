import geometria.*;

public class Sprawdzarka{

	public static void main(String[] args){
		System.out.println("0. Punkty, odcinki i trojkaty: ");
		Punkt A = new Punkt(1 , 1);
		Punkt B = new Punkt(1.55 , 0.667);
		Odcinek D = new Odcinek(new Punkt(2.0, 0.33),new Punkt(3.23, 6.69));
		Trojkat E = new Trojkat(new Punkt(2.0, 0.33),new Punkt(3.23, 6.69), new Punkt(15.66, 897.32));		
		int alfa = new Integer(args[0]);
		System.out.println(A);
		System.out.println(D);
		System.out.println(E);
	
		System.out.println("\n1. Obracanie o kat: "+alfa+" stopni "+"wzgledem punktu "+B);
		for(int i = 0; i< 360/alfa; i++){
			A.obroc(B, Math.toRadians(alfa));
			D.obroc(B, Math.toRadians(alfa));
			E.obroc(B, Math.toRadians(alfa));
			System.out.println(A);
			System.out.println(D);
			System.out.println(E);
		}
		
		Wektor V = new Wektor(40.0, 2.45);
		System.out.println("\n2. Translacja o wektor "+V);
		A.przesun(V);
		D.przesun(V);
		E.przesun(V);
		System.out.println(A);
		System.out.println(D);
		System.out.println(E);
		
		Prosta k = new Prosta(3.33, -1 , 10);
		System.out.println("\n3. Odbijanie wzgledem prostej "+k);
		A.odbij(k);
		D.odbij(k);
		E.odbij(k);
		System.out.println(A);
		System.out.println(D);
		System.out.println(E);
		
		Wektor W = new Wektor(-32.323, 0.9083);
		System.out.println("\n4. Wektory "+V+" i "+W);
		V = Wektor.zloz(V,W);
		System.out.println("Zlozenie: "+V);
		
		
		Prosta l = new Prosta(1/3.33,-1,-1000);
		System.out.println("\n5. Proste\t"+k+" i "+l);
		System.out.println("Przeciecie prostych to: "+Prosta.przeciecie(k,l));
		System.out.println("Czy proste sa rownolegle: "+Prosta.czyRownolegle(k,l)+", prostopadle: "+Prosta.czyProstopadle(k,l));
		System.out.println("Translacja o wektor: "+V);
		System.out.println(Prosta.translacja(k,V)+"\t"+Prosta.translacja(l,V));
		
		
	}
	
}