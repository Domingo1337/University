package grafika;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;


public class ImagePanel extends JPanel {

    private BufferedImage originalImage;
    private BufferedImage bufferedImage;
    private int zoomLevel = 1;

    public int getZoomLevel() {
        return zoomLevel;
    }

    public void zoom(int zoomLevel) {
        if(zoomLevel>0 && zoomLevel<9) {
            this.zoomLevel = zoomLevel;
            bufferedImage = new BufferedImage(originalImage.getWidth() * zoomLevel, originalImage.getHeight() * zoomLevel, BufferedImage.TYPE_INT_ARGB);
            bufferedImage.createGraphics().drawImage(originalImage, 0, 0, bufferedImage.getWidth(), bufferedImage.getHeight(), null);
            setPreferredSize(new Dimension(bufferedImage.getWidth(),bufferedImage.getHeight()));
           // this.repaint();
        }
    }
    public ImagePanel(){
        super();
    }
    public void paintDot(int x, int y, Paint paint){
        Graphics2D g = originalImage.createGraphics();
        g.setPaint(paint);
        g.drawRect(x,y,0,0);
        zoom(getZoomLevel());
    }
    public void openImage(String filepath){
        try {
            originalImage = ImageIO.read(new File(filepath));
        } catch (IOException e) {
            System.err.println(e);
            System.exit(1);
        }
        zoom(1);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawImage(bufferedImage, 0, 0, this);
    }

}