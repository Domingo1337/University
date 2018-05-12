package narzedzia;

public class Wyrazenie implements Obliczalny {
    private Kolejka kolejka = new Kolejka(); // kolejka symboli (elementy typu narzedzia.Symbol)
    private Stos stos = new Stos(); // stos z wynikami posrednimi (elementy typu double)
    private Lista zmienne = new Lista<Zmienna>(); // lista zmiennych (pary String-double)

    public static boolean czyKomenda(String onp) {
        String[] pomoc = onp.trim().split("\\s+");
        if (pomoc[0].equalsIgnoreCase("exit")) return true;
        if (pomoc[0].equalsIgnoreCase("clear") && pomoc.length <= 2) return true;
        if (pomoc[0].equalsIgnoreCase("calc") && pomoc.length >= 2) return true;
        return false;
    }

    /**
     * W konstruktorze nastepuje wczytanie polecenia.
     *
     * @param onp polecenie ONP
     * @param zm  lista zmiennych
     * @throws WyjatekONP gdy nie uda sie wczytac polecenia.
     */
    public Wyrazenie(String onp, Lista zm) throws WyjatekONP {
        zmienne = zm;
        String[] pomoc = onp.trim().split("\\s+");

        if (pomoc[0].equalsIgnoreCase("exit")) {
            System.exit(0);
        } else if (pomoc[0].equalsIgnoreCase("clear")) {
            if (pomoc.length > 1)
                zm.usun(new Zmienna(pomoc[1], 0));
            else {
                zm.wyczysc();
            }
        } else if (pomoc[0].equalsIgnoreCase("calc")) {
            for (int i = 1; i < pomoc.length; i++) {
                if ((pomoc[i].charAt(0) >= '0' && pomoc[i].charAt(0) <= '9') || (pomoc[i].charAt(0) == '-' && pomoc[i].length() > 1)) {
                    boolean czyLiczba = true;
                    for (int j = 1; j < pomoc[i].length(); j++)
                        if ((pomoc[i].charAt(j) < '0' || pomoc[i].charAt(j) > '9') && (pomoc[i].charAt(j) != '.')) {
                            czyLiczba = false;
                            break;
                        }
                    if (czyLiczba) {
                        kolejka.dodaj(new Liczba(Double.valueOf(pomoc[i])));
                    } else throw new WyjatekONP(pomoc[i]);
                } else {
                    if (pomoc[i].equalsIgnoreCase("=")) kolejka.dodaj(new Przypisanie());
                    else if (pomoc[i].equalsIgnoreCase("+")) kolejka.dodaj(new Suma());
                    else if (pomoc[i].equalsIgnoreCase("-")) kolejka.dodaj(new Roznica());
                    else if (pomoc[i].equalsIgnoreCase("*")) kolejka.dodaj(new Iloczyn());
                    else if (pomoc[i].equalsIgnoreCase("/")) kolejka.dodaj(new Iloraz());
                    else if (pomoc[i].equalsIgnoreCase("Min")) kolejka.dodaj(new Min());
                    else if (pomoc[i].equalsIgnoreCase("Max")) kolejka.dodaj(new Max());
                    else if (pomoc[i].equalsIgnoreCase("Pow")) kolejka.dodaj(new Pow());
                    else if (pomoc[i].equalsIgnoreCase("Log")) kolejka.dodaj(new Log());
                    else if (pomoc[i].equalsIgnoreCase("Abs")) kolejka.dodaj(new Abs());
                    else if (pomoc[i].equalsIgnoreCase("Sgn")) kolejka.dodaj(new Sgn());
                    else if (pomoc[i].equalsIgnoreCase("Floor")) kolejka.dodaj(new Floor());
                    else if (pomoc[i].equalsIgnoreCase("Ceil")) kolejka.dodaj(new Ceil());
                    else if (pomoc[i].equalsIgnoreCase("Frac")) kolejka.dodaj(new Frac());
                    else if (pomoc[i].equalsIgnoreCase("Sin")) kolejka.dodaj(new Sin());
                    else if (pomoc[i].equalsIgnoreCase("Cos")) kolejka.dodaj(new Cos());
                    else if (pomoc[i].equalsIgnoreCase("Atan")) kolejka.dodaj(new Atan());
                    else if (pomoc[i].equalsIgnoreCase("Acot")) kolejka.dodaj(new Acot());
                    else if (pomoc[i].equalsIgnoreCase("Ln")) kolejka.dodaj(new Ln());
                    else if (pomoc[i].equalsIgnoreCase("Exp")) kolejka.dodaj(new Exp());
                    else if (pomoc[i].equalsIgnoreCase("E")) kolejka.dodaj(new E());
                    else if (pomoc[i].equalsIgnoreCase("Pi")) kolejka.dodaj(new Pi());
                    else kolejka.dodaj(new Zmienna(pomoc[i], 0));

                }
            }
        }
    }

    /**
     * Metoda wykonuje funkcje podane w konstruktorze klasy.
     *
     * @return Wartosc obliczenia.
     * @throws WyjatekONP gdy podano bledne wejscie.
     */
    public double obliczWartosc() throws WyjatekONP {
            while (kolejka.getSize() > 0) {
                Symbol s = (Symbol) kolejka.obsluz();
                if (s instanceof Liczba) {
                    stos.dodaj(s.obliczWartosc());
                } else if (s instanceof Zmienna) {
                    if (kolejka.getSize() > 0 && kolejka.podejrzyj() instanceof Przypisanie) {
                        Zmienna z = (Zmienna) s;
                        s = (Przypisanie) kolejka.obsluz();
                        ((Przypisanie) s).set(z.getKlucz(), zmienne);
                        ((Funkcja) s).dodajArgument(stos.sciagnij());
                        stos.dodaj(s.obliczWartosc());
                    } else
                        stos.dodaj(((Zmienna) zmienne.szukaj(s.toString())).obliczWartosc());
                } else if (s instanceof Funkcja) {
                    if (kolejka.getSize() > 0 && kolejka.podejrzyj() instanceof Przypisanie)
                        throw new ONP_NiepoprawnyZapis("Nie mozna utworzyc zmiennej o takiej samej nazwie jak funkcja. (" + s.toString() + ")");
                    while (((Funkcja) s).brakujaceArgumenty() > 0)
                        ((Funkcja) s).dodajArgument(stos.sciagnij());
                    stos.dodaj(s.obliczWartosc());
                }
            }
        if (stos.getSize() == 1) {
            double wynik = stos.sciagnij();
            stos.dodaj(wynik);
            return wynik;
        } else throw new ONP_NiepoprawnyZapis();
    }

}