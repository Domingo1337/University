import java.io.Console;

public class Sorter extends Thread {
    private int[] array;
    private static int counter = 0;
    private int start;
    private int stop;
    private final int id;

    public Sorter(int[] array, int start, int stop) {
        this.array = array;
        this.start = start;
        this.stop = stop;
        id = counter++;
    }

    public Sorter(int[] array) {
        this.array = array;
        id = counter++;
    }

    @Override
    public void run() {
        super.run();
        if (start != stop) {

            Sorter s1, s2;

            s1 = new Sorter(array, start, start + (stop - start) / 2);
            s2 = new Sorter(array, 1 + start + (stop - start) / 2, stop);

            try {
                s1.start();
                s2.start();
                s1.join();
                s2.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            int i = start;
            int j = 1 + start + (stop - start) / 2;
            int temp[] = new int[stop - start + 1];
            for (int k = 0; k <= stop - start; k++) {
                if (i <= start + (stop - start) / 2 && j <= stop) {
                    if (array[i] < array[j])
                        temp[k] = array[i++];
                    else temp[k] = array[j++];
                } else if (i <= start + (stop - start) / 2)
                    temp[k] = array[i++];
                else temp[k] = array[j++];
            }
            for (int k = 0; k <= stop - start; k++)
                array[start + k] = temp[k];
        }
    }
}
