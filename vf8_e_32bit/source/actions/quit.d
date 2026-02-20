module actions.quit;

import app : Event;
import vf.base.actions : Action;


class
Quit : Action!Event {
    override
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln (":ACTION Quit");
        //evt.o.quit = true;
    }
}


class
SDL_MOUSEBUTTONDOWN : Action!Event {
    override
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln (":ACTION SDL_MOUSEBUTTONDOWN");
        //evt.o.quit = true;
    }
}

