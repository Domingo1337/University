package strumienie;

import java.io.FilterReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;

public class strCzytajacy extends FilterReader {

    public strCzytajacy(Reader in) {
        super(in);
        tab = 8;
    }

    public strCzytajacy(Reader in, int tab) {
        super(in);
        this.tab = tab;
    }

    int tab;

    @Override
    public int read(char[] cbuf, int off, int len) throws IOException {
        int count = super.read(cbuf, off, len);
        if (count != -1) {
            ArrayList<Character> list = new ArrayList<Character>();
            int i = off;
            boolean nl = true;
            while (i < off + count) {
                if (cbuf[i] == '\n') {
                    list.add(cbuf[i]);
                    nl = true;
                } else if (Character.isWhitespace(cbuf[i])) {
                    if (nl) {
                        if (cbuf[i] == ' ') list.add(' ');
                        else if (cbuf[i] == '\t')
                            for (int k = 0; k < tab; k++)
                                list.add(' ');
                    } else {
                        boolean b = true;
                        while (Character.isWhitespace(cbuf[i]) && b) {
                            if (cbuf[i] == '\n') {
                                list.add(cbuf[i]);
                                nl = true;
                                b = false;
                            } else i++;
                        }
                        if (b) {
                            list.add(' ');
                            list.add(cbuf[i]);
                            nl = false;
                        }
                    }
                } else {
                    list.add(cbuf[i]);
                    nl = false;
                }
                i++;
            }

            for (int k = 0; k < list.size(); k++) {
                cbuf[off + k] = list.get(k);
            }
            return list.size();
        }
        return count;
    }

}
