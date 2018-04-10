import javax.swing.*;
import java.awt.*;

public class KontrolkaPojazdu extends JComponent {
    Pojazd pojazd;
    String filename = "test.ser"

    public KontrolkaPojazdu(Pojazd pojazd) {
        this.pojazd = pojazd;

        JTextField textRocznik = new JTextField(String.valueOf(pojazd.rocznik), 40);
        JTextField textModel = new JTextField(pojazd.model, 40);
        JTextField textKolor = new JTextField(pojazd.kolor, 40);
        this.setLayout(new GridLayout(5, 5));
        this.add(textRocznik);
        this.add(textModel);
        this.add(textKolor);
        textRocznik.addActionListener(e -> System.out.println(textRocznik.getText()));
        JButton buttonZapis = new JButton("Zapisz");
        JButton buttonOdczyt = new JButton("Wczytaj");
        this.add(buttonZapis);
        this.add(buttonOdczyt);
        buttonZapis.addActionListener(e->);


    }
}
