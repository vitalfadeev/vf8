module vf.gui.page_.widgets;

import app               : Event;
import mod.widget        : Widget;
import vf.std.tstring256 : Tstring256;


struct
Widgets {
    //Tstring256!Widget s;
    //Widget[ubyte.max+1] s;
    Widget*[] s;

    void
    _init () {
        //
    }

    void
    do_switch (Event* evt) {
        //foreach (Widget* widget; s.range) {
        //    if (widget.flags.enabled)
        //        widget.do_switch (evt);
        //}
    }
}
