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
        import mod.widget_button;
        foreach (ubyte t; 0..256) {
            s[t] = &(new Widget_button ()).do_switch;
        }
        import mod.widget_volume;
        s[4] = &(new Widget_volume ()).do_switch;
    }
}
