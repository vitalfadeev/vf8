module vf.sdl.loc_input;

import vf.std.ring_buffer : Ring_buffer;

//
struct
Loc_input (Event) {
    Ring_buffer!(Event,128) s;
    
    Event* front ()    { return s.front; }
    bool   empty ()    { return s.empty; }
    void   popFront () { s.popFront ();  }

    void
    opOpAssign (string op : "~") (Event* evt) {
        s ~= evt;
    }
}

