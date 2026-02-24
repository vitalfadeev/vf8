module vf.gui.page_.widgets;

import app : Event;


struct
Widgets {
    DO_SWITCH_DG[ubyte.max+1] s;

    alias DO_SWITCH_DG = void delegate (Event* evt);

    DO_SWITCH_DG
    get_e_widget_do_switch (ubyte type) {
        return s[type];
    }

    void
    _init () {
        //
    }
}
