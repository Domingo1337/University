package grafika;

import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.List;

class Kreska
{
    protected Point poczatek, koniec;
    public final Color kolor;

    public Kreska(Point poczatek, Point koniec, Color kolor) {
        this.poczatek = poczatek;
        this.koniec = koniec;
        this.kolor = kolor;
    }
}

class Okno extends Frame {

    Canvas plotno = new Canvas();
    boolean czyRysowac = false;

    Point start;

    List<Kreska> kreski = new ArrayList<Kreska>();

    Color kolor = Color.RED;
    CheckboxGroup kolory = new CheckboxGroup();  Checkbox c1 = new Checkbox("Czerwony",  kolory, true);
    Checkbox c2 = new Checkbox("Zielony",   kolory, false);
    Checkbox c3 = new Checkbox("Niebieski", kolory, false);
    Checkbox c4 = new Checkbox("Amarantowy",kolory, false);
    Checkbox c5 = new Checkbox("Żółty",     kolory, false);
    Checkbox c6 = new Checkbox("Cyjanowy",  kolory, false);
    Checkbox c7 = new Checkbox("Biały",     kolory, false);
    Checkbox c8 = new Checkbox("Szary",     kolory, false);
    Checkbox c9 = new Checkbox("Czarny",    kolory, false);

    Button przycTla = new Button("Zmień tło");

    TextField poleTkst = new TextField("Usuwanie kresek: [F] - pierwszej; [L] - ostatniej; [BCKSPC] - wszystkich;");

    void narysujKreski(Graphics gr) {
        gr.clearRect(0, 0, super.getWidth(), super.getHeight());
        for (Kreska k : kreski) {
            gr.setColor(k.kolor);
            gr.drawLine((int) k.poczatek.getX(), (int) k.poczatek.getY(), (int) k.koniec.getX(), (int) k.koniec.getY());
        }
    }

    void narysujJednaKreske(Kreska k, Graphics gr) {
        gr.setColor(k.kolor);
        gr.drawLine((int) k.poczatek.getX(), (int) k.poczatek.getY(), (int) k.koniec.getX(), (int) k.koniec.getY());
    }

    WindowListener windowList = new WindowAdapter() {
        @Override
        public void windowClosing(WindowEvent ev) {
            Okno.this.dispose();
        }
    };

    MouseListener mouseList = new MouseAdapter() {
        @Override
        public void mouseReleased(MouseEvent e) {
            if (czyRysowac) {
                czyRysowac = false;
                kreski.add(new Kreska(start, e.getPoint(), kolor));
                narysujKreski(plotno.getGraphics());
            }
        }

        @Override
        public void mouseExited(MouseEvent e) {
            czyRysowac = false;
            narysujKreski(plotno.getGraphics());
        }

        @Override
        public void mousePressed(MouseEvent e) {
            if (!czyRysowac) {
                czyRysowac = true;
                narysujKreski(plotno.getGraphics());
                start = e.getPoint();
            }
        }
    };

    MouseMotionListener mouseMotion = new MouseMotionAdapter() {
        @Override
        public void mouseDragged(MouseEvent e) {
            if (czyRysowac) {
                narysujKreski(plotno.getGraphics());
                narysujJednaKreske(new Kreska(start, e.getPoint(), Color.LIGHT_GRAY), plotno.getGraphics());
            }
        }
    };

    ItemListener itemList = new ItemListener() {
        @Override
        public void itemStateChanged(ItemEvent e) {
            if (e.getSource() == c1) kolor = Color.RED;
            else if (e.getSource() == c2) kolor = Color.GREEN;
            else if (e.getSource() == c3) kolor = Color.BLUE;
            else if (e.getSource() == c4) kolor = Color.MAGENTA;
            else if (e.getSource() == c5) kolor = Color.YELLOW;
            else if (e.getSource() == c6) kolor = Color.CYAN;
            else if (e.getSource() == c7) kolor = Color.WHITE;
            else if (e.getSource() == c8) kolor = Color.GRAY;
            else if (e.getSource() == c9) kolor = Color.BLACK;
        }
    };

    ActionListener actionList = new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            plotno.setBackground(kolor);
        }
    };

    KeyListener keyList = new KeyAdapter() {
        @Override
        public void keyPressed(KeyEvent ev) {
            switch (ev.getKeyCode()) {
                case KeyEvent.VK_BACK_SPACE:
                    kreski.clear();
                    narysujKreski(plotno.getGraphics());
                    break;
                case KeyEvent.VK_F:
                    if (kreski.size() > 0)
                        kreski.remove(0);
                    narysujKreski(plotno.getGraphics());
                    break;
                case KeyEvent.VK_B:
                case KeyEvent.VK_L:
                    if (kreski.size() > 0)
                        kreski.remove(kreski.size() - 1);
                    narysujKreski(plotno.getGraphics());
                    break;
            }
        }
    };

    public Okno() {
        super("Rysunek");
        setSize(800, 600);
        setLocation(100, 100);

        addWindowListener(windowList);
        setResizable(false);
        setVisible(true);

        plotno.addMouseListener(mouseList);
        plotno.addMouseMotionListener(mouseMotion);
        plotno.addKeyListener(keyList);

        przycTla.addActionListener(actionList);

        //KOLORY
        Panel panel = new Panel();
        panel.setLayout(new GridLayout(9, 1));
        panel.setBackground(Color.lightGray);
        c1.addItemListener(itemList);
        c2.addItemListener(itemList);
        c3.addItemListener(itemList);
        c4.addItemListener(itemList);
        c5.addItemListener(itemList);
        c6.addItemListener(itemList);
        c7.addItemListener(itemList);
        c8.addItemListener(itemList);
        c9.addItemListener(itemList);
        panel.add(c1);
        panel.add(c2);
        panel.add(c3);
        panel.add(c4);
        panel.add(c5);
        panel.add(c6);
        panel.add(c7);
        panel.add(c8);
        panel.add(c9);

        //ULOZENIE
        add(plotno,   BorderLayout.CENTER);
        add(poleTkst, BorderLayout.SOUTH);
        add(przycTla, BorderLayout.EAST);
        add(panel,    BorderLayout.WEST);
    }
}

public class Rysunek {
    public static void main(String[] args) {
        new Okno();
    }
}
