module vf.base.o;

import vf.base.input : Input;

///
struct
O (Event) {
    Input!Event _input;
    auto         input () { return _input.range; };
    GO           go;

    alias GO = void function (Event* evt);

    this (GO go) {
        this.go = go;
    }

    //
    void
    send_now (Event* evt) {
        assert (go !is null);
        if (go !is null) 
            go (evt);
    }

    void
    send_now (Event evt) {
        assert (go !is null);
        if (go !is null) 
            go (&evt);
    }

    void
    send_now (Event.Type type) {
        assert (go !is null);
        Event event;
        event.type = type;
        if (go !is null) 
            go (&event);
    }

    void
    send (Event* event) {
        _input ~= event;
    }

    void
    send (Event event) {
        _input ~= &event;
    }

    void
    send (Event.Type type) {
        Event event;
        event.type = type;
        _input ~= &event;
    }

    //void
    //send (Event.Type type, string ev, string prop, VALUE) (VALUE value) {
    //    Event event;
    //    event.type = type;
    //    __traits (getMember, __traits (getMember, event, ev), prop) = value;
    //    local_input.put (&event);
    //}
}


// input  line
// direct line
// 1   2   3   4   5   6   7
// key key key             key
//             drt drt drt 

// map
//   to text
//   text to map
//
// map
//   to_text
// editor
//   fields
//     lineno,inlinepos  // x,y
//     complete_list
//   complete_list
// text
//   to_map
//


