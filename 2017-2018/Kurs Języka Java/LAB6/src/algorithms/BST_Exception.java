package algorithms;

/**
 * Klasa obslugujaca wyjatki BST.
 */
public class BST_Exception extends Exception{
    public BST_Exception(){
        super("BST Exception");
    }
    public BST_Exception(String error){
        super(error);
    }
}
