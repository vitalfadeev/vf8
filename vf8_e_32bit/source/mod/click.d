module mod.click;

import app : Event;
import vf.std.xywh : XY;


struct
Mod_click {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT   : _init (evt); break;
            case CLICK  : _click (evt); break;
            default     :
        }
    }

    void
    _init (Event* evt) {
        //
    }

    void
    _click (Event* evt) {
        //
    }

    struct
    _Event {
        Type type;

        union {
            Click click;
        }

        enum
        Type {
            CLICK
        }

        struct
        Click {
            Type type = Type.CLICK;
            XY   xy;
        }
    }
}
