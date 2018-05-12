
import java.awt.FlowLayout;

import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

public class Main {

  String languages[] = { "Java", "Perl", "Python", "C++", "Basic", "C#", "Java", "Perl", "Python", "C++", "Basic", "C#" };

  JList jlst = new JList(languages);

  Main() {
    JFrame jfrm = new JFrame("Use JList");
    jfrm.setLayout(new FlowLayout());
    jfrm.setSize(200, 160);
    jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    jlst.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    jlst.addListSelectionListener(new ListSelectionListener() {
      public void valueChanged(ListSelectionEvent le) {
        int idx = jlst.getSelectedIndex();
        if (idx != -1)
          System.out.println("Current selection: " + languages[idx]);
        else
          System.out.println("Please choose a language.");
      }
    });

    jfrm.add(new JScrollPane(jlst));
    jfrm.setSize(300, 300);
    jfrm.setVisible(true);
  }

  public static void main(String args[]) {
    new Main();
  }
}