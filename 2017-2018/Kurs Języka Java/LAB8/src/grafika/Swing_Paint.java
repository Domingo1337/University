package grafika;

import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import java.awt.*;
import java.awt.event.*;
import java.util.Vector;

class PaintFrame extends JFrame {

    //TOOLBAR
    private JToolBar toolbar = new JToolBar();
    private JButton fileOpener = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\open.png"));
    private JButton zoomButton = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\zoom_in.png"));
    private JButton unzoomButton = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\zoom_out.png"));
    private JButton up = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\up.png"));
    private JButton left = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\left.png"));
    private JButton right = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\right.png"));
    private JButton down = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\down.png"));
    private ActionListener fileListener = new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            JFileChooser jFileChooser = new JFileChooser();
            if (jFileChooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
                imagePanel.openImage(jFileChooser.getSelectedFile().getPath());
            }
            drawingPane.revalidate();
            repaint();
        }
    };
    private ActionListener zoomListener = new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            imagePanel.zoom(imagePanel.getZoomLevel() + (e.getSource() == zoomButton ? 1 : -1));
            drawingPane.revalidate();
            repaint();
        }
    };
    private ActionListener navigationListener = new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == up)
                drawingPane.getVerticalScrollBar().setValue(0);
            else if (e.getSource() == down)
                drawingPane.getVerticalScrollBar().setValue(drawingPane.getVerticalScrollBar().getMaximum());
            else if (e.getSource() == left) drawingPane.getHorizontalScrollBar().setValue(0);
            else if (e.getSource() == right)
                drawingPane.getHorizontalScrollBar().setValue(drawingPane.getHorizontalScrollBar().getMaximum());
        }
    };

    //MIDDLESCREEN
    private JSplitPane jSplitPane;

    //COLORS
    private Paint paint = Color.BLACK;
    private JPanel colorPanel = new JPanel();
    private Vector<Paint> colors = new Vector<Paint>();
    private DefaultListModel listModel = new DefaultListModel();
    private JList colorlist = new JList(listModel);
    private JButton colorButton = new JButton(new ImageIcon("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\palette.png"));
    private ActionListener colorListener = new ActionListener() {
        int nr = 1;
        @Override
        public void actionPerformed(ActionEvent e) {
            paint = JColorChooser.showDialog(null, "Choose color", Color.WHITE);
            colors.add(paint);
            listModel.addElement((String)"Custom "+(nr++));
        }
    };

    private ListSelectionListener colorlistListener = new  ListSelectionListener() {
        @Override
        public void valueChanged(ListSelectionEvent e) {
            paint = (Paint) colors.get(colorlist.getSelectedIndex());
        }
    };

    //DRAWING
    private ImagePanel imagePanel = new ImagePanel();
    private JScrollPane drawingPane = new JScrollPane(imagePanel);
    private MouseListener mouseListener = new MouseListener() {
        @Override
        public void mouseClicked(MouseEvent e) {
            imagePanel.paintDot(e.getX() / imagePanel.getZoomLevel(), e.getY() / imagePanel.getZoomLevel(), paint);
        }

        @Override
        public void mousePressed(MouseEvent e) {
            mouseClicked(e);
        }

        @Override
        public void mouseReleased(MouseEvent e) {
        }

        @Override
        public void mouseEntered(MouseEvent e) {

        }

        @Override
        public void mouseExited(MouseEvent e) {

        }
    };
   private MouseMotionListener mouseMotionListener = new MouseMotionListener() {
        @Override
        public void mouseDragged(MouseEvent e) {
            mouseListener.mouseClicked(e);
            mouseMoved(e);
        }

        @Override
        public void mouseMoved(MouseEvent e) {
            label.setText("x: " + (e.getX() / imagePanel.getZoomLevel()) + " y: " + (e.getY() / imagePanel.getZoomLevel()));
        }
    };

    //LABEL
    private JLabel label = new JLabel();

    public PaintFrame() {
        super("Swing Paint");
        setLayout(new BorderLayout());
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        //TOOLBAR
        fileOpener.addActionListener(fileListener);
        zoomButton.addActionListener(zoomListener);
        unzoomButton.addActionListener(zoomListener);
        up.addActionListener(navigationListener);
        down.addActionListener(navigationListener);
        left.addActionListener(navigationListener);
        right.addActionListener(navigationListener);
        toolbar.add(fileOpener);
        toolbar.add(zoomButton);
        toolbar.add(unzoomButton);
        toolbar.add(up);
        toolbar.add(down);
        toolbar.add(left);
        toolbar.add(right);
        add(toolbar, BorderLayout.NORTH);

        //DRAWING
        imagePanel.openImage("E:\\Media\\Documents\\java\\LAB8\\src\\grafika\\java-logo.jpg");
        imagePanel.addMouseMotionListener(mouseMotionListener);
        imagePanel.addMouseListener(mouseListener);
        drawingPane.setMinimumSize(imagePanel.getPreferredSize());

        //COLOR
        listModel.addElement("Red");      colors.add(Color.RED);
        listModel.addElement("Green");    colors.add(Color.GREEN);
        listModel.addElement("Blue");     colors.add(Color.BLUE);
        colorlist.addListSelectionListener(colorlistListener);
        colorPanel.setLayout(new GridLayout(2, 1));
        colorPanel.add(new JScrollPane(colorlist));
        colorButton.addActionListener(colorListener);
        colorPanel.add(colorButton);

        //SPLITCENTER AREA
        jSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, drawingPane, colorPanel);
        jSplitPane.setResizeWeight(1);
        jSplitPane.setMinimumSize(imagePanel.getSize());
        add(jSplitPane, BorderLayout.CENTER);

        //LABEL
        add(label, BorderLayout.SOUTH);

        pack();
        setVisible(true);
    }
}


public class Swing_Paint {
    public static void main(String[] args) {
        new PaintFrame();
    }
}
