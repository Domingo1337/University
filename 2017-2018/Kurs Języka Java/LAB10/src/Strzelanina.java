/*
  Copyright (c) December 2014 by PaweĹ Rzechonek
  Program uruchamia trzy wÄtki i czeka na ich zakoĹczenie.
  Istotne elementy w programie:
    * utworzenie i uruchomienie wÄtku;
    * czekanie na zakoĹczenie pracy wÄtku.
*/

import static java.lang.Math.random;

class Strzelec extends Thread {

    private String strzal;
    private int czas;
    private int ile;

    public Strzelec(String st, int cz, int il) {
        strzal = st;
        czas = cz;
        ile = il;
    }

    public void run() {
        for (int i=0; i<ile; i++)
            try {
                System.out.println(strzal);
                sleep((int)(czas*random()+czas));
            }
            catch(InterruptedException ex) {
                return;
            }
    }
}

public class Strzelanina {

    public static void main(String[] args) throws InterruptedException {
        System.out.println("pojedynek rewolwerowcĂłw");
        Strzelec a = new Strzelec("pif *", 1800, 10);
        Strzelec b = new Strzelec("paf **", 1500, 12);
        Strzelec c = new Strzelec("puf ***", 1200, 15);
        a.start();
        b.start();
        c.start();
        a.join();
        b.join();
        c.join();
        System.out.println("koniec strzelaniny");
    }
}