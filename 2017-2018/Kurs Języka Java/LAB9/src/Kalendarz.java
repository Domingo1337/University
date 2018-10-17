import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.*;
import java.util.GregorianCalendar;
import java.util.Random;

class ModelDanych2 extends AbstractListModel {
    int rok;
    int miesiac;

    public ModelDanych2(int rok, int miesiac) {
        while (miesiac > 11) {
            miesiac -= 12;
            rok += 1;
        }
        while (miesiac < 0) {
            miesiac += 12;
            rok -= 1;
        }
        this.miesiac = miesiac;
        this.rok = rok;
    }

    public int getRok() {
        return rok;
    }

    public void setRok(int rok) {
        this.rok = rok;
    }

    public int getMiesiac() {
        return miesiac;
    }

    public void setMiesiac(int miesiac) {
        this.miesiac = miesiac;
    }

    @Override
    public String getElementAt(int index) {
        GregorianCalendar gregorianCalendar = new GregorianCalendar(rok, miesiac, index + 1);
        if(rok == 1582 && miesiac == 9 && index>3)
            return staleKalendarza.dzienTygodznie(gregorianCalendar.get(GregorianCalendar.DAY_OF_WEEK)) + " " + String.valueOf(index + 11) + " " + staleKalendarza.miesiace[miesiac] + " " + rok;
        return staleKalendarza.dzienTygodznie(gregorianCalendar.get(GregorianCalendar.DAY_OF_WEEK)) + " " + String.valueOf(index + 1) + " " + staleKalendarza.miesiace[miesiac] + " " + rok;
    }

    @Override
    public int getSize() {
        return staleKalendarza.ileDni(miesiac, rok);
    }

    @Override
    protected void fireContentsChanged(Object source, int index0, int index1) {
        super.fireContentsChanged(source, index0, index1);
    }
}

class KreslarzElementowListy extends JLabel implements ListCellRenderer {
    public KreslarzElementowListy() {
        setHorizontalAlignment(LEFT);
    }

    public Component getListCellRendererComponent(
            JList lista, Object elem, int indeks, boolean zazn, boolean fokus) {
        String napis = elem.toString();
        setText(napis);
        if (napis.substring(0, napis.indexOf(' ')).equalsIgnoreCase("Niedziela")) setForeground(Color.RED);
        else setForeground(Color.DARK_GRAY);
        return this;
    }
}


public class Kalendarz extends JFrame {

    protected JList lista;
    protected JList listapoprzednia;
    protected JList listanastepna;
    protected JPanel panelMiesiaca;
    protected ModelDanych2 model;
    protected ModelDanych2 modelnastepny;
    protected ModelDanych2 modelpoprzedni;
    protected JTabbedPane tabbedPane = new JTabbedPane();

    protected JPanel widokRoku;
    protected JPanel widokMiesiaca[] = new JPanel[12];
    protected JPanel widokDni[] = new JPanel[12];

    public void setRok(int rok) {
        this.rok = rok;
        modelnastepny.setRok(rok);
        model.setRok(rok);
        modelpoprzedni.setRok(rok);

        for (int i = 0; i < 12; i++) {
            GregorianCalendar gregorianCalendarTemp = new GregorianCalendar(rok, i, 1);
            int j = gregorianCalendarTemp.get(GregorianCalendar.DAY_OF_WEEK) - 2;
            if (j < 0) j = 6;
            for (int k = 0; k < j; k++) {
                ((JLabel) widokDni[i].getComponent(k)).setBorder(BorderFactory.createEmptyBorder());
                ((JLabel) widokDni[i].getComponent(k)).setText("");
            }
            int dzien = 1;
            for (int k = j; k < 6; k++) {
                ((JLabel) widokDni[i].getComponent(k)).setBorder(BorderFactory.createLineBorder(Color.gray));
                ((JLabel) widokDni[i].getComponent(k)).setText(String.valueOf(dzien++));
            }
            for (int k = 6; k < 42; k++) {
                if (dzien <= staleKalendarza.ileDni(i, rok)) {
                    ((JLabel) widokDni[i].getComponent(k)).setText(String.valueOf(dzien++));
                    if ((k + 1) % 7 == 0)
                        ((JLabel) widokDni[i].getComponent(k)).setBorder(BorderFactory.createLineBorder(Color.red));
                    else ((JLabel) widokDni[i].getComponent(k)).setBorder(BorderFactory.createLineBorder(Color.gray));
                } else {
                    ((JLabel) widokDni[i].getComponent(k)).setText("");
                    ((JLabel) widokDni[i].getComponent(k)).setBorder(BorderFactory.createEmptyBorder());
                }
            }
        }
        if(rok==1582){
            int dzien = 1;
            for(int i =0; i<21; i++){
                ((JLabel) widokDni[9].getComponent(i)).setText(String.valueOf(dzien++));
                if(dzien == 5) dzien = 15;
            }
        }
        tabbedPane.getComponentAt(1).setName(String.valueOf(rok));
    }

    public void setMiesiac(int m) {
        while (m < 0) {
            m += 12;
            setRok(rok - 1);
        }
        while (m > 11) {
            m -= 12;
            setRok(rok + 1);
        }
        this.miesiac = m;
        model.setMiesiac(miesiac);
        model.setRok(rok);
        model.fireContentsChanged(model, 0, model.getSize());
        m -= 1;
        if (m < 0) {
            modelpoprzedni.setMiesiac(m + 12);
            modelpoprzedni.setRok(rok - 1);
        } else {
            modelpoprzedni.setMiesiac(m);
            modelpoprzedni.setRok(rok);
        }
        m += 2;
        if (m > 11) {
            modelnastepny.setMiesiac(m - 12);
            modelnastepny.setRok(rok + 1);
        } else {
            modelnastepny.setMiesiac(m);
            modelnastepny.setRok(rok);
        }
        modelpoprzedni.fireContentsChanged(modelpoprzedni, 0, modelpoprzedni.getSize());
        modelnastepny.fireContentsChanged(modelnastepny, 0, modelnastepny.getSize());
        tabbedPane.setTitleAt(0, staleKalendarza.miesiace[miesiac]);
        tabbedPane.setTitleAt(1, String.valueOf(rok));
    }


    int rok;
    int miesiac;
    JToolBar toolBar = new JToolBar();
    JButton losuj = new JButton("Wylosuj");

    JSpinner spinnerMiesiaca;
    JSpinner spinnerRoku;
    JScrollBar scrollBar;
    Random generator;

    public Kalendarz() {
        super("Kalendarz");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        GregorianCalendar gregorianCalendar = new GregorianCalendar();
        rok = gregorianCalendar.get(GregorianCalendar.YEAR);
        miesiac = gregorianCalendar.get(GregorianCalendar.MONTH);

        model = new ModelDanych2(rok, miesiac);
        modelnastepny = new ModelDanych2(rok, miesiac + 1);
        modelpoprzedni = new ModelDanych2(rok, miesiac - 1);
        lista = new JList(model);
        listanastepna = new JList(modelnastepny);
        listapoprzednia = new JList(modelpoprzedni);
        lista.setCellRenderer(new KreslarzElementowListy());
        listanastepna.setCellRenderer(new KreslarzElementowListy());
        listapoprzednia.setCellRenderer(new KreslarzElementowListy());
        panelMiesiaca = new JPanel();
        panelMiesiaca.setLayout(new GridLayout(1, 3));
        panelMiesiaca.add(new JScrollPane(listapoprzednia));
        panelMiesiaca.add(new JScrollPane(lista));
        panelMiesiaca.add(new JScrollPane(listanastepna));
        tabbedPane.addTab(String.valueOf(staleKalendarza.miesiace[miesiac]), panelMiesiaca);

        widokRoku = new JPanel();
        widokRoku.setLayout(new GridLayout(3, 4));
        for (int i = 0; i < 12; i++) {
            final int tempInt = i;
            JPanel temp = new JPanel();
            JButton tempButton = new JButton(staleKalendarza.miesiace[i]);
            temp.setLayout(new BorderLayout());
            temp.add(tempButton, BorderLayout.NORTH);
            tempButton.addActionListener(e -> {
                setMiesiac(tempInt);
                tabbedPane.setSelectedIndex((tabbedPane.getSelectedIndex() + 1) % 2);
            });


            widokDni[i] = new JPanel();
            widokDni[i].setLayout(new GridLayout(6, 8));
            GregorianCalendar gregorianCalendarTemp = new GregorianCalendar(rok, i, 1);
            int j = gregorianCalendarTemp.get(GregorianCalendar.DAY_OF_WEEK) - 2;
            if (j < 0) j = 6;
            for (int k = 0; k < j; k++) {
                JLabel tempLabel = new JLabel();
                tempLabel.setHorizontalAlignment(SwingConstants.CENTER);
                widokDni[i].add(tempLabel);
            }
            int dzien = 1;
            for (int k = j; k < 42; k++) {
                if (dzien <= staleKalendarza.ileDni(miesiac, rok)) {
                    JLabel tempLabel = new JLabel(String.valueOf(dzien++));
                    tempLabel.setHorizontalAlignment(SwingConstants.CENTER);
                    if ((k + 1) % 7 == 0) {
                        tempLabel.setBorder(BorderFactory.createLineBorder(Color.RED));
                        tempLabel.setForeground(Color.RED);
                    } else tempLabel.setBorder(BorderFactory.createLineBorder(Color.gray));
                    widokDni[i].add(tempLabel);
                } else {
                    JLabel tempLabel = new JLabel();
                    tempLabel.setHorizontalAlignment(SwingConstants.CENTER);
                    widokDni[i].add(tempLabel);
                }
            }
            temp.add(widokDni[i], BorderLayout.CENTER);
            widokMiesiaca[i] = temp;
            widokRoku.add(widokMiesiaca[i]);
        }

        tabbedPane.addTab(String.valueOf(rok), widokRoku);

        scrollBar = new JScrollBar(JScrollBar.HORIZONTAL, rok, 1, 1, 5000);
        spinnerRoku = new JSpinner(new SpinnerNumberModel(rok, 1, 5000, 1));
        spinnerMiesiaca = new JSpinner(new SpinnerNumberModel(miesiac + 1, 1, 12, 1));

        scrollBar.addAdjustmentListener(e -> {
            setRok(scrollBar.getValue());
            spinnerRoku.setValue(rok);
            setMiesiac(miesiac);
        });
        spinnerRoku.addChangeListener(e -> {
            setRok((int) spinnerRoku.getValue());
            setMiesiac(miesiac);
        });
        spinnerRoku.addChangeListener(e -> System.out.println(e) );
        generator = new Random();
        losuj.addActionListener(e -> {
            setRok(generator.nextInt(5000));
            setMiesiac(generator.nextInt(11));
            spinnerMiesiaca.setValue(miesiac);
            spinnerRoku.setValue(rok);
        });

        toolBar.add(losuj);
        toolBar.add(spinnerMiesiaca);
        toolBar.add(spinnerRoku);
        toolBar.add(scrollBar);
        add(tabbedPane, BorderLayout.CENTER);
        add(toolBar, BorderLayout.SOUTH);
        setSize(800, 450);
        setVisible(true);
    }

    public static void main(String[] args) {
        new Kalendarz();
    }

}