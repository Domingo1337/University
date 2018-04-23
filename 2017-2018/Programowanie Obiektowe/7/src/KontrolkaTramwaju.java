import javax.swing.*;
import java.awt.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class KontrolkaTramwaju extends JComponent {
    Tramwaj tramwaj;

    public KontrolkaTramwaju(Tramwaj tramwaj) {
        this.tramwaj = tramwaj;

        this.setLayout(new BorderLayout());
        this.add(new JLabel("Kontrolka Tramwaju"), BorderLayout.NORTH);

        JPanel panelTramwaju = new JPanel();
        panelTramwaju.setLayout(new GridLayout(4,2));
        JTextField textModel = new JTextField(tramwaj.model, 1);
        JTextField textKolor = new JTextField(tramwaj.kolor, 1);
        JTextField textRocznik = new JTextField(String.valueOf(tramwaj.rocznik), 1);
        JTextField textNumer_boczny = new JTextField(tramwaj.numer_boczny, 1);
        panelTramwaju.add(new JLabel("Model:"));
        panelTramwaju.add(textModel);
        panelTramwaju.add(new JLabel("Kolor:"));
        panelTramwaju.add(textKolor);
        panelTramwaju.add(new JLabel("Rocznik:"));
        panelTramwaju.add(textRocznik);
        panelTramwaju.add(new JLabel("Numer_boczny:"));
        panelTramwaju.add(textNumer_boczny);
        this.add(panelTramwaju, BorderLayout.CENTER);

        JPanel panelPrzyciskow = new JPanel();
        panelPrzyciskow.setLayout(new GridLayout(2,2));
        JTextField textPlik = new JTextField("tramwaj.ser");
        JButton buttonZapis = new JButton("Zapisz");
        JButton buttonOdczyt = new JButton("Wczytaj");
        buttonZapis.addActionListener(e->{
            tramwaj.model = textModel.getText();
            tramwaj.kolor = textKolor.getText();
            tramwaj.rocznik = Integer.parseInt(textRocznik.getText());
            tramwaj.numer_boczny = textNumer_boczny.getText();
            String filename = textPlik.getText();
            if(!filename.equals("")){
                try {
                    ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(filename));
                    out.writeObject(tramwaj);
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
                    Tramwaj temp = (Tramwaj) in.readObject();
                    tramwaj.model = temp.model;
                    tramwaj.kolor = temp.kolor;
                    tramwaj.rocznik = temp.rocznik;
                    tramwaj.numer_boczny = temp.numer_boczny;
                    textModel.setText(temp.model);
                    textKolor.setText(temp.kolor);
                    textRocznik.setText(String.valueOf(temp.rocznik));
                    textNumer_boczny.setText(temp.numer_boczny);
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
