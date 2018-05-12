import java.io.*;

public class Main {
    public static void main(String[] args) {

        Lista<String> lista = new Lista<String>();
        lista.pushback("test");
        lista.pushback("serializacji");
        lista.pushback("listy");

        String filename = "lista.ser";
        // save the object to file
        try {
            ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(filename));
            out.writeObject(lista);
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        Lista<String> listaWczytana = new Lista<String>();
        // read the object from file
        try {
            ObjectInputStream in = new ObjectInputStream(new FileInputStream(filename));
            listaWczytana = (Lista<String>) in.readObject();
            in.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        while (listaWczytana.getCount() > 0)
            System.out.println(listaWczytana.popfront());
    }
}
