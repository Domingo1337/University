package strumienie;

import java.io.BufferedWriter;
import java.io.FilterWriter;
import java.io.Writer;

public class strPiszacy extends BufferedWriter {
    public strPiszacy(Writer out) {
        super(out);
    }
}
