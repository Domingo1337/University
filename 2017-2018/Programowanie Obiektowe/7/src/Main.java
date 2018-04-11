import javax.swing.*;
import java.awt.*;

public class Main {
    public static void main(String[] args) {

        Samochod samochod = new Samochod("Seat Ibiza", "Czerwony", 2016, "XX 2345");

        //Create and set up the window.
        JFrame frame = new JFrame("Kontrolki");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.setLayout(new BorderLayout());
        frame.add(new KontrolkaSamochodu(samochod));

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }
}
