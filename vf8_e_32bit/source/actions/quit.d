module actions.quit;

version (ACTIONS):
import app : Event;
import vf.gui.page_.actions : Action;


class
Quit : Action {
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln (":ACTION Quit");
        //evt.o.quit = true;
    }
}


class
SDL_MOUSEBUTTONDOWN : Action {
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln (":ACTION SDL_MOUSEBUTTONDOWN");
    }
}

class
SHOW_QUICK_SETTINGS : Action {
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln (":ACTION SHOW_QUICK_SETTINGS");
        // create window
        // init page
        //   init layout QUICK_SETTINGS
        //     wh
        //     locations
        //   init es
        //   define style
        //     font
        //     text
        //     color
        //     widget type
        //     xh

        // create window
        // load quick_settings.ui
    }
}

