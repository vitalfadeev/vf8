module mod.action;

import app : Event;


struct
Mod_action (O) {
    O* o;

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
        auto act = evt.action.name in evt.o.page.actions.s;
        if (act !is null)
            act._do (evt);
    }

    void
    _default_action (Event* evt) {
        auto act = evt.type_to_string in evt.o.page.actions.s;
        if (act !is null)
            act._do (evt);
    }

    struct
    _Event {
        union {
            Action action;
        }

        enum
        Type {
            ACTION
        }

        struct
        Action {
            EType  type;
            string name;
        }
    }
}
