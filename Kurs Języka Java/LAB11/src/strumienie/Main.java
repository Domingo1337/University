package strumienie;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilterWriter;

class Okno extends JFrame {
    JEditorPane editorPane;
    JButton fileButton;
    JButton saveButton;
    JButton cleanButton;
    JToolBar toolBar;
    String filepath;
    public Okno(String title) throws HeadlessException {
        super(title);
        setLayout(new BorderLayout());
        toolBar = new JToolBar();
        add(toolBar, BorderLayout.SOUTH);
        editorPane = new JEditorPane();
        add(editorPane, BorderLayout.CENTER);
        fileButton = new JButton("Wybierz plik");
        fileButton.addActionListener(e -> {
            JFileChooser jFileChooser = new JFileChooser();
            if (jFileChooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
                String str = null;
                filepath = jFileChooser.getSelectedFile().getPath();
                editorPane.setText("");
                try {
                    BufferedReader br = new BufferedReader(new FileReader(filepath));
                    while ((str = br.readLine()) != null) {
                        editorPane.setText(editorPane.getText()+str+'\n');
                    }
                }catch (Exception ex){
                    System.err.println(ex);
                }
            }
        });
        cleanButton = new JButton("Wyczyść");
        cleanButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                    try {   String str = null;
                        editorPane.setText("");
                        BufferedReader br = new BufferedReader(new strCzytajacy(new FileReader(filepath), 8));
                        while ((str = br.readLine()) != null) {
                            editorPane.setText(editorPane.getText() + str + '\n');
                        }
                        editorPane.revalidate();
                    } catch (Exception ex) {
                        System.err.println(ex);
                    }
            }
        });
        saveButton = new JButton("Zapisz");
        saveButton.addActionListener(e -> {
            try {

                BufferedReader br = new BufferedReader(new strCzytajacy(new FileReader(filepath)));
                strPiszacy out = new strPiszacy(new FileWriter(filepath.replace(".txt", "_czysty.txt")));
                String str = null;
                while ((str = br.readLine()) != null) {
                    out.append(str+'\n');
                }
                out.close();
            } catch (Exception ex) {
                System.err.println(ex);
            }
        });
        toolBar.add(fileButton);
        toolBar.add(cleanButton);
        toolBar.add(saveButton);
        setSize(400, 800);
        setVisible(true);

    }
}

public class Main {
    public static void main(String[] args) throws Exception {
        Okno okno = new Okno("Strumienie");
    }
}