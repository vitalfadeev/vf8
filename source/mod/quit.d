module mod.quit;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.input        : Event;
import importc;


void
go (void* o, void* e, void* evt, REG d) {
    auto _evt = cast (Event*) evt;
    REG   typ = _evt.type;
    REG   key;

    switch (typ) {
        case SDL_QUIT: go_quit!"Quit" (o,e,evt,d); break;
        default:
    }
}

void
go_quit (alias TEXT) (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf (TEXT);
        go = null;
    }
}
