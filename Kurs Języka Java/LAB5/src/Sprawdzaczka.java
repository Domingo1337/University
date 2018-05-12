import narzedzia.*;

import java.io.IOException;
import java.util.Scanner;
import java.util.logging.*;

public class Sprawdzaczka {
    public static void main(String[] args) throws IOException {
        Logger logger = Logger.getLogger(Sprawdzaczka.class.getName());
        Handler handler = new FileHandler("calc.log", true);
        handler.setFormatter(new SimpleFormatter());
        logger.setUseParentHandlers(false);
        logger.addHandler(handler);
        Lista zmienne = new Lista<Zmienna>();
        String zapis = new String();
        Wyrazenie polecenie;
        Scanner wejscie = new Scanner(System.in);
        logger.entering(Sprawdzaczka.class.getName(), "main");
        while ((zapis = wejscie.nextLine()) != null) try {
            assert Wyrazenie.czyKomenda(zapis) : "Bledne polecenie: " + zapis;
            polecenie = new Wyrazenie(zapis, zmienne);
            if (zapis.trim().substring(0, 4).equalsIgnoreCase("calc")) {
                System.out.println(polecenie.obliczWartosc());
                logger.log(Level.INFO, "Obliczenia udane\t'" + zapis + "' wynosi " + polecenie.obliczWartosc());
            } else {
                logger.log(Level.INFO, "Wykonano polecenie " + zapis);
            }
        } catch (WyjatekONP w) {
            System.err.println("Nie udalo sie wykonac polecenia.\nKomunikat bledu: " + w);
            logger.log(Level.INFO, "Polecenie: " + zapis + " Obliczenia nieudane: " + w);
        } catch (AssertionError a) {
            System.err.print(a);
            System.err.println("\nDozwolone komendy:\n" +
                    "1) 'calc' po ktorym wystepuje wyrazenie w postaci postfixowej, ktorego elementy rozdzielone sa pojedyncza spacja.\n" +
                    "2) 'erase' lub 'erase zm' czyszczenie zbioru zmiennych(lub usuniece wybranej zmiennej zm).\n" +
                    "3) 'exit' konczy dzialanie programu.");
            logger.log(Level.INFO, "Polecenie: " + zapis + " Obliczenia nieudane: " + a);
        }
    }
}