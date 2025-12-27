module vf.local_input;

import vf.ring_buffer : Ring_buffer;
import importc;

//
struct
Local_input (T) {
    Ring_buffer!(T,128) s;

    void
    open () {
        s.open ();
    }

    void
    read (T* t) {
        s.get (t);
    }

    bool
    empty () {
        return s.empty;
    }

    void
    put (T* t) {
        s.put (t);
    }
}
