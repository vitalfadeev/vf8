module vf.base.actions;


struct
Actions (Event) {
    Action!Event[string] actions;

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
        import actions.quit : Quit;
        import actions.quit : SDL_MOUSEBUTTONDOWN;
        register (Quit.stringof, new Quit);
        register (SDL_MOUSEBUTTONDOWN.stringof, new SDL_MOUSEBUTTONDOWN);
    }

    void
    _action (Event* evt) {
        auto act = evt.action.name in actions;
        if (act !is null)
            act._do (evt);
    }

    void
    _default_action (Event* evt) {
        auto act = evt.type_to_string in actions;
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

mixin template
Send (Event) {
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

interface
Action (Event) {
    void _do (Event* evt);
}
//alias DG (Event) = void delegate (Event* evt);
