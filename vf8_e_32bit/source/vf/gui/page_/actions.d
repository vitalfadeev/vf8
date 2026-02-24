module vf.gui.page_.actions;

import app : Event;


struct
Actions {
    static Action[string] s;

    void
    _init () {
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
