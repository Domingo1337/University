import javax.swing.*;
import java.awt.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class KontrolkaSamochodu extends JComponent {
    Samochod samochod;

    public KontrolkaSamochodu(Samochod samochod) {
        this.samochod = samochod;

        this.setLayout(new BorderLayout());
        this.add(new JLabel("Kontrolka Samochodu"), BorderLayout.NORTH);

        JPanel panelSamochodu = new JPanel();
        panelSamochodu.setLayout(new GridLayout(4,2));
        JTextField textModel = new JTextField(samochod.model, 1);
        JTextField textKolor = new JTextField(samochod.kolor, 1);
        JTextField textRocznik = new JTextField(String.valueOf(samochod.rocznik), 1);
        JTextField textRejestracja = new JTextField(samochod.rejestracja, 1);
        panelSamochodu.add(new JLabel("Model:"));
        panelSamochodu.add(textModel);
        panelSamochodu.add(new JLabel("Kolor:"));
        panelSamochodu.add(textKolor);
        panelSamochodu.add(new JLabel("Rocznik:"));
        panelSamochodu.add(textRocznik);
        panelSamochodu.add(new JLabel("Rejestracja:"));
        panelSamochodu.add(textRejestracja);
        this.add(panelSamochodu, BorderLayout.CENTER);

        JPanel panelPrzyciskow = new JPanel();
        panelPrzyciskow.setLayout(new GridLayout(2,2));
        JTextField textPlik = new JTextField("samochod.ser");
        JButton buttonZapis = new JButton("Zapisz");
        JButton buttonOdczyt = new JButton("Wczytaj");
        buttonZapis.addActionListener(e->{
            samochod.model = textModel.getText();
            samochod.kolor = textKolor.getText();
            samochod.rocznik = Integer.parseInt(textRocznik.getText());
            samochod.rejestracja = textRejestracja.getText();
            String filename = textPlik.getText();
            if(!filename.equals("")){
                try {
                    ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(filename));
                    out.writeObject(samochod);
                    out.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });
        buttonOdczyt.addActionListener(e->{
            String filename = textPlik.getText();
            if(!filename.equals("")) {
                try {
                    ObjectInputStream in = new ObjectInputStream(new FileInputStream(filename));
                    Samochod temp = (Samochod) in.readObject();
                    samochod.model = temp.model;
                    samochod.kolor = temp.kolor;
                    samochod.rocznik = temp.rocznik;
                    samochod.rejestracja = temp.rejestracja;
                    textModel.setText(temp.model);
                    textKolor.setText(temp.kolor);
                    textRocznik.setText(String.valueOf(temp.rocznik));
                    textRejestracja.setText(temp.rejestracja);
                    in.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        });
        panelPrzyciskow.add(new Label("Nazwa pliku:"));
        panelPrzyciskow.add(textPlik);
        panelPrzyciskow.add(buttonZapis);
        panelPrzyciskow.add(buttonOdczyt);
        this.add(panelPrzyciskow, BorderLayout.SOUTH);
    }
}
