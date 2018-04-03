import java.util.Random;

public class Main {
    public static boolean sorted(int[] array) {
        for (int i = 0; i < array.length - 1; i++)
            if (array[i] > array[i + 1])
                return false;
        return true;
    }

    public static void main(String[] args) throws InterruptedException {
        Random random = new Random();
        int[] array = new int[1000];
        System.out.println("Array of length " + array.length + ": ");
        for (int i = 0; i < array.length; i++) {
            array[i] = random.nextInt();
            System.out.print(array[i] + " ");
        }

        System.out.print("\nSorting ");
        Sorter sorter = new Sorter(array, 0, array.length - 1);
        long timer = System.currentTimeMillis();

        sorter.start();
        sorter.join();

        timer = System.currentTimeMillis() - timer;
        System.out.println("took " + timer + "ms.");

        System.out.println("Sorted? " + Main.sorted(array));
        for (int x : array)
            System.out.print(x + " ");
    }
}
