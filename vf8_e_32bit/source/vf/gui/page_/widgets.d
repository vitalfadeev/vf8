module vf.gui.page_.widgets;

import app : Event;


struct
Widgets {
    DO_SWITCH_DG[ubyte.max+1] s;

    alias DO_SWITCH_DG = void delegate (Event* evt);

    void
    _init () {
        //
    }

    DO_SWITCH_DG
    get_e_widget_do_switch (ubyte type) {
        return s[type];
    }

    void
    do_widget_switch (Event* evt) {
        with (evt.o)
        if (evt.e !is null) {
            auto type   = evt.e.type;
            auto widget_do_switch = get_e_widget_do_switch (type);
            widget_do_switch (evt);     
        }
    }    
}
