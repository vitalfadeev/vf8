module vf.local_input;

import vf.input    : Event;
import vf.bc_array : Array;
import vf.types    : REG;
import importc;

//
struct
Local_input {
    Array!Event s;

    void
    open () {
        s.setup (8);
    }

    void
    read (Event* event) {
        *event = s[0];
        s.remove_at (0);
    }

    bool
    empty () {
        return s.length == 0;
    }

    void
    put (Event* evt) {
        s.add (*evt);
    }

    void
    put_reg (typeof(Event.type) _reg) {
        Event event;
        event.type           = SDL_USEREVENT;
        event.user.code      = _reg;
        event.user.data1     = null;
        event.user.data2     = null;
        event.user.timestamp = SDL_GetTicks ();

        s.add (event);
    }
}
