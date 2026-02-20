module actions.quit;

import app : Event;
import vf.base.actions : Action;


class
Quit : Action!Event {
    override
    void
    _do (Event* evt) {
        import std.stdio : writeln;
        writeln ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ACTION");
    }
}
