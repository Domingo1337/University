package algorithms;

/**
 * Interfejs metod słownikowych kolekcji typów generycznych.
 * @param <T>
 */
interface Dict<T extends Comparable<T>> {

    boolean search(T element);

    void remove(T element) throws Exception;

    void insert(T element) throws Exception;

    T min();

    T max();
}

