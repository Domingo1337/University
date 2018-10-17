import javax.swing.*;
import java.awt.*;

public class Main {
    public static void main(String[] args) {

        Samochod samochod = new Samochod("Seat Ibiza", "Czerwony", 2016, "DW 12345");
        Tramwaj tramwaj = new Tramwaj("Skoda T16", "niebieski", 2012, "4097");

        //Create and set up the window.
        JFrame frame = new JFrame("Kontrolki");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.setLayout(new GridLayout());
        frame.add(new KontrolkaSamochodu(samochod));
        frame.add(new KontrolkaTramwaju(tramwaj));

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }
}
