module vf.gui.page_.styles;

import vf.gui.style : Style;
import mod.widget   : Widget;


struct
Styles {
    // style 
    //   by type 
    //   by flags 
    //   by flags2
    //
    // assume sorted
    Style[] s;
    // styles[0]  // bask
    pragma (msg, "styles.size: ", s.sizeof);  // 261_120

    Style*
    get (bool OR_CREATE=false) (Widget.Type type, Widget.Flags flags) {
        foreach (ref _s; s) {
            if (_s.type == type)
            if (_s.flags == flags) {
                return &_s;
            }
        }
        return &s[0];

        static if (OR_CREATE) {
            s ~= Style (type,flags);
            return &s[$-1];
        }
        else {
            return &s[0];
        }
    }

    Style*
    get_style (Widget* widget) {
        return get (widget.type, widget.base.flags);
    }

    void
    _init () {
        s.length = 0;
        s ~= Style ();
    }
}
