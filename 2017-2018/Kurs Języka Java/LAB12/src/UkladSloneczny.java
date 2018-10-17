import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class UkladSloneczny {

    public static void main(String[] args) {
        new UkladSloneczny();
    }

    public UkladSloneczny() {
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                try {
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | UnsupportedLookAndFeelException ex) {
                    ex.printStackTrace();
                }

                JFrame frame = new JFrame("Planety i Księżyce");
                frame.setLayout(new BorderLayout());
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                PanelSloneczny panelSloneczny = new PanelSloneczny();
                frame.add(panelSloneczny, BorderLayout.CENTER);

                JToolBar toolBar = new JToolBar();
                JButton day = new JButton("1s = 1 dzien");
                JButton month = new JButton("1s = 1 miesiąc");
                JButton slower = new JButton("2x wolniej");
                JButton faster = new JButton("2x szybciej");
                JButton pause = new JButton("pauza");
                JButton way = new JButton("zawróć");
                day.addActionListener(e -> panelSloneczny.speed = 1);
                month.addActionListener(e -> panelSloneczny.speed = 30);
                slower.addActionListener(e -> panelSloneczny.speed *= 0.5);
                faster.addActionListener(e -> panelSloneczny.speed *= 2);
                pause.addActionListener(e -> panelSloneczny.pause = !panelSloneczny.pause);
                way.addActionListener(e -> panelSloneczny.way *= -1);
                toolBar.add(day);
                toolBar.add(month);
                toolBar.add(slower);
                toolBar.add(faster);
                toolBar.add(way);
                toolBar.add(pause);

                frame.add(toolBar, BorderLayout.SOUTH);

                frame.pack();
                //frame.setResizable(false);
                frame.setVisible(true);
            }
        });
    }

    public class PanelSloneczny extends JPanel {

        private BufferedImage currentFrame;
        private int frame;
        ArrayList<Cialo> list = new ArrayList<Cialo>();
        BufferedImage background = null;
        double angle = 0;
        double speed = 1;
        double way = -1;
        boolean pause = true;

        public PanelSloneczny() {
            try {
                background = ImageIO.read(new File("E:\\Media\\Documents\\java\\LAB12\\graphics\\starry_sky_stock_by_budgie.jpg"));
            } catch (IOException e) {
                e.printStackTrace();
            }

            list.add(Cialo.Słońce);
            list.add(Cialo.Merkury);
            list.add(Cialo.Wenus);
            list.add(Cialo.Ziemia);
            list.add(Cialo.Księżyc);
            list.add(Cialo.Mars);
            list.add(Cialo.Eris);
            list.add(Cialo.Jowisz);
            list.add(Cialo.Saturn);
            list.add(Cialo.Uran);
            list.add(Cialo.Neptun);
            list.add(Cialo.Pluto);
            list.add(Cialo.Ceres);
            list.add(Cialo.Haumea);
            list.add(Cialo.Makemake);
            list.add(Cialo.Titan);
            list.add(Cialo.Ganymede);
            list.add(Cialo.Callisto);
            list.add(Cialo.Io);

            Timer timer = new Timer(16, new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    repaint();
                }
            });
            timer.start();
        }

        @Override
        public Dimension getPreferredSize() {
            return new Dimension(1200, 1000);
        }

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            if (pause)
                angle += Math.PI * 2 * way * speed * 0.016;
            if (background != null) {
                Graphics2D g2d = (Graphics2D) g.create();
                g2d.drawImage(background, 0, 0, this);
                g2d.setPaint(Color.GRAY);
                for (int i = 1; i < list.size(); i++) {
                    list.get(i).calcPosition(angle);
                    g2d.drawOval(list.get(i).center.getX() - (int) list.get(i).orbit, list.get(i).center.getY() - (int) list.get(i).orbit,
                            (int) list.get(i).orbit * 2, (int) list.get(i).orbit * 2);
                }

                for(int i = 0; i < list.size(); i++) {
                    g2d.setPaint(list.get(i).color);
                    g2d.fillOval(list.get(i).getX() - (int) list.get(i).radius, list.get(i).getY() - (int) list.get(i).radius,
                            (int) list.get(i).radius * 2, (int) list.get(i).radius * 2);
                }
                g2d.setPaint(Color.WHITE);
                for(int i = 0; i < list.size(); i++) {
                    g2d.drawString(list.get(i).toString(), list.get(i).getX() + (int) list.get(i).radius, list.get(i).getY() + (int) list.get(i).radius);
                }
                g2d.drawString("1s to: "+speed+"dni = "+speed/365+" lat.", 10, 990);
                g2d.dispose();
            }

        }

    }

    public enum Cialo {
        Słońce(new Point(600, 500), 696342, new Color(255, 200, 0)),
        Merkury(Słońce, 57909036.f, 2439, 0.241, new Color(225, 190, 150)),
        Wenus(Słońce, 108208925.f, 6051, 0.615, new Color(178, 118, 50)),
        Ziemia(Słońce, 149597871.f, 6371, 1, new Color(60, 180, 200)),
        Księżyc(Ziemia, 384400.f, 1736, 0.0748, Color.LIGHT_GRAY),
        Mars(Słońce, 227936637.f, 3389, 1.881, new Color(182, 144, 109)),
        Jowisz(Słońce, 778412028.f, 70000, 11.862, new Color(226, 203, 159)),
        Saturn(Słońce, 1473838225.f, 60000, 29.457, new Color(248, 243, 172)),
        Uran(Słońce, 2872428721.f, 25362, 84.011, new Color(151, 188, 208)),
        Neptun(Słońce, 4494967229.f, 24662, 164.69, new Color(97, 138, 211)),
        Ceres(Słońce, 414082773.f, 945, 4.6054, new Color(158, 151, 156)),
        Pluto(Słońce, 5906423142.f, 2370, 247.6, new Color(165, 126, 103)),
        Haumea(Słońce, 6483571729.f, 1379, 285.3, new Color(203, 203, 203)),
        Eris(Słońce, 10120295973.f, 2326, 556.4, new Color(214, 212, 225)),
        Makemake(Słońce, 6845598576.f, 1500, 309.57, new Color(100, 50, 40)),
        Titan(Saturn, 1221870.f, 2575, 0.0438, new Color(220, 220, 110)),
        Io(Jowisz, 421700.f, 1821, 0.00466, new Color(220, 220, 110)),
        Ganymede(Jowisz, 1070400.f, 2634, 0.0192, Color.LIGHT_GRAY),
        Callisto(Jowisz, 1882700.f, 2410, 0.0457, Color.LIGHT_GRAY);

        Point position;
        boolean stationary;
        Cialo center;
        double orbit;
        double radius;
        double period;
        Color color;

        Cialo(Cialo center, double orbit, double radius, double period, Color color) {
            this.center = center;
            this.position = new Point();//center.getX()+orbit, center.getY());
            stationary = false;
            this.color = color;
            this.radius = Math.sqrt(radius) / 15;
            //this.orbit = (Math.log10(orbit)-5.5)*100+this.radius;
            this.orbit = (Math.sqrt(orbit) / 50 + (Math.log10(orbit) - 5) * 50) * 0.195 + center.radius;
            this.period = period * 365.256363004;
        }

        Cialo(Point position, double radius, Color color) {
            this.position = position;
            this.stationary = true;
            this.color = color;
            this.radius = Math.sqrt(radius) / 15;
        }

        void calcPosition(double angle) {
            if (stationary) return;
            angle = angle / period;
            position.setLocation(center.getX() + orbit * Math.sin(angle),
                    center.getY() + orbit * Math.cos(angle));
        }

        public int getX() {
            return (int) position.getX();
        }

        public int getY() {
            return (int) position.getY();
        }
    }
}

