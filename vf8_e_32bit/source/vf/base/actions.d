module vf.base.actions;


struct
Actions (O,Event) {
    O* o;
    Action!Event[string] actions;

    void
    do_switch (Event* evt) {
        switch (evt.type) with (Event.Type) {
            case INIT   : _init (evt); break;
            case ACTION : _action (evt); break;
            default:
        }
    }

    void
    _init (Event* evt) {
        import actions.quit : Quit;
        register ("QUIT", new Quit);
    }

    void
    _action (Event* evt) {
        auto act = evt.action.name in actions;
        if (act !is null)
            act._do (evt);
    }

    void
    register (string name, Action!Event act) {
        actions[name] = act;
    }
}

// send ("SHOW_QUICK_SETTINGS")  // string
// send (REDRAW)                 // enum
void
send (alias o, Event) (string action_name) {
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

class
Action (Event) {
    void
    _do (Event* evt) {
        //
    }
}

//alias DG (Event) = void delegate (Event* evt);
