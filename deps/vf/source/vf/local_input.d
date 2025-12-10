module vf.local_input;

import vf.input    : Event;
import vf.bc_array : Array;
import vf.types    : REG;
import importc;

//
struct
Local_input {
    Array!Local_event s;
    Local_event       event;

    void
    open () {
        s.setup (8);
    }

    void
    read () {
        event = s[0];
        s.remove_at (0);
    }

    bool
    empty () {
        return s.length == 0;
    }

    void
    put (Local_event* evt) {
        s.add (*evt);
    }

    void
    put_reg (typeof(Event.type) _reg) {
        s.add (Local_event (_reg));
    }

    void
    put_reg (typeof(Event.type) _reg, void* e) {
        s.add (Local_event (_reg,e));
    }
}

struct
Local_event {
    Event event;
    void* e;

    this (typeof(Event.type) _reg) {
        event.type           = SDL_USEREVENT;
        event.user.code      = _reg;
        event.user.data1     = null;
        event.user.data2     = null;
        event.user.timestamp = SDL_GetTicks ();
    }

    this (typeof(Event.type) _reg, void* _e) {
        event.type           = SDL_USEREVENT;
        event.user.code      = _reg;
        event.user.data1     = null;
        event.user.data2     = null;
        event.user.timestamp = SDL_GetTicks ();
        e                    = _e;
    }
}
