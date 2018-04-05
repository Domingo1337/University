import java.io.*;

public class Main {
    public static void main(String[] args) {
        Lista<String> lista = new Lista<String>();

        String filename = "lista.ser";

        lista.pushback("test");
        lista.pushback("serializacji");
        lista.pushback("listy");

        // save the object to file
        try {
            ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(filename));
            out.writeObject(lista);
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // read the object from file
        try {
            ObjectInputStream in = new ObjectInputStream(new FileInputStream(filename));
            lista = (Lista<String>) in.readObject();
            in.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        while (lista.getCount() > 0)
            System.out.println(lista.popfront());
    }

}
