import java.io.Serializable;

public class Lista<T> implements Serializable {
    class Node implements Serializable {
        public T info;
        public Node prev;
        public Node next;

        public Node(T info, Lista<T>.Node prev, Lista<T>.Node next) {
            this.info = info;
            this.prev = prev;
            this.next = next;
        }
    }

    private Node begin;
    private Node end;
    private int Count;

    public Lista() {
        clear();
    }

    public void clear() {
        begin = null;
        end = null;
        Count = 0;
    }

    public T popback() {
        T temp = end.info;
        if (begin == end)
            clear();
        else {
            end = end.prev;
            Count--;
        }
        return temp;
    }

    public T popfront() {
        T temp = begin.info;
        if (begin == end)
            clear();
        else {
            begin = begin.next;
            Count--;
        }
        return temp;
    }

    public void pushfront(T element) {
        Node push = new Node(element, end, begin);
        if (Count > 0) {
            begin.prev = push;
            begin = push;
        } else {
            end = push;
            begin = push;
        }
        Count++;
    }

    public void pushback(T element) {
        Node push = new Node(element, end, begin);
        if (Count > 0) {
            end.next = push;
            end = push;
        } else {
            end = push;
            begin = push;
        }
        Count++;
    }

    public int getCount() {
        return Count;
    }
}

