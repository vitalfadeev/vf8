module mod.send;

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
go_send (REG EVT) (void* o, void* e, void* evt, REG d) {
    printf ("  put Event: 0x%X\n", EVT);
    with (cast(O*)o) {
        local_input.put_reg (EVT);
    }
}
