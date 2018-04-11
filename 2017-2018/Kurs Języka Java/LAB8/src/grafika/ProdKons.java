/*
  Copyright (c) December 2014 by Paweł Rzechonek
  Program uruchamia sześć wątków (producenci i konsumenci),
  które pracują na wspólnym zasobie (magazyn).
  Istotne elementy w programie:
    * utworzenie i uruchomienie wątku;
    * synchronizacja pracy wątków za pomocą metod synchronizowanych.
*/

import static java.lang.Math.random;

class Magazyn {

    private int pojemnosc, zapelnienie;
    
    public Magazyn(int poj) {
        if (poj<=0) throw new IllegalArgumentException();
        pojemnosc = poj;
    }

    public synchronized boolean pusty() {
        return zapelnienie == 0;
    }
    public synchronized boolean pelny() {
        return zapelnienie == pojemnosc;
    }
    public synchronized void wstaw() throws InterruptedException {
        while (pelny()) {
            System.out.format("magazyn jest pełny - producent musi poczekać\n");
            wait();
        }
        zapelnienie++;
        notifyAll();
        System.out.format("magazyn nie jest pusty\n");
    }
    public synchronized void pobierz() throws InterruptedException {
        while (pusty()) {
            System.out.format("magazyn jest pusty - konsument musi poczekać\n");
            wait();
        }
        zapelnienie--;
        notifyAll();
        System.out.format("magazyn nie jest pełny\n");
    }
}

class Producent implements Runnable {

    public static volatile boolean praca = true;

    private Magazyn magazyn;    
    private String nazwa;    

    public Producent(Magazyn mag, String naz) {
        magazyn = mag;
        nazwa = naz;
    }

    public void run() {
        while (praca)
            try {
                Thread.currentThread().sleep((int)(Math.random()*1000));
                System.out.format("\t\tproducent %s wyprodukował towar\n", nazwa);
                magazyn.wstaw();
                System.out.format("\t\tproducent %s wstawił towar do magazynu\n", nazwa);
            }
            catch(InterruptedException ex) {
                System.out.println(ex);
                return;
            }
    }
}

class Konsument implements Runnable {

    public static volatile boolean praca = true;

    private Magazyn magazyn;    
    private String nazwa;    

    public Konsument(Magazyn mag, String naz) {
        magazyn = mag;
        nazwa = naz;
    }

    public void run() {
        while (praca)
            try {
                Thread.currentThread().sleep((int)(Math.random()*1000));
                System.out.format("\tkonsument %s potrzebuje towar\n", nazwa);
                magazyn.pobierz();
                System.out.format("\tkonsument %s pobrał towar z magazynu\n", nazwa);
            }
            catch(InterruptedException ex) {
                System.out.println(ex);
                return;
            }
    }
}

public class ProdKons {

    public static void main(String[] args) throws InterruptedException {
        System.out.println("==== początek produkcji ====");
        Magazyn m = new Magazyn(2);
        Producent p1 = new Producent(m, "p1");
        Producent p2 = new Producent(m, "p2");
        Producent p3 = new Producent(m, "p3");
        Konsument k1 = new Konsument(m, "k1");
        Konsument k2 = new Konsument(m, "k2");
        Konsument k3 = new Konsument(m, "k3");
        new Thread(p1).start();
        new Thread(p2).start();
        new Thread(p3).start();
        new Thread(k1).start();
        new Thread(k2).start();
        new Thread(k3).start();
        Thread.currentThread().sleep(2000);
        Producent.praca = false;
        Konsument.praca = false;
        Thread.currentThread().sleep(1000);
        System.out.println("==== koniec konsumpcji ====");
    }
}
