module mod.action;

import app : Event;
import vf.std.xywh;
import vf.sdl.importc_sdl;
import vf.sdl.renderer_sdl;


struct
Mod_action {
    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT   : _init (evt); break;
            case ACTION : _action (evt); break;
            default     : _default_action (evt);
        }
    }

    void
    _init (Event* evt) {
        //
    }

    void
    _action (Event* evt) {
        auto act = evt.action.name in evt.o.actions.s;
        if (act !is null)
            act._do (evt);
    }

    void
    _default_action (Event* evt) {
        auto act = evt.type_to_string in evt.o.actions.s;
        if (act !is null)
            act._do (evt);
    }

    struct
    _Event {
        Type type;

        union {
            Action action;
        }

        enum
        Type {
            ACTION
        }

        struct
        Action {
            Type   type = Type.ACTION;
            string name;
        }
    }
}

mixin template
Send () {
    void
    send (O) (O* o, string action_name) {
        // string save in Event
        // set type to ACTION
        //   then send event
        //   then get Actions
        //   via Actions.do_switch ()
        Event evt;
        evt.type = Event.Type.ACTION;
        evt.action.name = action_name;
        o.input ~= &evt;
    }
}

struct
Actions {
    static Action[string] s;

    void
    _init (Event* evt) {
        //
    }

    void
    register (string name, Action act) {
        s[name] = act;
    }
}

interface
Action {
    void _do (Event* evt);
}
