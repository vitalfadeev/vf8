module mod.quit;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O_base;
import importc;


void
go (O,Event) (O o, E e, Event* evt) {
    switch (evt.type) with (evt.Type) {
        case SDL: 
            if (evt.sdl.sdl_event.type ==  SDL_QUIT)
                go_quit!"Quit" (o,e,evt,d); 
            break;
        default:
    }
}

void
go_quit (alias TEXT,O) (void* o, void* e, void* evt, REG d) {
    with (cast(O*)o) {
        printf (TEXT);
        go_flag = false;
    }
}
