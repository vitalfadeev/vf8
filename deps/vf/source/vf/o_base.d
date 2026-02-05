module vf.o_base;

import vf.input       : Input;
import vf.local_input : Local_input;

///
class
O_base (Event) {
    bool              go_flag = true;
    Input!Event       input;
    Local_input!Event local_input;
    Event             event;

    void
    open () {
        input.open ();
        local_input.open ();
    }

    void
    go () {
        // each input event
        while (go_flag)
            if (input.read (&event))
                go2 (&event);
    }

    void
    go2 (Event* evt) {
        // process input event
        ego (evt);

        // each local input event
        while (!local_input.empty) {
            local_input.read (evt);
            // process local input event
            ego (evt);
        }
    }

    void
    ego (Event* evt) {
        //
    }

    void
    send_now (Event evt) {
        ego (&evt);
    }

    void
    send_now (Event.Type type) {
        Event event;
        event.type = type;
        ego (&event);
    }

    void
    send_now (Event.Type type, string ev, string prop, VALUE) (VALUE value) {
        Event event;
        event.type = type;
        __traits (getMember, __traits (getMember, event, ev), prop) = value;
        ego (&event);
    }

    void
    send (Event.Type type) {
        Event event;
        event.type = type;
        local_input.put (&event);
    }

    void
    send (Event* event) {
        local_input.put (event);
    }

    void
    send (Event event) {
        local_input.put (&event);
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


