module mod.print;

import core.stdc.stdio : printf;
import vf.types        : GO,REG;
import vf.o_base       : O;
import vf.input        : Event;
import importc;


void
go (void* o, void* e, void* evt, REG d) {
    //
}

void
go_printf (alias TEXT) (void* o, void* e, void* evt, REG d) {
    printf (TEXT);
}
