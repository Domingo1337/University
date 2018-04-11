import algorithms.*;

import java.util.Random;
import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        Scanner scanner = new Scanner(System.in);
        BST tree = new BST<Integer>(0);
        boolean loop = true;
        while (loop) try {
            switch (scanner.next()) {
                case "clear":
                    tree.clear();
                    break;
                case "search":
                    System.out.println(tree.search(Integer.valueOf(scanner.next())));
                    break;
                case "insert":
                    tree.insert(Integer.valueOf(scanner.next()));
                    break;
                case "print":
                    System.out.println(tree.toString());
                    break;
                case "remove":
                    tree.remove(Integer.valueOf(scanner.next()));
                    break;
                case "max":
                    System.out.println(tree.max());
                    break;
                case "min":
                    System.out.println(tree.min());
                    break;
                case "size":
                    System.out.println(tree.size());
                    break;
                case "random":
                    int howMany = Integer.valueOf(scanner.next());
                    Random random = new Random();
                    for (int i = 0; i < howMany; i++)
                        tree.insert(random.nextInt());
                    break;
                case "exit":
                    System.exit(1);
                    break;
                case "string":
                    loop = false;
                    break;
                default:
                    System.err.println("Dozwolone komendy: clean min max search insert remove print size random exit");
            }
        } catch (Exception e) {
            System.err.println(e);
        }
        tree = new BST<String>("ROOT");
        while (true) try {
            switch (scanner.next()) {
                case "clear":
                    tree.clear();
                    break;
                case "search":
                    System.out.println(tree.search((scanner.next())));
                    break;
                case "insert":
                    tree.insert(scanner.next());
                    break;
                case "print":
                    System.out.println(tree);
                    break;
                case "remove":
                    tree.remove(scanner.next());
                    break;
                case "max":
                    System.out.println(tree.max());
                    break;
                case "min":
                    System.out.println(tree.min());
                    break;
                case "size":
                    System.out.println(tree.size());
                    break;
                case "random":
                    int howMany = Integer.valueOf(scanner.next());
                    Random random = new Random();
                    byte rndString[] =new byte[howMany];
                    random.nextBytes(rndString);
                    tree.insert(new String(rndString));
                    break;
                case "exit":
                    System.exit(1);
                    break;
                default:
                    System.err.println("Dozwolone komendy: clean min max search insert remove print size exit random");
            }
        } catch (Exception e) {
            System.err.println(e);
        }
    }
}