module vf.gui.page_.colors;

import vf.gui.color : Color;


static __gshared Colors colors;

struct 
Colors {    
    Color[ubyte.max+1] s;
    pragma (msg, "colors.size: ", s.sizeof);  // 1_020

    ubyte
    index_of (Color a) {
        for (ubyte i=0; i<s.length; i++)
            if (s[i] == a)
                return i;
        return 0xFF;
    }
}

