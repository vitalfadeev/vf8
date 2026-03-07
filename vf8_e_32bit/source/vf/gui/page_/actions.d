module vf.gui.page_.actions;

import vf.sdl.importc_sdl;


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
    void _do (SDL_Event* evt);
}
