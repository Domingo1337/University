import obliczenia.*;

public class TestWyr
{
    public static void main (String[] args)
    {
        /*Wyrazenie w = new WartBezwzgl(
            new Dodaj(
                new Liczba(7),
                new Mnoz(
                    new Liczba(-3),
                    new Liczba(5)
                )
            )
        );
        System.out.println(w+" = "+w.oblicz());
		*/
		Zmienna x = new Zmienna(new Para("x",-1.618));
		
		Wyrazenie w = new Dodaj(
            new Liczba(3),
            new Liczba(5)
        );
        System.out.println(w+" = "+w.oblicz());
		w = new Dodaj(
            new Liczba(2),
            new Mnoz(
				x,
				new Liczba(7)
			)				
        );
        System.out.println(w+" = "+w.oblicz());
		w = new Dziel(
            new Odejmij(
				new Mnoz(
					new Liczba(3),
					new Liczba(11)
				),
				new Liczba(1)
			),
			new Dodaj(
				new Liczba(7),
				new Liczba(5)
			)
        );
        System.out.println(w+" = "+w.oblicz());
		w = new Atan(
			new Dziel(
				new Mnoz(
					new Dodaj(
						x,
						new Liczba(13)
					),
					x
				),
				new Liczba(2)
			)
		);
		System.out.println(w+" = "+w.oblicz());
		w = new Dodaj(
			new Podnies(
				new Liczba(2),
				new Liczba(5)
			),
			new Mnoz(
				x,
				new Logarytm(
					new Liczba(2),
					new Zmienna(new Para("y",2))
				)
			)
		);
		System.out.println(w+" = "+w.oblicz());		
    }
	
	double d = Double.valueOf(".35");
	new
	System.out.println(d);
	
}
