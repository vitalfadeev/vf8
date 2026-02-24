module vf.gui.page_.styles;

import vf.gui.style : Style;
import vf.gui.e     : E;


struct
Styles {
    // style 
    //   by type 
    //   by flags 
    //   by flags2
    //
    // assume sorted
    Style[] styles;
    // styles[0]  // bask
    pragma (msg, "styles.size: ", styles.sizeof);  // 261_120

    Style*
    get (bool OR_CREATE=false) (ubyte type, ubyte flags) {
        foreach (ref s; styles) {
            if (s.type == type)
            if (s.flags == flags)
                return &s;
        }
        return &styles[0];

        static if (OR_CREATE) {
            styles ~= Style (type,flags);
            return &styles[$-1];
        }
        else {
            return &styles[0];
        }
    }

    Style*
    get_e_style (E e) {
        return get (e.type, e.flags);
    }

    void
    _init () {
        styles ~= Style ();
        Style* s = &styles[0];
        Style* s2 = &styles[0];
        s.fg   = 1;
        s.font = 1;

        foreach (ubyte t; 0..255) {
            styles ~= Style (t);
            s = &styles[$-1];

            switch (t) {
                case 1 /* start  */ : s.font = 1; s.text = 1; s.fg = 2; break;
                case 2 /* clock  */ : s.font = 2; s.text = 2; s.fg = 2; break;
                case 3 /* batary */ : s.font = 1; s.text = 3; s.fg = 2; break;
                case 4 /* volume */ : s.font = 1; s.text = 4; s.fg = 2; break;
                case 5 /* avia   */ : s.font = 1; s.text = 5; s.fg = 2; break;
                default:
           }

            // base 
            styles ~= *s;
            s2 = &styles[$-1];
            s2.fg = 3; 
            s2.bg = 1;
            // pressed
            styles ~= *s;
            s2 = &styles[$-1];
            s2.pressed = true;
            s2.fg = 5; 
            s2.bg = 2;
            // selected
            styles ~= *s;
            s2 = &styles[$-1];
            s2.selected = true;
            s2.fg = 3; 
            s2.bg = 4;
            // focused
            styles ~= *s;
            s2 = &styles[$-1];
            s2.focused = true;
            s2.fg = 3; 
            s2.bg = 2;
        }

        // disabled pressed selected focused m_over lamp_on
        // 16
        // type * 16  // base, button, check, radio, select, text
        // 6*16 = 96 styles * 10 = 960 Bytes
        //
        // max
        // 256 types * 6 flags = 1536 * 10 = 15_360 Bytes
        // 256 types * 2^6 flags = 256*64 = 16384 *10 = 163_840 Bytes
    }
}
