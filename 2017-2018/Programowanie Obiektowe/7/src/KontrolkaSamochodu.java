import javax.swing.*;
import java.awt.*;

public class KontrolkaSamochodu extends JComponent {
    Samochod samochod;

    public KontrolkaSamochodu(Samochod samochod) {
        this.samochod = samochod;

        this.setLayout(new GridLayout(2,1 ));

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
        this.add(panelSamochodu);

        JPanel panelPrzyciskow = new JPanel();
        panelPrzyciskow.setLayout(new GridLayout(2,2));
        JButton buttonZapis = new JButton("Zapisz");
        JButton buttonOdczyt = new JButton("Wczytaj");
        panelPrzyciskow.add(buttonZapis);
        panelPrzyciskow.add(buttonOdczyt);
        this.add(panelPrzyciskow);
    }
}
