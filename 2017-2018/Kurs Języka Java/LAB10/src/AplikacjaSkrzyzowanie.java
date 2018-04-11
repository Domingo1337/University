
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Random;

class Skrzyzowanie extends JPanel {
    int width;
    int height;
    int szerokosc;
    Jezdnia jezdnie[];
    ArrayList samochody = new ArrayList<Samochod>();

    public Skrzyzowanie(int width, int height, int szerokosc) {
        super();
        this.width = width;
        this.height = height;
        this.szerokosc = szerokosc;
        super.setMaximumSize(new Dimension(width, height));
        super.setMinimumSize(new Dimension(width, height));
        super.setPreferredSize(new Dimension(width, height));

        jezdnie = new Jezdnia[4];
        jezdnie[0] = new Jezdnia(Kierunek.gora, szerokosc / 2 - 2, width / 2 + szerokosc / 4, new Point(width / 2 + szerokosc / 4, height), width);
        jezdnie[1] = new Jezdnia(Kierunek.lewo, szerokosc / 2 - 2, height / 2 - szerokosc / 4, new Point(width, height / 2 - szerokosc / 4), width);
        jezdnie[2] = new Jezdnia(Kierunek.dol, szerokosc / 2 - 2, width / 2 - szerokosc / 4, new Point(width / 2 - szerokosc / 4, 0), width);
        jezdnie[3] = new Jezdnia(Kierunek.prawo, szerokosc / 2 - 2, height / 2 + szerokosc / 4, new Point(0, height / 2 + szerokosc / 4), width);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.setColor(Color.green);
        g.fillRect(0, 0, width, height);
        g.setColor(Color.darkGray);
        g.fillRect(0, height / 2 - szerokosc / 2, height, szerokosc);
        g.fillRect(width / 2 - szerokosc / 2, 0, szerokosc, width);
        g.setColor(Color.black);
        for (Jezdnia j : jezdnie)
            namalujJezdnie(g, j);
        for (int i = samochody.size() - 1; i >= 0; i--) {
            if (i < samochody.size()) {
                if (Math.abs(((Samochod) samochody.get(i)).pozycja.x - width / 2) > width || Math.abs(((Samochod) samochody.get(i)).pozycja.y - height / 2) > height) {
                    System.err.print(((Samochod) samochody.get(i)).pozycja);
                    ((Samochod) samochody.get(i)).zatrzymaj();
                    samochody.remove(((Samochod) samochody.get(i)));
                    System.err.println(i);
                } else
                    g.setColor(((Samochod) samochody.get(i)).kolor);
                g.fillRect(((Samochod) samochody.get(i)).pozycja.x - 10, ((Samochod) samochody.get(i)).pozycja.y - 10, 20, 20);
            }
        }
    }

    void namalujJezdnie(Graphics g, Jezdnia jezdnia) {
        g.setColor(Color.black);
        if (jezdnia.kierunek == Kierunek.lewo || jezdnia.kierunek == Kierunek.prawo)
            g.fillRect(0, jezdnia.pozycja - jezdnia.szerokosc / 2, width, jezdnia.szerokosc);
        else if (jezdnia.kierunek == Kierunek.gora || jezdnia.kierunek == Kierunek.dol)
            g.fillRect(jezdnia.pozycja - jezdnia.szerokosc / 2, 0, jezdnia.szerokosc, height);
    }

    @Override
    public void repaint() {
        super.repaint();
    }

    public void dodajSamochod(int j) {
        Random random = new Random();
        int c = random.nextInt(4);
        while (c == j) c = random.nextInt(4);
        Samochod s = new Samochod(random.nextInt(20),  jezdnie[j], jezdnie[c], samochody, new Color(random.nextInt(245) + 10, random.nextInt(245) + 10, random.nextInt(245) + 10));
        samochody.add(s);
        s.start();
    }
}

class Jezdnia {
    final int kierunek;
    final int szerokosc;
    final int dlugosc;
    final int pozycja;
    final Point start;

    public Jezdnia(int kierunek, int szerokosc, int pozycja, Point start, int dlugosc) {
        this.kierunek = kierunek;
        this.szerokosc = szerokosc;
        this.pozycja = pozycja;
        this.start = start;
        this.dlugosc = dlugosc;
    }

    public boolean czyNaJezdni(Samochod samochod) {
        if (kierunek == Kierunek.lewo || kierunek == Kierunek.prawo) {
            if (Math.abs(pozycja - samochod.pozycja.y) < szerokosc / 4) return true;
        } else if (kierunek == Kierunek.gora || kierunek == Kierunek.dol) {
            if (Math.abs(pozycja - samochod.pozycja.x) < szerokosc / 4) return true;
        }
        return false;
    }

}

class Samochod extends Thread {
    Point pozycja;
    int szybkosc;
    Jezdnia jezdnia;
    final Jezdnia cel;
    boolean aktywny;
    ArrayList<Samochod> inne;
    Color kolor;

    public Samochod(int szybkosc, Jezdnia jezdnia, Jezdnia cel, ArrayList inne, Color kolor) {
        this.szybkosc = szybkosc;
        this.jezdnia = jezdnia;
        this.pozycja = new Point(jezdnia.start.x, jezdnia.start.y);
        this.cel = cel;
        this.aktywny = true;
        this.inne = inne;
        this.kolor = kolor;
    }

    @Override
    public void run() {
        while (aktywny) {
            try {
                jedz();
                Thread.sleep(40);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public void zatrzymaj() {
        aktywny = false;
    }

    public void jedz() {
        if (jezdnia.kierunek == Kierunek.dol) pozycja.translate(0, szybkosc);
        else if (jezdnia.kierunek == Kierunek.gora) pozycja.translate(0, -szybkosc);
        else if (jezdnia.kierunek == Kierunek.lewo) pozycja.translate(-szybkosc, 0);
        else if (jezdnia.kierunek == Kierunek.prawo) pozycja.translate(szybkosc, 0);
        for (Samochod s : inne) {
            if (s.kolizja(pozycja)) {
                try {
                    szybkosc = s.szybkosc;
                    sleep(40);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                break;

            }
        }
        if (cel.czyNaJezdni(this)) jezdnia = cel;
    }

    public boolean kolizja(Point p) {
        if (Math.abs(pozycja.x - p.x) < 15) return true;
        if (Math.abs(pozycja.y - p.y) < 15) return true;
        return false;
    }
}

class Kierunek {
    public static final int gora = 0;
    public static final int lewo = 1;
    public static final int dol = 2;
    public static final int prawo = 3;
}

class OknoSkrzyzowania extends JFrame {
    Skrzyzowanie skrzyzowanie;
    JToolBar toolBar;
    JButton[] button = new JButton[4];

    public OknoSkrzyzowania() {
        super("Skrzyżowanie");
        skrzyzowanie = new Skrzyzowanie(1000, 1000, 200);
        setLayout(new BorderLayout());
        add(skrzyzowanie, BorderLayout.CENTER);

        toolBar = new JToolBar();
        button[0] = new JButton("Góra");
        button[1] = new JButton("Lewo");
        button[2] = new JButton("Dół");
        button[3] = new JButton("Prawo");
        for (int i = 0; i < 4; i++) {
            int j = i;
            button[i].addActionListener(e -> skrzyzowanie.dodajSamochod(j));
            toolBar.add(button[i]);
        }
        add(toolBar, BorderLayout.EAST);
        toolBar.setMinimumSize(new Dimension(200, 1000));
        toolBar.setPreferredSize(new Dimension(200, 1000));
        setVisible(true);
        pack();
        setResizable(false);
    }
}

public class AplikacjaSkrzyzowanie {
    public static void main(String[] args) throws InterruptedException {
        OknoSkrzyzowania okno = new OknoSkrzyzowania();
        while (true) {
            try {
                okno.skrzyzowanie.repaint();
                Thread.sleep(40);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
