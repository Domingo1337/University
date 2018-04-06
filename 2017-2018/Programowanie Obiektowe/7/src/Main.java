import javax.swing.*;
import java.awt.*;

public class Main {
    public static void main(String[] args) {
        //Create and set up the window.
        JFrame frame = new JFrame("Swingtest");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        frame.setLayout(new BorderLayout());

        //Add the ubiquitous "Hello World" label.
        JLabel label = new JLabel("test-label");

        JTextPane textPane = new JTextPane();
        textPane.setEditable(false);
        textPane.setText("Tutaj będzie\njakiś tekst\n\nkiedyś");


        JButton buttonRefresh = new JButton("refresh");
        buttonRefresh.addActionListener(e -> label.repaint());

        frame.add(textPane, BorderLayout.WEST);
        frame.add(buttonRefresh, BorderLayout.SOUTH);
        frame.add(label, BorderLayout.NORTH);

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }
}
