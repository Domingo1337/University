package algorithms;

/**
 * Klasa BST - generyczny kontener.
 * @param <T>
 */
public class BST<T extends Comparable<T>> implements Dict<T> {
    /**
     * Klasa
     * @param <T>
     */
    private class Node<T extends Comparable<T>> {
        Node<T> left, right, parent;
        T data;

        public Node(T data, Node<T> parent, Node<T> left, Node<T> right) {
            this.left = left;
            this.right = right;
            this.parent = parent;
            this.data = data;
        }

        public Node(T data) {
            this(data, null, null, null);
        }

        @Override
        public String toString() {
            return data.toString();
        }

        public Node<T> getLeft() {
            return left;
        }

        public void setLeft(Node<T> left) {
            this.left = left;
        }

        public Node<T> getRight() {
            return right;
        }

        public void setRight(Node<T> right) {
            this.right = right;
        }

        public Node<T> getParent() {
            return parent;
        }

        public void setParent(Node<T> parent) {
            this.parent = parent;
        }

        public T getData() {
            return data;
        }

        public void setData(T data) {
            this.data = data;
        }

        public void printMe() {
            String out = data + " ";
            if (parent != null) out += parent.hashCode() + " ";
            else out += "null ";
            if (left != null) out += left.hashCode() + " ";
            else out += "null ";
            if (right != null) out += right.hashCode() + " ";
            else out += "null ";
            System.out.println(out);
        }
    }

    private Node<T> root;

    public BST(T data) {
        this.root = new Node<T>(data, null, null, null);
    }

    private BST(Node<T> node) {
        this.root = new Node<T>(node.getData(), null, node.getLeft(), node.getRight());
    }

    @Override
    public void insert(T element) throws Exception {
        if(element == null) throw new NullPointerException();
        if (root == null) {
            root = new Node<T>(element, null, null, null);
            return;
        }
        Node temp = root;
        while (temp != null) {
            int res = temp.getData().compareTo(element);
            if (res == 0) {
                throw new BST_Exception("Element " + element + " already in the tree.");
            } else if (res > 0) {
                if (temp.getLeft() != null) temp = temp.getLeft();
                else {
                    temp.setLeft(new Node(element, temp, null, null));
                    return;
                }
            } else if (res < 0) {
                if (temp.getRight() != null) temp = temp.getRight();
                else {
                    temp.setRight(new Node(element, temp, null, null));
                    return;
                }
            }
        }
    }

    @Override
    public boolean search(T element) {
        Node temp = root;
        while (temp != null) {
            int res = temp.getData().compareTo(element);
            if (res == 0) {
                return true;
            } else if (res > 0) {
                if (temp.getLeft() != null) temp = temp.getLeft();
                else return false;
            } else if (res < 0) {
                if (temp.getRight() != null) temp = temp.getRight();
                else return false;
            }
        }
        return false;
    }

    @Override
    public void remove(T element) throws BST_Exception {
        Node<T> temp = root;
        Boolean isLeftSon = null;
        while (temp != null) {
            int res = temp.getData().compareTo(element);
            if (res == 0) {
                break;
            } else if (res > 0) {
                if (temp.getLeft() != null) {
                    temp = temp.getLeft();
                    isLeftSon = true;
                } else {
                    throw new BST_Exception(element+" not found in tree.");
                }
            } else if (res < 0) {
                if (temp.getRight() != null) {
                    temp = temp.getRight();
                    isLeftSon = false;
                } else {
                    throw new BST_Exception(element+" not found in tree.");
                }
            }
        }
        if (temp.getRight() == null && temp.getLeft() == null) {
            if (temp == root)
                clear();
            if (isLeftSon) temp.getParent().setLeft(null);
            else temp.getParent().setRight(null);
            return;
        }
        if (temp.getLeft() == null) {
            if (isLeftSon) temp.getParent().setLeft(temp.getRight());
            else temp.getParent().setRight(temp.getRight());
            return;
        }
        if (temp.getRight() == null) {
            if (isLeftSon) temp.getParent().setLeft(temp.getLeft());
            else temp.getParent().setRight(temp.getLeft());
            return;
        }
        Node<T> delete = temp.getRight();
        while (delete.getLeft() != null)
            delete = delete.getLeft();
        T data = delete.getData();
        remove(delete.getData());
        temp.setData(data);
    }

    @Override
    public T min() {
        Node<T> temp = root;
        while (temp.getLeft() != null)
            temp = temp.getLeft();
        return temp.getData();
    }

    @Override
    public T max() {
        Node<T> temp = root;
        while (temp.getRight() != null)
            temp = temp.getRight();
        return temp.getData();
    }

    public int size() {
        if(root==null) return 0;
        int size = 0;
        if (root.getLeft() != null)
            size += (new BST<T>(root.getLeft())).size();
        if (root.getRight() != null)
            size += (new BST<T>(root.getRight())).size();
        return size + 1;
    }

    public void clear() {
        root = null;
    }

    /**
     * Metoda zamienia drzewo na stringa w celu wyswietlania.
     * @return BST in-order.
     */
    @Override
    public String toString() {
        String string = "";
        if (root == null) return string;
        if (root.getLeft() != null)
            string += (new BST<T>(root.getLeft())).toString() + " ";
        string += root.toString();
        if (root.getRight() != null)
            return string + " " + (new BST<T>(root.getRight())).toString();
        else return string;
    }
}
