module vf.base.app;

import vf.base.o     : O;
import vf.base.event : Event;

void
App () {
    auto o = O!Event (&go);
    with (o)
    with (Event.Type) {
        send (OPEN);

        bool send_first = true;
        bool send_force = true;

        foreach (Event* evt; input) {
            // OPEN
            // LOAD_UI
            // ...
            // QUIT
            if (send_first) { send_first = false; send (DO_1); }
            if (send_force) { send_force = false; send_now (DO_FORCED); }

            go (evt);
        }

        send_now (CLOSE);
    }
}

void
go (Event* evt) {
    import std.stdio : writefln;
    writefln ("go: %s", evt.type);
}
